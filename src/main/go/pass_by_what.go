package main

import "fmt"

type A struct {
	v string
}

func pass_value(p1 A, p2 A) {
	p1.v = "changed"
	p2 = A{v:"changed"}
}

func pass_pointer(p1 *A, p2 *A){
	p1.v = "changed"
	p2 = &A{v:"changed"}
}

func main() {
	{
		var a1 = A{v: "unchange"}
		var a2 = A{v: "unchange"}
		pass_value(a1,a2)
		fmt.Println(a1.v) // unchange
		fmt.Println(a2.v) // unchange
	}
	{
		var a1 = &A{v: "unchange"}
		var a2 = &A{v: "unchange"}
		pass_pointer(a1,a2)
		fmt.Println(a1.v) // changed
		fmt.Println(a2.v) // unchange
	}
}
