var Suite = require('benchmark').Suite
var fs = require('fs')

var suite = new Suite

suite.add('deffered.resolve()', function (deferred) {
    deferred.resolve()
}, {defer: true})

suite.add('setImmediate()', function (deferred) {
    setImmediate(function () {
        deferred.resolve()
    })
}, {defer: true})

suite.add('setTimeout(,0)', function (deferred) {
    setTimeout(function () {
        deferred.resolve()
    }, 0)
}, {defer: true})

suite
    .on('cycle', function (event) {
        console.log(String(event.target));
    })
    .run({async: true})

// deffered.resolve() x 342,190 ops/sec ±7.98% (38 runs sampled)
// setImmediate() x 718,724 ops/sec ±1.53% (81 runs sampled)
// setTimeout(,0) x 702 ops/sec ±0.71% (79 runs sampled)
