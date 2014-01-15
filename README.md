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

and thus the module "neither" was born. And then I later changed it to "indeed", which was more globally usable as a boolean helper. A bit of an anti-climatic ending, really. At any rate, this library is just a set of boolean helpers to put `if` statements into English-like syntax. Note that I used to be an English teacher and thus, that syntax is extremely opinionated and grammatically correct. Grammar is your friend.

![Grammar Matters](http://50gooddeeds.files.wordpress.com/2012/06/howcangooglesearch.jpg)

Ahem . . . now on with the API.

## Installation

```bash
npm install indeed --save
```

then

```javascript
var helpers = require('indeed');
```

which gives you an object with the following properties: indeed, either, neither, both, allOf, anyOf, oneOf, noneOf, and nOf. Alternatively, you can call `helpers` (or your `require`) to set up global helpers of the same name:

```javascript
// Set up global methods
require('indeed')();
```

### Indeed

Begins a chain. All of the helpers are chainable (though most limit which chain methods you can call and how many times). `indeed` is chainable with the following methods: `and`, `andNot`, `or`, `orNot`, `butNot`, and `xor`. Most do what they sound like, but for completeness: `and` = `&&`, `andNot` = `&& !`, `or` = `||`, `orNot` = `|| !`, `butNot` = `andNot`, and `xor` = `(a || b) && !(a && b)`.

In general, these helpers are more useful (or at least more immediately readable) with "exists" checks, as opposed to comparisons. To evaluate the result of a helper, call one of `test`, `eval`, or `val` (whatever your preference) to get a boolean result. 

`indeed` is actually just a starting point with no particularly special meaning:

```javascript
if (indeed(member.isAdmin).and(member.settings.hideFromChat).or(page.isMobilePage).test()) {
  // do something
}
```

Chainable methods are evaluated left to right, with no grouping, but with order. In other words, firstCondition/secondCondition are evaluated, and then the result with the thirdCondition. So this example is equivalent to

```javascript
if (member.isAdmin && member.settings.hideFromChat || page.isMobilePage)
```

however

```javascript
if (indeed(member.isAdmin).or(member.settings.hideFromChat).and(page.isMobilePage).test())
```

is more closely equivalent to

```javascript
if ((member.isAdmin || member.settings.hideFromChat) && page.isMobilePage)
```

You _can_ do some grouping (see below), but it is limited, and I don't intend to expand it any time soon, since you could actually just group it yourself:

```javascript
if ((indeed(member.isAdmin).or(member.settings.hideFromChat).test()) && indeed(page.isMobilePage).test())
```

or

```javascript
if ((indeed(member.isAdmin).or(member.settings.hideFromChat).test()) && page.isMobilePage)
```

or just plain old javascript booleans.

`indeed` is also equipped with some negation tools: `not` and `Not`. `not` simply negates the first condition:

```javascript
if (indeed.not(a))
```

is equivalent to

```javascript
if (!a)
```

`Not` negates the result of the chain, so

```javascript
if (indeed.Not(a).and(b))
```

is equivalent to

```javascript
if (!(a && b))
```

### Either

Begins a chain where one of two conditions should be true.

Chainable methods: `or`<br>
Chain limit: 1

```javascript
if (either(opts.async).or(callback).test())
```

### Neither

Begins a chain where both conditions should be false. 

Chainable methods: `nor`<br>
Chain limit: 1

```javascript
if (neither(opts.async).nor(callback).test())
```

### Both

Begins a chain where both conditions should be true.

Chainable methods: `and`<br>
Chain limit: 1

```javascript
if (both(opts.sync).and(callback).test())
```

### AllOf

Begins a chain where all conditions should be true. Incidentally, it only makes sense to use this with more than two conditions. With two conditions only, use `both`.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (allOf(a).and(b).and(c))
```

### AnyOf

Begins a chain where at least condition should be true.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (allOf(member.firstname).and(member.lastname).and(member.email).test())
```

### OneOf

Begins a chain where exactly one condition should be true. Like `allOf`, use this with more than two conditions. With two conditions, use `either`.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (oneOf(member.nickname).and(member.penname).and(member.pseudonym).test())
```

### NoneOf

Begins a chain where all of the conditions should be true. Again, with only two conditions, use `neither` instead.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (noneOf(list.length > 2).and(~list.indexOf('foo')).and(~list.indexOf('bar')).test())
```

### NOf

`nOf` is the only helper that deviates from the standard structure. It accepts a number, and then any number of conditions, of which _exactly_ that number must be true.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (n(2).of(member.firstname).and(member.middleInitial).and(member.lastname)test())
```

## Grouping

You can create groups of chains which are, also, evaluated left to right, using the properties `And`, `But`, `Or`, and `Xor`. They do what you would expect:

```javascrit
if (indeed(a).or(b).And.indeed(c).test())

if (indeed(a).and(b).Or.indeed(c).test())

if (indeed(a).and(b).Xor.indeed(c).test())
```

This will evaluate `a || b` first and then the result of that with `&& c`. `But` is an alias to `And` because sometimes it feels more natural to say "but" than "and." `indeed` also has several aliases that can be used after joins depending on what you want to say next:

```javascript
// just like indeed
if (indeed(a).or(b).And.also(c).test()) { }

// also just like indeed
if (indeed(a).and(b).Or.else(c).test()) { }

// just like indeed, but negated
if (indeed(a).and(b).But.not(c).test()) { }

// just like indeed, but negates the entire next group
if (indeed(a).and(b).But.Not(c).test()) { }
```
