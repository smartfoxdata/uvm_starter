################################################################################
# MIT License
#
# Copyright (c) 2017 Smartfox Data Solutions Inc.
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
################################################################################

#
# Change SPATH below to actual uvm_starter path
# 

#!/bin/bash

CURRDIR="${PWD##*/}"
CLONE="${CURRDIR/uvm_/}"
SPATH="~/release/uvm_starter"

echo "Cloning starter files in $SPATH into current directory $CURRDIR with prefix $CLONE..."
echo "Press Y or y to proceed"

read -s -N 1 PROCEED

if [ "$PROCEED" = 'Y' ] || [ "$PROCEED" = "y" ]
then
  echo "$PROCEED"
else
  echo "$PROCEED"
  echo "Cloning cancelled"
  exit
fi

declare -a DIRS=("sv" "tb")

# copy sim/Makefile"
echo "generating sim/Makefile"
rm -rf sim
mkdir sim
cat $SPATH/sim/Makefile |sed "s/starter/$CLONE/g" > sim/Makefile

# copy rest of sv and tb files
for d in "${DIRS[@]}"
do
  FILES=($(ls "$SPATH/$d"))
  rm -rf "$d"
  mkdir -p "$d"
  for f in "${FILES[@]}"
  do
    nf=${f/starter/$CLONE}
    echo "generating $d/$nf"
    cat $SPATH/$d/$f |sed "s/starter/$CLONE/g" > $d/$nf
  done
done

echo "Done!"

