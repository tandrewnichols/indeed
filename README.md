[![Build Status](https://travis-ci.org/tandrewnichols/indeed.png)](https://travis-ci.org/tandrewnichols/indeed)

# Indeed

Boolean helpers for node.js

## Why Bother?

Simple booleans are efficient and not that hard to use in javascript, so what's the value of a DDL for booleans? Mainly, I just find booleans one of those things that, if I think too hard about them, then I get lost. The project was born when I had

```javascript
if (!oneThing || anotherThing) {
  // . . .
}
```

but then realized I actually needed the negative of `anotherThing`. So I changed it to

```javascript
if (!oneThing || !anotherThing) {
  // . . .
}
```

at which point, I thought, maybe I should just do

```javascript
if (!(oneThing || anotherThing)) {
  // . . .
}
```

but by then, I had overthought it and began wondering whether I needed `||` or `&&`. And then I thought, what I want to say is

```javascript
if (neither(oneThing).nor(anotherThing)) {
  // do something
}
```

and thus the module "neither" was born. And then I later changed it to "indeed", which was more globally usable as a boolean helper. A bit of anti-climatic ending, really. At any rate, this library is just a set of boolean helpers to put if statements into English-like syntax. Note that I use to be an English teacher and thus, that syntax is extremely opinionated and grammatically correct. Grammar is your friend.

[Grammar Matters](http://50gooddeeds.files.wordpress.com/2012/06/howcangooglesearch.jpg)

Ahem . . . now on with the API.

## Installation

```bash
npm install indeed --save
```

then

```javascript
var helpers = require('indeed');
```

which gives you an obj with the following properties: indeed, either, neither, both, allOf, anyOf, oneOf, noneOf, and nOf. Alternatively, you can call `helpers` (or your `require`) to set up global helpers of the same name:

```javascript
// Set up global methods
require('indeed')();
```
