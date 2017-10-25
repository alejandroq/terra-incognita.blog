---
title: "Polymer 2.0 in Drupal 8.4.*"
date: 2017-10-25T00:40:03-04:00
draft: false
tags: ["Polymer", "Drupal 8", "Open Source"]
categories: ["Technology"]
---

`This article is under construction.`

The web has come long since my joining of the space. Once HTML5, jQuery and AngularJS were magical. However, when scale was introduced my codebases leveraging such became racked with technical debt when optimizations were absent. Technology and 'best practices' are ephemeral in this space as we know. Are we stuck on a hedonic treadmill? Perhaps it is Sisyphean. The answer likely doesn't exist below; but it merits further consideration: Web Component's[^ Throughout this article I will use Polymer and Web Components interchangeably] proximity to the browser platform makes it a candidate for truly interoperable components between a matrix of orchestration technologies (Angular, React, ASP, Drupal, etc).  

## tl:dr;
```
To be completed.
```

## Extend HTML5 with Web Components
Web Components utilize modern browser features such as Custom Elements, Shadow Dom, HTML Imports and HTML Templates[^ Details can be found at [webcomponents.org](https://www.webcomponents.org/introduction)]. For browsers that do not support all of these features, polyfills exist with a small footprint (~36kb in the worst of IE11) in comparison to heavy JS contemporaries. Browsers, like Chrome, that support the aforementioned, have a JS footprint of ~10kb. As per development, the approach undertaken to develop Elements deltas the typical Turing Complete JS approach but lacks no less the flexibility once understood. 

With Polymer you are able to develop an Element once and use anywhere as long as its imported correctly and it's dependencies are represented. This is further improved if the interfaces of an Element are deliberately abstracted. As an organization, you would then be able to disperse these Elements through a matrix of projects where the only limitation is whether the project is meant for a browser. Typical constraints of whether it is an Angular Component, etc will no longer be relevant as the Web Component technology is agnostic given it's proximity to the metal. 

- Extra Reading:
	- [Browser Support](https://www.polymer-project.org/2.0/docs/browsers)
	- [Polymer 2 - 10kb Web Framework](https://www.captaincodeman.com/2017/03/31/polymer-2-10kb-web-framework)

## Web Only
Web Components being coupled to the platform likely lack the proper interface for Hybrid Mobile application frameworks such as React Native or Native Script[^ I have not tested whether Polymer works for mobile apps, but predict outside of Cordova, Phone Gap or Ionic, it will not work proper.].

## Expedited Operation Workflows by Minimizing Feedback Loops
Polymer Elements, in utilization of the Shadow DOM, encapsulate styles nicely reducing the need for obtuse CSS preprocessors like SASS. This is not to say it need be abandoned as you could still use it in an atomic fashion to describe your base theme, but reducing the computation required to compile your SASS per change minimizes the overhead of feedback loops. 

Changes to a Polymer Element can also be live observed via `polymer serve` in the directory with the `polymer.json` file. A demo page will live in `localhost:8081`; allowing for quick visual feedback of changes made to elements. Given the Web Components are HTML Imported into the Drupal application (via the root Twig file of `html.html.twig`) and are by extension not coupled to it's cacheing system; there is no need to `drush cr` between changes on Polymer Elements. This further reduces feedback loops.

For changes to reflect in Drupal, the Polymer Elements must be be built via `polymer build` in the directory with the `polymer.json` file. This is because in this implementation, Drupal 8 asks for the contents of said build folder. In general, the build is executed quicker than a typical `drush cr`. With basic file watchers, you could likely automate `polymer build` executions to even further reduce feedback loops. 

## Blackboxes and Composition
Components by definition are discrete units that maintain an interface for complying with peers. They are traditionally composed of one another and so on and so forth. Each component behaves as a lambda (or a functional blackbox), accepting a specific input and returning a specific output. The utilization of any component only requires that you declaratively provide it the properties it's interface requires. It's required interfaces and expected output is the contract between user and creator. 

Polymer respects the above definitions. Developing it primarily requires the developer to: 1.1) respect contracts, 1.2) declaratively compose and 2) not overly sweat how the browser handles details and/or control flows. 

Components and its development is most metaphorically represented by lego blocks. If you have never worked with them in the past, the initial mind shift is the most difficult part of the adoption. 

## Into the Rabbit Hole of Contracts, CI/CD and Testability
After you build an Element, it is easy to apply Unit Tests and E2E tests. Given the Web Components, whether dumb or intelligent, reflect some state and output 1:1 according to it. This may only be circumvented with Slotting[^ Slotting works great with Drupal 8's Twig]. Proper functional I/O is encouraged in your element building as it leads to a more impactful and thorough test suite will be. This is a far cry better than days where unit testing jQuery or E2E a web page gain inherent complexity and volatility due to state not introduced directly to it (the primary delta I think of when it comes to OOP vs Functional). 

CI/CD[^ Continuous Integration and Continuous Deployment] processes allow the elements to be thoroughly scrutinized, vetted and validated at it's most intimate levels on a by commit basis. If you are an organization maintaining a repository of such elements; CI/CD per element may only be necessary within the host repository itself and not at the project level (though project level testing for edge cases could be argued). The output of this would be expedited builds per projects as fixed cost resources are dispersed throughout a matrix utilizing shared elements. Other issues of shared technology may arrive if contracts are not respected (unit tests serve to be the guarantor); this by extension provides another argument for project level testing of dependencies.

## How to implement Polymer 2.0 in Drupal 8.4.*
```
To be completed.
```

## Initial Implementation Challenges 
Developmental challenges I experienced are below; not to be confused with cons. A few of the items may be related to my implementation:

- Related to Drupal:
	- Paint times need to be further optimized likely via some sort of lazy loading or minimizing initial app shell dependencies. Likely due to HTML Import latency. An initial PWA loading screen can fix this.
- General Polymer:
	- Lack of opinion.
	- Documentation for 2.0 gets obfuscated by 1.0.
	- Bower for flat dependencies is humorous when Bower tells you to use Yarn, but Polymer currently prioritizes Bower.
	- Slotting, though powerful, is a bit odd to style. This is supposedly due to the hybrid nature of the components slot[^ Slot styling is a problem I am working on now]. 
	- `polymer build` could be improved as far as optimizations and error handling goes. 
	- As for errors there are two extremes: 1) your console barfs red or 2) it quietly fails lacking any indication of reason
- Webcomponents.org's Elements being black boxes occasionally lead to head scratches in dysfunctionality. Documentation is handled on a per developer basis. More automation should likely be introduced to the documentations development per tool. Perhaps based off of tests, etc? 
- CSS variable scoping seems a bit global.

## Where to go from here with Polymer 2.0 and Drupal 8.4.*
To list a few ideas:

- Setup a Progressive Web Application with a `manifest.json` and appropriate tooling (Polymer comes with half of it).
- Setup custom Drupal 8 Blocks for Site Builders to move Polymer Elements orchestrated in Twig files per site building expectation. Would work well for Lightning Distributions, etc.
- Turn your Drupal 8 application into a very dynamic application without the heavy JS. For example in the [Obra Theme Demo](https://github.com/alejandroq/obra-drupal-demo) there is a `<obra-list-ajax></obra-list-ajax>` element that accepts a parameter of `get="mysite.docksal/jsonapi/node/article"`. The element contains an [RXJS](http://reactivex.io/rxjs/) Observable that polls the URL and appends Material cards for new content. Aka when new Drupal 8 content is created it should appear on surfing users devices within N ms. The [JSONAPI](https://www.drupal.org/project/jsonapi) was used for this case as it's output interface is quite flexible for numerous applications.

## Conclusion
Web Components are modern. They adhere to Cloud Principals (according to some book I read) of rigorous testability, reliance on distribution (S3 with Cloud Front anyone?), compostability and are declarative on the browser. Whether it's array of theoretical capabilities are realized is somewhat besides the point; it is left field to it's compatriots. Could it be the step off of the treadmill or the trough of Sisyphus' mountain? They say not all "progress" is progress; so it seems Web Components play a different game than what we are used, to interoperate with what we are used to. 


## Resources
- [Obra Theme Demo based from Drupal Composer ❤️ Docksal Git Repo](https://github.com/alejandroq/obra-drupal-demo)
- [Obra Theme Git Repo](https://github.com/alejandroq/obra-drupal-theme)
- [Obra Theme Naked Git Repo](https://github.com/alejandroq/obra-drupal-theme-naked)
- [Drupal Composer](https://github.com/drupal-composer/drupal-project)
- [Docksal](https://github.com/docksal/docksal)