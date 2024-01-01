import { constMap, Network, Chain, RoArray } from "@wormhole-foundation/sdk-base";

//from here: https://docs.uniswap.org/contracts/v3/reference/deployments
//and here: https://gov.uniswap.org/t/deploy-uniswap-v3-on-avalanche/20587/18

const uniswapV3RouterContracts = [
  [
    "Mainnet",
    [
      ["Ethereum",  "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45"],
      ["Arbitrum",  "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45"],
      ["Optimism",  "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45"],
      ["Polygon",   "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45"],
      ["Avalanche", "0xbb00FF08d01D300023C629E8fFfFcb65A5a578cE"],
      ["Base",      "0x2626664c2603336E57B271c5C0b26F421741e481"],
      ["Bsc",       "0xB971eF87ede563556b2ED4b1C0b0019111Dd85d2"],
      ["Celo",      "0x5615CDAb10dc425a742d643d949a7F474C01abc4"],
    ],
  ],
  [
    "Testnet",
    [
      ["Ethereum",  "0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45"], //Goerli
    ],
  ],
] as const satisfies RoArray<readonly [Network, RoArray<readonly [Chain, string]>]>;

export const uniswapV3Router = constMap(uniswapV3RouterContracts);

//same across all chains/networks
export const permit2Contract = "0x000000000022D473030F116dDEE9F6B43aC78BA3";
