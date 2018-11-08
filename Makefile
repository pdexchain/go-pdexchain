# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

# .PHONY: gpdex android ios geth-cross swarm evm all test clean
# .PHONY: geth-linux geth-linux-386 geth-linux-amd64 geth-linux-mips64 geth-linux-mips64le
# .PHONY: geth-linux-arm geth-linux-arm-5 geth-linux-arm-6 geth-linux-arm-7 geth-linux-arm64
# .PHONY: geth-darwin geth-darwin-386 geth-darwin-amd64
# .PHONY: geth-windows geth-windows-386 geth-windows-amd64

GOBIN = build/bin
GO ?= latest

linuxDir=$(shell echo gpdex-linux-amd64-`cat ./VERSION`-`git rev-parse --short=8 HEAD`)
windowsDir=$(shell echo gpdex-windows-amd64-`cat ./VERSION`-`git rev-parse --short=8 HEAD`)
darwinDir=$(shell echo gpdex-mac-amd64-`cat ./VERSION`-`git rev-parse --short=8 HEAD`)
# The gpdex target build gpdex binary
gpdex:
	build/env.sh go run   -gcflags "-N -l"    build/ci.go install ./cmd/gpdex
	@echo "Done building."
	@echo "Run \"$(GOBIN)/gpdex\" to launch gpdex."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."


# The all target build all the pdexchain tools
all:
	build/env.sh go run build/ci.go install

# android:
# 	build/env.sh go run build/ci.go aar --local
# 	@echo "Done building."
# 	@echo "Import \"$(GOBIN)/geth.aar\" to use the library."

# ios:
# 	build/env.sh go run build/ci.go xcode --local
# 	@echo "Done building."
# 	@echo "Import \"$(GOBIN)/Geth.framework\" to use the library."

# The test target run all unit tests
test: all
	build/env.sh go run build/ci.go test

lint: ## Run linters.
	build/env.sh go run build/ci.go lint

clean:
	./build/clean_go_build_cache.sh
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/kevinburke/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go get -u github.com/golang/protobuf/protoc-gen-go
	env GOBIN= go install ./cmd/abigen
	@type "npm" 2> /dev/null || echo 'Please install node.js and npm'
	@type "solc" 2> /dev/null || echo 'Please install solc'
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

# Cross Compilation Targets (xgo)

# geth-cross: geth-linux geth-darwin geth-windows geth-android geth-ios
# 	@echo "Full cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-*

# geth-linux: geth-linux-386 geth-linux-amd64 geth-linux-arm geth-linux-mips64 geth-linux-mips64le
# 	@echo "Linux cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-*

# geth-linux-386:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/geth
# 	@echo "Linux 386 cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep 386

gpdex-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/gpdex
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gpdex-linux-* | grep amd64
        mkdir -p ${linuxDir}
        cp ./build/bin/gpdex-linux-* ${linuxDir}/gpdex
        tar zcf ${linuxDir}.tar.gz ${linuxDir}/gpdex

# geth-linux-arm: geth-linux-arm-5 geth-linux-arm-6 geth-linux-arm-7 geth-linux-arm64
# 	@echo "Linux ARM cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep arm

# geth-linux-arm-5:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/geth
# 	@echo "Linux ARMv5 cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep arm-5

# geth-linux-arm-6:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/geth
# 	@echo "Linux ARMv6 cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep arm-6

# geth-linux-arm-7:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/geth
# 	@echo "Linux ARMv7 cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep arm-7

# geth-linux-arm64:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/geth
# 	@echo "Linux ARM64 cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep arm64

# geth-linux-mips:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/geth
# 	@echo "Linux MIPS cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep mips

# geth-linux-mipsle:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/geth
# 	@echo "Linux MIPSle cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep mipsle

# geth-linux-mips64:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/geth
# 	@echo "Linux MIPS64 cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep mips64

# geth-linux-mips64le:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/geth
# 	@echo "Linux MIPS64le cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-linux-* | grep mips64le

# geth-darwin: geth-darwin-386 geth-darwin-amd64
# 	@echo "Darwin cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-darwin-*

# geth-darwin-386:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/geth
# 	@echo "Darwin 386 cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-darwin-* | grep 386

gpdex-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/gpdex
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gpdex-darwin-* | grep amd64
        mkdir -p ${darwinDir}
        cp ./build/bin/gpdex-darwin-* ${darwinDir}/gpdex
        tar zcf ${darwinDir}.tar.gz ${darwinDir}/gpdex

# geth-windows: geth-windows-386 geth-windows-amd64
# 	@echo "Windows cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-windows-*

# geth-windows-386:
# 	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/geth
# 	@echo "Windows 386 cross compilation done:"
# 	@ls -ld $(GOBIN)/geth-windows-* | grep 386

gpdex-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/gpdex
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/gpdex-windows-* | grep amd64
        mkdir -p ${windowsDir}
        cp ./build/bin/gpdex-windows-* ${windowsDir}/gpdex.exe
        zip ${windowsDir}.zip ${windowsDir}/gpdex.exe

release: clean gpdex-linux-amd64 gpdex-windows-amd64 gpdex-darwin-amd64