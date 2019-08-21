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
cp ../../lib/port.sh .

PORT="$(bash ./port.sh)"
docker build -t $SOURCE_REP -f docker/Dockerfile .
docker run -p 8080:$PORT -l $SOURCE_REP parcel-test

npm install -g cypress mocha mochawesome
npx cypress run --reporter mocha-spec-json-reporter > ../../log/output.log
mv mocha-output.json ../../log/

docker rmi --force $(docker images -q $SOURCE_REP | uniq)

cd ../..
#rm -rf ./reps
