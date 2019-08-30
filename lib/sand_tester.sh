#!/bin/bash

argc=$#
argv=($@)

UUID=$1
PORT=$2
SOURCE_REP=$3

mkdir reps
cd reps
mkdir origin$UUID
mkdir origin$UUID/cypress
mkdir origin$UUID/cypress/integration
for (( j=3; j<argc; j++ )); do
  git clone ${argv[j]} tests$j$UUID
  yes | cp -rf ./tests$j$UUID/cypress/integration/* ./origin$UUID/cypress/integration/
done
cd origin$UUID

echo "{\"baseUrl\": \"$SOURCE_REP\"}" > cypress.json

npm init -y
npm install --save-dev cypress mocha mocha-spec-json-reporter
npx cypress run --reporter mocha-spec-json-reporter > ../../log/output$PORT.log
cp ./mocha-output.json ../../log/mocha-output$PORT.json

cd ..
rm -rf ./origin$UUID
rm -rf ./tests*$UUID
