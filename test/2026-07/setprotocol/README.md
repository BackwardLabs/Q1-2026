# SetProtocol Incident Report

## Summary

- **Protocol**: SetProtocol
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0x7f45428df558fba1d19ab115effef8ecd1e6e05b491f02202b0815e47b8d658b`](https://etherscan.io/tx/0x7f45428df558fba1d19ab115effef8ecd1e6e05b491f02202b0815e47b8d658b)
- **Block**: 25644621
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 1631.63s (1631626 ms)
- **Detected at**: 2026-07-30T09:58:54+00:00
- **Original alert**: https://x.com/SlowMist_Team/status/2082767887245410320

## Impact

- **Estimated loss**: $8653.21
- **Funds valued at**: 2026-07-30T08:57:11Z (price as of block N-1, pre-hack)
- **Main affected assets**: LINK, UNI, AAVE, MKR, WBTC
- **Attacker gain reproduced**: $0.00 (USD ratio: 1.000x)
- **USD incomplete**: 1 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: ExchangeIssuance priced a SetToken before an attacker-controlled issuance hook changed settlement state
- **In short**: ExchangeIssuance.issueSetForExactToken computes setIssueAmount from pre-hook SetToken component units and AMM spot-reserve quotes, then calls BasicIssuanceModule.issue without revalidating the component/unit state after ...
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: A quoted SetToken issuance amount must be settled against the same component list, unit amounts, and valuation state used to price the quote, or the quote must be recomputed and bounded after all issuance hooks.

ExchangeIssuance.issueSetForExactToken computes setIssueAmount from pre-hook SetToken component units and AMM spot-reserve quotes, then calls BasicIssuanceModule.issue without revalidating the component/unit state after the module's manager pre-issue hook runs. BasicIssuanceModule.issue calls that hook before recomputing required component quantities and bef...

Mechanism:

- The exploit entered through `0x5d371673` before reaching the vulnerable accounting path.
- That path trusted attacker-controlled state while performing protected accounting updates.
- The accounting update violated the invariant: A quoted SetToken issuance amount must be settled against the same component list, unit amounts, and valuation state used to price the quote, or the quote must be recomputed and bounded after all issuance hooks.

Key evidence:

- PoC status, forge build, forge test, and economic reproduction are pass.
- Verified replay target, attacker, callback surfaces, and multi-token economic effect.
- Frontier shows direct asset loss, Set issuance ancestors, and downstream transferFrom effects.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xc8c85a3b4d03fb3451e7248ff94f780c92f884fd` | `ExchangeIssuance` | `primary vulnerable contract` |
| `0xd8ef3cace8b4907117a45b0b125c68560532f94d` | `BasicIssuanceModule` | `settlement module whose hook order realized the stale quote` |
| `0xf7c2d0a2bf81bf803ed6e1d97c89fe3b30b06948` | `SetToken` | `attacker-created SetToken used for component entitlement` |

## Limitations

- CustomOracleNavIssuanceModule source is not present under [internal artifact]; hook-time module calls are supported by pseudocode and semantic CSIR, but no source-level bug is claimed inside that module.
- storage_writer_provenance.json did not resolve a prior writer because tested trace-read storage values did not match pre-block RPC state; this RCA does not infer a prior setup transaction.
