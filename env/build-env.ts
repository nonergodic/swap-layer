import * as base from "@wormhole-foundation/sdk-base";
import { uniswapV3Router, permit2Contract } from "./uniswap";

import { writeFileSync } from "fs";

function errorExit(msg: string): never {
  console.error(msg);
  process.exit(1);
}

if (process.argv.length != 4)
  errorExit("Usage: <network (e.g. Mainnet)> <chain (e.g. Ethereum)>");

const network = (() => {
  const network = process.argv[2];
  if (!base.network.isNetwork(network))
    errorExit(`Invalid network: ${network}`);

  return network;
})();

const chain = (() => {
  const chain = process.argv[3];
  if (!base.chain.isChain(chain))
    errorExit(`Invalid chain: ${chain}`);

  return chain;
})();

const foreignChain = chain === "Ethereum" ? "Avalanche" : "Ethereum";

const rpc = base.rpc.rpcAddress(network, chain);
if (!rpc)
  errorExit(`No RPC address for ${network} ${chain}`);

if (!uniswapV3Router.has(network, chain))
  errorExit(`No Uniswap V3 router for ${network} ${chain}`);

if (!base.circle.usdcContract.has(network, chain))
  errorExit(`No USDC contract for ${network} ${chain}`);

if (!base.contracts.circleContracts.get(network, chain)?.wormhole)
  errorExit(`No Circle integration contract for ${network} ${chain}`);

const testVars =
`TEST_RPC=${rpc}
TEST_FOREIGN_CHAIN_ID=${base.chainToChainId(foreignChain)}
TEST_USDC_ADDRESS=${base.circle.usdcContract.get(network, chain)!}
TEST_FOREIGN_USDC_ADDRESS=${base.circle.usdcContract.get(network, foreignChain)!}
TEST_CIRCLE_INTEGRATION_ADDRESS=${base.contracts.circleContracts.get(network, chain)!.wormhole}
TEST_UNISWAP_V3_ROUTER_ADDRESS=${uniswapV3Router.get(network, chain)!}
TEST_PERMIT2_ADDRESS=${permit2Contract}
`;

writeFileSync("testing.env", testVars);
