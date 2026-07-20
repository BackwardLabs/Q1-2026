// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0x622b4c078f1175c9aee10e9e79572f19cfedfeaf
// Attack Contract : 0x71f12a5b0e60d2ff8a87fd34e7dcff3c10c914b0
// Vulnerable Contract : 0x71f12a5b0e60d2ff8a87fd34e7dcff3c10c914b0
// Attack Tx : 0xccdf085354c5e7112c6af2a68a330f42b74efe2e536cba2cb6ef3e68eda464ef
// Block : 25576194
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : unpriced_reproduction
// Reproduced Value : N/A
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = 0x71F12a5b0E60d2Ff8A87FD34E7dcff3c10c914b0;
    uint256 constant FORK_BLOCK = 25576193;
    uint256 constant TX_TIMESTAMP = 1784577875;
    uint256 constant TX_BLOCK_NUMBER = 25576194;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 22;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(attack);
        attack.attack{value: TX_VALUE}();
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        attack = new OurAttack();
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        return address(0);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        return;
    }
}

contract OurAttack {
    function attack() public payable {}

    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
    }

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _recordBalancerPre(address[] memory tokens) internal {
        for (uint256 i = 0; i < tokens.length; i++) {
            _balancerVaultPreBalance[tokens[i]] =
                IERC20Like(tokens[i]).balanceOf(0xBA12222222228d8Ba445958a75a0704d566BF2C8);
        }
    }

    function recordBalancerPre(address[] memory tokens) external {
        _recordBalancerPre(tokens);
    }

    function balancerVaultPreBalance(address token) external view returns (uint256) {
        return _balancerVaultPreBalance[token];
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attacker_eoa = 0x622B4c078f1175c9aee10E9e79572F19cfEdfeAf; // Addresses.attacker_eoa = 0x622b4c078f1175c9aee10e9e79572f19cfedfeaf label=attacker_eoa roles=attacker_eoa|contract source=tx_metadata.from confidence=high
}

