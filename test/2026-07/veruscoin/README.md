# VerusCoin Incident Report

## Summary

- **Protocol**: VerusCoin
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0x6990f01720f57fc515d0e976a0c4f8157e0a9529194c4c15d190e98d087eb321`](https://etherscan.io/tx/0x6990f01720f57fc515d0e976a0c4f8157e0a9529194c4c15d190e98d087eb321)
- **Block**: 25118335
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 1467.44s (1467445 ms)
- **Detected at**: 2026-07-23T14:22:21+00:00
- **Original alert**: https://x.com/QuillAudits_AI/status/2080297469733441654

## Impact

- **Estimated loss**: $11585974.20
- **Funds valued at**: 2026-05-17T23:55:11Z (price as of block N-1, pre-hack)
- **Main affected assets**: tBTC, ETH, USDC
- **Attacker gain reproduced**: $11585974.20 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Bridge import path accepted an attacker-supplied import payload that released escrowed ETH, tBTC, and USDC
- **In short**: The incident transaction calls submitImports on 0x71518580f36feceffe0721f06ba4703218cd7f63 and reaches frame 54, a delegatecall into 0x08f0fbcc068c70a29326094110769ee5f1d0107d selector 0xf419ee83.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Escrowed bridge assets may be released only for a decoded transfer whose amount, token, recipient, and uniqueness are proven by a valid authorized bridge/export proof.

The incident transaction calls submitImports on 0x71518580f36feceffe0721f06ba4703218cd7f63 and reaches frame 54, a delegatecall into 0x08f0fbcc068c70a29326094110769ee5f1d0107d selector 0xf419ee83. That path consumes the supplied import/transfer payload and reaches native/ERC20 payout dispatch, releasing pre-existing escrowed assets to 0x65cb8b128bf6e69076104...

Mechanism:

- The exploit entered through `submitImports(((uint8,uint8,(uint8,(uint8,uint32,uint32,uint8,bytes32[]))[],(uint8,uint8,bytes,(uint8,(uint8,uint32,uint32,uint8,bytes32[]))[])[]),bytes))` before reaching the vulnerable accounting path.
- The incident transaction calls submitImports on 0x71518580f36feceffe0721f06ba4703218cd7f63 and reaches frame 54, a delegatecall into 0x08f0fbcc068c70a29326094110769ee5f1d0107d selector 0xf419ee83.
- The accounting update violated the invariant: Escrowed bridge assets may be released only for a decoded transfer whose amount, token, recipient, and uniqueness are proven by a valid authorized bridge/export proof.

Key evidence:

- PoC status, build status, and test status are pass, with economic reproduction reported as exact.
- Verified replay target and exact asset-loss table for ETH, tBTC, and USDC.
- Root submitImports call delegates into frame 2 and frame 54; frame 54 is the bridge-processing delegatecall with native and token payout children.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x71518580f36feceffe0721f06ba4703218cd7f63` | `unknown bridge storage/dispatcher` | `primary vulnerable contract and asset holder` |
| `0x08f0fbcc068c70a29326094110769ee5f1d0107d` | `unknown bridge import processor` | `delegatecall code executing visible import-processing and payout dispatch` |

## Limitations

- proof_validation_branch_source_gap: the decisive proof/notary/unique-import guard is not pinpointed in source or semantic CSIR.
- prior_state_provenance_gap: consumed pre-state slots are observed as anchors, but their writer provenance and semantic layout are unavailable.
