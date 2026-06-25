# OCA Incident Report

## Summary

- **Protocol**: OCA
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0xcd5979352d9b42ccb7780d5344fac08d1d46591a592ab284a588e2156cf44906`](https://bscscan.com/tx/0xcd5979352d9b42ccb7780d5344fac08d1d46591a592ab284a588e2156cf44906)
- **Block**: 81020478
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 668.67s (668671 ms)
- **Detected at**: 2026-02-14T00:00:00Z

## Impact

- **Estimated loss**: $422610.71
- **Funds valued at**: 2026-02-13T17:48:29Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDC, OCA
- **Attacker gain reproduced**: $422610.71 (USD ratio: 1.000x)
- **USD incomplete**: 1 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: OCA-triggered pair reserve sync lets attacker manipulate PancakePair swap accounting
- **In short**: The vulnerable path is the `PancakePair.swap(uint256,uint256,address,bytes)` flow; it violated the value/accounting invariant below.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: AMM reserves used to validate a swap must not be externally refreshed from attacker-manipulated in-flight token balances before the swap's final K check and settlement.

OCA token interactions call PancakePair.sync() during the same transaction as attacker-driven swap callbacks, causing the pair reserves to be refreshed from manipulated in-flight token balances before settlement. PancakePair.swap then uses the post-callback balance/reserve state for its adjusted constant-product check, so repeated swaps can be made to appear...

Mechanism:

- The attacker reached the victim through the `PancakePair.swap(uint256,uint256,address,bytes)` flow during the exploit.
- OCA token interactions call PancakePair.sync() during the same transaction as attacker-driven swap callbacks, causing the pair reserves to be refreshed from manipulated in-flight token balances before settlement.
- The accounting update violated the invariant: AMM reserves used to validate a swap must not be externally refreshed from attacker-manipulated in-flight token balances before the swap's final K check and settlement.

Key evidence:

- PoC is verified with passing build, test, and economic proof.
- Trace places Moolah flash-loan callback, attacker pair swaps, pair callbacks to the attacker, and callback token movements in order.
- Top-ranked direct attacker calls enter PancakePair.swap, write pair reserve storage, emit logs, and connect to pair OCA/USDC losses.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xe0dafd4592205067299a6ae269f68aa804f95419` | `OCA token` | `primary source-gapped token whose transfer-side behavior triggers pair sync` |
| `0x5779bf44cd518b05651ae38fcc066247cce21504` | `PancakePair` | `affected AMM pair whose reserves are synchronized and then drained` |

## Limitations

- verified OCA source or pseudocode for the exact transfer-side branch that calls PancakePair.sync() is absent from the closed-world artifacts.
- source_branch_gap: the trace proves OCA-called sync frames, but the patchable OCA function/branch and guard condition cannot be pinpointed.
