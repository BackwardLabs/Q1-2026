# Summer Finance Incident Report

## Summary

- **Protocol**: Summer Finance
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0x0db528c44f23fc7fa4544684a2fab81096450a14aae8bc89f42cd0592d43da12`](https://etherscan.io/tx/0x0db528c44f23fc7fa4544684a2fab81096450a14aae8bc89f42cd0592d43da12)
- **Block**: 25471348
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 1415.41s (1415410 ms)
- **Detected at**: 2026-07-06T05:41:54+00:00
- **Original alert**: https://x.com/CertiKAlert/status/2074005902362132625

## Impact

- **Estimated loss**: $5127129.50
- **Funds valued at**: 2026-07-06T05:17:47Z (price as of block N-1, pre-hack)
- **Main affected assets**: KPK_USDC_Prime, USDC, gtUSDC, USDS, sUSDS
- **Attacker gain reproduced**: $6016213.65 (USD ratio: 1.000x)
- **USD incomplete**: 5 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Public forced deallocation made adapter liquidity withdrawable beyond the caller's economic claim
- **In short**: The vulnerable path is the `forceDeallocate(address,bytes,uint256,address)` flow; it violated the value/accounting invariant below.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A public forced-deallocation caller may only unlock adapter liquidity up to the caller's fully burned or otherwise owned pro-rata claim, and adapter calldata/assets must be constrained to configured vault allocation state.

Affected Morpho VaultV2 contracts expose forceDeallocate(address,bytes,uint256,address) as an external branch that calls the allocator deallocation path and then charges only a configured penalty withdrawal from onBehalf. The violated invariant is that public forced deallocation must not make adapter-held vault liquidity withdrawable beyond the caller's full...

Mechanism:

- The attacker reached the victim through the `forceDeallocate(address,bytes,uint256,address)` flow during the exploit.
- Affected Morpho VaultV2 contracts expose forceDeallocate(address,bytes,uint256,address) as an external branch that calls the allocator deallocation path and then charges only a configured penalty withdrawal from onBehalf...
- The accounting update violated the invariant: A public forced-deallocation caller may only unlock adapter liquidity up to the caller's fully burned or otherwise owned pro-rata claim, and adapter calldata/assets must be constrained to configured vault allocation state.

Key evidence:

- PoC build, test, and economic proof passed.
- Frontier records 6016754998120906520734632 DAI gained by the attacker EOA and giant tsvSummerfiUSDC share expansion context.
- Frame 2060 is the tsvSummerfiUSDC deposit/share mint; forceDeallocate frames are connected to large vault-token losses and adapter deallocation calls.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x4ef53d2caa51c447fdfeeedee8f07fd1962c9ee6` | `VaultV2 / KPK_USDC_Prime` | `primary vulnerable contract` |
| `0xe2221aa07ec3266da87763e2b1e28d07a8a4e53b` | `VaultV2 / Api3CoreUSDC` | `affected sibling vault` |
| `0x56bfa6f53669b836d1e0dfa5e99706b12c373ecf` | `VaultV2 / skyMoneyUsdcRiskCapital` | `affected sibling vault` |
| `0x98c49e13bf99d7cad8069faa2a370933ec9ecf17` | `FleetCommander / LVUSDC` | `downstream share and ark accounting consumer` |
| `0xa9ca4909700505585b1ad2a1579da3b670ffa9c4` | `tsvSummerfiUSDC Strategy` | `entitlement context` |

## Limitations

- the exact MorphoMarketV1AdapterV2.deallocate branch is not available as verified source or semantic CSIR; adapter behavior is supported by trace/pseudocode fallback only.
- adapter_source_gap: victim_sources contains VaultV2, FleetCommander, ERC4626Ark, and TokenizedStrategy source, but not the concrete Morpho adapter implementation used in the forceDeallocate calls.
