---
title: "Polymer 2.0 in Drupal 8.4.*"
date: 2017-10-25T00:40:03-04:00
update: 2017-10-27T00:40:03-04:00
draft: false
tags: ["Polymer", "Drupal 8", "Open Source", "Workflows", "Organization"]
categories: ["Technology"]
---

`This article is under construction.`

The web has come long since my joining of the space. Once HTML5, jQuery and AngularJS were magical. However, when scale was introduced my codebases leveraging such became racked with technical debt when optimizations were absent. Technology and 'best practices' are ephemeral in this space as we know. Are we stuck on a hedonic treadmill? Perhaps it is Sisyphean. The answer likely doesn't exist below; but it merits further consideration: Web Component's<a href="#1"><sup>1</sup></a> proximity to the browser platform makes it a candidate for truly interoperable components between a matrix of orchestration technologies (Angular, React, ASP, Drupal, etc).  

## tl:dr;
<a href="#cut-to-the-chase">Skip to Polymer 2.0 as orchestrated by Drupal 8.4.* Setup</a>

## Extend HTML5 with Web Components
Web Components utilize modern browser features such as Custom Elements, Shadow Dom, HTML Imports and HTML Templates<a href="#2"><sup>2</sup></a>?. For browsers that do not support all of these features, polyfills exist with a small footprint (~36kb in the worst of IE11) in comparison to heavy JS contemporaries. Browsers, like Chrome, that support the aforementioned, have a JS footprint of ~10kb. As per development, the approach undertaken to develop Elements deltas the typical Turing Complete JS approach but lacks no less the flexibility once understood. 

With Polymer you are able to develop an Element once and use anywhere as long as its imported correctly and it's dependencies are represented. This is further improved if the interfaces of an Element are deliberately abstracted. As an organization, you would then be able to disperse these Elements through a matrix of projects where the only limitation is whether the project is meant for a browser. Typical constraints of whether it is an Angular Component, etc will no longer be relevant as the Web Component technology is agnostic given it's proximity to the metal. 

- Bridges for JS orchestration layers:
	- [React with React-Polymer](https://github.com/jscissr/react-polymer)
	- [Angular with Origami](https://github.com/hotforfeature/origami)

- Extra Reading:
	- [Browser Support](https://www.polymer-project.org/2.0/docs/browsers)
	- [Polymer 2 - 10kb Web Framework](https://www.captaincodeman.com/2017/03/31/polymer-2-10kb-web-framework)

## Web Only
Web Components being coupled to the platform likely lack the proper interface for Hybrid Mobile application frameworks such as React Native or Native Script<a href="#3"><sup>3</sup></a>.

## Expediting Workflows by Minimizing Feedback Loops 
Polymer Elements, in utilization of the Shadow DOM, encapsulate styles nicely reducing the need for obtuse CSS preprocessors like SASS. This is not to say they need be abandoned as you could still use them in an atomic fashion to describe your base theme, but reducing the computation required to compile your SASS per dev build minimizes overhead of feedback loops. 

Changes to a Polymer Element can be observed via `polymer serve` in the directory with the `polymer.json` file. The demo page will live in `localhost:8081`; allowing for visual feedback loops as quick as a browser refresh. 

For changes to reflect in Drupal, the Polymer Elements must be be built via `polymer build` in the directory with the `polymer.json` file. In my implementation captured below, Drupal 8 asks for the contents of said build folder. In general, the build is executed quicker than a typical `drush cr`. Given the Web Components are HTML Imported into the Drupal application (via the root Twig file of `html.html.twig`) and are by extension not coupled to it's cacheing system; there is no need to `drush cr` between Element updates. Taking this further, with basic file watchers, you could likely automate `polymer build`.

In conclusion, a standard feedback loop is provisioned by combinatory effort of a Gulp pipeline and/or Webpack that compiles SASS, ES6/Typescript and then clearing Drupal's cache. Pure Polymer would remove the SASS and cache clearing steps before further optimizations. 

## Blackboxes and Composition
Components by definition are discrete units that maintain an interface for complying with peers. They are traditionally composed of one another and so on and so forth. Each component behaves as a lambda (or a functional blackbox), accepting a specific input and returning a specific output. The utilization of any component only requires that you declaratively provide the properties it's interface requires. The expected 1:1 I/O relationship is the contract between user and creator of said elements.

Polymer respects the above definitions. Developing it primarily requires the developer to: 1.1) respect contracts, 1.2) declaratively compose and 2) not overly sweat how the browser handles details and/or control flows. 

Components and its development is most metaphorically represented by lego blocks. If you have never worked with them in the past, the initial mind shift is the most difficult part of the adoption. 

## Into the Rabbit Hole of Contracts, CI/CD and Testability
After you build an element, it is easy to apply Unit Tests and E2E tests. Given the Web Components, whether dumb or intelligent, reflect some state and output 1:1 according to it. Proper functional I/O is encouraged in the developing of your element as it allows a thorough deterministic test suite. Slotting, though powerful and affluent in my Drupal 8 implementation, does introduce external state which complicates element testing <a href="#4"><sup>4</sup></a>.

CI/CD<a href="#5"><sup>5</sup></a> processes allow the elements to be thoroughly scrutinized, vetted and validated at it's most intimate levels on a commit basis. If you are an organization maintaining a repository of Polymer elements; CI/CD per element may only be necessary within the central host repository itself and not at the project level

```
Complete this. Don't forget fixed costs distributed via a matrix of projects. 
```


 (though project level testing for edge cases could be argued). The output of this would be expedited builds per projects as fixed cost resources are dispersed throughout a matrix utilizing shared elements. Other issues of shared technology may arrive if contracts are not respected (unit tests serve to be the guarantor); this by extension provides another argument for project level testing of dependencies.

## The Markup Problem
<span class="hidden">Atomic Design, Pattern Lab</span>
`To be completed`

<a name="cut-to-the-chase"></a>
## How to implement Polymer 2.0 in Drupal 8.4.*
This was executed on a macOS 10.x machine. Steps are as follows: 

### Requirements
- Required
	- Drupal 8
	- Polymer CLI
	- [Bower](https://bower.io/)
	- [Drupal Console](https://github.com/hechoendrupal/drupal-console)
	- [Drush](https://github.com/drush-ops/drush)
- Optional
	- [Docksal](https://github.com/docksal/docksal)

### Drupal 8 Initialization with Drupal Composer ❤️ Docksal (Optional)
This particular step is optional. If your project is new; this solution provides simple container and dependency management batteries included.
```bash
git clone https://github.com/alejandroq/drupal8-composer-docksal.git myrepo;
cd myrepo;
fin init;
```

### Theme Setup (Required)
1) Generate a new theme.
```
cd $PROJECTROOT/web;
fin drupal generate:theme;
```

2) Fill out appropriate requested information. Select 'Stable' as your theme's base theme. The result should be a `themename.info.yml` with contents of: 
```
name: obra-theme-naked
type: theme
description: Obra Theme without any opinion. Polymer requirements built in.
package: Obra
core: 8.x
libraries:
  - obra_theme_naked/global-styling
 
base theme: stable
```

3) Init Polymer:
```
cd $PROJECTROOT/web/themes/custom/themename;
polymer init;
# select option 1: polymer-2-element
```

4) Edit `polymer.json` to match the following:
```
{
  "entrypoint": "index.html",
  "fragments": [],
  "sources": [
    "themename-element.html",
    "index.html"
  ],
  "extraDependencies": [
  ],
  "builds": [
    {
      "name": "es6-unbundled",
      "browserCapabilities": [
        "es2015",
        "push"
      ],
      "js": {
        "minify": true,
        "compile": false
      },
      "css": {
        "minify": true
      },
      "html": {
        "minify": true
      },
      "bundle": false,
      "addServiceWorker": true,
      "addPushManifest": true,
      "preset": "es6-unbundled"
    }
  ],
  "lint": {
    "rules": [
      "polymer-2"
    ]
  }
}

```

5) Build your first Polymer element via `polymer build` in your Theme's root directory.

6) Create and overwrite Stable Theme's `html.html.twig`:
```
cd $PROJECTROOT/web/themes/custom/themename;
mkdir templates;
cp ../../../core/themes/stable/templates/layout/html.html.twig templates/html.html.twig 
```
Update the `html.html.twig` to reflect: 
```html
<!DOCTYPE html>
<html{{ html_attributes }}>
  <head>
    <head-placeholder token="{{ placeholder_token|raw }}">
    <title>{{ head_title|safe_join(' | ') }}</title>
    <css-placeholder token="{{ placeholder_token|raw }}">
    <js-placeholder token="{{ placeholder_token|raw }}">

    {# MUST FOR POLYMER ELEMENT UTILIZATION #}
    <link rel="import" href="{{ directory }}/build/es6-unbundled/themename-element.html">
    {# END MUST FOR POLYMER ELEMENT UTILIZATION g#}

  </head>
  <body{{ attributes }}>
    {#
      Keyboard navigation/accessibility link to main content section in
      page.html.twig.
    #}
    <a href="#main-content" class="visually-hidden focusable">
      {{ 'Skip to main content'|t }}
    </a>
    {{ page_top }}
    {{ page }}
    {{ page_bottom }}
    <js-bottom-placeholder token="{{ placeholder_token|raw }}">
  </body>
</html>
```

7) `to complete library`

## Initial Implementation Challenges 
Developmental challenges I experienced are below; not to be confused with cons. A few of the items may be related to my implementation:

- Related to Drupal:
	- Paint times need to be further optimized likely via some sort of lazy loading or minimizing initial app shell dependencies. Likely due to HTML Import latency. An initial PWA loading screen can fix this.
- General Polymer:
	- Lack of opinion.
	- Documentation for 2.0 gets obfuscated by 1.0.
	- Bower for flat dependencies is humorous when Bower tells you to use Yarn, but Polymer currently prioritizes Bower.
	- Slotting, though powerful, is a bit odd to style. This is supposedly due to the hybrid nature of the components slot<a href="#6"><sup>6</sup></a>. 
	- `polymer build` could be improved as far as optimizations and error handling goes. 
	- As for errors there are two extremes: 1) your console barfs red or 2) it quietly fails lacking any indication of reason
- Webcomponents.org's Elements being black boxes occasionally lead to head scratches in dysfunctionality. Documentation is handled on a per developer basis. More automation should likely be introduced to the documentations development per tool. Perhaps based off of tests, etc? 
- CSS variable scoping seems a bit global.

## Where to go from here with Polymer 2.0 and Drupal 8.4.*
To list a few ideas:

- Setup a Progressive Web Application with a `manifest.json` and appropriate tooling (Polymer comes with half of it).
- Setup custom Drupal 8 Blocks for Site Builders to move Polymer Elements orchestrated in Twig files per site building expectation. Would work well for Lightning Distributions, etc.
- Upgrade current unscaled jQuery and/or Vanilla JS for a complicated Drupal 8 web application via a strangler pattern. 
<li class="hidden">Turn your Drupal 8 application into a very dynamic application without the heavy JS. For example in the [Obra Theme Demo](https://github.com/alejandroq/obra-drupal-demo) there is a `<obra-list-ajax></obra-list-ajax>` element that accepts a parameter of `get="mysite.docksal/jsonapi/node/article"`. The element contains an [RXJS](http://reactivex.io/rxjs/) Observable that polls the URL and appends Material cards for new content. Aka when new Drupal 8 content is created it should appear on surfing users devices within N ms. The [JSONAPI](https://www.drupal.org/project/jsonapi) was used for this case as it's output interface is quite flexible for numerous applications.</li> 

## Conclusion
Web Components are modern; they adhere to rigorous testability, reliance on individual distribution (S3 and Cloud Front?), compostability and are declarative on the browser. Whether it's array of theoretical capabilities are realized is somewhat besides the point; it is left field to it's compatriots. Could it be the step off of the treadmill or the trough of Sisyphus' mountain? They say not all "progress" is progress -- so Polymer plays a different game than we are used to in order to interoperate with what we are used to. 


## Resources
- [Obra Theme Demo based from Drupal Composer ❤️ Docksal Git Repo](https://github.com/alejandroq/obra-drupal-demo)
- [Obra Theme Git Repo](https://github.com/alejandroq/obra-drupal-theme)
- [Obra Theme Naked Git Repo](https://github.com/alejandroq/obra-drupal-theme-naked)
- [Drupal Composer](https://github.com/drupal-composer/drupal-project)
- [Docksal](https://github.com/docksal/docksal)

<hr>
Footnotes:

<a name="1"><sup>1</sup></a> Throughout this article I will use Polymer and Web Components interchangeably.

<a name="2"><sup>2</sup></a> Details can be found at [webcomponents.org](https://www.webcomponents.org/introduction).

<a name="3"><sup>3</sup></a> I have not tested Polymer for mobile apps but predict outside of Cordova, Phone Gap or Ionic it will not work proper.

<a name="4"><sup>4</sup></a> Slotting works great to achieve interoperability with Drupal 8's template engine, Twig.

<a name="5"><sup>5</sup></a> Continuous Integration and Continuous Deployment.

<a name="6"><sup>6</sup></a> Slot styling is a problem I am working on figuring out now.
