# Hinkal Protocol Incident Report

## Summary

- **Protocol**: Hinkal Protocol
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xbf7252af56be8867a12e27cc332f85e8f39e906756e559d6a076dc8bd9d50008`](https://etherscan.io/tx/0xbf7252af56be8867a12e27cc332f85e8f39e906756e559d6a076dc8bd9d50008)
- **Block**: 25448306
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 544.65s (544651 ms)
- **Detected at**: 2026-07-03T04:29:31+00:00
- **Original alert**: https://x.com/GoPlusZH/status/2072900522450026638

## Impact

- **Estimated loss**: $820000.00
- **Funds valued at**: 2026-07-03T00:07:11Z (price as of block N-1, pre-hack)
- **Main affected assets**: unknown
- **Attacker gain reproduced**: $24996.21 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Hinkal proofless deposits create commitments through an unimplemented validation hook
- **In short**: Hinkal.prooflessDeposit calls HinkalHelper.performProoflessDepositChecks but ignores its bool result, and the deployed helper's check body is unimplemented.
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: A proofless deposit must not create a spendable Hinkal commitment from caller-supplied token/amount/stealth metadata unless the helper validates that metadata and the deposit constraints.

Hinkal.prooflessDeposit calls HinkalHelper.performProoflessDepositChecks but ignores its bool result, and the deployed helper's check body is unimplemented. The delegated handleProoflessDeposit path then transfers caller-specified token amounts from msg.sender and creates UTXOs/commitments directly from caller-supplied token, amount, tokenId, and stealth-add...

Mechanism:

- The exploit entered through `prooflessDeposit(address[],uint256[],uint256[],(uint256,uint256,uint256,uint256)[]) / 0x0ed4a94e` before reaching the vulnerable accounting path.
- Hinkal.prooflessDeposit calls HinkalHelper.performProoflessDepositChecks but ignores its bool result, and the deployed helper's check body is unimplemented.
- The accounting update violated the invariant: A proofless deposit must not create a spendable Hinkal commitment from caller-supplied token/amount/stealth metadata unless the helper validates that metadata and the deposit constraints.

Key evidence:

- PoC result reports pass for status, forge build, forge test, and economic reproduction.
- Trace flow places prooflessDeposit as the root entry, helper check as frame 2, delegated handleProoflessDeposit as frame 3, and USDC balance/transfer frames under frame 3.
- PoC calls prooflessDeposit with USDC, amount 25000000000, tokenId 0, and one stealth address structure.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x25e5e82f5702a27c3466fe68f14abdbbadfca826` | `Hinkal` | `primary vulnerable contract` |
| `0xf498fa8b0c1328a22f5d3764dcab712728d12562` | `HinkalHelper` | `validation helper with empty proofless deposit check` |

## Limitations

- tx_scope_gap: the supplied transaction shows funded commitment creation, not a downstream withdrawal or realized third-party asset loss.
- The PoC economic proof treats the Hinkal contract balance increase as attacker-controlled gain, while closed-world asset deltas also show the transaction sender losing the same USDC amount.
