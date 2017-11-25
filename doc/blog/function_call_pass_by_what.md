# TL;DR
1. java,js,python的`引用类型` 和 `引用` 不是一个概念，前者就是指针，[引用vs指针](../pl/cpp.md#引用和指针的区别)
2. `传递参数` = `调用参数类型的复制构造函数`
3.  返回
	1. 调用返回值类型的复制构造函数，返回
	2. 调用返回值类型的析构函数

## demo code
- [cpp](../../src/main/cpp/pass_by_what.cpp)
- [rust](../../src/main/rust/biolee/src/bin/pass_what.rs)
- [go](../../src/main/go/pass_by_what.go)
- [python](../../src/main/python/pass_what.py)
- [js](../../src/main/js/pass_what.ts)
