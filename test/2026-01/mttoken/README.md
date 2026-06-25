# MTToken Incident Report

## Summary

- **Protocol**: MTToken
- **Chain**: arbitrum (chain_id=42161)
- **Tx hash**: [`0xe1e6aa5332deaf0fa0a3584113c17bedc906148730cbbc73efae16306121687b`](https://arbiscan.io/tx/0xe1e6aa5332deaf0fa0a3584113c17bedc906148730cbbc73efae16306121687b)
- **Block**: 419829771
- **Economic reproduction**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Elapsed analysis time**: 737.10s (737096 ms)
- **Detected at**: 2026-01-15T00:00:00Z

## Impact

- **Estimated loss**: $406220.61
- **Funds valued at**: 2026-01-10T08:30:35Z (price as of block N-1, pre-hack)
- **Main affected assets**: WETH, USDC
- **Attacker gain reproduced**: $395149.66 (USD ratio: 0.973x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: changePosition accepted an underbounded negative quote withdrawal after attacker-controlled position setup
- **In short**: The vulnerable path is the `changePosition(int256,int256,int256)` flow; it violated the value/accounting invariant below.
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: A negative quote/base withdrawal or position reduction must be capped by the caller's solvent, price-checked position entitlement and must not reduce pool reserves beyond valid equity.

The vulnerable pool proxy 0xf7ca7384cc6619866749955065f17bedd3ed80bc delegated changePosition(int256,int256,int256) to implementation 0x010659727ad7716c239e206acd3ebee0fdc9e207. The attacker used a flash-loan-funded sequence of helper position changes and then called changePosition(0, -894992852305, 0), which the pool accepted and which produced large pool a...

Mechanism:

- The attacker reached the victim through the `changePosition(int256,int256,int256)` flow during the exploit.
- The vulnerable pool proxy 0xf7ca7384cc6619866749955065f17bedd3ed80bc delegated changePosition(int256,int256,int256) to implementation 0x010659727ad7716c239e206acd3ebee0fdc9e207.
- The accounting update violated the invariant: A negative quote/base withdrawal or position reduction must be capped by the caller's solvent, price-checked position entitlement and must not reduce pool reserves beyond valid equity.

Key evidence:

- PoC status, execution, economic proof, forge build, and forge test all passed.
- Trace flow enters attacker executeOperation, helper openPosition/zeroPool, and final drain helper.
- Verified PoC performs the flash loan, position setup, approvals, and final changePosition(0, -894992852305, 0).

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xf7ca7384cc6619866749955065f17bedd3ed80bc` | `unknown` | `primary vulnerable pool/proxy storage contract` |
| `0x010659727ad7716c239e206acd3ebee0fdc9e207` | `unknown` | `primary vulnerable implementation` |

## Limitations

- Verified source or decompiled branch evidence for implementation 0x010659727ad7716c239e206acd3ebee0fdc9e207 was not supplied under [internal artifact] or pseudocode.
- Exact storage slot meanings in 0xf7ca7384cc6619866749955065f17bedd3ed80bc are unresolved; slots are cited only as large accounting writes.
