# DLMC Incident Report

## Summary

- **Protocol**: DLMC
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0x151025d3f0a782340a74d30ef33a5fad044b838e74437a803f0652e70c231306`](https://bscscan.com/tx/0x151025d3f0a782340a74d30ef33a5fad044b838e74437a803f0652e70c231306)
- **Block**: 106091607
- **Economic reproduction**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Elapsed analysis time**: 575.97s (575972 ms)
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

- **Finding**: DLMC buy rewards were converted at stale price and then repriced with contract-held minted supply excluded
- **In short**: DLMCToken buy(uint256) derives minted principal DLMC from attacker-controlled amountQuote and the old livePrice, mints that principal to address(this), then _distributeReferralBonusOnBuy converts a 5% USDT-denominated re...
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: Sellable DLMC reward entitlement must be priced against a denominator that includes the supply minted to create the entitlement, or the reward must remain capped to its original USDT-denominated value.

DLMCToken buy(uint256) derives minted principal DLMC from attacker-controlled amountQuote and the old livePrice, mints that principal to address(this), then _distributeReferralBonusOnBuy converts a 5% USDT-denominated referral bonus into DLMC at the same stale livePrice. _updatePrice then counts the new USDT reserve but subtracts the contract-held minted pri...

Mechanism:

- The exploit entered through `PancakePair.swap(uint256,uint256,address,bytes) callback into DLMCToken buy(uint256)/sell(uint256)` before reaching the vulnerable accounting path.
- That path trusted attacker-controlled state while performing protected accounting updates.
- The accounting update violated the invariant: Sellable DLMC reward entitlement must be priced against a denominator that includes the supply minted to create the entitlement, or the reward must remain capped to its original USDT-denominated value.

Key evidence:

- PoC status, forge build, forge test, and economic reproduction all passed.
- Places the flash swap callback, DLMC register/buy calls, livePrice/balance reads, sell call, repayment, and profit transfer in execution order.
- Verified PoC performs flash swap, two register/approve/buy sequences, sell of DLMC, repayment, and USDT profit transfer.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xf2ca2a3572b26ae7c479dc7ae36d922113b1bdf2` | `DLMCToken` | `primary vulnerable contract` |

## Limitations

- Analysis is limited to available evidence for this transaction; no external exploit reports or historical context were used.
