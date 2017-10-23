#!/usr/bin/env bash

hugo;
aws s3 sync public s3://terraincognita-website/ --acl public-read --delete;
