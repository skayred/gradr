#!/bin/bash

argc=$#
argv=($@)

SOURCE_REP=$1

UID="cat /dev/urandom | tr -cd 'a-f0-9' | head -c 32"

PORT="$(bash ../../lib/port.sh)"

mkdir reps
cd reps
git clone $SOURCE_REP origin$UID
mkdir origin$UID/cypress
mkdir origin$UID/cypress/integration
for (( j=1; j<argc; j++ )); do
  git clone ${argv[j]} tests$j$UID
  yes | cp -rf ./tests$j$UID/cypress/integration/* ./origin$UID/cypress/integration/
done
cd origin$UID
mkdir docker
cp ../../lib/Dockerfile docker/
cp ../../lib/start2.sh docker/

echo "{\"baseUrl\": \"http://localhost:$PORT/\"}" > cypress.json
docker build -t $PORT -f docker/Dockerfile .
DOCKER_PID="$(docker run  -d -p $PORT:80 --name $PORT --rm $PORT)"

npm install --save-dev cypress mocha mocha-spec-json-reporter
npx cypress run --reporter mocha-spec-json-reporter > ../../log/output.log
mv mocha-output.json ../../log/

#docker kill $DOCKER_PID
docker rmi --force $(docker images -q $SOURCE_REP | uniq)

cd ..
rm -rf ./origin$UID
rm -rf ./tests*$UID
