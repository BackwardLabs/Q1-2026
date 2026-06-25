# DLMC Incident Report

## Summary

- **Protocol**: DLMC
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0x151025d3f0a782340a74d30ef33a5fad044b838e74437a803f0652e70c231306`](https://bscscan.com/tx/0x151025d3f0a782340a74d30ef33a5fad044b838e74437a803f0652e70c231306)
- **Block**: 106091607
- **Economic reproduction**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Elapsed analysis time**: 569.08s (569076 ms)
- **Detected at**: 2026-06-25T01:35:10+00:00
- **Original alert**: https://x.com/TenArmorAlert/status/2069957542109958498

## Impact

- **Estimated loss**: $222600.00
- **Funds valued at**: 2026-06-24T11:15:10Z (price as of block N-1, pre-hack)
- **Main affected assets**: unknown
- **Attacker gain reproduced**: unknown

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: DLMC buy/sell accounting allowed flash-funded entitlement redemption for excess USDT
- **In short**: The vulnerable path is the `buy(uint256)` flow; it violated the value/accounting invariant below.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: DLMC redemption value must be bounded by a correct reserve/price/share formula and must not let transient buy-side entitlement withdraw more USDT than its economically valid share.

The supported cause is in DLMC buy/sell accounting during the exploit transaction. The attacker used a Pancake callback to register affiliates, approve USDT, call DLMC buy(uint256) twice, and then call sell(uint256); the buy frames expanded DLMC totalSupply and balances, and the sell frame redeemed a smaller DLMC amount for a large USDT payout.

Mechanism:

- The attacker reached the victim through the `buy(uint256)` flow during the exploit.
- The supported cause is in DLMC buy/sell accounting during the exploit transaction.
- The accounting update violated the invariant: DLMC redemption value must be bounded by a correct reserve/price/share formula and must not let transient buy-side entitlement withdraw more USDT than its economically valid share.

Key evidence:

- PoC replay, build, test, and economic reproduction all pass.
- Trace flow enters Pancake callback, calls DLMC buy/sell path, and reports USDT and DLMC profit legs.
- PoC performs the swap callback, DLMC registrations, USDT approvals, two DLMC buys, DLMC sell, pair repayment, and USDT profit transfer.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xf2ca2a3572b26ae7c479dc7ae36d922113b1bdf2` | `DLMCToken` | `primary vulnerable contract` |

## Limitations

- DLMC source is absent from [internal artifact], so the exact vulnerable function body, helper formula, branch, and missing guard cannot be named.
- [internal artifact] reconstructs the outer call sequence but not the internal DLMC pricing, mint, affiliate, or redemption calculation.
