#!/usr/bin/env bash
#
# Deployment of the website consists of sync'ing to an S3 bucket
# The master branch is considered the production copy and can be viewed at https://hassiumlabs.com
# The test branch is to stage and test updates and can be viewed at https://test.hassiumlabs.com
#

pip install --user awscli; export PATH=$PATH:$HOME/.local/bin

if [ "$TRAVIS_BRANCH" == "master" ]; then
  aws s3 sync srv/public s3://terraincognita-website/pro/ --delete
fi

if [ "$TRAVIS_BRANCH" == "dev" ]; then
  aws s3 sync srv/public s3://terraincognita-website/dev/ --delete
fi
