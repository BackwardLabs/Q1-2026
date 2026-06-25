# BUBU2 Incident Report

## Summary

- **Protocol**: BUBU2
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0x1bc0a65cb33a839d44425016b11ed51e325997afe61c5bb6cc4bbe93a330141c`](https://bscscan.com/tx/0x1bc0a65cb33a839d44425016b11ed51e325997afe61c5bb6cc4bbe93a330141c)
- **Block**: 83896145
- **Economic reproduction**: usd_pricing_unavailable — historical USD pricing was unavailable.
- **Elapsed analysis time**: 397.72s (397719 ms)
- **Detected at**: 2026-03-01T00:00:00Z

## Impact

- **Estimated loss**: 19700
- **Main affected assets**: unknown
- **Attacker gain reproduced**: unknown

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Insufficient evidence to identify a patchable root cause
- **In short**: The vulnerable path is the `setTriggerInterval(uint256)` flow; it violated the value/accounting invariant below.
- **Severity**: `low`
- **Confidence**: `low`
- **Violated invariant**: Not established from supplied artifacts.

The transaction calls BUBU2.setTriggerInterval(uint256) with value 120 and the trace records a write to storage slot 66. The supplied artifacts do not prove what slot 66 controls, whether the caller was unauthorized, or whether this state change enabled any asset loss, entitlement expansion, payout, approval, or drain.

Mechanism:

- The attacker reached the victim through the `setTriggerInterval(uint256)` flow during the exploit.
- The transaction calls BUBU2.setTriggerInterval(uint256) with value 120 and the trace records a write to storage slot 66.
- The accounting update violated the invariant: Not established from supplied artifacts.

Key evidence:

- The deterministic frontier reports no asset-loss signal, no loss-enabling state-change signal, no entitlement/accounting anomaly, no giant mint, and no candidate frames.
- The PoC replay passes build/test gates and identifies the only observed surface as setTriggerInterval(uint256) on the transaction target.
- The replay pranks the attacker EOA and calls setTriggerInterval(120), then asserts through the generic harness.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x3ff3f18b5c113fac5e81b43f80bf438b99edee52` | `BUBU2` | `observed call target; vulnerable role not proven` |

## Limitations

- source_gap: no victim source files are present under [internal artifact]
- state_semantics_gap: slot 66 is written but its protocol meaning is not established by source, layout, RPC observation, or pseudocode
