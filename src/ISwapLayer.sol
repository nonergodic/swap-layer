// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.23;

import { OrderResponse } from "liquidity-layer/ITokenRouter.sol";

interface ISwapLayer {
  //signature: 22bf2bd8
  function initiate(
    uint16 targetChain,
    bytes32 recipient, //must be the redeemer in case of a custom payload
    bool isExactIn,
    bytes calldata params
  ) external payable returns (bytes memory);

  //signature: 838dd05b
  function complete(
    OrderResponse calldata response,
    bytes calldata params
  ) external payable returns (bytes memory);

  //signature: aa327791
  function updateFeeParams(bytes calldata updates) external;

  //signature: d78b3c6e
  function executeGovernanceActions(bytes calldata actions) external;

  //signature: f4189c473 - can't actually be called externally except by the contract itself
  function checkedUpgrade(bytes calldata data) external payable;

  //required for weth.withdraw
  receive() external payable;
}