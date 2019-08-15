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
cp ../../lib/_jest.config.js .
cp ../../lib/.babelrc .
cp ../../lib/fileMock.js .
npm install
npm install --save-dev @testing-library/dom @testing-library/jest-dom jest jest-css-modules jest-css-modules-transform @babel/core babel-jest babel-plugin-transform-es2015-modules-commonjs
node ./node_modules/jest/bin/jest.js --config _jest.config.js --json > ../../log/test.log 2> ../../log/output.log
cd ../..
rm -rf ./reps
