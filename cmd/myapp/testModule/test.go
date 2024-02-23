package test

import "fmt"

type Pair struct {
	x, y int
}

func (p Pair) PrintPair() {
	fmt.Println("(%d, %d)", p.x, p.y)
}
