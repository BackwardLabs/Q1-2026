# Lula Incident Report

## Summary

- **Protocol**: Lula
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0xa219ab9d57e520e5235b15a8801f4ebac8cc45551be0430ce4e49caea0411d7c`](https://bscscan.com/tx/0xa219ab9d57e520e5235b15a8801f4ebac8cc45551be0430ce4e49caea0411d7c)
- **Block**: 112655390
- **Economic reproduction**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Elapsed analysis time**: 3038.01s (3038008 ms)

## Impact

- **Estimated loss**: $591062.12
- **Funds valued at**: 2026-07-28T16:08:29Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDT, BNB, LULA
- **Attacker gain reproduced**: $577666.44 (USD ratio: 0.977x)
- **USD incomplete**: 1 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: LULA sell hook mutates the same AMM pair before crediting the outer sell input
- **In short**: In LULA._handleSell, the sell branch computes taxFee/lpFee/actual and calls _swapAndLiquify when amountLPFee reaches swapAtAmount before transferring actual to the Pancake pair.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A token sell hook must not swap or add liquidity against the same AMM pair before the outer sell transfer has credited the pair input.

In LULA._handleSell, the sell branch computes taxFee/lpFee/actual and calls _swapAndLiquify when amountLPFee reaches swapAtAmount before transferring actual to the Pancake pair. _swapAndLiquify performs same-route router swaps and addLiquidity while the outer router sell has not yet credited its input to the pair, violating the order invariant for fee-on-tra...

Mechanism:

- The exploit entered through `PancakeRouter.swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256,uint256,address[],address,uint256) -> LULA.transferFrom(address,address,uint256)` before reaching the vulnerable accounting path.
- In LULA._handleSell, the sell branch computes taxFee/lpFee/actual and calls _swapAndLiquify when amountLPFee reaches swapAtAmount before transferring actual to the Pancake pair.
- The accounting update violated the invariant: A token sell hook must not swap or add liquidity against the same AMM pair before the outer sell transfer has credited the pair input.

Key evidence:

- PoC build, test, and economic reproduction passed; observed attacker USDT gain and PancakePair USDT/LULA victim loss.
- Economic effect lists PancakePair USDT and LULA losses and attacker/profit-side gains.
- Frontier ties the LULA transfer path and PancakePair loss frames to the observed asset impact while showing approvals and transferFrom as path frames.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xf5d7029eb6751d170dcf0bb1c87af6f93d5a2e9a` | `LULA` | `primary vulnerable contract` |
| `0xf0b36389a12a28be1280c0ec2a4bbc76889d6a96` | `PancakePair` | `impacted AMM pair` |

## Limitations

- downstream reward/claim contracts that later reach PancakePair skim were not fully source-inspected in the supplied artifacts, so the complete end-to-end extraction chain is not claimed.
- The aBnbWBNB totalSupply increase is verified and its Pool/AToken mint amount path was inspected, but the supplied source evidence does not support selecting it as the direct LULA/USDT pair-loss cause.
