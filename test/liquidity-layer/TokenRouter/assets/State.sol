// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {ICircleIntegration} from "wormhole/ICircleIntegration.sol";
import {IState} from "../../interfaces/IState.sol";

import "./Errors.sol";
import {getRouterEndpoint} from "./Storage.sol";

abstract contract State is IState {
    // Immutable state.
    IERC20 immutable _orderToken;
    ICircleIntegration immutable _wormholeCctp;
    uint16 immutable _wormholeChainId;

    // Consts.
    uint32 constant NONCE = 0;

    constructor(address token_, address wormholeCctp_) {
        _orderToken = IERC20(token_);
        _wormholeCctp = ICircleIntegration(wormholeCctp_);
        _wormholeChainId = _wormholeCctp.chainId();
    }

    /// @inheritdoc IState
    function getRouter(uint16 chain) public view returns (bytes32) {
        return getRouterEndpoint().endpoints[chain];
    }

    /// @inheritdoc IState
    function isFillRedeemed(bytes32 fillHash) external view returns (bool) {
        return _wormholeCctp.isMessageConsumed(fillHash);
    }

    /// @inheritdoc IState
    function orderToken() external view returns (IERC20) {
        return _orderToken;
    }

    /// @inheritdoc IState
    function wormholeCctp() external view returns (ICircleIntegration) {
        return _wormholeCctp;
    }

    /// @inheritdoc IState
    function wormholeChainId() external view returns (uint16) {
        return _wormholeChainId;
    }
}
