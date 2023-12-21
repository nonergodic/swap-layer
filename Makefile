.PHONY: all unit-test integration-test test build dependencies clean

all: build

build: dependencies
	forge build

dependencies: lib/forge-std lib/openzeppelin-contracts

clean:
	forge clean

lib/forge-std:
	forge install foundry-rs/forge-std --no-git --no-commit

lib/openzeppelin-contracts:
	forge install openzeppelin/openzeppelin-contracts --no-git --no-commit