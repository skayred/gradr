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
mkdir docker
cp ../../lib/Dockerfile docker/
cp ../../lib/start2.sh docker/

PORT="$(bash ./port.sh)"
docker build -t $SOURCE_REP -f docker/Dockerfile .
DOCKER_PID="$(docker run -d -p 8080:$PORT --name $SOURCE_REP $SOURCE_REP)"

npm install -g cypress mocha mocha-spec-json-reporter
npx cypress run --reporter mocha-spec-json-reporter > ../../log/output.log
mv mocha-output.json ../../log/

docker kill $DOCKER_PID
docker rmi --force $(docker images -q $SOURCE_REP | uniq)

cd ../..
#rm -rf ./reps
