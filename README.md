[![Build Status](https://travis-ci.org/tandrewnichols/indeed.png)](https://travis-ci.org/tandrewnichols/indeed)

# Indeed

Boolean helpers for node.js

## Why Bother?

Simple booleans are efficient and not that hard to use in javascript, so what's the value of a DDL for booleans? Mainly, I just find booleans one of those things that, if I think too hard about them, then I get lost. The project was born when I had

```javascript
if (!oneThing && anotherThing) {
  // . . .
}
```

but then realized I actually needed the negative of `anotherThing`. So I changed it to

```javascript
if (!oneThing && !anotherThing) {
  // . . .
}
```

at which point, I started wondering if that was the same as

```javascript
if (!(oneThing && anotherThing)) {
  // . . .
}
```

And then I thought, what I really want is to say

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

or

```javascript
// Set up global methods.
// Mainly useful because I don't like having to say "if (helpers.indeed(a)..."
require('indeed')();
```

## Entry points

Indeed is the name of the module, but in fact, requiring indeed gives you access to a variety of different "entry points" which begin new boolean chains. Those entry points are as follows:

#### Indeed

Begins a chain. All of the helpers are chainable, though most limit which chain methods you can call and how many times (e.g. you cannot call either/or/or - that's numerically inconsistent - nor can you call either/and - that just doesn't make sense). `indeed` is chainable with the following methods: `and`, `andNot`, `or`, `orNot`, `butNot`, and `xor`. Most do what they sound like, but for completeness: `and` = `&&`, `andNot` = `&& !`, `or` = `||`, `orNot` = `|| !`, `butNot` = `andNot`, and `xor` = `(a || b) && !(a && b)`.

To evaluate the result of a helper, call one of `test`, `eval`, or `val` (whatever your preference) to get a boolean result. 

```javascript
if (indeed(a).and(b).or(c).test()) {
  // do something
}
```

Chainable methods are evaluated left to right, with no grouping, but with order. In other words, in the example above `a` and `b` are evaluated first, and then the result is `or`'d with c. So this example is equivalent to

```javascript
if (a && b || c)
```

however

```javascript
if (indeed(a).or(b).and(c).test())
```

is more closely equivalent to

```javascript
if ((a || b) && c)
```

(See [Grouping](#grouping) for more information.)

`indeed` is also equipped with some negation tools: `not` and `Not`. `not` simply negates the first condition:

```javascript
if (indeed.not(a).test())
```

is equivalent to

```javascript
if (!a)
```

`Not` negates the result of the chain, so

```javascript
if (indeed.Not(a).and(b).test())
```

is equivalent to

```javascript
if (!(a && b))
```

#### Either

Begins a chain where one of two conditions (or both) should be true.

Chainable methods: `or`<br>
Chain limit: 1

```javascript
if (either(a).or(b).test())
```

#### Neither

Begins a chain where both conditions should be false. 

Chainable methods: `nor`<br>
Chain limit: 1

```javascript
if (neither(a).nor(b).test())
```

#### Both

Begins a chain where both conditions should be true.

Chainable methods: `and`<br>
Chain limit: 1

```javascript
if (both(a).and(b).test())
```

#### AllOf

Begins a chain where all conditions should be true. Incidentally, it only makes sense to use this with more than two conditions. With two conditions only, use `both`.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (allOf(a).and(b).and(c).test())
```

#### AnyOf

Begins a chain where at least one condition should be true.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (anyOf(a).and(b).and(c).test())
```

#### OneOf

Begins a chain where exactly one condition should be true.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (oneOf(a).and(b).and(c).test())
```

#### NoneOf

Begins a chain where all of the conditions should be false. With only two conditions, use `neither` instead.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (noneOf(a).and(b).and(c).test())
```

#### NOf

`nOf` is the only helper that deviates from the standard structure. It accepts a number, and then any number of conditions, of which _exactly_ that number must be true.

Chainable methods: `and`<br>
Chain limit: none

```javascript
if (n(2).of(a).and(b).and(c)test())
```

## Grouping

You can create groups of chains, which are also evaluated left to right, using the properties `And`, `But`, `Or`, and `Xor`. They do what you would expect:

```javascript
if (indeed(a).or(b).And.indeed(c).test())

if (indeed(a).and(b).Or.indeed(c).test())

if (indeed(a).and(b).Xor.indeed(c).test())

if (indeed(a).and(b).But.not(c).test())
```

The first example evaluates `a || b` first and then the result of that with `&& c`. `But` is an alias to `And` because sometimes it feels more natural to say "but" than "and." `indeed` also has several aliases that can be used after joins depending on what you want to say next:

```javascript
// just like indeed
if (indeed(a).or(b).And.also(c).test()) { }

// also just like indeed
if (indeed(a).and(b).Or.else(c).test()) { }

// just like indeed, but negated
if (indeed(a).and(b).But.not(c).test()) { }

// just like indeed, but negates the entire next group
if (indeed(a).and(b).But.Not(c).or(d).test()) { }
```

## Matching

All the examples so far have been simple checks for definedness (for simplicify), but `indeed` has a wide variety of comparison functions as well.

#### Is

Literal comparison (i.e. reference equality).

```javascript
if (indeed(a).is('foo').test())
```

#### Equals

Non-reference equality. This delegates to _.isEqual.

```javascript
if (indeed(a).equals(b).test())
```

#### IsA

For type comparisons. This is more strict that `typeof` however. It checks for constructor.name (allowing custom types) and, failing, that uses typeof. It is worth noting that both the type and comparison are lower cased, so 'string', 'String', 'strIng', etc. are all equivalent.

```javascript
if (indeed(a).isA('string').test())
```

#### IsAn

Just like isA but preferable (for me anyway) for types beginning with vowels.

#### Contains

Indicates if the string or array contains the given value.

```javascript
if (indeed('foo bar').contains('foo').test()) {}
if (indeed([1,2,3]).contains(1).test()) {}
```

#### ContainsKey

Indicates if the object (or array, though somewhat by accident) contains the given key.

```javascript
if (indeed({foo: 'bar'}).containsKey('foo').test())
```

#### ContainsValue

Indicates if the object (or array) contains the given value.

```javascript
if (indeed({foo: 'bar'}).containsValue('bar').test())
```

#### IsDefined

Returns true for everthing except undefined. A little cleaner looking than `if (typeof thing !== 'undefined')`, though that's exactly what it does under the hood.

```javascript
if (indeed('string').isDefined().test())
```

#### IsUndefined

Again, just a useful shortcut for `typeof thing === 'undefined'`, especially when `0` or even `false` is a valid value, making `if (thing)` impossible.

```javascript
if (indeed(undefined).isUndefined().test())
```

#### IsNull

Returns true for null and false for everything else.

```javascript
if (indeed(null).isNull().test())
```

#### IsNotNull

Opposite of `isNull`.

```javascript
if (indeed([1,2]).isNotNull().test())
```

#### IsTrue

Not to be confused with truthiness, this checks for the literal value `true`.

```javascript
if (indeed(true).isTrue().test())
```

#### IsFalse

Checks for the literal value `false`.

```javascript
if (indeed(false).isFalse().test())
```

#### IsGreaterThan / IsGt

Compares two numbers

```javascript
if (indeed(1).isGreaterThan(0).test())
if (indeed(1).isGt(0).test())
```

#### IsLessThan / IsLt
```javascript
if (indeed(1).isLessThan(2).test())
if (indeed(1).isLt(2).test())
```

#### IsGreaterThanOrEqualTo / IsGte

```javascript
if (indeed(1).isGreaterThanOrEqualTo(1).test())
if (indeed(1).isGte(0).test())
```

#### IsLessThanOrEqualTo / IsLte

```javascript
if (indeed(1).isLessThanOrEqualTo(1).test())
if (indeed(1).isLte(2).test())
```

## Mixin

Additionally, `indeed` has a mixin method for extending these comparison methods. It takes an object of function names with corresponding functions.

```javascript
indeed.mixin({
  can: function(condition) {
    return function(val) {
      return typeof val[condition] === 'function';
    }
  },
  beginsWith: function(condition) {
    return function(val) {
      return val.charAt(0).toLowerCase() === condition.toLowerCase();
    }
  }
});
```

The custom functions should be in this form, where `condition` is the thing to match against and `val` is the original object (which seems a little backwards, since val is "inside"). These methods,for example, would be called like this:

```javascript
if (indeed({ foo: function() {} }).can('foo').test())
if (indeed('hello').beginsWith('h').test())
```
