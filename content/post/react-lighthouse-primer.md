---
title: "ReactJS 16.* Lighthouse Primer"
date: 2018-04-06T23:28:24+02:00
update: 2018-07-14T23:28:24+02:00
draft: false
---

_This article was originally part of my "edu" series originally publicized via a GitHub repository and live presented to a group of peers. Therefore much of it is organized in a manner meant to direct said presentation and is not optimized as an article._

<!--more-->

- [Get Started](#get-started)
    - [**"Initial Build" Lighthouse Performance**](#%22initial-build%22-lighthouse-performance)
    - [**"React-Snapshot" Lighthouse Performance**](#%22react-snapshot%22-lighthouse-performance)
    - [**"Component Level Transpiled CSS with Styled-Components" Lighthouse Performance**](#%22component-level-transpiled-css-with-styled-components%22-lighthouse-performance)
    - [**Our Three New Routes**](#our-three-new-routes)
    - [**Our New Router**](#our-new-router)
    - [**Build Directory - Monolithic Output**](#build-directory---monolithic-output)
    - [**Build Directory - Lazy Loading Chunks Output**](#build-directory---lazy-loading-chunks-output)
    - [**First Time Visitor PWA Network Activity**](#first-time-visitor-pwa-network-activity)
    - [**Sequential Time Visitor PWA Network Activity**](#sequential-time-visitor-pwa-network-activity)
    - [**"Lazy Load Assets" Lighthouse Performance**](#%22lazy-load-assets%22-lighthouse-performance)
    - [**"CloudFront Distribution" Lighthouse Performance !Feed-12**](#%22cloudfront-distribution%22-lighthouse-performance-feed-12)
    - [**Browser Javascript Turnt Off !Feed-13**](#browser-javascript-turnt-off-feed-13)
    - [**Offline Viewing !Feed-14**](#offline-viewing-feed-14)
    - [**Service Worker Async Pulls Chunks !Feed-17**](#service-worker-async-pulls-chunks-feed-17)
    - [**Safari Technology Preview (PWAs are on their way to MacOS) !Feed-16**](#safari-technology-preview-pwas-are-on-their-way-to-macos-feed-16)
    - [**CloudFront Popular Objects Report !Feed-15**](#cloudfront-popular-objects-report-feed-15)
- [HNPWA](#hnpwa)
- [Relevant Links](#relevant-links)
- [Extra Extra Credit](#extra-extra-credit)
    - [_if you are into that sort of thing_](#if-you-are-into-that-sort-of-thing)

## Get Started

- `> create-react-app enlightenment-series --scripts-version=react-scripts-ts`
- `> cd enlightenment-series`

### **"Initial Build" Lighthouse Performance**

![Feed-1](../../../images/react-lighthouse-primer/feed-1.png)

- `> yarn add react-snapshot`
- For the purposes of this presentation invert `noImplicitAny` to `false` in `tsconfig.json`:

```json
{
  "compilerOptions": {
    "outDir": "build/dist",
    "module": "esnext",
    "target": "es5",
    "lib": ["es6", "dom"],
    "sourceMap": true,
    "allowJs": true,
    "jsx": "react",
    "moduleResolution": "node",
    "rootDir": "src",
    "forceConsistentCasingInFileNames": true,
    "noImplicitReturns": true,
    "noImplicitThis": true,
    "noImplicitAny": false,
    "strictNullChecks": true,
    "suppressImplicitAnyIndexErrors": true,
    "noUnusedLocals": true
  },
  "exclude": [
    "node_modules",
    "build",
    "scripts",
    "acceptance-tests",
    "webpack",
    "jest",
    "src/setupTests.ts"
  ]
}
```

- The browser renders markup and styles before it parses through Javascript, so lets send the aforementioned in its complete state. Replace ReactDOM.render in `src/index.tsx` with:

```tsx
import * as React from "react";
import { render } from "react-snapshot";
import App from "./App";
import registerServiceWorker from "./registerServiceWorker";
import "./index.css";

render(<App />, document.getElementById("root") as HTMLElement);
registerServiceWorker();
```

- Update the package.json "build" script:

```json
{
  "name": "enlightenment-series",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^16.2.0",
    "react-dom": "^16.2.0",
    "react-helmet": "^5.2.0",
    "react-scripts-ts": "2.14.0",
    "react-snapshot": "^1.3.0"
  },
  "scripts": {
    "start": "react-scripts-ts start",
    "build": "react-scripts-ts build && react-snapshot",
    "test": "react-scripts-ts test --env=jsdom",
    "eject": "react-scripts-ts eject"
  },
  "devDependencies": {
    "@types/jest": "^22.2.2",
    "@types/node": "^9.6.0",
    "@types/react": "^16.0.41",
    "@types/react-dom": "^16.0.4",
    "typescript": "^2.7.2"
  }
}
```

### **"React-Snapshot" Lighthouse Performance**

![Feed-2](../../../images/react-lighthouse-primer/feed-2.png)

- Lets compare `<body></body>` tags of the original and react-snapshot `index.html`:

```html
<!-- Original -->
<body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root"></div>
    <script type="text/javascript" src="/static/js/main.fca5d544.js"></script>
</body>

<!-- React-Snapshot -->
<body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root">
        <div class="App" data-reactroot="">
            <header class="App-header">
                <img src="/static/media/logo.5d5d9eef.svg" class="App-logo" alt="logo">
                <h1 class="App-title">Welcome to React</h1>
            </header>
            <p class="App-intro">To get started, edit
                <code>src/App.tsx</code> and save to reload.</p>
        </div>
    </div>
    <script type="text/javascript" src="/static/js/main.fca5d544.js"></script>
</body>
```

- Whilst the hydration effect is minimal at this level of application simplicity; it scales well (and can be uses for multiple routes _NOTE: this is seen below_, an oppurtunity for AMP HTML rendering if one felt so). React-snapshot is preferrable IF serving static; IF dynamic, one can server-side render. Why hydrate? For intial perceptual performance and SEO. Let's reduce our CSS demand by incorprating it into our Javascript. Thereinby our transpile can treeshake redundant and unused styles whilst allowing us to style at the component level.
- `> yarn add styled-components`
- Update `src/App.tsx` accordingly (notice the `src/App.css` styles are now encorporated into module limited components):

```tsx
import * as React from "react";
import styled, { keyframes } from "styled-components";

interface Props {}

const logo = require("./logo.svg");

const AppContainer = styled.div`
  text-align: center;
`;

const AppLogoSpin = keyframes`
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
`;

/** Note: functional capability here. */
const AppLogo = styled.img`
  animation: ${AppLogoSpin} infinite 20s linear;
  height: 80px;
`;

const AppHeader = styled.div`
  background-color: #222;
  height: 150px;
  padding: 20px;
  color: white;
`;

const AppTitle = styled.div`
  font-size: 1.5em;
`;

const AppIntro = styled.div`
  font-size: large;
`;

const App = (props: Props) => (
  <AppContainer>
    <AppHeader>
      <AppLogo src={logo} alt="logo" />
      <AppTitle>Welcome to React</AppTitle>
    </AppHeader>
    <AppIntro>
      To get started, edit <code>src/App.tsx</code> and save to reload
    </AppIntro>
  </AppContainer>
);

export default App;
```

- The new HTML `<body></body>` is as so. _Note: the new style classes embedded in the Javascript below_:

```html
<body>
    <noscript>You need to enable JavaScript to run this app.</noscript>
    <div id="root">
        <div class="sc-bdVaJa khUSez" data-reactroot="">
            <div class="sc-htpNat bvrYjX">
                <img class="sc-bwzfXH ldyXqg" src="/static/media/logo.5d5d9eef.svg" alt="logo">
                <div class="sc-bxivhb dJLTzd">Welcome to React</div>
            </div>
            <div class="sc-ifAKCX bsUOqa">To get started, edit
                <code>src/App.tsx</code> and save to reload</div>
        </div>
    </div>
    <script type="text/javascript" src="/static/js/main.1bbbc589.js"></script>
</body>
```

### **"Component Level Transpiled CSS with Styled-Components" Lighthouse Performance**

![Feed-3](../../../images/react-lighthouse-primer/feed-3.png)

- Time to add routes via React-Router.
- `> yarn add react-router-dom`
- `> mkdir src/components src/containers`
- `> touch src/components/AppShell.tsx src/components/AppRouter.tsx src/components/RouteOne.tsx src/components/RouteTwo.tsx src/components/NotFound.tsx`
- In `src/components/AppShell.tsx`:

```tsx
import * as React from "react";
import styled from "styled-components";
import { Header } from "./Header";
import { AppRouter } from "./AppRouter";

const Container = styled.div`
  text-align: center;
`;

export const AppShell = () => (
  <Container>
    <Header />
    <AppRouter />
  </Container>
);
```

- In `src/components/Header.tsx`:

```tsx
import * as React from "react";
import styled, { keyframes } from "styled-components";

const logo = require("../logo.svg");

const Banner = styled.div`
  background-color: #222;
  height: 150px;
  padding: 20px;
  color: white;
`;

const SpinAnimation = keyframes`
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
`;

const AppLogo = styled.img`
  animation: ${SpinAnimation} infinite 20s linear;
  height: 80px;
`;

const Title = styled.div`
  font-size: 1.5em;
`;

export const Header = () => (
  <Banner>
    <AppLogo src={logo} alt="logo" />
    <Title>Welcome to React</Title>
    <Link to="/">
      <p>Route One</p>
    </Link>
    <Link to="/routetwo">
      <p>Route Two</p>
    </Link>
    <Link to="/asdf">
      <p>404 URL</p>
    </Link>
  </Banner>
);
```

- In `src/components/AppRouter.tsx`:

```tsx
import * as React from "react";
import { Switch, Route } from "react-router-dom";
import { RouteOne } from "./RouteOne";
import { RouteTwo } from "./RouteTwo";
import { NotFound } from "./NotFound";

/** Note: purely declarative routing */
export const AppRouter = () => (
  <main>
    <Switch>
      <Route path="/routetwo" component={RouteTwo} />
      <Route exact={true} path="/" component={RouteOne} />
      <Route component={NotFound} />
    </Switch>
  </main>
);
```

- In `src/components/RouteOne.tsx`:

```tsx
import * as React from "react";
import styled from "styled-components";

const AppIntro = styled.div`
  font-size: large;
`;

export const RouteOne = () => (
  <AppIntro>
    <p>This is Route One</p>
    <p>
      To get started, edit <code>src/App.tsx</code> and save to reload
    </p>
  </AppIntro>
);
```

- In `src/components/RouteTwo.tsx`:

```tsx
import * as React from "react";
import styled from "styled-components";

const AppIntro = styled.div`
  font-size: large;
`;

export const RouteTwo = () => (
  <AppIntro>
    <p>This is Route Two</p>
    <p>
      To get started, edit <code>src/App.tsx</code> and save to reload
    </p>
  </AppIntro>
);
```

- In `src/components/NotFound.tsx`:

```tsx
import * as React from "react";

export const NotFound = () => <h3>404: Not Found</h3>;
```

- Add Router in `src/index.tsx` to:

```tsx
import * as React from "react";
import { render } from "react-snapshot";
import { BrowserRouter as Router } from "react-router";
import registerServiceWorker from "./registerServiceWorker";
import { AppShell } from "./components/AppShell";

render(
  <Router>
    <AppShell />
  </Router>,
  document.getElementById("root") as HTMLElement
);
registerServiceWorker();
```

### **Our Three New Routes**

![Feed-4](../../../images/react-lighthouse-primer/feed-4.png)

### **Our New Router**

![Feed-8](../../../images/react-lighthouse-primer/feed-8.png)

- Currently we have a monolithic Javascript Webpack output:

### **Build Directory - Monolithic Output**

![Feed-5](../../../images/react-lighthouse-primer/feed-5.png)

- Lets lazy-load Javascript assets via async routes.
- `> touch src/containers/AsyncContainer.tsx src/components/AsyncRouteTwo.tsx src/components/AsyncNotFound.tsx`
- Update `src/components/AppRouter.tsx` for async routes:

```tsx
import * as React from "react";
import { Switch, Route } from "react-router-dom";
import { RouteOne } from "./RouteOne";
import { AsyncRouteTwo as RouteTwo } from "./AsyncRouteTwo";
import { AsyncNotFound as NotFound } from "./AsyncNotFound";

/** Note: purely declarative routing */
export const AppRouter = () => (
  <main>
    <Switch>
      <Route path="/routetwo" component={RouteTwo} />
      <Route exact={true} path="/" component={RouteOne} />
      <Route component={NotFound} />
    </Switch>
  </main>
);
```

- In `src/containers/AsyncContainer.tsx`:

```tsx
import * as React from "react";

export default function asyncComponent(getComponent: any) {
  class AsyncComponent extends React.Component {
    static Component: any;
    state = { Component: AsyncComponent.Component };

    componentWillMount() {
      if (!this.state.Component) {
        getComponent().then((Component: any) => {
          AsyncComponent.Component = Component;
          this.setState({ Component });
        });
      }
    }

    render() {
      const { Component } = this.state;
      if (Component) {
        return <Component {...this.props} />;
      }
      return null;
    }
  }
  return AsyncComponent;
}
```

- In `src/components/AsyncRouteTwo.tsx`:

```tsx
import asyncComponent from "../containers/AsyncComponent";

export const AsyncRouteTwo = asyncComponent(() =>
  import("./RouteTwo").then((module: any) => module.RouteTwo)
);
```

- In `src/components/AsyncNotFound.tsx`:

```tsx
import asyncComponent from "../containers/AsyncComponent";

export const AsyncNotFound = asyncComponent(() =>
  import("./NotFound").then((module: any) => module.NotFound)
);
```

- Our new chunked Javascript assets:

### **Build Directory - Lazy Loading Chunks Output**

![Feed-9](../../../images/react-lighthouse-primer/feed-9.png)

- Our app is a Progressive Web Application. On first load and transitioning through all routes we have this Network activity:

### **First Time Visitor PWA Network Activity**

![Feed-10](../../../images/react-lighthouse-primer/feed-10.png)

- Our app is a Progressive Web Application. On sequential loads our Network activity:

### **Sequential Time Visitor PWA Network Activity**

![Feed-11](../../../images/react-lighthouse-primer/feed-11.png)

### **"Lazy Load Assets" Lighthouse Performance**

![Feed-7](../../../images/react-lighthouse-primer/feed-7.png)

- `> yarn build`
- `> aws s3 mb "s3://enlightenment-series-4604bd5718a4f7eaf48ee7b081de4c2813d9470d" --profile testaccount --region us-east-1`
- `> aws s3 website "s3://enlightenment-series-4604bd5718a4f7eaf48ee7b081de4c2813d9470d" --index-document index.html --error-document index.html --profile testaccount --region us-east-1`
- `> aws s3 sync build "s3://enlightenment-series-4604bd5718a4f7eaf48ee7b081de4c2813d9470d" --profile testaccount --region us-east-1 --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers`
- The S3 URL is now: `http://enlightenment-series-4604bd5718a4f7eaf48ee7b081de4c2813d9470d.s3-website-us-east-1.amazonaws.com/`
- Create the CloudFront according to this article: `https://medium.com/@omgwtfmarc/deploying-create-react-app-to-s3-or-cloudfront-48dae4ce0af`. Why use CloudFront CDN? CloudFront will cache and distribute static documents geographically closer to users at local AWS Edge Locations. This translates to a user in San Francisco having a comporable experience to one in Washington DC despite the assets originating from region us-east-1 (because a Californian would get the asset next door). The contrast to this (and more typical) is that a request from California would have to travel across the United States and back thereinby negatively affecting an entire coast's user experience. The reduction of network travel should minimize bounce rates, etc. CloudFront, as well, quickly enables configuration for HTTP/2, GZIP and distributes SSLs for HTTPS. This should provide us a good mark below on our Progressive Web Application:
- The CloudFront URL is now: `https://d34fl1nfj4ze8f.cloudfront.net/`

### **"CloudFront Distribution" Lighthouse Performance ![Feed-12](../../../images/react-lighthouse-primer/feed-12.png)**

### **Browser Javascript Turnt Off ![Feed-13](../../../images/react-lighthouse-primer/feed-13.png)**

### **Offline Viewing ![Feed-14](../../../images/react-lighthouse-primer/feed-14.png)**

### **Service Worker Async Pulls Chunks ![Feed-17](../../../images/react-lighthouse-primer/feed-17.png)**

### **Safari Technology Preview (PWAs are on their way to MacOS) ![Feed-16](../../../images/react-lighthouse-primer/feed-16.png)**

### **CloudFront Popular Objects Report ![Feed-15](../../../images/react-lighthouse-primer/feed-15.png)**

_Note: I have reloaded the page more than 5 times, significantly more, and the index.html has only been pulled 5 times. This is because assets are locally cached via a PWA Service Worker (network proxy). Second note: source maps should be removed as is a development artifact._

## HNPWA

There exists a challenge called the "Hacker News PWA" and it considers itself the spirtiual successor to the "TodoMVC". I have gone ahead and collected network performance metrics of the stack above as the challenge requests. As the above was especially attentive to Lighthouse, this entry may not meet the higher standards found within the [HNPWA site](https://hnpwa.com/). If you are interested in all manners of optimizations for your web applications (request caching, continued budgeting of dependencies with webpack, etc), check it out.

The images below reflect the stacks local market performance:

![local-market image](../../../images/react-lighthouse-primer/local-market-react-1.png)
![local-market image](../../../images/react-lighthouse-primer/local-market-react-2.png)
![local-market image](../../../images/react-lighthouse-primer/local-market-react-3.png)

The images below reflect the stacks emerging market performance (a 3G Basic connection on a lower-end device):

![emerging-market image](../../../images/react-lighthouse-primer/emerging-market-react-1.png)
![emerging-market image](../../../images/react-lighthouse-primer/emerging-market-react-2.png)
![emerging-market image](../../../images/react-lighthouse-primer/emerging-market-react-3.png)

## Relevant Links

- https://developers.google.com/web/fundamentals/performance/prpl-pattern/
- http://www.typescriptlang.org/
- https://github.com/nfl/react-helmet
- https://github.com/geelen/react-snapshot
- https://en.wikipedia.org/wiki/Functional_programming
- https://developers.google.com/web/progressive-web-apps/
- https://developers.google.com/web/tools/lighthouse/
- https://developers.google.com/web/tools/lighthouse/audits/custom-splash-screen

## Extra Extra Credit

### _if you are into that sort of thing_

- https://storybook.js.org/ in-lieu of http://patternlab.io/- https://github.com/redux-observable/redux-observable
- https://facebook.github.io/flux/
- http://reactivex.io/rxjs/
- https://12factor.net/
- https://www.ampproject.org/
- https://medium.com/styled-components/the-simple-guide-to-server-side-rendering-react-with-styled-components-d31c6b2b8fbf

This concludes _Functional React Primer with a bit of PRPL PWA Pattern (featuring Typescript), but Minus Critical CSS Server-Side Rendering_.
