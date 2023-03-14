package main

import (
	"fmt"
	"gonum.org/v1/gonum/stat/combin"
	rand1 "math/rand"
	"time"
)

func main() {
	dataMap := make(map[int]int)
	for i := 0; i < 100; i++ {
		rand1.Seed(time.Now().UnixNano())
		fmt.Println("seed", rand1.Int63())
		min := 2
		max := 6
		m := 6
		for m >= 1 {
			m = rand1.Intn(max-min+1) + min
			if m >= 2 {
				break
			}
		}
		fmt.Println(m)
		ls := rand1.Perm(m)
		//value := dataMap[m]
		dataMap[m] += 1
		fmt.Println("permutation list", ls)

		fmt.Println("data map", dataMap)

		// combin provides several ways to work with the combinations of
		// different objects. Combinations generates them directly.
		fmt.Println("Generate list:")
		n := 6
		k := 3
		list := combin.Combinations(n, k)
		// for i, v := range list {
		// 	fmt.Println(i, v)
		// }

		m = rand1.Intn(len(list))

		fmt.Println("list for combination", list, "length", list[m])
		// This is easy, but the number of combinations  can be very large,
		// and generating all at once can use a lot of memory.
	}

}
