#!/bin/sh -e

exec parcel server index.html --port 80 --hmr-port 1235
