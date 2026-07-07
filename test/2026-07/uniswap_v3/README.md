# Uniswap V3 Incident Report

## Summary

- **Protocol**: Uniswap V3
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xb1a43313b51512b45fc5d921838a8a6427266f4326e5d82cde7cdbe02daa3349`](https://etherscan.io/tx/0xb1a43313b51512b45fc5d921838a8a6427266f4326e5d82cde7cdbe02daa3349)
- **Block**: 25467373
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 769.91s (769906 ms)
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

- **Finding**: No patchable vulnerable branch established from closed-world evidence
- **In short**: The artifacts prove a profitable transaction that routes through PoolManager flash accounting, Uniswap V2, Uniswap V3, WETH, and AVAIL.
- **Severity**: `low`
- **Confidence**: `low`
- **Violated invariant**: Not established; no supplied source, pseudocode, trace, or RPC evidence proves a failed protocol/accounting/authority/price/entitlement invariant.

The artifacts prove a profitable transaction that routes through PoolManager flash accounting, Uniswap V2, Uniswap V3, WETH, and AVAIL. PoolManager source shows how take/sync/settle create and clear transient currency deltas, but the supplied evidence does not prove that this behavior violates a source-visible invariant.

Mechanism:

- The exploit entered through `0x00000002` before reaching the vulnerable accounting path.
- The artifacts prove a profitable transaction that routes through PoolManager flash accounting, Uniswap V2, Uniswap V3, WETH, and AVAIL.
- The accounting update violated the invariant: Not established; no supplied source, pseudocode, trace, or RPC evidence proves a failed protocol/accounting/authority/price/entitlement invariant.

Key evidence:

- PoC, forge build, forge test, and economic proof all passed.
- Identifies the transaction, callback sequence, PoolManager/AMM frames, and attacker ETH/WETH gains.
- Frontier shows no direct asset loss, state/accounting anomaly shape, and transfer/withdraw frames nested under PoolManager and AMM route frames.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x000000000004444c5dc75cb358380d2e3de08a90` | `PoolManager` | `candidate accounting contract; no vulnerable invariant proven` |
| `0x80f8143fa056a063aaeecec3323aa3426262ddb2` | `UniswapV3Pool` | `routed swap counterparty; repayment check source-visible` |
| `0x0d4a11d5eeaac28ec3f61d100daf4d40471f1852` | `UniswapV2Pair` | `routed swap counterparty; K check source-visible` |

## Limitations

- closed_world_no_top_negative_asset_delta
- no_source_or_pseudocode_evidence_of_failed_invariant
