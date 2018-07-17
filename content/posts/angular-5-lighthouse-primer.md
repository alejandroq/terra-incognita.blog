---
title: "Angular 5.* Lighthouse Primer"
date: 2018-04-14T23:01:13+02:00
draft: false
git: "https://github.com/alejandroq/angular-primer"
---

_This article was originally part of my "edu" series originally publicized via a GitHub repository and live presented to a group of peers. Therefore much of it is organized in a manner meant to direct said presentation and is not optimized as an article._

<!--more-->

- [Get Started](#get-started)
- [Steps](#steps)
- [Migrate from Angular5 to Angular6](#migrate-from-angular5-to-angular6)
- [Routes](#routes)
- [Extra Credit](#extra-credit)
    - [Prettier and VSCode](#prettier-and-vscode)

## Get Started

Install the following dependencies:

- [Angular CLI](https://cli.angular.io/)
- [NPM](https://www.npmjs.com/) or [Yarn](https://yarnpkg.com/en/)

We will be using Angular 5 and Angular CLI 1.6.

## Steps

- Create an NG application

```sh
$ ng new ngapp --service-worker --routing
```

- Let's benchmark with Lighthouse and `ng build --prod --aot`:

![PWA](../../../images/angular-5-lighthouse-primer/1-1.png)
![Stats](../../../images/angular-5-lighthouse-primer/1-2.png)

- Create an App Shell

```sh
$ npm install @angular/platform-server
$ ng generate universal ngu-app-shell
$ ng generate app-shell loading-shell \
    --universal-app=ngu-app-shell \
    --route=app-shell-path
```

- Let's benchmark with Lighthouse and `ng build --prod --aot`:

![Stats](../../../images/angular-5-lighthouse-primer/2-1.png)

- What is enabled with a Shell vs no Shell besides ~600ms First-Paint speed saved for a 3G connection? Rehydration!

```html
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Ngapp</title><base href="/"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" type="image/x-icon" href="favicon.ico"><link href="styles.9c0ad738f18adc3d19ed.bundle.css" rel="stylesheet"><style ng-transition="serverApp"></style></head><body><app-root _nghost-c0="" ng-version="5.2.9"></app-root><script type="text/javascript" src="inline.69fe2ea4c1357caad977.bundle.js"></script><script type="text/javascript" src="polyfills.46af3f84a403e219371b.bundle.js"></script><script type="text/javascript" src="main.3f0a915399c6ba87014e.bundle.js"></script></body></html>
```

```html
<!DOCTYPE html><html lang="en"><head><meta charset="utf-8"><title>Ngapp</title><base href="/"><meta name="viewport" content="width=device-width,initial-scale=1"><link rel="icon" type="image/x-icon" href="favicon.ico"><link href="styles.9c0ad738f18adc3d19ed.bundle.css" rel="stylesheet"><style ng-transition="serverApp"></style></head><body><app-root _nghost-c0="" ng-version="5.2.9">
<div _ngcontent-c0="" style="text-align:center">
  <h1 _ngcontent-c0="">
    Welcome to app!
  </h1>
  <img _ngcontent-c0="" alt="Angular Logo" src="data:image/svg+xml;base64,PHN2ZyB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC9zdmciIHZpZXdCb3g9IjAgMCAyNTAgMjUwIj4KICAgIDxwYXRoIGZpbGw9IiNERDAwMzEiIGQ9Ik0xMjUgMzBMMzEuOSA2My4ybDE0LjIgMTIzLjFMMTI1IDIzMGw3OC45LTQzLjcgMTQuMi0xMjMuMXoiIC8+CiAgICA8cGF0aCBmaWxsPSIjQzMwMDJGIiBkPSJNMTI1IDMwdjIyLjItLjFWMjMwbDc4LjktNDMuNyAxNC4yLTEyMy4xTDEyNSAzMHoiIC8+CiAgICA8cGF0aCAgZmlsbD0iI0ZGRkZGRiIgZD0iTTEyNSA1Mi4xTDY2LjggMTgyLjZoMjEuN2wxMS43LTI5LjJoNDkuNGwxMS43IDI5LjJIMTgzTDEyNSA1Mi4xem0xNyA4My4zaC0zNGwxNy00MC45IDE3IDQwLjl6IiAvPgogIDwvc3ZnPg==" width="300">
</div>
<h2 _ngcontent-c0="">Here are some links to help you start: </h2>
<ul _ngcontent-c0="">
  <li _ngcontent-c0="">
    <h2 _ngcontent-c0=""><a _ngcontent-c0="" href="https://angular.io/tutorial" rel="noopener" target="_blank">Tour of Heroes</a></h2>
  </li>
  <li _ngcontent-c0="">
    <h2 _ngcontent-c0=""><a _ngcontent-c0="" href="https://github.com/angular/angular-cli/wiki" rel="noopener" target="_blank">CLI Documentation</a></h2>
  </li>
  <li _ngcontent-c0="">
    <h2 _ngcontent-c0=""><a _ngcontent-c0="" href="https://blog.angular.io/" rel="noopener" target="_blank">Angular blog</a></h2>
  </li>
</ul>

<router-outlet _ngcontent-c0=""></router-outlet><app-shell _nghost-c1=""><p _ngcontent-c1="">
  app-shell works!
</p>
</app-shell>
</app-root><script type="text/javascript" src="inline.69fe2ea4c1357caad977.bundle.js"></script><script type="text/javascript" src="polyfills.46af3f84a403e219371b.bundle.js"></script><script type="text/javascript" src="main.3f0a915399c6ba87014e.bundle.js"></script></body></html>
```

- In our previous benchmark, there is render-blocking stylesheet. Let's remove it by removing references to `"styles.css"` in the `.angular-cli.json`. The end result should be:

```json
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "project": {
    "name": "ngapp"
  },
  "apps": [
    {
      "root": "src",
      "outDir": "dist",
      "assets": ["assets", "favicon.ico"],
      "index": "index.html",
      "main": "main.ts",
      "polyfills": "polyfills.ts",
      "test": "test.ts",
      "tsconfig": "tsconfig.app.json",
      "testTsconfig": "tsconfig.spec.json",
      "prefix": "app",
      "styles": [],
      "scripts": [],
      "environmentSource": "environments/environment.ts",
      "environments": {
        "dev": "environments/environment.ts",
        "prod": "environments/environment.prod.ts"
      },
      "serviceWorker": true,
      "appShell": {
        "app": "ngu-app-shell",
        "route": "app-shell-path"
      }
    },
    {
      "root": "src",
      "outDir": "dist-server",
      "assets": ["assets", "favicon.ico"],
      "index": "index.html",
      "main": "main.server.ts",
      "test": "test.ts",
      "tsconfig": "tsconfig.server.json",
      "testTsconfig": "tsconfig.spec.json",
      "prefix": "app",
      "styles": [],
      "scripts": [],
      "environmentSource": "environments/environment.ts",
      "environments": {
        "dev": "environments/environment.ts",
        "prod": "environments/environment.prod.ts"
      },
      "serviceWorker": true,
      "platform": "server",
      "name": "ngu-app-shell"
    }
  ],
  "e2e": {
    "protractor": {
      "config": "./protractor.conf.js"
    }
  },
  "lint": [
    {
      "project": "src/tsconfig.app.json",
      "exclude": "**/node_modules/**"
    },
    {
      "project": "src/tsconfig.spec.json",
      "exclude": "**/node_modules/**"
    },
    {
      "project": "e2e/tsconfig.e2e.json",
      "exclude": "**/node_modules/**"
    }
  ],
  "test": {
    "karma": {
      "config": "./karma.conf.js"
    }
  },
  "defaults": {
    "styleExt": "css",
    "component": {}
  }
}
```

- Let's benchmark with Lighthouse and `ng build --prod --aot`:

![Stats](../../../images/angular-5-lighthouse-primer/3-1.png)

Our Lighthouse First-Paint speed for a 3G connection in this case was 800ms.

- Let's update a few of the meta PWA tasks. First edit the `index.html` as so to accomodate specific meta data:

```html
<!doctype html>
<html lang="en">

<head>
  <meta charset="utf-8">
  <title>Ngapp</title>
  <base href="/">
  <link rel="manifest" href="assets/manifest.json">
  <meta name="description" content="An example Angular5 application with Service Worker" />
  <meta name="theme-color" content="#f2f2f2">

  <meta name="mobile-web-app-capable" content="yes">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link rel="icon" type="image/x-icon" href="favicon.ico">
</head>

<body>
  <app-root></app-root>
  <noscript>
    Javascript must be enabled to use this app.
  </noscript>
</body>

</html>
```

Note the new `<noscript>` tags and `<meta>` tags.

- Create a `assets/manifest.json`:

```json
{
  "short_name": "Ngapp",
  "name": "Angular 5.0 PWA",
  "start_url": "/",

  "theme_color": "#f2f2f2",
  "background_color": "#ffffff",

  "display": "standalone",
  "orientation": "portrait",

  "icons": [
    {
      "src":
        "../../../images/angular-5-lighthouse-primer/icons/android-chrome-512x512.png",
      "sizes": "512x512",
      "type": "image/png"
    }
  ]
}
```

The browser requires the `manifest.json` for prompting web app download to device.

- Let's benchmark with Lighthouse and `ng build --prod --aot`:

![Stats](../../../images/angular-5-lighthouse-primer/4-1.png)

Our PWA score is now 91. When we deliver via HTTPS, it will be 100.

## Migrate from Angular5 to Angular6

_If you already maintain an application and would rather not replace your entire `package.json`; checkout this [upgrade guide](https://angular-update-guide.firebaseapp.com/)_

- Let's update out experiment from Angular5 to Angular6-rc4. Replace your `package.json` as so and then run `rm -r node_modules && npm install`:

```json
{
  "name": "ngapp",
  "version": "0.0.0",
  "license": "MIT",
  "scripts": {
    "ng": "ng",
    "start": "ng serve",
    "build": "ng build --prod",
    "test": "ng test",
    "lint": "ng lint",
    "e2e": "ng e2e"
  },
  "private": true,
  "dependencies": {
    "@angular-devkit/core": "0.5.6",
    "@angular/animations": "^6.0.0-rc.4",
    "@angular/common": "^6.0.0-rc.4",
    "@angular/compiler": "^6.0.0-rc.4",
    "@angular/core": "^6.0.0-rc.4",
    "@angular/forms": "^6.0.0-rc.4",
    "@angular/http": "^6.0.0-rc.4",
    "@angular/platform-browser": "^6.0.0-rc.4",
    "@angular/platform-browser-dynamic": "^6.0.0-rc.4",
    "@angular/platform-server": "^6.0.0-rc.4",
    "@angular/router": "^6.0.0-rc.4",
    "@angular/service-worker": "^6.0.0-rc.4",
    "core-js": "^2.4.1",
    "rxjs": "^6.0.0-beta.1",
    "rxjs-compat": "^6.0.0-uncanny-rc.7",
    "zone.js": "^0.8.26"
  },
  "devDependencies": {
    "@angular-devkit/core": "0.3.2",
    "@angular-devkit/schematics": "^0.5.6",
    "@angular/cli": "1.7.4",
    "@angular/compiler-cli": "^6.0.0-rc.4",
    "@angular/language-service": "^6.0.0-rc.4",
    "@types/jasmine": "~2.8.6",
    "@types/jasminewd2": "~2.0.2",
    "@types/node": "~9.6.5",
    "codelyzer": "^4.0.1",
    "jasmine-core": "~3.1.0",
    "jasmine-spec-reporter": "~4.2.1",
    "karma": "~2.0.0",
    "karma-chrome-launcher": "~2.2.0",
    "karma-cli": "~1.0.1",
    "karma-coverage-istanbul-reporter": "^1.2.1",
    "karma-jasmine": "~1.1.0",
    "karma-jasmine-html-reporter": "^1.0.0",
    "protractor": "~5.3.1",
    "ts-node": "~5.0.1",
    "tslint": "~5.9.1",
    "typescript": "2.7.2"
  }
}
```

- AngularCLI 1.7 comes with a bundle analyzer. Update your `.angular-cli.json` accordingly to enable:

```json
{
  "$schema": "./node_modules/@angular/cli/lib/config/schema.json",
  "project": {
    "name": "ngapp"
  },
  "apps": [
    {
      "root": "src",
      "outDir": "dist",
      "assets": ["assets", "favicon.ico"],
      "index": "index.html",
      "main": "main.ts",
      "polyfills": "polyfills.ts",
      "test": "test.ts",
      "tsconfig": "tsconfig.app.json",
      "testTsconfig": "tsconfig.spec.json",
      "prefix": "app",
      "styles": [],
      "scripts": [],
      "environmentSource": "environments/environment.ts",
      "environments": {
        "dev": "environments/environment.ts",
        "prod": "environments/environment.prod.ts"
      },
      "serviceWorker": true,
      "appShell": {
        "app": "ngu-app-shell",
        "route": "app-shell-path"
      },
      "budgets": [
        {
          "type": "bundle",
          "name": "main",
          "baseline": "300kb",
          "warning": "30kb"
        },
        { "type": "bundle", "name": "races", "maximumWarning": "360kb" },
        { "type": "allScript", "baseline": "1.4mb", "maximumError": "100kb" },
        { "type": "initial", "baseline": "1.6mb", "error": "100kb" },
        { "type": "any", "maximumError": "500kb" }
      ]
    },
    {
      "root": "src",
      "outDir": "dist-server",
      "assets": ["assets", "favicon.ico"],
      "index": "index.html",
      "main": "main.server.ts",
      "test": "test.ts",
      "tsconfig": "tsconfig.server.json",
      "testTsconfig": "tsconfig.spec.json",
      "prefix": "app",
      "styles": [],
      "scripts": [],
      "environmentSource": "environments/environment.ts",
      "environments": {
        "dev": "environments/environment.ts",
        "prod": "environments/environment.prod.ts"
      },
      "serviceWorker": true,
      "platform": "server",
      "name": "ngu-app-shell"
    }
  ],
  "e2e": {
    "protractor": {
      "config": "./protractor.conf.js"
    }
  },
  "lint": [
    {
      "project": "src/tsconfig.app.json",
      "exclude": "**/node_modules/**"
    },
    {
      "project": "src/tsconfig.spec.json",
      "exclude": "**/node_modules/**"
    },
    {
      "project": "e2e/tsconfig.e2e.json",
      "exclude": "**/node_modules/**"
    }
  ],
  "test": {
    "karma": {
      "config": "./karma.conf.js"
    }
  },
  "defaults": {
    "styleExt": "css",
    "component": {}
  }
}
```

- Let's benchmark with Lighthouse and `ng build --prod --aot`:

![Stats](../../../images/angular-5-lighthouse-primer/5-1.png)

Its "First-Paint" time has greatly improved! A feat accomplished by a simple upgrade. How significant is every 100ms?

- How does our bundle analysis look?

![Bundle Analysis](../../../images/angular-5-lighthouse-primer/5-2.png)

## Routes

- Lets create a lazy loaded route.

```sh
$ ng g m routetwo --skip-import && ng g c routetwo --skip-import
```

- Apply this to your `src/app-routing.module.ts`:

```ts
const routes: Routes = [
  {
    path: "",
    pathMatch: "full",
    component: AppComponent
  },
  {
    path: "routetwo",
    pathMatch: "full",
    loadChildren: "./routes/routetwo/routetwo-routing.module#RoutetwoModule"
  },
  {
    path: "**",
    pathMatch: "full",
    redirectTo: ""
  }
];
```

The NG CLI will intelligently chunk the `RoutetwoModule`. When a user visits said route, the module will lazy load without the user savvy.

- The `src/routes/routetwo-routing.module.ts` should look as so:

```ts
import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { RoutetwoComponent } from "./routetwo.component";

const routes: Routes = [
  {
    path: "",
    pathMatch: "full",
    component: RoutetwoComponent
  },
  {
    path: "**",
    pathMatch: "full",
    redirectTo: ""
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
  declarations: [RoutetwoComponent]
})
export class RoutetwoRoutingModule {}
```

This module will handle component declaration and sub-routes for the RotuetwoModule. Further layers can also be lazy loaded as handled before.

## Extra Credit

### Prettier and VSCode

- For code formatting lets take advantage of VSCode's plugin for PrettierJS. This specific plugins identifier is as so: `esbenp.prettier-vscode`.

- Create a `.prettierrc` file with the following contents:

```json
{
  "singleQuote": true,
  "trailingComma": "es5",
  "bracketSpacing": true
}
```

- Create a `settings.json` with the following contents:

```json
{
  "editor.formatOnSave": true,
  "[javascript]": {
    "editor.formatOnSave": true
  }
}
```

What does this do? View the following before and after. The before becomes the after upon saving the document:

```text
import { NgModule } from '@angular/core';
import { Routes, RouterModule } from '@angular/router';
import { RoutetwoComponent } from './routetwo.component';

const routes: Routes = [
  { path: '', pathMatch:
  'full', component: RoutetwoComponent },
  {
    path: '**', pathMatch: 'full', redirectTo: '' },
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [
    RouterModule

  ],
  declarations: [RoutetwoComponent],
})
export class RoutetwoRoutingModule {



}
```

```ts
import { NgModule } from "@angular/core";
import { Routes, RouterModule } from "@angular/router";
import { RoutetwoComponent } from "./routetwo.component";

const routes: Routes = [
  {
    path: "",
    pathMatch: "full",
    component: RoutetwoComponent
  },
  {
    path: "**",
    pathMatch: "full",
    redirectTo: ""
  }
];

@NgModule({
  imports: [RouterModule.forChild(routes)],
  exports: [RouterModule],
  declarations: [RoutetwoComponent]
})
export class RoutetwoRoutingModule {}
```
