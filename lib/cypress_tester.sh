#!/bin/bash

argc=$#
argv=($@)

SOURCE_REP=$1

mkdir reps
cd reps
git clone $SOURCE_REP origin
mkdir origin/cypress
mkdir origin/cypress/integration
for (( j=1; j<argc; j++ )); do
  git clone ${argv[j]} tests$j
  yes | cp -rf ./tests$j/cypress/integration/* ./origin/cypress/integration/
done
cd origin
cp ../../lib/cypress.json .
npm install
npm install --save-dev cypress mocha mochawesome
npm run start &
PROC_PID=$!
npx cypress run --reporter mocha-spec-json-reporter > ../../log/output.log
mv mocha-output.json ../../log/
kill $PROC_PID
cd ../..
rm -rf ./reps
