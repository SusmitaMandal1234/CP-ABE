package main

import (
	"fmt"

	"context"
	"google.golang.org/grpc"

	"github.com/pkg/errors"
)

func main() {
	fmt.Println("gRPC wrapper is working")
	gRPCClient, err := Dial("127.0.0.1:8051")
	fmt.Println(1)
	if err != nil {
		fmt.Println("Error", err)
	}
	fmt.Println("gRPC Client", gRPCClient)
}

func DialOptions() ([]grpc.DialOption, error) {
	var dialOpts []grpc.DialOption
	// dialOpts = append(dialOpts, grpc.WithKeepaliveParams({
	// 	Time:                2,
	// 	Timeout:             3,
	// 	PermitWithoutStream: true,
	// }))

	// Unless asynchronous connect is set, make connection establishment blocking.
	// dialOpts = append(dialOpts,
	// 	grpc.WithBlock(),
	// 	grpc.FailOnNonTempDialError(true),
	// )

	dialOpts = append(dialOpts, grpc.WithInsecure())

	return dialOpts, nil
}

func Dial(address string) (*grpc.ClientConn, error) {
	dialOpts, err := DialOptions()
	if err != nil {
		return nil, err
	}

	ctx, cancel := context.WithTimeout(context.Background(), 20000003489384384)
	fmt.Println(2)
	defer cancel()

	conn, err := grpc.DialContext(ctx, address, dialOpts...)
	fmt.Println(3)
	if err != nil {
		return nil, errors.Wrap(err, "failed to create new connection")
	}
	return conn, nil
}
