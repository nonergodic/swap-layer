// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.23;

import { ProxyBase } from "proxy/ProxyBase.sol";

contract UpgradeTester is ProxyBase {
  event Constructed(bytes data, uint256 value);
  event Upgraded(bytes data);

  function upgradeTo(address newImplementation, bytes calldata data) external {
    _upgradeTo(newImplementation, data);
  }

  function getImplementation() external view returns (address) {
    return _getImplementation();
  }

  function _proxyConstructor(bytes calldata data) internal override {
    emit Constructed(data, msg.value);
  }

  function _contractUpgrade(bytes calldata data) internal override {
    emit Upgraded(data);
  }
}
