# Private MEV/Arb Bot Incident Report

## Summary

- **Protocol**: Private MEV/Arb Bot
- **Chain**: base (chain_id=8453)
- **Tx hash**: [`0xe831f3991132cbaffbb4a3738da7d1e254a6c02f0adce605a333229a61e27ad7`](https://basescan.org/tx/0xe831f3991132cbaffbb4a3738da7d1e254a6c02f0adce605a333229a61e27ad7)
- **Block**: 49304016
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 1857.08s (1857078 ms)
- **Detected at**: 2026-08-01T08:27:10+00:00
- **Original alert**: https://t.me/c/2360854548/3208

## Impact

- **Estimated loss**: $31580.73
- **Funds valued at**: 2026-07-30T07:42:57Z (price as of block N-1, pre-hack)
- **Main affected assets**: WETH
- **Attacker gain reproduced**: $31580.73 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Unrestricted token executor spent victim WETH allowance through caller-controlled transferFrom calldata
- **In short**: Contract 0xa31722ca2a32695280d0e7e325b3dd6d699fc170 selector 0x42be3129 is the controlling protocol frame for the WETH drain.
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: A contract able to spend third-party token allowances must restrict execution to authorized callers and approved token/from/to/amount/callData intents before making external token calls.

Contract 0xa31722ca2a32695280d0e7e325b3dd6d699fc170 selector 0x42be3129 is the controlling protocol frame for the WETH drain. Trace and PoC evidence show it was called by attacker-created child 0x797c889d8df4498640f018d7e5d5f0df5bea6dc8 with embedded WETH transferFrom calldata that pulled 16623029776956898128 WETH from victim 0x386218744a2053d949a1cafae0b7b4...

Mechanism:

- The exploit entered through `0x42be3129 (signature unresolved)` before reaching the vulnerable accounting path.
- Contract 0xa31722ca2a32695280d0e7e325b3dd6d699fc170 selector 0x42be3129 is the controlling protocol frame for the WETH drain.
- The accounting update violated the invariant: A contract able to spend third-party token allowances must restrict execution to authorized callers and approved token/from/to/amount/callData intents before making external token calls.

Key evidence:

- PoC status, forge build, forge test, and economic proof all passed for the incident transaction.
- Trace flow places attacker child frame 6 calling protocol frame 7, then WETH transfer frames, and records exact WETH loss.
- Frame 7 is the parent protocol call to 0xa317...c170 selector 0x42be3129; child frames transfer WETH from victim to the protocol, then to the attacker child and EOA.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xa31722ca2a32695280d0e7e325b3dd6d699fc170` | `unknown` | `primary vulnerable contract` |
| `0x4200000000000000000000000000000000000006` | `WETH9` | `asset token and downstream transfer primitive` |

## Limitations

- verified_source_missing_for_0xa31722ca2a32695280d0e7e325b3dd6d699fc170
- selector_0x42be3129_signature_unresolved
