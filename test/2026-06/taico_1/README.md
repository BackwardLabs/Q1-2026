# taico_1 Incident Report

## Summary

- **Protocol**: taico_1
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xb8befb015a67de8f40890b1f8667c597c3b66a52b388ec1c6cd28637fd65dd13`](https://etherscan.io/tx/0xb8befb015a67de8f40890b1f8667c597c3b66a52b388ec1c6cd28637fd65dd13)
- **Block**: 25368908
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 627.44s (627437 ms)

## Impact

- **Estimated loss**: unknown
- **Main affected assets**: unknown
- **Attacker gain reproduced**: $223255.73 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Destination bridge processed a 130 ETH message whose source-side entitlement is not proven in the supplied artifacts
- **In short**: The current Ethereum transaction executes MainnetBridge/Bridge.processMessage, verifies a supplied SignalService proof, consumes ETH quota, and invokes the message recipient with 130 ETH.
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: An Ethereum bridge ETH release must only occur for a source-chain bridge message whose proven signal is backed by corresponding value/custody entitlement for the same msgHash, recipient, and amount.

The current Ethereum transaction executes MainnetBridge/Bridge.processMessage, verifies a supplied SignalService proof, consumes ETH quota, and invokes the message recipient with 130 ETH. The failed invariant would be that every ETH release must be backed by a valid source-chain bridge message and value/custody entitlement for the same message hash, recipien...

Mechanism:

- The exploit entered through `processMessage((uint64,uint64,uint32,address,uint64,address,uint64,address,address,uint256,bytes),bytes) / selector 0x2035065e` before reaching the vulnerable accounting path.
- The current Ethereum transaction executes MainnetBridge/Bridge.processMessage, verifies a supplied SignalService proof, consumes ETH quota, and invokes the message recipient with 130 ETH.
- The accounting update violated the invariant: An Ethereum bridge ETH release must only occur for a source-chain bridge message whose proven signal is backed by corresponding value/custody entitlement for the same msgHash, recipient, and amount.

Key evidence:

- PoC status and Foundry execution passed for the analyzed transaction.
- Trace order shows processMessage calling SignalService, QuotaManager, then the 130 ETH recipient payout.
- Frame 2 is the processMessage ancestor; frames 4 and 6 are proof/quota accounting; frame 9 is the downstream 130 ETH transfer.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xd60247c6848b7ca29eddf63aa924e53db6ddd8ec` | `MainnetBridge proxy` | `primary bridge holding and releasing ETH` |
| `0x9e0a24964e5397b566c1ed39258e21ab5e35c77c` | `SignalService proxy` | `proof verification gate` |
| `0x91f67118dd47d502b1f0c354d0611997b022f29e` | `QuotaManager proxy` | `ETH quota accounting gate` |

## Limitations

- tx_scope_gap: the supplied artifacts cover the Ethereum processMessage transaction but not the source-chain sendMessage/custody transaction that created the proven signal.
- a complete claim that the SignalService proof was forged or value-unbacked would require checkpoint/proof/source-chain provenance not present in the closed-world evidence.
