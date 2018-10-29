#!/bin/bash

ENDF=$1
MAT=$(sed -n '2,2 p' $ENDF | cut -c67-70 | xargs)

cat > input <<EOF
moder
20 -21
reconr
-21 -22 /
'' /
${MAT} 0 0 /
${NJOY_TOLER:-0.001} 0. /
0/
broadr
-21 -22 -23 /
${MAT} 1 0 0 0. /
${NJOY_TOLER:-0.001} /
${NJOY_TEMP:-293.6} /
0/
thermr
0 -23 -24 /
0 ${MAT} 20 1 1 0 0 1 221 0 /
${NJOY_TEMP:-293.6} /
${NJOY_TOLER:-0.001} ${NJOY_EMAX:-10} /
heatr
-21 -24 -25 0 /
${MAT} 7 0 0 0 0 /
302 303 304 318 402 442 443 /
heatr
-21 -25 -26 0 /
${MAT} 4 0 0 0 0 /
444 445 446 447 /
moder
-26 27 /
acer
-21 -26 0 51 52 /
1 0 1 .${NJOY_ACE_SUFF:-03} 0 /
" " /
${MAT} ${NJOY_TEMP:-293.6} /
1 1 /
/
stop
EOF

ln -sfv $ENDF tape20
${TRAVIS_BUILD_DIR}/NJOY2016/bin/njoy < input
