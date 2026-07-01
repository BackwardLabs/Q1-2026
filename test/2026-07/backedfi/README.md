# BackedFi Incident Report

## Summary

- **Protocol**: BackedFi
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xe2320086b2815d21b0927839bd0e306466c29a68d38d5361e99dd21ec5472612`](https://etherscan.io/tx/0xe2320086b2815d21b0927839bd0e306466c29a68d38d5361e99dd21ec5472612)
- **Block**: 25434062
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 935.99s (935994 ms)
- **Detected at**: 2026-07-01T01:30:57+00:00
- **Original alert**: https://x.com/TenArmorAlert/status/2072130807356129726

## Impact

- **Estimated loss**: $204137.47
- **Funds valued at**: 2026-07-01T00:24:35Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDC, wSPYx, wQQQx, wNVDAx, wMSTRx
- **Attacker gain reproduced**: $204137.47 (USD ratio: 1.000x)
- **USD incomplete**: 5 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Lending pool accepted recursive borrowed wGOOGLx as collateral and allowed over-borrowing
- **In short**: The vulnerable path is the `borrow(address,uint256,uint256,uint16,address) then attacker selector 0xc1d5a727 supplying wGOOGLx` flow; it violated the value/accounting invariant below.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Borrowed assets must not be immediately re-counted as fresh collateral in a way that increases effective borrowing power beyond post-action health, oracle valuation, isolation, and solvency constraints.

The root cause is attacker-controlled state reaching protected accounting updates.

Mechanism:

- The attacker reached the victim through the `borrow(address,uint256,uint256,uint16,address) then attacker selector 0xc1d5a727 supplying wGOOGLx` flow during the exploit.
- That path trusted attacker-controlled state while performing protected accounting updates.
- The accounting update violated the invariant: Borrowed assets must not be immediately re-counted as fresh collateral in a way that increases effective borrowing power beyond post-action health, oracle valuation, isolation, and solvency constraints.

Key evidence:

- PoC execution, economic proof, Forge build, and Forge test all passed.
- Top frames are pool-called debt/eToken mint/accounting frames tied to giant supply expansion, not raw transfer frames.
- The PoC supplies USDC, loops borrow(wGOOGLx) plus supply(wGOOGLx), then borrows USDC and wrapped equities.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x3eeeb3cd20f844a578807fc457388ceb9a67faa6` | `unknown lending pool proxy` | `primary vulnerable contract` |
| `0xc84577a366bdc6ace161388dace77ff0a8958b9a` | `VariableDebtToken` | `downstream debt-token implementation` |
| `0xb0c626f9c25418ba16132e5ae33cf54e61f8242f` | `AToken` | `downstream eToken implementation` |

## Limitations

- pool health/oracle/solvency validation branch is not source-visible in supplied artifacts
- pool_validation_source_gap: no victim_sources directory for implementation 0xf7ba2c2b2e3b8c3c327b632e6bdff77840f06b34
