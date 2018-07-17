---
title: "Angular 6.* and Jest"
date: 2018-07-16T22:03:37+02:00
draft: false
---

<!--more-->

## Jest in-lieu of Karma

{{< youtube d91uDEmbBUs >}}

## Getting Started

The commands below will bootstrap a new Angular project. Further documentation can be found in the "[Resources](#resources)" section before.

```sh
ng new example-project  # create a new ng project
cd example-project
yarn add @briebug/jest  # locally add package
ng g @briebug/jest:jest # bootstrap jest from schematics
```

## NG Generate

The `@angular/cli:v6.*` has the `ng generate` (or `ng g`) command which consumes a schematic (found in popular Angular libraries). The output is the bootstraping of boilerplate for said library whom provided the schematic for the current AngularCLI application.

## Resources {#resources}

- [https://github.com/briebug/jest-schematic](https://github.com/briebug/jest-schematic)
