# Event Loop
![](https://dn-cnode.qbox.me/Fppv-U2FJpIUbOcXMYMWyy6-Aj5k)
- js 的Event Loop有两个Task queue
- Task queue
	- macroTask: 
		- setTimeout, 
		- setInterval, 
		- setImmediate, 
		- requestAnimationFrame, 
		- I/O, 
		- UI rendering
	- microTask: 
		- process.nextTick, 
		- Promise, 
		- Object.observe(已废弃) , 
		- MutationObserver
- 一次事件循环
	1. 运行microTask队列中的所有任务
		1. 运行microTask队列中的*所有*process.nextTick
		2. 运行microTask队列中的*所有*Promise
	2. 先运行macroTask队列中的一个
	3. 接着开始下一次循环

[demo code](./event_loop.js)

# code

```js
console.log('main 1');

process.nextTick(()=> {
    console.log('process.nextTick 1');
});

console.log('main 2');

setTimeout(()=> {
    console.log("setTimeout 1")
}, 0);

console.log('main 3');

setTimeout(function() {
    console.log('setTimeout 2');
    process.nextTick(()=> {
        console.log('process.nextTick in setTimeout 2');
    });
}, 0);

console.log('main 4');

new Promise(function executor(resolve) {
    console.log("Promise 1");
    for( var i=0 ; i<10000 ; i++ ) {
        i == 9999 && resolve();
    }
    console.log("Promise 2");
}).then(function() {
    console.log("Promise 3 then");
});

process.nextTick(()=> {
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
```

# setTimeout(0) vs setImmediate

- TL;DR:
	- 因为不用检查时间`setImmediate()`更高效
	- `setImmediate()` task 插入macroTask queue末尾
	- `setTimeout`先运行
	- ```setTimeout(fn, 0)``` === ```setTimeout(fn, 1)```
	- 用`setImmediate()`

理论上`setImmediate`应该更快，[bench](./bench_setTimeout0_setImmediate.js)支持
```js
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

// deffered.resolve() x 342,190 ops/sec ±7.98% (38 runs sampled)
// setImmediate() x 718,724 ops/sec ±1.53% (81 runs sampled)
// setTimeout(,0) x 702 ops/sec ±0.71% (79 runs sampled)
```

```js
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
```
[setImmediate vs nextTick vs setTimeout(fn, 0)](https://cnodejs.org/topic/5556efce7cabb7b45ee6bcac)

# 最强死循环
```js
function test() { 
   console.log("a")
  process.nextTick(() => test());
}
test()
```
强于
```js
while(true){
    console.log("a")
}
```