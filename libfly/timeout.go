package main

import (
	"flag"
	"fmt"
	"log"
	"os"
	"os/exec"
	"time"
)

func main() {
	timeout := flag.Int("t", 10, "<int> timeout second")
	defaultRet := flag.Int("r", 13, "<int> default return code")

	flag.Parse()
    log.Print("timeout ", *timeout)
	log.Print("timeout default exit code ", *defaultRet)

	cmd := exec.Command(flag.Arg(0))
    cmd.Args = flag.Args()
	cmd.Stdout = os.Stdout
	cmd.Stderr = os.Stderr
	err := cmd.Start()
	if err != nil {
		log.Fatal(err.Error())
		return
	}

	ch := make(chan int)
	go func() {
		err = cmd.Wait()
		ch <- 0
	}()

	select {
	case ret := <-ch:
		fmt.Println(ret)
	case <-time.After(time.Second * time.Duration(*timeout)):
		log.Println("Timeout, Quit")
		cmd.Process.Kill()
		os.Exit(*defaultRet)
	}
}
