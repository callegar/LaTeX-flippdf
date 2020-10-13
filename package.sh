#!/bin/bash

PKGNAME=flippdf
PKGVERS=1-0b
PKGCNT=("README")
TESTFILES=("test-flippdf-1" "test-flippdf-2")

build()
  {
    mkdir -p buildpkg/workdir
    cp "$PKGNAME".dtx "$PKGNAME".ins "${PKGCNT[@]}" buildpkg/workdir/
    cd buildpkg/workdir
    cat > docstrip.cfg <<EOF
\BaseDirectory{.}
\UseTDS
\askforoverwritefalse
EOF
    mkdir -p tex/latex/"$PKGNAME"
    mkdir -p doc/latex/"$PKGNAME"/examples
    tex "$PKGNAME".ins
    lualatex "$PKGNAME".dtx
    makeindex -s gind.ist "$PKGNAME"
    makeindex -s gglo.ist -o "$PKGNAME".gls "$PKGNAME".glo
    lualatex "$PKGNAME".dtx
    lualatex "$PKGNAME".dtx
    cp "$PKGNAME".pdf doc/latex/"$PKGNAME"/
    cd -
  }

test()
  {
    cd buildpkg/workdir/doc/latex/"$PKGNAME"/examples
    for name in "${TESTFILES[@]}"; do
        pdflatex "$name"
    done
    cd -
  }

package()
  {  
    mkdir -p buildpkg/"$PKGNAME"_"$PKGVERS"
    cp "$PKGNAME".dtx "$PKGNAME".ins "${PKGCNT[@]}" \
       buildpkg/"$PKGNAME"_"$PKGVERS"/
    #cd buildpkg/workdir
    #zip -r -9 ../$PKGNAME.tds.zip tex doc
    #cd -
    cp buildpkg/workdir/"$PKGNAME".pdf buildpkg/"$PKGNAME"_"$PKGVERS"/
    cd buildpkg
    #zip -r -9 "$PKGNAME"_"$PKGVERS".zip "$PKGNAME"_"$PKGVERS" $PKGNAME.tds.zip
    zip -r -9 "$PKGNAME"_"$PKGVERS".zip "$PKGNAME"_"$PKGVERS"
    cd -
  }

clean()
  {
    cd buildpkg
    rm -fr ./workdir ./"$PKGNAME"_"$PKGVERS" ./"$PKGNAME".tds.zip
    cd -
  }
    
build
package  
test
clean
 
