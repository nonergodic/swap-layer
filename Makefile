#the chain that will be forked for testing
TEST_FORK = Mainnet Ethereum

#include (and build if necessary) env/testing.env if we're running tests
ifneq (,$(filter test, $(MAKECMDGOALS)))
-include env/testing.env
export
unexport TEST_FORK
env/testing.env:
	$(MAKE) -C env build NETWORK=$(word 1,${TEST_FORK}) CHAIN=$(word 2,${TEST_FORK})
endif

.DEFAULT_GOAL = build
.PHONY: build test clean

build: lib/forge-std lib/openzeppelin-contracts
	forge build

test: build
	forge test --fork-url $$TEST_RPC -vvvvv

clean:
	forge clean
	@$(MAKE) -C env clean

#TODO nail down version
lib/forge-std:
	forge install foundry-rs/forge-std --no-git --no-commit

#TODO nail down version
lib/openzeppelin-contracts:
	forge install openzeppelin/openzeppelin-contracts --no-git --no-commit