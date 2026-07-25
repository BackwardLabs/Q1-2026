# FCOW Incident Report

## Summary

- **Protocol**: FCOW
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0x78a6463e1b74607d62aba5e834836f9b34d2df3993fbd9d120b15e4b71e5c601`](https://bscscan.com/tx/0x78a6463e1b74607d62aba5e834836f9b34d2df3993fbd9d120b15e4b71e5c601)
- **Block**: 110415810
- **Economic reproduction**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Elapsed analysis time**: 1256.79s (1256791 ms)

## Impact

- **Estimated loss**: $65190.15
- **Funds valued at**: 2026-07-17T00:01:48Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDT, FCOW
- **Attacker gain reproduced**: $61206.55 (USD ratio: 0.939x)
- **USD incomplete**: 1 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: FCOW transfer hook manipulates AMM balance accounting during router transfers
- **In short**: The vulnerable path is the `PancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens` flow; it violated the value/accounting invariant below.
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: AMM-facing FCOW transfers must preserve fresh, conserved, explicit pair input accounting and must not let hidden transfer-hook side effects create balance-derived LP or swap entitlement.

FCOW transferFrom(address,address,uint256) selector 0x23b872dd routes router-driven AMM transfers through an internal fee/swap-pair branch that performs balance splits and additional token side effects during the transfer. Attacker-created child contracts repeatedly trigger that branch through PancakeRouter, after which PancakePair trusts the resulting balan...

Mechanism:

- The attacker reached the victim through the `PancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens` flow during the exploit.
- FCOW transferFrom(address,address,uint256) selector 0x23b872dd routes router-driven AMM transfers through an internal fee/swap-pair branch that performs balance splits and additional token side effects during the transfe...
- The accounting update violated the invariant: AMM-facing FCOW transfers must preserve fresh, conserved, explicit pair input accounting and must not let hidden transfer-hook side effects create balance-derived LP or swap entitlement.

Key evidence:

- PoC artifact reports pass with forge build/test pass and economic proof pass.
- Shows attacker entry/callback flow, dynamic child contracts, and incident drain from the FCOW/USDT pair.
- Shows expected USDT/BNB profit, Moolah flash loan, repeated router interactions, and final profit routing.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xcf51963d55e6ec01d3bc9f55ecd537939a614468` | `FCOW` | `primary vulnerable token contract` |
| `0x4514ffcbbd1e28d76b38b50515d19fcbe81ecd0d` | `PancakePair` | `downstream affected AMM pair` |

## Limitations

- FCOW verified source is not present under victim_sources; the analysis relies on partial semantic CSIR and trace evidence.
- exact_internal_amount_formula_unresolved
