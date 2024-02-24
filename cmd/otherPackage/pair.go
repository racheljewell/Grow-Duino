package otherpackage

import "fmt"

type Pair struct {
	x, y int
}

func (p Pair) DisplayPair() {
	fmt.Printf("(%d, %d)", p.x, p.y)
}

func (p *Pair) SetPair(x, y int) {
	p.x = x
	p.y = y
}
