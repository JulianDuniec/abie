Abie = A/B-testing in node
=========================

## Installation
    $ npm install abie


## Usage

### Configure a test


```js

    abie.addTest({
      name : "mytest",    //Refer to this when running the test
      population : 10000, //Amount of impressions
      variations : [
        { "name" : "coolVariation", weight : "0.5", default : true }, //When test is over, the code will revert to default variation
        { "name" : "notSoCoolVariation", weight : "0.5" },
      ]
    })

```

### In a template

```jade

    if abie('mytest', 'coolVariation')
      h1 CoolVariation-header
    if abie('mytest', 'notSoCoolVariation')
      h1 Not so cool, but effective? Who knows, that's the fun!

```
### In a template

```js

    if abie('mytest', 'coolVariation')
      res.render('variationA')
    if abie('mytest', 'notSoCoolVariation')
      res.render('variationA')

```