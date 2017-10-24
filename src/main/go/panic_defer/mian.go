package main

import (
	"fmt"
	"errors"
)

func pa() (i int, err error) {
	defer func() {
		fmt.Println("defer-1")
		i=2
		fmt.Println("",err)
		err = errors.New("final err")
	}()

	defer func() {
		fmt.Println("defer0")
		v:=recover()
		fmt.Println(v)
	}()

	defer func() {
		fmt.Println("defer1")

	}()

	defer func() {
		v:=recover()
		fmt.Println(v)
		fmt.Println("defer2")
		panic("err")
	}()
	panic("err1")
	return 1, errors.New("return err")
}

func main() {

	fmt.Println(pa())

}
