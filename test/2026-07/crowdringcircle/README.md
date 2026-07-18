# CrowdRingCircle Incident Report

## Summary

- **Protocol**: CrowdRingCircle
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0xeaef22325e02ac65a8e1f2e1a3a43f7b7ac8d2323ce6f698a90813e77017c834`](https://bscscan.com/tx/0xeaef22325e02ac65a8e1f2e1a3a43f7b7ac8d2323ce6f698a90813e77017c834)
- **Block**: 110301524
- **Economic reproduction**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Elapsed analysis time**: 1621.09s (1621091 ms)
- **Detected at**: 2026-07-17T01:18:39+00:00
- **Original alert**: https://x.com/TenArmorAlert/status/2077925916228120766

## Impact

- **Estimated loss**: $209650.34
- **Funds valued at**: 2026-07-16T09:44:27Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDT, BNB, 众环CRC
- **Attacker gain reproduced**: $201166.18 (USD ratio: 0.960x)
- **USD incomplete**: 1 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: CRC sell transfer burns and syncs AMM pair inventory before crediting input
- **In short**: CrowdRingCircle's `_update` sell branch burns tokens from the DEX pair's existing CRC balance and calls `sync()` before crediting the seller's incoming tokens.
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: A token transfer into an AMM pair must not debit or resynchronize the pair's pre-existing inventory as seller input before the incoming transfer is credited.

CrowdRingCircle's `_update` sell branch burns tokens from the DEX pair's existing CRC balance and calls `sync()` before crediting the seller's incoming tokens. A non-exempt transfer into a configured pair therefore treats LP inventory as burnable sell amount, collapses the CRC reserve, and lets subsequent router swaps execute against distorted balances.

Mechanism:

- The exploit entered through `CrowdRingCircle.transferFrom(address,address,uint256) -> _update(address,address,uint256)` before reaching the vulnerable accounting path.
- CrowdRingCircle's `_update` sell branch burns tokens from the DEX pair's existing CRC balance and calls `sync()` before crediting the seller's incoming tokens.
- The accounting update violated the invariant: A token transfer into an AMM pair must not debit or resynchronize the pair's pre-existing inventory as seller input before the incoming transfer is credited.

Key evidence:

- Foundry reproduction passes and records USDT profit of 201359472267252045095696 to the attacker EOA.
- Attack flow reports a passing economic proof and LP/Vault losses including the CRC/USDT LP loss.
- The sell branch deducts a fee, burns the post-fee amount from the pair, calls pair sync, then credits the incoming transfer; the helper burns min(requested amount, pair balance).

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x8581433150f2c48ff2efe5a22b17c7d405054509` | `CrowdRingCircle` | `primary vulnerable contract` |
| `0xd8799a644850c065388c22df4ee0c28472922526` | `PancakePair` | `impacted AMM pair` |

## Limitations

- Storage writer provenance for the Vault transient locker slot is partial and was not used for causal claims; the selected root cause does not depend on that slot.
- The top-level `profit_token` fields in `[internal artifact]` are null, so profit fields are taken from the verified profit observations in the same result and attack-flow artifacts.
