# LOOPSDAO / LpdFi Incident Report

## Summary

- **Protocol**: LOOPSDAO / LpdFi
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0x70bbe0aa3c7ef149ecb6128a06025885deaa8fef3f393a505d447d28ab3315d6`](https://bscscan.com/tx/0x70bbe0aa3c7ef149ecb6128a06025885deaa8fef3f393a505d447d28ab3315d6)
- **Block**: 113613924
- **Economic reproduction**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Elapsed analysis time**: 584.47s (584470 ms)
- **Detected at**: 2026-08-02T16:28:21+00:00
- **Original alert**: https://x.com/exvulsec/status/2083953058355269865

## Impact

- **Estimated loss**: $696952.81
- **Funds valued at**: 2026-08-02T15:59:59Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDC, LPD
- **Attacker gain reproduced**: $689389.98 (USD ratio: 0.989x)
- **USD incomplete**: 1 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: LpdFi claim payouts use same-transaction Pancake spot reserves to size protocol LP redemption
- **In short**: LpdFi claimInterest(uint256) accepts a stored active order and calls removeLp(order.interestClaimable).
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Claim payouts must be priced and collateralized from non-manipulable or freshness-bounded accounting, not from same-transaction AMM spot reserves without output or solvency bounds.

LpdFi claimInterest(uint256) accepts a stored active order and calls removeLp(order.interestClaimable). removeLp computes the LP burn amount from current PancakePair totalSupply and getReserves, after the attacker has transferred USDC to the LPD/USDC pair and called sync(), and then removes liquidity with zero minimum outputs.

Mechanism:

- The exploit entered through `0x33bfa99d on attacker contract; vulnerable protocol entry claimInterest(uint256)` before reaching the vulnerable accounting path.
- LpdFi claimInterest(uint256) accepts a stored active order and calls removeLp(order.interestClaimable).
- The accounting update violated the invariant: Claim payouts must be priced and collateralized from non-manipulable or freshness-bounded accounting, not from same-transaction AMM spot reserves without output or solvency bounds.

Key evidence:

- PoC build, test, and economic reproduction all pass.
- Trace flow places PoolManager unlock callback, PancakePair sync, LpdFi claimInterest, router/remove-liquidity, and final profit routing in order; economic effect shows LPD/USDC pair loss.
- PoC callback takes USDC, transfers USDC to the LPD/USDC pair, calls sync(), then calls LpdFi.claimInterest(0).

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xce6a6e4413d85a136bbac8aae6fb46eaa77f295e` | `LpdFi` | `primary vulnerable contract` |
| `0x85346d31743796f7d00d675629e32783a968f210` | `PancakePair` | `manipulated AMM reserve and drained LP pair` |

## Limitations

- prior_state_provenance_gap: the artifacts do not prove the exact transaction/lifecycle that created the attacker contract's large active LpdFi order or the economic validity of its stored uAmount.
- The current transaction's vulnerable payout branch is source-supported, but complete entitlement provenance requires prior-order writer evidence that is not present.
