---
title: "Open Source: ProtractorJS + Docker = Headless E2E for CI/CD"
date: 2018-07-15T00:18:21+02:00
draft: false
git: https://github.com/alejandroq/docker-protractor
---

*Alejandro Quesada v1.0.0*

## Description

Plug n' play functional E2E ProtractorJS testing suites in a Docker container. Chrome XVFB, documentation and permissions factored into Debian usage. 

## Status

| Image Name | Travis Status                                                                                                                               | Git    |
| ---------- | ------------------------------------------------------------------------------------------------------------------------------------------- | ------ |
| stable     | [![Build Status](https://travis-ci.org/alejandroq/docker-protractor.svg?branch=master)](https://travis-ci.org/alejandroq/docker-protractor) | master |
| latest     | [![Build Status](https://travis-ci.org/alejandroq/docker-protractor.svg?branch=dev)](https://travis-ci.org/alejandroq/docker-protractor)    | dev    |

| Docker Hub                                             | Docker Pull Command                      |
| ------------------------------------------------------ | ---------------------------------------- |
| https://hub.docker.com/r/alejandroq/docker-protractor/ | docker pull alejandroq/docker-protractor |

## Documentation

Your Protractor and Karma configurations must maintain the following:

```js
// Protractor Conf
chromeOptions: {
      args: [
        "--headless",
        "no-sandbox",
        "--disable-gpu",
        "--window-size=800,600"
      ]
    }
// Karma Conf
browsers: ['ChromeHeadlessNoSandbox'],
    customLaunchers: {
      ChromeHeadlessNoSandbox: {
        base: 'ChromeHeadless',
        flags: ['--no-sandbox']
      }
    },
```

Examples can be found in the `examples` directory.

An example of this container being used for Angular:

```sh
# !/bin/bash

# the currenty testing entry point is via:
# ENTRYPOINT ["bash"]

# At the moment, it would be best to define
# a smoke test in a shell script for running
# within the CI/CD. Specifying a specific 
# suite is beneficial as you can freely determine 
# the tradeoff of quality and money (as CI/CD services
# such as CodeCommit are typically pay as you go)
#
# Our example smoke test in a `./test` shell script file
set -e
npm install
./node_modules/@angular/cli/bin/ng e2e --aot --prod
./node_modules/@angular/cli/bin/ng test --single-run
```

```sh
docker run -v $PWD/examples/angular-example:/protractor -w /protractor  "$AUTHOR/$CONTAINER" ./test
```

## Updates

A notorious issue with `ChromeDriver` is its frequency of updating - and rendering old webdrivers obsolete. I have a TravisCI Cron job re-build the Docker containers daily (and therefore pull in the latest webdrivers). In your personal use, it is advisable you update them often when it fails to run outside of any errors within a testing script.

![daily cron](../../../../images/headless-protractor-cicd/daily-updates.png)

## TODO

- [ ] Repair tests
  - [ ] NG
  - [ ] Cucumber
  - [ ] Typescript
- [ ] Update test package.json's
  - [ ] Cucumber
  - [ ] NG to 6.*
  - [ ] Typescript

## Resources

- [Docker Hub](https://hub.docker.com/r/alejandroq/docker-protractor/)
- [GitHub](https://github.com/alejandroq/docker-protractor)