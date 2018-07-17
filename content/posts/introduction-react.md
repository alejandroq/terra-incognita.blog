---
title: "An Introduction to ReactJS"
date: 2018-06-04T23:12:17+02:00
draft: false
git: https://github.com/alejandroq/react-intro.tcm.edu
---

_This article was originally part of my "edu" series originally publicized via a GitHub repository and live presented to a group of peers. Therefore much of it is organized in a manner meant to direct said presentation and is not optimized as an article._

<!--more-->

- [Goal](#goal)
- [Ulterior Motives](#ulterior-motives)
- [What is Not Included](#what-is-not-included)
- [What is Included](#what-is-included)
- [General Note on an Unopinionated Library](#general-note-on-an-unopinionated-library)
- [Must Have Software](#must-have-software)
- [Knowledge Requirements](#knowledge-requirements)
- [Key React Dogma: https://reactjs.org/](#key-react-dogma-httpsreactjsorg)
- [Getting Started](#getting-started)
- [Components](#components)
- [Decomposing a UI into Components](#decomposing-a-ui-into-components)
- [React's Virtual DOM and its diffing algorithm](#reacts-virtual-dom-and-its-diffing-algorithm)
- [Handling Events](#handling-events)
- [Synthetic Events](#synthetic-events)
- [Styling](#styling)
- [Conditional Elements](#conditional-elements)
- [Directory Structure](#directory-structure)
- [Thinking in React](#thinking-in-react)
- [Versus Web Components](#versus-web-components)
- [Context API](#context-api)
- [Higher Order Components (HOC)](#higher-order-components-hoc)
- [Recompose](#recompose)
- [Performance Optimization](#performance-optimization)
- [Resources](#resources)

## Goal

Provision an academic understanding of component-based development and React. Point our further resources if interested.

## Ulterior Motives

Iteration, composition and declaration equate to a generally more horizontal application with improved testability and determinism.

## What is Not Included

- Combining React with frameworks such as Drupal. This is likely well documented elsewhere.
- Non-`Create A React App` (CRA) React app instantiation. Custom Webpack solutions can be rolled up for edge cases.
- In-order to keep to basics I will not go into the following:
  - RxJS
  - MobX
  - Jest
  - ImmutableJS
  - StorybookJS
  - Async Loading Components
  - Server Side Render (SSR)
  - Redux Middlewares (Netflix and RxJS)
  - Form Handling is traditional HTML handling
  - Redux (most popular Flux implementation for React)
  - etc

## What is Included

- Fundamentals
- And a few opinions

## General Note on an Unopinionated Library

React has a massive ecosystem so 10 developers if asked, will return 11 best React setups. This is indicative of the lack of opinion the library holds.

## Must Have Software

- NodeJS
- NPM || Yarn
- create-react-app CLI tool (npm i -g create-react-app)

## Knowledge Requirements

- Basic ES6 understanding
  - If you know JS, you can pick up React
  - JSX is only syntatical sugar over the XMLs in a Component
- Basic Browser understanding
- Understanding Webpack in concept
- Basic Terminal CLI use

## Key React Dogma: [https://reactjs.org/](https://reactjs.org/)

- Declarative over Imperative
  - Emphasis on iteration and declaration of intent vs specific discourse in code. In-code:

```js
/** basic - increment all ints in an array */

/** imperative */
let arr = [1, 2, 3];
for (let i = 0; i < arr.length; i++) {
  arr[i] = arr[i] + 1;
}
console.log(arr);

/** declarative */
console.log([1, 2, 3].map(x => x + 1));
```

- JS operations on the Virtual DOM are faster than crawling the actual DOM
- Component-based
  - Components encapsulate their functionality and maintain their own state. Additional information below.
- Learn Once, Write Anywhere
  - React lives on many platforms such as React Native for Mobile and React VR for VR.

## Getting Started

```sh
> create-react-app <your-app-name>
```

## Components

What is a component? You already use them. HTML tags are each 'atomic' or 'leaf' components. How would you re-implement a paragraph tag in React?

![what is a component?](../../../images/introduction-react/03-component.png)

```html
<p style="color:red">Some Test</p>
```

```js
/** imagine T below as a generic - in-browser a <p> tag is a primitive. we are using deconstruction to get the props content into variables by key/value */
const p = ({ style, children }) => <T {...style}>{children}</T>;

/** the above is equivalent to */
const p = props => <T {...props.style}>{props.children}</T>;
```

`Style` in the above example is a 'prop' and anything within the tags are children. Lets create a BoldText component:

```js
const BoldText = ({ children }) => (
  <p>
    <strong>{children}</strong>
  </p>
);

/** utilized as so */
() => <BoldText>This is a child</BoldText>;
```

In React you have two (and a third) styles of Components: Functional (or Presentation) and Class-based (or State-based | Containers). There is a larger distinction: Functional lacks state and lifecycle hooks; the Class-based has them. A Functional Component is a Dumb Component or sometimes called a Presentation Component. Heavy logical operations should be restricted to the latter.

```js
/** Container */
/** lifecycle hooks: https://reactjs.org/docs/react-component.html */
const Todo = ({ todo, index, handler }) => (
  <div>
    <p>
      <span>{index}</span>
      {todo}
    </p>
    <button onClick={handler} />
  </div>
);

// Copied and pasted from reactjs.org
class TodoApp extends React.Component {
  constructor(props) {
    super(props);
    this.state = { items: [], text: "" };
    this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }

  render() {
    return (
      <div>
        <h3>TODO</h3>
        <TodoList items={this.state.items} />
        <form onSubmit={this.handleSubmit}>
          <label htmlFor="new-todo">What needs to be done?</label>
          <input
            id="new-todo"
            onChange={this.handleChange}
            value={this.state.text}
          />
          <button>Add #{this.state.items.length + 1}</button>
        </form>
      </div>
    );
  }

  handleChange(e) {
    this.setState({ text: e.target.value });
  }

  handleSubmit(e) {
    e.preventDefault();
    if (!this.state.text.length) {
      return;
    }
    const newItem = {
      text: this.state.text,
      id: Date.now()
    };
    this.setState(prevState => ({
      items: prevState.items.concat(newItem),
      text: ""
    }));
  }
}
```

So rule of thumb: if stateful use a class else use a function. Functions get all of their guts via props and **ALWAYS** output the same thing (pure I/O).

React JSX templates are in pure JS so we can take advantage of data structure such as a Sets, Arrays, Objects and handle Functional Programming esque operations.

Note: a presentation component CAN contain a container component as a child. There is no hard and fast rule against this.

## Decomposing a UI into Components

![components example alt text](./../../../images/introduction-react/01-components.png)
![components example alt text](./../../../images/introduction-react/02-components.png)

## React's Virtual DOM and its diffing algorithm

The `render()` function of any Component returns a tree of React elements; on state and prop updates a derive a new tree returned by `render()`.

> There are some generic solutions to this algorithmic problem of generating the minimum number of operations to transform one tree into another. However, the state of the art algorithms have a complexity in the order of O(n3) where n is the number of elements in the tree.

> If we used this in React, displaying 1000 elements would require in the order of one billion comparisons. This is far too expensive. Instead, React implements a heuristic O(n) algorithm based on two assumptions:

> Two elements of different types will produce different trees.
> The developer can hint at which child elements may be stable across different renders with a key prop.
> In practice, these assumptions are valid for almost all practical use cases.

Quote from: [https://reactjs.org/](https://reactjs.org/)

```js
// Reacts reconciliation algorithm expects certain implementation details for deterministic behavior and the O(n) algorithm time. Such an implementation is seen with the `key` prop for dynamic elements below.
const todos = ["xyz", "abc"];
const Todo = ({ content }) => <li>{content}</li>;
export const TodoList = () => (
  <ul>{todos.map((todo, index) => <Todo content={todo} key={index} />)}</ul>
);
```

[https://reactjs.org/docs/reconciliation.html](https://reactjs.org/docs/reconciliation.html)

## Handling Events

Rule of thumb: if there is a HTML event listener (ala: `onclick`), make it camelCase on a React Component: `onClick`.

- [https://reactjs.org/docs/handling-events.html](https://reactjs.org/docs/handling-events.html)

## Synthetic Events

Details: [https://reactjs.org/docs/events.html](https://reactjs.org/docs/events.html)

tl:dr Promote cross-browser serenity. The synthetic event is ~1 level higher than a typical JS HTML Event (onclick, etc) and is pooled for performance purposes. To utilize for async purposes, call `event.persist()`; this will remove event from pool and place in your place of selection.

```js
function onClick(event) {
  console.log(event); // => nullified object.
  console.log(event.type); // => "click"
  const eventType = event.type; // => "click"

  setTimeout(function() {
    console.log(event.type); // => null
    console.log(eventType); // => "click"
  }, 0);

  // Won't work. this.state.clickEvent will only contain null values.
  this.setState({ clickEvent: event });

  // You can still export event properties.
  this.setState({ eventType: event.type });
}
```

## Styling

CRA comes with a preference for CSS. The `02-react/README.md` bears information on including SCSS. Other options include CSS in JS such as (Styled-Components)[https://www.styled-components.com/].

Why CSS in JS? Have one less HTTP request that delays first interaction and paint performance metrics by ~700ms on a poor 3G network. Maintain a smaller bundle size as JS is tree shaken whereas CSS is not. It also helps keep components tidier and more platform agnostic (if also creating a React Native application).

The React CRA CSS preference:

```css
.Button {
  background: blue;
}
```

```js
import styles from "./styles.css";

/** Note: styles is an object or dictionary of your imported css classes. Therein by the core React team is opinionated on that SCSS primarily benefited users in helping them prevent style leaking, but with this import solution, everything is encapsulated without the extra SCSS dependency. They may also opine that CSS Variables (good in all Browsers, but IE11) could replace typical SCSS theme variables. If you are into functional SCSS, there is no replacement for that in the CSS spec. Therein by the README.md does include a solution for including SCSS into a CRA app without ejecting and mutating the Webpack configuration */
export const AppButton = () => <button style={styles.Button}>Submit</button>;
```

- [https://codeburst.io/4-four-ways-to-style-react-components-ac6f323da822](https://codeburst.io/4-four-ways-to-style-react-components-ac6f323da822)

## Conditional Elements

If you want a element to appear given a specific condition:

```js
const todos = [];
const Todo = ({ content }) => <li>{content}</li>;
const TodoList = ({ appear }) => (
  <>
    {todos.length > 0 ? <h1>Todos</h1> : <h1>Empty List of Todos</h1>}
    <ul>{todos.map((todo, index) => <Todo content={todo} key={index} />)}</ul>
    {todos.length > 0 && <p>Count {todos.length}</p>}
  </>
);
```

## Directory Structure

My reccomendation today is for the format below:

```
src/
  components/
    Button/
      Button.css
      Button.js
    Todo/
      Todo.css
      Todo.js
  containers/
    TodoList/
      TodoList.css
      TodoList.js
```

Presentation/Dumb components live in the components directory whereas their logical cohorts live in the containers directory.

## Thinking in React

[https://reactjs.org/docs/thinking-in-react.html](https://reactjs.org/docs/thinking-in-react.html)

## Versus Web Components

> React and Web Components are built to solve different problems. Web Components provide strong encapsulation for reusable components, while React provides a declarative library that keeps the DOM in sync with your data. The two goals are complementary. As a developer, you are free to use React in your Web Components, or to use Web Components in React, or both.

## Context API

React 16 introduces the Context API. In-lieu of needing to use an external State Management pattern or library, typically Redux, a developer can place state into the global React tree and have it be accessible by any and all components that a part of it.

[https://reactjs.org/docs/context.html](https://reactjs.org/docs/context.html)

## Higher Order Components (HOC)

HOC are components that return components. In the wild these are utilized by Redux `connect`, Apollo queries, etc. HOCs allow extensible and flexible behaviors to compose components. As the composition of a HOC or a list of HOCs are generally pure functions, they tend to be side-effect free and simpler to test.

![hoc](../../../images/introduction-react/04-hoc.png)

_Note: simpler testing allows you to focus on edge cases where your application will likely fail (ie. unexpected user input, HTTP errors, mistypes, etc)._

## Recompose

[https://github.com/acdlite/recompose](https://github.com/acdlite/recompose) is a React utility library that simplifies creating HOCs. Reacts really seperated itself for template based frameworks/libraries here as the full breadth of Javascript is available to the developer as it pertains to deriving composable behaviors. An example is a toggle behavior, I can create a toggle behavior and wrap another component in it and the output is a component with toggle behavior. This could be extended to mouse tracking, etc.

Examples:

```jsx
import React from "react";
import { compose, mapPropsStream, createEventHandler } from "recompose";
import { map, combineLatest, switchMap } from "rxjs/operators";

export const openCloseStream = mapPropsStream(props$ => {
  const { stream: onClick$, handler: onClick } = createEventHandler();

  let visible = false;

  const visibility$ = onClick$
    .pipe(
      combineLatest(props$),
      map(e => {
        console.log("MADE IT THIS FAR", e);
        visible = !visible;
        return visible;
      })
    )
    .startWith(visible);

  return visibility$.map(visibility => ({ visibility, onClick }));
});

/** used like */
const enhance = compose(openCloseStream);

export const ToggleMenu = enhance(({ visibility, onClick }) => (
  <React.Fragment>
    {visibility && (
      <nav>
        <ul>
          <li>Foo</li>
          <li>Bar</li>
        </ul>
      </nav>
    )}
    <button onClick={onClick}>Show menu</button>
  </React.Fragment>
));
```

```jsx
import React from "react";
import { graphql } from "react-apollo";
import gql from "graphql-tag";
import { compose, branch, renderComponent, mapProps } from "recompose";

const _listsQuery = graphql(gql`
  query {
    todoListEntityQuery(filter: {}) {
      count
      entities {
        entityId
        ... on TodoListEntity {
          name
          state
        }
      }
    }
  }
`);

const massageLists = ({
  data: {
    todoListEntityQuery: { entities }
  }
}) => ({
  lists: entities
});

const isLoading = ({ data: { loading } }) => loading;

const hasError = ({ data: { error } }) => error;

const LoadingComponent = () => <p>Loading...</p>;

const ErrorComponent = ({
  data: {
    error: { message },
    ...props
  }
}) => (
  <React.Fragment>
    <p style={{ color: "red" }}>{message}</p>
    <code>{JSON.stringify(props)}</code>
  </React.Fragment>
);

export const listsQuery = compose(
  _listsQuery,
  branch(isLoading, renderComponent(LoadingComponent)),
  branch(hasError, renderComponent(ErrorComponent)),
  branch(hasError, renderComponent(ErrorComponent)),
  mapProps(massageLists)
);
```

## Performance Optimization

React does not compare `props` by default. When it or `state` updates, React re-renders the content. You can avoid optimize this by leveraging the `shouldComponentUpdate(): boolean` lifecycle method for a class-based component. How about a functional component? Recompose has a utility HOC for this:

```jsx
// example from recompose github
import { pure, onlyUpdateForKeys } from 'recompose';

// A component that is expensive to render
const ExpensiveComponent = ({ propA, propB }) => {...}

// Optimized version of same component, using shallow comparison of props
// Same effect as extending React.PureComponent
const OptimizedComponent = pure(ExpensiveComponent)

// Even more optimized: only updates if specific prop keys have changed
const HyperOptimizedComponent = onlyUpdateForKeys(['propA', 'propB'])(ExpensiveComponent)
```

`pure` and `onlyUpdateForKeys` will implement `shouldComponentUpdate()` without you needing to create a class-based container.

## Resources

- Documentation: [https://reactjs.org/](https://reactjs.org/)
- Some of my favorite Javascript content out there: [https://egghead.io/](https://egghead.io/)
- CRA produces great README's that aggregate many best practices. Example can be seen: [`02-react/README.md`](02-react/README.md)
- If you are interested in optimizing your React applications Lighthouse performance right out of the box: [https://github.com/alejandroq/enlightenment-series-react-primer](https://github.com/alejandroq/enlightenment-series-react-primer)
- If you are interested in GraphQL and Drupal (or at a minimum Apollo Clients HOC's with React): [https://github.com/alejandroq/graphql-drupal.meetup.edu](https://github.com/alejandroq/graphql-drupal.meetup.edu)
- If you are interested in composing your infrastructure of serverless components: [https://github.com/alejandroq/serverless.deepdive.edu](https://github.com/alejandroq/serverless.deepdive.edu)
- If you are interested in a quick Angular primer: [https://github.com/alejandroq/angular-primer](https://github.com/alejandroq/angular-primer)
