#!/bin/bash

argc=$#
argv=($@)

SOURCE_REP=$1

mkdir reps
cd reps
git clone $SOURCE_REP origin
for (( j=1; j<argc; j++ )); do
  git clone ${argv[j]} tests$j
  yes | cp -rf ./tests$j/src/__tests__ ./origin/src/
done
cd origin
npm install
npm install --save-dev react-testing-library
CI=true node ./node_modules/react-scripts/bin/react-scripts test --env=jsdom --json > ../../log/test.log 2> ../../log/output.log
cd ../..
rm -rf ./reps
