#!/bin/bash
#
# Title:lambda_build.sh
# Description: assemble lambda zip
# Development Environment: OS X 10.13.6
#
PATH=/bin:/usr/bin:/etc:/usr/local/bin:$HOME/.local/bin:$HOME/local/bin; export PATH
#
rm -f test-lambda.zip
#zip ../test-lambda.zip *.py
#zip test-lambda.zip *.py psycopg2/*
#
pushd venv/lib/python3.8/site-packages
cp ../../../../test_lambda.py .
zip -r9 ../../../../test-lambda.zip *
popd
#