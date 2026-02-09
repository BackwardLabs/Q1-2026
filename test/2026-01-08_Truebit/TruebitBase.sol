// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "src/shared/BaseTest.sol";
import "src/shared/FeatureTypes.sol";
import "src/shared/interfaces.sol";

/*
@Protocol: Truebit
@Date: 2026-01-08
@Attacker: 0x6C8EC8f14bE7C01672d31CFa5f2CEfeAB2562b50
@Target: 0x1De399967B206e446B4E9AeEb3Cb0A0991bF11b8
@TxHash: 0xcd4755645595094a8ab984d0db7e3b4aabde72a5c87c4f176a030629c47fb014
@ChainId: 1
@GasUsed: 481749
*/

abstract contract TruebitBase is BaseTest {
    function setUp() public virtual {
        vm.createSelectFork("mainnet", 24191018);
        target = 0x1De399967B206e446B4E9AeEb3Cb0A0991bF11b8;
        txHash = 0xcd4755645595094a8ab984d0db7e3b4aabde72a5c87c4f176a030629c47fb014;
    }
}
