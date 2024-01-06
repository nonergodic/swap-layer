// SPDX-License-Identifier: Apache 2

pragma solidity ^0.8.19;

error ErrInvalidRedeemer(bytes32 redeemer, bytes32 expected);

error ErrInvalidRefundAddress();

error ErrInvalidRedeemerAddress();

error ErrInvalidEndpoint(bytes32 endpoint);

error ErrUnsupportedChain(uint16 chain);

error ErrChainNotAllowed(uint16 chain);

error ErrInvalidSourceRouter(bytes32 sender, bytes32 expected);

error ErrInvalidMatchingEngineSender(bytes32 sender, bytes32 expected);

error ErrInvalidChain(uint16 chain);

error ErrInsufficientAmount(uint128 amount, uint128 minAmount);

error ErrInsufficientFastTransferFee();

error ErrAmountTooLarge(uint128 amountIn, uint128 maxAmount);

error ErrFastTransferFeeUnset();

error ErrInvalidFeeInBps();

error ErrInvalidFastTransferParameters();

error ErrFastTransferNotSupported();

error ErrInvalidFeeOverride();

error ErrFastTransferDisabled();

error ErrInvalidMaxFee(uint128 maxFee, uint128 minimumReuiredFee);
