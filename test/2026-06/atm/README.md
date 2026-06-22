# ATM Incident Report

## Summary

- **Protocol**: ATM
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0x5c27edc326e38641d8ce6093cd7f15ae5fca039f5fb988b7f10cb432e6e3a056`](https://bscscan.com/tx/0x5c27edc326e38641d8ce6093cd7f15ae5fca039f5fb988b7f10cb432e6e3a056)
- **Block**: 105692847
- **Economic reproduction**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Elapsed analysis time**: 483.31s (483307 ms)
- **Detected at**: 2026-06-22T09:45:24+00:00
- **Original alert**: https://x.com/TenArmorAlert/status/2068993748936151209

## Impact

- **Estimated loss**: $949900.00
- **Main affected assets**: unknown
- **Attacker gain reproduced**: unknown

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: No patchable root cause proven for standard Cake-LP transfer
- **In short**: The current transaction calls PancakePair/PancakeERC20 `transfer(address,uint256)` with the pair/token contract as recipient.
- **Severity**: `low`
- **Confidence**: `low`
- **Violated invariant**: Unproven: no supplied artifact shows a violated in-transaction protocol, accounting, authority, price, entitlement, payout, or transfer invariant.

The current transaction calls PancakePair/PancakeERC20 `transfer(address,uint256)` with the pair/token contract as recipient. The artifacts do not show a failed invariant, attacker-created entitlement, mint/supply expansion, reserve/accounting branch, approval transition, or prior transaction explaining why the EOA held that LP balance.

Mechanism:

- The exploit entered through `transfer(address,uint256)` before reaching the vulnerable accounting path.
- The current transaction calls PancakePair/PancakeERC20 `transfer(address,uint256)` with the pair/token contract as recipient.
- The accounting update violated the invariant: Unproven: no supplied artifact shows a violated in-transaction protocol, accounting, authority, price, entitlement, payout, or transfer invariant.

Key evidence:

- PoC status, execution status, economic status, forge build, and forge test are all reported as pass.
- Verified PoC invokes `transfer(pair, 400498341357466415661652)` from the attacker EOA context and notes unresolved internal storage-write semantic coverage.
- Frontier reports the Cake-LP positive delta but no candidate frames, no giant mint tokens, no authority anomalies, no state anomalies, empty frame_io, and no rpc_questions.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x9753a64fb7c233fdc43f04dab9cca88e1e229eba` | `PancakePair` | `current transaction target / LP token contract` |

## Limitations

- tx_scope_gap: the supplied transaction contains only the LP token transfer and does not include the event that created the sender's pre-existing LP balance.
- prior_state_provenance_gap: artifacts show the sender balance was consumed by transfer, but do not prove how that balance was obtained.
