#!/bin/bash

XML=$1

mkdir -p ${TRAVIS_BUILD_DIR}/html

(
echo "---"
echo "layout: default"
echo "---"
echo "<body>"
xsltproc transform.xsl ${XML} | sed '1d;$d'
echo "</body>"
) > ${TRAVIS_BUILD_DIR}/html/index.html

echo 'theme: jekyll-theme-cayman' > ${TRAVIS_BUILD_DIR}/html/_config.yml

