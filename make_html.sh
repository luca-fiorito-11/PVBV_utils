#!/bin/bash

XML=$1
SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"   # Directory of this script

mkdir -p ${TRAVIS_BUILD_DIR}/html

(
echo "---"
echo "layout: default"
echo "---"
echo "<body>"
xsltproc ${SCRIPTDIR}/transform.xsl ${XML} | sed '1d;$d'
echo "</body>"
) > ${TRAVIS_BUILD_DIR}/html/index.html

echo 'theme: jekyll-theme-cayman' > ${TRAVIS_BUILD_DIR}/html/_config.yml

