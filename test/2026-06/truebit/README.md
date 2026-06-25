# Truebit Incident Report

## Summary

- **Protocol**: Truebit
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xcd4755645595094a8ab984d0db7e3b4aabde72a5c87c4f176a030629c47fb014`](https://etherscan.io/tx/0xcd4755645595094a8ab984d0db7e3b4aabde72a5c87c4f176a030629c47fb014)
- **Block**: 24191019
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 710.75s (710745 ms)
- **Detected at**: 2026-06-25T13:07:18Z
- **Original alert**: https://github.com/BackwardLabs/report/tree/main/exports/lumoskit-555581b0312b492da5ea4a161b2ae63b78c96c9b-partial-20260616T111006Z/cases/004_truebit

## Impact

- **Estimated loss**: $26505216.79
- **Funds valued at**: 2026-01-08T16:02:23Z (price as of block N-1, pre-hack)
- **Main affected assets**: ETH
- **Attacker gain reproduced**: $26504937.32 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Truebit market buy pricing allowed fully redeemable TRU to be minted for zero or tiny ETH
- **In short**: Attacker-controlled buyTRU/sellTRU cycles made sellTRU return more ETH than market accounting justified.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: For every nonzero TRU mint, the required purchase payment must be at least the token amount's immediate reserve-backed redemption value and must not round to zero.

The affected code path is the Truebit market's sell-side accounting: attacker-held TRU was converted into outsized ETH payouts from the market.

Mechanism:

- The attacker repeatedly executed the market buy/sell loop: `getPurchasePrice`, `buyTRU`, `approve`, then `sellTRU`.
- `buyTRU` created attacker-held TRU, then `sellTRU` reduced market accounting and sent ETH back to the attacker.
- The sell-side payout exceeded what the checked reserve/price accounting should have allowed, draining the market ETH balance.

Key evidence:

- PoC reproduction is non-failing: status pass, forge build pass, forge test pass.
- PoC executes five cycles of getPurchasePrice, buyTRU, balanceOf, approve, and sellTRU.
- Market lost 8535453576519732789359 wei ETH and attacker EOA gained 8535348497836391626573 wei ETH.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x764c64b2a09b09acb100b80d8c505aa6a0302ef2` | `AdminUpgradeabilityProxy / Truebit market` | `primary vulnerable contract` |
| `0xf65b5c5104c4fafd4b709d9d60a185eae063276c` | `AdminUpgradeabilityProxy / TRU token` | `token minted and burned by market` |

## Limitations

- implementation Solidity source and source-level pseudocode for 0xc186e6f0163e21be057e95aa135edd52508d14d3 were not present under victim_sources, so the exact high-level purchase formula/source line could not be pinned down.
- The RCA is partial because the bytecode/trace proves the vulnerable pricing-check-to-mint branch, but not the precise Solidity arithmetic expression inside getPurchasePrice.
