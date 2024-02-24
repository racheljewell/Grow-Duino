package main

import (
	"fmt"
	otherpackage "growduino/main/otherPackage"
)

func main() {
	fmt.Println("I am the main function!")
	var p otherpackage.Pair
	p.SetPair(1, 2)
	p.DisplayPair()
}
