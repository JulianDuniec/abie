Abie = A/B-testing in node
=========================

## Installation
    $ npm install abie


## Usage

### Basic example

```javascript

    //Will contain either 'index' or 'index2'
    var template = abie.test('mytest', [{name : 'index'}, {name: 'index2'}]);
    res.render(template);

```
### Max population

```javascript

    //Will subject the test to 1000 impressions, and then return the default ('index')
    var template = abie.test('mytest', [{name : 'index'}, {name: 'index2'}], {population : 1000});
    res.render(template);

```

### Date-expiration

```javascript

    //Will only execute the test january to february 2012, and then return the default ('index')
    var template = abie.test('mytest', [{name : 'index'}, {name: 'index2'}], {startDate : new Date(2012, 01, 01), endDate : new Date(2012, 02, 01);});
    res.render(template);

```