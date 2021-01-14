#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Test
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2021. GPLv2
# ----------------------------------------------------------------------------------------------
TESTINPUT=test/TestHoprToken.js
TESTOUTPUT=results/TestHoprToken.txt

# Clear scollback buffer and screen
printf "\033[2J\033[3J\033[1;1H"

echo "\$ npx hardhat --verbose --show-stack-traces test $TESTINPUT > $TESTOUTPUT" | tee $TESTOUTPUT

npx hardhat test $TESTINPUT | tee -a $TESTOUTPUT

# Strip out unnamed event parameters
# sed -i '' 's/(0:.*length__: [0-9]*, /(/g' $TESTOUTPUT
