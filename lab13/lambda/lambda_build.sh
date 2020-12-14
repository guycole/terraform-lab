#!/bin/bash
#
# Title:lambda_build.sh
# Description: assemble lambda zip
# Development Environment: OS X 10.13.6
#
PATH=/bin:/usr/bin:/etc:/usr/local/bin:$HOME/.local/bin:$HOME/local/bin; export PATH
#
# UPDATE BELOW
PG_REPO=/Users/gsc/Documents/github/awslambda-psycopg2
#
rm -f test-lambda.zip
pushd deploy
cp ../test_lambda.py .
cp -R $PG_REPO/psycopg2-3.8 psycopg2
zip -r9 ../test-lambda.zip *
popd
#zip ../test-lambda.zip *.py
#zip test-lambda.zip *.py psycopg2/*
#
#pushd venv/lib/python3.8/site-packages
#cp ../../../../test_lambda.py .
#zip -r9 ../../../../test-lambda.zip *
#popd
#