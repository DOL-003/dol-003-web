#!/bin/sh

bundle install
yarn --frozen-lockfile

exec "$@"
