// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.23;

import "forge-std/Test.sol";
import "forge-std/console.sol";

import { ERC1967Proxy } from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { fromUniversalAddress } from "wormhole/Utils.sol";
import { ICircleIntegration } from "wormhole/ICircleIntegration.sol";
import { SigningWormholeSimulator } from "wormhole/WormholeSimulator.sol";
import { CircleSimulator } from "cctp-solidity/CircleSimulator.sol";
import { ITokenRouter } from "liquidity-layer/ITokenRouter.sol";
import { Proxy } from "proxy/Proxy.sol";
import { IPermit2 } from "permit2/IPermit2.sol";
import { ISwapRouter } from "uniswap/ISwapRouter.sol";

import { TokenRouterImplementation }
  from "./liquidity-layer/TokenRouter/TokenRouterImplementation.sol";

import { SwapLayer } from "../src/SwapLayer.sol";

contract SwapLayerTestBase is Test {
  IERC20 immutable usdc;
  //IWormhole immutable wormhole;
  ICircleIntegration immutable circleIntegration;
  uint16 immutable chainId;
  uint16 immutable foreignChainId;
  bytes32 constant foreignLiquidityLayer = bytes32(uint256(uint160(address(1))));

  address immutable signer;
  uint256 immutable signerSecret;
  address immutable llOwner;
  address immutable llAssistant;
  address immutable owner;
  address immutable assistant;
  address immutable feeRecipient;

  ITokenRouter liquidityLayer;
  SigningWormholeSimulator wormholeSimulator;
  CircleSimulator circleSimulator;

  SwapLayer swapLayer;

  constructor() {
    usdc              = IERC20(vm.envAddress("TEST_USDC_ADDRESS"));
    circleIntegration = ICircleIntegration(vm.envAddress("TEST_CIRCLE_INTEGRATION_ADDRESS"));
    chainId           = circleIntegration.chainId();
    foreignChainId    = uint16(vm.envUint("TEST_FOREIGN_CHAIN_ID"));

    (signer, signerSecret) = makeAddrAndKey("signer");
    llOwner                = makeAddr("llOwner");
    llAssistant            = makeAddr("llAssistant");
    owner                  = makeAddr("owner");
    assistant              = makeAddr("assistant");
    feeRecipient           = makeAddr("feeRecipient");
  }

  function deployBase() public {
    liquidityLayer = ITokenRouter(address(new ERC1967Proxy(
      address(new TokenRouterImplementation(address(usdc), address(circleIntegration))),
      abi.encodeCall(TokenRouterImplementation.initialize, (llOwner, llAssistant))
    )));

    vm.prank(llOwner);
    TokenRouterImplementation(address(liquidityLayer))
      .addRouterEndpoint(foreignChainId, foreignLiquidityLayer);

    wormholeSimulator = new SigningWormholeSimulator(circleIntegration.wormhole(), signerSecret);
    circleSimulator = new CircleSimulator(
      signerSecret,
      address(circleIntegration.circleTransmitter()),
      vm.envAddress("TEST_FOREIGN_USDC_ADDRESS")
    );
    circleSimulator.setupCircleAttester();

    swapLayer = SwapLayer(payable(address(new Proxy(
      address(new SwapLayer(
        IPermit2(vm.envAddress("TEST_PERMIT2_ADDRESS")),
        ISwapRouter(vm.envAddress("TEST_UNISWAP_V3_ROUTER_ADDRESS")),
        liquidityLayer
      )),
      abi.encodePacked(owner, assistant, feeRecipient)
    ))));
  }
}
