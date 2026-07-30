# SashimiSwap Incident Report

## Summary

- **Protocol**: SashimiSwap
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0x8a598a4b2fba9bd9e67fbefc3f3e86df405ea89202efc182257f57f212ba5935`](https://etherscan.io/tx/0x8a598a4b2fba9bd9e67fbefc3f3e86df405ea89202efc182257f57f212ba5935)
- **Block**: 25618503
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 1943.99s (1943986 ms)
- **Detected at**: 2026-07-29T15:10:38+00:00
- **Original alert**: https://t.me/c/2360854548/3199

## Impact

- **Estimated loss**: $1610.25
- **Funds valued at**: 2026-07-26T17:36:11Z (price as of block N-1, pre-hack)
- **Main affected assets**: SASHIMI, slETH
- **Attacker gain reproduced**: $948.12 (USD ratio: 1.000x)
- **USD incomplete**: 1 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Sashimi router swap output shortfall can withdraw investment vault WETH as AMM output
- **In short**: The vulnerable path is the `swapTokensForExactTokens(uint256,uint256,address[],address,uint256)` flow; it violated the value/accounting invariant below.
- **Severity**: `high`
- **Confidence**: `high`
- **Violated invariant**: Public AMM swap output must be paid from pair/router swap liquidity and must not trigger investment/vault withdrawals based on transient router balance shortage.

The Sashimi router's swap output path treats a local token/WETH balance shortfall as authority to call SashimiInvestment.withdrawWithReBalance. SashimiInvestment computes reserve needs from the router's transient token balance plus deposits[_token], then withdraws from SashimiLendingVaultProvider, which redeems slETH-backed WETH and sends it back to the cont...

Mechanism:

- The attacker reached the victim through the `swapTokensForExactTokens(uint256,uint256,address[],address,uint256)` flow during the exploit.
- The Sashimi router's swap output path treats a local token/WETH balance shortfall as authority to call SashimiInvestment.withdrawWithReBalance.
- The accounting update violated the invariant: Public AMM swap output must be paid from pair/router swap liquidity and must not trigger investment/vault withdrawals based on transient router balance shortage.

Key evidence:

- The replay artifact passed forge build/test and economic verification.
- Shows the flash-loan callback, slETH mint, market entry, slSASHIMI borrow, Sashimi router swaps, normal Uniswap monetization, and final WETH/slETH balances.
- Frontier marks the transaction as direct asset loss with entitlement/accounting anomaly and identifies borrow/swap/approval/transfer frames used for narrowing.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xe4fe6a45f354e845f954cddee6084603cedb9410` | `UniswapV2Router02` | `primary vulnerable router` |
| `0x3f966fa1c0606e19047ed72068d2857677e07ef4` | `SashimiInvestment` | `reserve controller that authorizes vault withdrawals for router shortfalls` |
| `0x7bc801a840a7c2c027f4e5e48bf618348b0bce2b` | `SashimiLendingVaultProvider` | `vault provider drained through redeemUnderlying and WETH transfer` |

## Limitations

- The SimplePriceOracle source was not present under victim_sources; oracle and health-check calls were visible through pseudocode, trace, and Comptroller source, and this gap does not affect the selected router/vault causal claim.
