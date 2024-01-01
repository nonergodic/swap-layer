TEST_FORK = Mainnet Ethereum

.DEFAULT_GOAL = build
.PHONY: build test clean

build: lib/forge-std lib/openzeppelin-contracts
	forge build

test: build
	@$(MAKE) -C env build NETWORK=$(word 1,${TEST_FORK}) CHAIN=$(word 2,${TEST_FORK})
	. env/testing.env && forge test --fork-url $$TEST_RPC -vv

clean:
	forge clean

#TODO nail down version
lib/forge-std:
	forge install foundry-rs/forge-std --no-git --no-commit

#TODO nail down version
lib/openzeppelin-contracts:
	forge install openzeppelin/openzeppelin-contracts --no-git --no-commit