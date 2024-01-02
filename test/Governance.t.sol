// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.23;

import { SwapLayerTestBase } from "./TestBase.sol";
import "./utils/UpgradeTester.sol";

import "../src/assets/SwapLayerGovernance.sol";

contract SwapLayerGovernanceTest is SwapLayerTestBase {
  function setUp() public {
    deployBase();
  }

  function testUpgradeContract() public {
    UpgradeTester upgradeTester = new UpgradeTester();

    vm.expectRevert(NotAuthorized.selector);
    swapLayer.executeGovernanceActions(
      abi.encodePacked(GovernanceAction.UpgradeContract, address(upgradeTester))
    );

    vm.startPrank(owner);
    swapLayer.executeGovernanceActions(
      abi.encodePacked(GovernanceAction.UpgradeContract, address(upgradeTester))
    );
    
    vm.stopPrank();
  }
}