#!/bin/bash

cd ./source/extensions
touch indexIncludes.tmp
:>indexIncludes.tmp
for index in `find ../../../src/Ylly -name "index.rst"`;
do
    bundleName=`echo $index | sed -e 's/^.*\/\([A-Za-z]\+Bundle\).*/\1/g'`
    rm -f "${bundleName}"
    ln -s `dirname $index` "${bundleName}"
    echo "   $bundleName <extensions/${bundleName}/index>" >> indexIncludes.tmp
done;

perl -ne 's/%YLLY_INDEX%/`cat indexIncludes.tmp`/e;print' ../index.rst.template > ../index.rst
rm indexIncludes.tmp
