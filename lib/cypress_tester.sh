#!/bin/bash

argc=$#
argv=($@)

UUID=$1
PORT=$2
SOURCE_REP=$3

mkdir reps
cd reps
git clone $SOURCE_REP origin$UUID
mkdir origin$UUID/cypress
mkdir origin$UUID/cypress/integration
for (( j=3; j<argc; j++ )); do
  git clone ${argv[j]} tests$j$UUID
  yes | cp -rf ./tests$j$UUID/cypress/integration/* ./origin$UUID/cypress/integration/
done
cd origin$UUID
mkdir docker
cp ../../lib/Dockerfile docker/
cp ../../lib/start2.sh docker/

docker rmi PORT
echo "{\"baseUrl\": \"http://localhost:$PORT/\"}" > cypress.json
docker build -t $PORT -f docker/Dockerfile .
echo 'Built!'
DOCKER_PID="$(docker run -d -p $PORT:80 --name $PORT --rm $PORT)"
echo 'Run!'

npm install --save-dev cypress mocha mocha-spec-json-reporter
npx cypress run --reporter mocha-spec-json-reporter > ../../log/output$PORT.log
cp ./mocha-output.json ../../log/mocha-output$PORT.json
../../log/mocha-output$PORT.json >> ../../log/output$PORT.log

docker kill $PORT
docker rmi $PORT

cd ..
rm -rf ./origin$UUID
rm -rf ./tests*$UUID
