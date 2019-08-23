#!/bin/bash

argc=$#
argv=($@)

SOURCE_REP=$1

PORT="$(bash ../../lib/port.sh)"

mkdir reps
cd reps
git clone $SOURCE_REP origin$PORT
mkdir origin$PORT/cypress
mkdir origin$PORT/cypress/integration
for (( j=1; j<argc; j++ )); do
  git clone ${argv[j]} tests$j$PORT
  yes | cp -rf ./tests$j$PORT/cypress/integration/* ./origin$PORT/cypress/integration/
done
cd origin$PORT
mkdir docker
cp ../../lib/Dockerfile docker/
cp ../../lib/start2.sh docker/

echo "{\"baseUrl\": \"http://localhost:$PORT/\"}" > cypress.json
docker build -t $PORT -f docker/Dockerfile .
docker kill $PORT
DOCKER_PID="$(docker run  -d -p $PORT:80 --name $PORT --rm $PORT)"

npm install --save-dev cypress mocha mocha-spec-json-reporter
npx cypress run --reporter mocha-spec-json-reporter > ../../log/output.log
mv mocha-output.json ../../log/

docker kill $DOCKER_PID
docker rmi --force $(docker images -q $SOURCE_REP | uniq)

cd ../..
rm -rf ./reps
