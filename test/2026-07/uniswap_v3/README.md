# Uniswap V3 Incident Report

## Summary

- **Protocol**: Uniswap V3
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xb1a43313b51512b45fc5d921838a8a6427266f4326e5d82cde7cdbe02daa3349`](https://etherscan.io/tx/0xb1a43313b51512b45fc5d921838a8a6427266f4326e5d82cde7cdbe02daa3349)
- **Block**: 25467373
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 746.64s (746641 ms)
- **Detected at**: 2026-07-06T06:28:44+00:00

## Impact

- **Estimated loss**: unknown
- **Funds valued at**: 2026-07-05T15:58:59Z (price as of block N-1, pre-hack)
- **Main affected assets**: unknown
- **Attacker gain reproduced**: $95403.91 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: No patchable vulnerable branch is supported by the supplied artifacts
- **In short**: The verified PoC reproduces attacker profit through a PoolManager unlock flow, V2 swap, PoolManager swap, V3 swap callback payment, and WETH withdrawal.
- **Severity**: `low`
- **Confidence**: `low`
- **Violated invariant**: Unknown: no supplied source, pseudocode, trace, or RPC evidence proves that a PoolManager, V3, V2, ERC20, oracle, or accounting invariant was violated.

The verified PoC reproduces attacker profit through a PoolManager unlock flow, V2 swap, PoolManager swap, V3 swap callback payment, and WETH withdrawal. However, source-visible PoolManager settlement checks and V3 callback repayment checks are not shown to fail or be bypassed, and the current artifact impact table has no negative victim deltas.

Mechanism:

- The exploit entered through `0x00000002` before reaching the vulnerable accounting path.
- The verified PoC reproduces attacker profit through a PoolManager unlock flow, V2 swap, PoolManager swap, V3 swap callback payment, and WETH withdrawal.
- The accounting update violated the invariant: Unknown: no supplied source, pseudocode, trace, or RPC evidence proves that a PoolManager, V3, V2, ERC20, oracle, or accounting invariant was violated.

Key evidence:

- PoC, execution, economic status, forge build, and forge test all passed.
- Trace sequence shows PoolManager unlock/callback, take, V2 swap, settle, PoolManager swap, V3 swap path, and reproduced ETH profit.
- Artifact records positive attacker and infrastructure deltas but no negative victim delta rows in the current transaction.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x000000000004444c5dc75cb358380d2e3de08a90` | `PoolManager` | `protocol accounting contract exercised by the PoC; vulnerable role unproven` |
| `0x80f8143fa056a063aaeecec3323aa3426262ddb2` | `UniswapV3Pool` | `swap pool used in the profit path; vulnerable role unproven` |

## Limitations

- tx_scope_gap: current impact artifacts show attacker profit but no direct negative victim delta rows.
- the decisive PoolManager swap execution is not trace-backed in the PoC handoff and is marked as storage-only.
