# Uniswap V3 Incident Report

## Summary

- **Protocol**: Uniswap V3
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xb1a43313b51512b45fc5d921838a8a6427266f4326e5d82cde7cdbe02daa3349`](https://etherscan.io/tx/0xb1a43313b51512b45fc5d921838a8a6427266f4326e5d82cde7cdbe02daa3349)
- **Block**: 25467373
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 808.56s (808564 ms)
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

- **Finding**: Verified profit path, but no source-backed vulnerable branch is established
- **In short**: The artifacts prove a profitable sequence using PoolManager unlock/take/sync/settle, Uniswap v2 swap, Uniswap v3 swap, WETH withdraw, and AVAIL/WETH transfers.
- **Severity**: `medium`
- **Confidence**: `low`
- **Violated invariant**: Not established by supplied closed-world evidence.

The artifacts prove a profitable sequence using PoolManager unlock/take/sync/settle, Uniswap v2 swap, Uniswap v3 swap, WETH withdraw, and AVAIL/WETH transfers. They do not prove that any selected contract branch violated an invariant: PoolManager enforces transient settlement at unlock exit, Uniswap v3 verifies callback payment, Uniswap v2 enforces its adjus...

Mechanism:

- The exploit entered through `attacker selector 0x00000002 / fallback dispatch` before reaching the vulnerable accounting path.
- The artifacts prove a profitable sequence using PoolManager unlock/take/sync/settle, Uniswap v2 swap, Uniswap v3 swap, WETH withdraw, and AVAIL/WETH transfers.
- The accounting update violated the invariant: Not established by supplied closed-world evidence.

Key evidence:

- PoC status is pass.
- PoC verification gates passed and the reproduced economic effect records attacker ETH gain of 53.817927899908925564 ETH.
- PoC sequence uses PoolManager unlock/take/sync/settle, v2 swap, PoolManager swap, v3 swap callback, WETH settlement, and WETH withdraw.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x000000000004444c5dc75cb358380d2e3de08a90` | `PoolManager` | `candidate accounting and flash-settlement contract; no vulnerable branch proven` |
| `0x80f8143fa056a063aaeecec3323aa3426262ddb2` | `UniswapV3Pool` | `candidate AMM price/accounting contract; no vulnerable branch proven` |
| `0x0d4a11d5eeaac28ec3f61d100daf4d40471f1852` | `UniswapV2Pair` | `intermediate AMM pair used in path; no vulnerable branch proven` |

## Limitations

- No direct negative victim delta is present in the frontier for this transaction.
- The supplied artifacts do not establish a contract + function/branch + failed invariant + trigger + effect root cause.
