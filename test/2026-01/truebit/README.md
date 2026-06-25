# Truebit Incident Report

## Summary

- **Protocol**: Truebit
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xcd4755645595094a8ab984d0db7e3b4aabde72a5c87c4f176a030629c47fb014`](https://etherscan.io/tx/0xcd4755645595094a8ab984d0db7e3b4aabde72a5c87c4f176a030629c47fb014)
- **Block**: 24191019
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 674.36s (674364 ms)
- **Detected at**: 2026-01-08T00:00:00Z

## Impact

- **Estimated loss**: $26505216.79
- **Funds valued at**: 2026-01-08T16:02:23Z (price as of block N-1, pre-hack)
- **Main affected assets**: ETH
- **Attacker gain reproduced**: $26504906.26 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Truebit market buy-side pricing minted TRU below immediate redemption value
- **In short**: Attacker-controlled buyTRU/sellTRU cycles made sellTRU return more ETH than market accounting justified.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: For any positive TRU amount minted by buyTRU, the ETH paid must be at least the amount redeemable by an immediate sellTRU under the same market accounting.

The affected code path is the Truebit market's sell-side accounting: attacker-held TRU was converted into outsized ETH payouts from the market.

Mechanism:

- The attacker repeatedly executed the market buy/sell loop: `getPurchasePrice`, `buyTRU`, `approve`, then `sellTRU`.
- `buyTRU` created attacker-held TRU, then `sellTRU` reduced market accounting and sent ETH back to the attacker.
- The sell-side payout exceeded what the checked reserve/price accounting should have allowed, draining the market ETH balance.

Key evidence:

- The reproduction passed build, test, and economic validation.
- The attacker repeats getPurchasePrice, buyTRU, balanceOf, approve, and sellTRU across five trade cycles.
- buyTRU calls delegate to implementation 0xc186e6f0163e21be057e95aa135edd52508d14d3 and accept zero or tiny ETH values for very large requested TRU amounts.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x764c64b2a09b09acb100b80d8c505aa6a0302ef2` | `AdminUpgradeabilityProxy / Truebit market` | `primary vulnerable proxy and ETH holder` |
| `0xc186e6f0163e21be057e95aa135edd52508d14d3` | `unknown implementation` | `market buy/sell implementation` |

## Limitations

- implementation_source_for_0xc186e6f0163e21be057e95aa135edd52508d14d3_missing
- source_branch_evidence_gap
