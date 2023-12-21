// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.0;

struct OrderResponse {
    // Signed wormhole message.
    bytes encodedWormholeMessage;
    // Message emitted by the CCTP contract when burning USDC.
    bytes circleBridgeMessage;
    // Attestation created by the CCTP off-chain process, which is needed to mint USDC.
    bytes circleAttestation;
}

struct RedeemedFill {
    // The address of the `PlaceMarketOrder` caller on the source chain.
    bytes32 sender;
    // The chain ID of the source chain.
    uint16 senderChain;
    // The address of the USDC token that was transferred.
    address token;
    // The amount of USDC that was transferred.
    uint256 amount;
    // The arbitrary bytes message that was sent to the `redeemer` contract.
    bytes message;
}

interface ITokenRouter {
    /**
     * @notice Redeems a `Fill` or `FastFill` Wormhole message from a registered router
     * (or the `MatchingEngine` in the case of a `FastFill`). The `token` and `message`
     * are sent to the `redeemer` contract on the target chain.
     * @dev The caller must be the encoded `redeemer` in the `Fill` message.
     * @param response The `OrderResponse` struct containing the `Fill` message.
     * @return redeemedFill The `RedeemedFill` struct.
     */
    function redeemFill(OrderResponse memory response) external returns (RedeemedFill memory);

    /**
     * @notice Place an "order" to transfer USDC to another blockchain.
     * The tokens will be transferred to the `redeemer` contract on the
     * target chain upon redemption.
     * @param amountIn Amount of tokens to transfer.
     * @param minAmountOut Minimum amount of tokens to receive in exchange for `amountIn`
     * when executing a market order on the MatchingEngine. This
     * parameter is currently unused, but is available to future proof
     * the contract.
     * @param targetChain The chain ID of the chain to transfer tokens to.
     * @param redeemer The address of the redeeming contract on the target chain.
     * @param redeemerMessage Arbitrary payload to be sent to the `redeemer`.
     * @param refundAddress The address to refund tokens to if the order is reverted. This
     * parameter is currently unused, but is available to future proof
     * the contract.
     * @return sequence The sequence number of the `Fill` Wormhole message.
     * @dev Currently, the `minAmountOut` and `refundAddress` parameters
     * are unused, but are available to future proof the contract. Eventually,
     * the `MatchingEngine` contract will faciliate transfers of cononical
     * USDC by swapping CCTP USDC for a wrapped alternative. If you plan to
     * support non-CCTP enabled chains in the future, use this interface.
     *
     * This function requires the caller to pass in `msg.value` equal to the
     * amount returned by `messageFee()` on the IWormhole.sol interface.
     */
    function placeMarketOrder(
        uint amountIn,
        uint minAmountOut,
        uint16 targetChain,
        bytes32 redeemer,
        bytes calldata redeemerMessage,
        address refundAddress
    ) external payable returns (uint64 sequence);

    /**
     * @notice Place an "order" to transfer USDC to a CCTP-enabled blockchain.
     * The tokens will be transferred to the `redeemer` contract on the
     * target chain upon redemption.
     * @param amountIn Amount of tokens to transfer.
     * @param targetChain The chain ID of the chain to transfer tokens to.
     * @param redeemer The address of the redeeming contract on the target chain.
     * @param redeemerMessage Arbitrary payload to be sent to the `redeemer`.
     * @return sequence The sequence number of the `Fill` Wormhole message.
     * @dev This interface is for CCTP-enabled chains only. If you plan to
     * support non-CCTP enabled chains in the future, use the other `placeMarketOrder`
     * interface which includes a `minAmountOut` and `refundAddress` parameter.
     *
     * This function requires the caller to pass in `msg.value` equal to the
     * amount returned by `messageFee()` on the IWormhole.sol interface.
     */
    function placeMarketOrder(
        uint amountIn,
        uint16 targetChain,
        bytes32 redeemer,
        bytes calldata redeemerMessage
    ) external payable returns (uint64 sequence);

    /**
     * @notice Place a "fast order" to transfer USDC to another blockchain.
     * A `FastMarketOrder` is an order type that does not wait for finality,
     * instead market makers on the `MatchingEngine` chain will participate in
     * an auction to determine the fee paid by the user to faciliate the fast
     * transfer. The order will be executed immediately after the auction and
     * the tokens will be transferred to the `redeemer` contract on the target
     * chain. The fee paid by the user is capped at a rate determined by the
     * protocol operator.
     * @param amountIn Amount of tokens to transfer.
     * @param minAmountOut Minimum amount of tokens to receive in exchange for `amountIn`.
     * @param targetChain The chain ID of the chain to transfer tokens to.
     * @param redeemer The address of the redeeming contract on the target chain.
     * @param redeemerMessage Arbitrary payload to be sent to the `redeemer`.
     * @param refundAddress The address to refund tokens to if the order is reverted. This
     * parameter is currently unused, but is available to future proof
     * the contract.
     * @param maxFee The maximum fee that the user is willing to pay to execute
     * a fast transfer.
     * @param deadline The deadline for the fast transfer auction to start. This timestamp
     * should be for the `MatchingEngine` chain to avoid any clock drift issues between
     * different blockchains. Set this value to 0 to opt out of using a deadline.
     * @return sequence The sequence number of the `SlowOrderResponse` Wormhole message.
     * @return fastSequence The sequence number of the `FastMarketOrder` Wormhole message.
     * @dev Currently, the `minAmountOut` and `refundAddress` parameters
     * are unused, but are available to future proof the contract. Eventually,
     * the `MatchingEngine` contract will faciliate transfers of cononical
     * USDC by swapping CCTP USDC for a wrapped alternative. If you plan to
     * support non-CCTP enabled chains in the future, use this interface.
     *
     * This function requires the caller to pass in `msg.value` equal to two
     * times the amount returned by `messageFee()` on the IWormhole.sol interface.
     *
     */
    function placeFastMarketOrder(
        uint amountIn,
        uint minAmountOut,
        uint16 targetChain,
        bytes32 redeemer,
        bytes calldata redeemerMessage,
        address refundAddress,
        uint maxFee,
        uint32 deadline
    ) external payable returns (uint64 sequence, uint64 fastSequence);

    /**
     * @notice Place a "fast order" to transfer USDC to another blockchain.
     * A `FastMarketOrder` is an order type that does not wait for finality,
     * instead market makers on the `MatchingEngine` chain will participate in
     * an auction to determine the fee paid by the user to faciliate the fast
     * transfer. The order will be executed immediately after the auction and
     * the tokens will be transferred to the `redeemer` contract on the target
     * chain. The fee paid by the user is capped at a rate determined by the
     * protocol operator.
     * @param amountIn Amount of tokens to transfer.
     * @param targetChain The chain ID of the chain to transfer tokens to.
     * @param redeemer The address of the redeeming contract on the target chain.
     * @param redeemerMessage Arbitrary payload to be sent to the `redeemer`.
     * @param maxFee The maximum fee that the user is willing to pay to execute
     * a fast transfer.
     * @param deadline The deadline for the fast transfer auction to start. This timestamp
     * should be for the `MatchingEngine` chain to avoid any clock drift issues between
     * different blockchains. Set this value to 0 to opt out of using a deadline.
     * @return sequence The sequence number of the `SlowOrderResponse` Wormhole message.
     * @return fastSequence The sequence number of the `FastMarketOrder` Wormhole message.
     * @dev This interface is for CCTP-enabled chains only. If you plan to
     * support non-CCTP enabled chains in the future, use the other `placeMarketOrder`
     * interface which includes a `minAmountOut` and `refundAddress` parameter.
     *
     * This function requires the caller to pass in `msg.value` equal to two
     * times the amount returned by `messageFee()` on the IWormhole.sol interface.
     */
    function placeFastMarketOrder(
        uint amountIn,
        uint16 targetChain,
        bytes32 redeemer,
        bytes calldata redeemerMessage,
        uint maxFee,
        uint32 deadline
    ) external payable returns (uint64 sequence, uint64 fastSequence);
}
