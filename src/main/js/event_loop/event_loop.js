console.log('main 1');

process.nextTick(() => {
    console.log('process.nextTick 1');
});

console.log('main 2');

setTimeout(() => {
    console.log("setTimeout 1")
}, 0);

console.log('main 3');

setTimeout(function () {
    console.log('setTimeout 2');
    process.nextTick(() => {
        console.log('process.nextTick in setTimeout 2');
    });
}, 0);

console.log('main 4');

new Promise(function executor(resolve) {
    console.log("Promise 1");
    for (var i = 0; i < 10000; i++) {
        i == 9999 && resolve();
    }
    console.log("Promise 2");
}).then(function () {
    console.log("Promise 3 then");
});

process.nextTick(() => {
    console.log('process.nextTick 2');
});

console.log("main 5");

// main 1
// main 2
// main 3
// main 4
// Promise 1
// Promise 2
// main 5
// -------- first loop -----
// process.nextTick 1
// Promise 3 then
// setTimeout 1
// setTimeout 2
// process.nextTick in setTimeout 2


setImmediate(() => {
    console.log("setImmediate 1")
    setImmediate(() => {
        console.log("setImmediate - setImmediate 1")
    })

    setTimeout(() => {
        console.log("setImmediate - setTimeout(0)")
    }, 0)

    setTimeout(() => {
        console.log("setImmediate - setTimeout(1)")
    }, 1)

    setTimeout(() => {
        console.log("setImmediate - setTimeout(10)")
    }, 10)
})

setImmediate(() => {
    console.log("setImmediate 2")
    setImmediate(() => {
        console.log("setImmediate - setImmediate 2")
    })
})

setTimeout(() => {
    console.log("setTimeout(0)")
    setImmediate(() => {
        console.log("setTimeout - setImmediate 1")
    })

    setTimeout(() => {
        console.log("setTimeout - setTimeout(0)")
    }, 0)

    setTimeout(() => {
        console.log("setTimeout - setTimeout(1)")
    }, 1)

    setTimeout(() => {
        console.log("setTimeout - setTimeout(10)")
    }, 10)
}, 0)

setTimeout(() => {
    console.log("setTimeout(1)")
}, 1)

console.log("main 6");


let  o = {}

Object.defineProperty(o, 'b', {
    get: function() { console.log("Object.defineProperty get"); },
    set: function(newValue) { console.log("Object.defineProperty set"); },
    enumerable: true,
    configurable: true
});




setTimeout(() => {
    o.b
    console.log("setTimeout(1)")
}, 1)