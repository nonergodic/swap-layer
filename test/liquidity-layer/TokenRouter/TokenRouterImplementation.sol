// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.19;

import {BytesParsing} from "wormhole/WormholeBytesParsing.sol";

import "../shared/Admin.sol";
import {Messages} from "../shared/Messages.sol";
import {getImplementationState, Implementation} from "../shared/Admin.sol";

import {TokenRouterAdmin} from "./assets/TokenRouterAdmin.sol";
import {PlaceMarketOrder} from "./assets/PlaceMarketOrder.sol";
import {RedeemFill} from "./assets/RedeemFill.sol";
import {State} from "./assets/State.sol";

contract TokenRouterImplementation is TokenRouterAdmin, PlaceMarketOrder, RedeemFill {
    constructor(address token_, address wormholeCircle_) State(token_, wormholeCircle_) {}

    function initialize(address owner, address ownerAssistant) external {
        require(owner != address(0), "Invalid owner");
        require(ownerAssistant != address(0), "Invalid owner assistant");
        require(getOwnerState().owner == address(0), "Already initialized");

        getOwnerState().owner = owner;
        getOwnerAssistantState().ownerAssistant = ownerAssistant;
    }
}
