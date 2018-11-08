.PHONY: build cluster test

default: build

build:
	go build -o bin/swarm    github.com/pdexchain/go-pdexchain/cmd/swarm
	go build -o bin/geth     github.com/pdexchain/go-pdexchain/cmd/geth
	go build -o bin/bootnode github.com/pdexchain/go-pdexchain/cmd/bootnode

cluster: build
	scripts/boot-cluster.sh

test:
	go test -v github.com/pdexchain/go-pdexchain/swarm/...
