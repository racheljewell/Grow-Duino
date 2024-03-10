package main

import (
	"fmt"
	toggles "growduino/main/switchControl"
	"time"
)

const (
	Switch_A = "switch.switch_a"
	Switch_B = "switch.switch_b"
	Switch_C = "switch.switch_c"
	Switch_D = "switch.switch_d"
)

func main() {
	fmt.Println("Turning On A...")
	toggles.ToggleOn(Switch_A)
	fmt.Println("Pausing...")
	time.Sleep(5 * time.Second)
	fmt.Println("Turning Off A...")
	toggles.ToggleOff(Switch_A)
	fmt.Println("Turning On B...")
	toggles.ToggleOn(Switch_B)
	fmt.Println("Pausing...")
	time.Sleep(5 * time.Second)
	fmt.Println("Turning Off B...")
	toggles.ToggleOff(Switch_B)
	fmt.Println("Turning On C...")
	toggles.ToggleOn(Switch_C)
	fmt.Println("Pausing...")
	time.Sleep(5 * time.Second)
	fmt.Println("Turning Off C...")
	toggles.ToggleOff(Switch_C)
}
