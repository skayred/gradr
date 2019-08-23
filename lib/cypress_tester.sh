#!/bin/bash

argc=$#
argv=($@)

SOURCE_REP=$1

UUID="$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 6)"

PORT="$(bash ./lib/port.sh)"

rm log/output.log

mkdir reps
cd reps
git clone $SOURCE_REP origin$UUID
mkdir origin$UUID/cypress
mkdir origin$UUID/cypress/integration
for (( j=1; j<argc; j++ )); do
  git clone ${argv[j]} tests$j$UUID
  yes | cp -rf ./tests$j$UUID/cypress/integration/* ./origin$UUID/cypress/integration/
done
cd origin$UUID
mkdir docker
cp ../../lib/Dockerfile docker/
cp ../../lib/start2.sh docker/

echo "{\"baseUrl\": \"http://localhost:$PORT/\"}" > cypress.json
docker build -t $PORT -f docker/Dockerfile .
DOCKER_PID="$(docker run -d -p $PORT:80 --name $PORT --rm $PORT)"

npm install --save-dev cypress mocha mocha-spec-json-reporter
npx cypress run --reporter mocha-spec-json-reporter > ../../log/output.log
cp ./mocha-output.json ../../log/
cp ./mocha-output.json ../..

docker kill $PORT
#docker rmi --force $(docker images -q $SOURCE_REP | uniq)

echo 'Script finished!'

cd ..
# rm -rf ./origin$UUID
rm -rf ./tests*$UUID
