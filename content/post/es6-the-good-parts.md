---
title: "ES6 the Good Parts"
date: 2018-06-04T23:09:51+02:00
draft: false
git: https://github.com/alejandroq/react-intro.tcm.edu
---

_This article was originally part of my "edu" series originally publicized via a GitHub repository and live presented to a group of peers. Therefore much of it is organized in a manner meant to direct said presentation and is not optimized as an article._

<!--more-->

- [`const` and `let`:](#const-and-let)
- [Fat Arrow Function:](#fat-arrow-function)
- [Object Spread](#object-spread)
- [Array Spread](#array-spread)
- [Importing Modules](#importing-modules)
- [Classes](#classes)
- [Promises for simple async concurrency (Observables for event streams - see RxJS)](#promises-for-simple-async-concurrency-observables-for-event-streams---see-rxjs)
- [Destructuring](#destructuring)
- [Template Strings](#template-strings)
- [Testing the Above](#testing-the-above)

## `const` and `let`:

- `const` is for immutable variables (transpiler forces this - JavaScript actually does not support immutability fully in the Functional Programming way)
- `let` in-lieu of `var`. A key distinction is in lexical scoping (improves shadowing errors, understanding application state and code readability):

```js
function foo(x) {
  if (x) {
    var y = x;
  }
  // will equal x
  console.log(y);
}

function bar(x) {
  if (x) {
    let y = x;
  }
  // will equal undefined
  console.log(y);
}

/** lets look at this in node - take note of the fat arrow function closure; detailed below */
(x => {
  if (x) {
    let y = x;
  }
  console.log(y);
})("will this appear")(
  /** $ > ReferenceError: y is not defined at x (repl:1:43) */

  x => {
    if (x) {
      var y = x;
    }
    console.log(y);
  }
)("will this appear");
/** $ > will this appear */
```

## Fat Arrow Function:

- [https://stackoverflow.com/questions/34361379/arrow-function-vs-function-declaration-expressions-are-they-equivalent-exch](https://stackoverflow.com/questions/34361379/arrow-function-vs-function-declaration-expressions-are-they-equivalent-exch)
- [https://www.sitepoint.com/es6-arrow-functions-new-fat-concise-syntax-javascript/](https://www.sitepoint.com/es6-arrow-functions-new-fat-concise-syntax-javascript/)
- tl:dr not for cases of `this` and `new`

```js
// ES5
API.prototype.get = function(resource) {
  var self = this;
  return new Promise(function(resolve, reject) {
    http.get(self.uri + resource, function(data) {
      resolve(data);
    });
  });
};

// ES6
API.prototype.get = function(resource) {
  return new Promise((resolve, reject) => {
    http.get(this.uri + resource, function(data) {
      resolve(data);
    });
  });
};
```

Fat Arrow Function Object Literal Syntax:

```js
const x = y => y;

/** equals if object - if multiline; common in a React Component or an immediate Object return */
const x = y => ({
  v: y
});

/** equals */
const x = y => {
  return y;
};

/** equals */
function x(y) {
  return y;
}
```

## Object Spread

```js
const x = { name: "Alejandro", age: 1 };
const y = { age: 200, hobby: "Angular" };
console.log(...x, ...y);
/** { name: 'Alejandro , age: 200, hobby: 'Angular' } */
```

## Array Spread

```js
const x = [1, 2, 3];
const y = [4, 5, 6];
console.log([...x, ...y]);
/** [1, 2, 3, 4, 5, 6] */
```

## Importing Modules

```js
import React from "react";

/** vs */

var React = require("react");
```

## Classes

```js
class X implements Y {
  constructor(x) {
    super(x);
  }
  foo() {
    return "foo";
  }
}

/** syntatical sugar over prototypes */
X.prototype.foo = function() {
  return "bar";
};
```

## Promises for simple async concurrency (Observables for event streams - see [RxJS](reactivex.io/rxjs))

```js
const x = () =>
  new Promise((res, rej) => {
    /** fetch is actually already a Promise, but for the purposes of showing a native constructor  */
    fetch("https://www.google.com").then(
      response => (response.status === 200 ? res(response) : rej(response))
    );
  });
```

## Destructuring

```js
/** es5 */
var props = {
  name: "Alejandro",
  age: 100
};
var name = props.name;
var age = props.age;

/** es6 */
const props = {
  name: "Alejandro",
  age: 100
};
const { name, age } = props;

/** or in a function (closure or not) */
(({ name, age }) =>
  console.log(`My name is ${name} and I am ${age} years old`))(props);
```

## Template Strings

```js
/** es5 - multiline with variable */
var name = "Alejandro";
console.log("My name is " + name + ".\n" + "I am a few years old");

/** es6 - multiline with variable */
const name = "Alejandro";
console.log(
  `My name is ${name}.
  I am a few years old`
);
```

## Testing the Above

You can find the above validated in the following `Jest` specs:

```js
describe("lexical scoping of var and let", () => {
  it("var", () => {
    var x = "test";
    if (x) {
      var y = x;
    }
    expect(y).toBe(x);
  });
  it("let (will fail)", () => {
    var x = "test";
    if (x) {
      let y = x;
    }
    expect(y).toBe(x);
  });
});

describe("immutability of const", () => {
  it("var", () => {
    var x = 1;
    x = x + 1;
    expect(x).toBe(2);
  });
  it("const (will fail)", () => {
    const x = 1;
    x = x + 1;
    expect(x).toBe(2);
  });
});

describe("destructuring operators", () => {
  it("array destructuring", () => {
    const x = [1, 2, 3];
    expect((([one, two, three]) => one + two + three)(x)).toBe(6);
  });
  it("object destructuring", () => {
    const x = { one: 1, two: 2, three: 3 };
    const { one, two, three } = x;
    expect(one + two + three).toBe(6);
  });
});

describe("spread operators", () => {
  it("array spread", () => {
    const x = [1, 2, 3];
    const y = [4, 5, 6];
    expect([...x, ...y]).toEqual([1, 2, 3, 4, 5, 6]);
  });
  it("object spread - merge two objects", () => {
    const user = { id: 1, name: "Alejandro", age: 25 };
    const post = { id: 2, content: "Hello World", userId: 1 };
    expect({ ...user, ...post }.name).toBe("Alejandro");
  });
  it("object spread 2 - which instance of `id` is adopted?", () => {
    const user = { id: 1, name: "Alejandro", age: 25 };
    const post = { id: 2, content: "Hello World", userId: 1 };
    expect({ ...user, ...post }.id).toBe(2);
  });
});

describe("template strings", () => {
  it("create a unique multiline post string from two objects without +'s", () => {
    const user = { id: 1, name: "Alejandro", age: 25 };
    const post = { id: 2, content: "Hello World", userId: 1 };
    const template = `${user.name}: ${user.age};
        
        There will be appended \\n characters as tested below.
        ${post.content}
        `;
    expect(template.indexOf("\n") > -1).toBe(true);
  });
});
```
