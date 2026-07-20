# BarnBridge Incident Report

## Summary

- **Protocol**: BarnBridge
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xccdf085354c5e7112c6af2a68a330f42b74efe2e536cba2cb6ef3e68eda464ef`](https://etherscan.io/tx/0xccdf085354c5e7112c6af2a68a330f42b74efe2e536cba2cb6ef3e68eda464ef)
- **Block**: 25576194
- **Economic reproduction**: usd_pricing_unavailable — historical USD pricing was unavailable.
- **Elapsed analysis time**: 825.89s (825892 ms)
- **Detected at**: 2026-07-20T20:04:40+00:00
- **Original alert**: https://t.me/c/2360854548/3172

## Impact

- **Estimated loss**: $25019.00
- **Main affected assets**: unknown
- **Attacker gain reproduced**: unknown

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: No patchable vulnerable contract or branch is proven
- **In short**: The incident transaction is a zero-value calldata warning message to 0x71f12a5b0e60d2ff8a87fd34e7dcff3c10c914b0.
- **Severity**: `low`
- **Confidence**: `low`
- **Violated invariant**: Unknown; no enforceable invariant is evidenced by the supplied source, pseudocode, frame, state, RPC, or PoC artifacts.

The incident transaction is a zero-value calldata warning message to 0x71f12a5b0e60d2ff8a87fd34e7dcff3c10c914b0. RPC observations show that address had no runtime bytecode before or after the incident block and no EIP-1967 implementation, while the frontier and flow artifacts show no storage writes, logs, child calls, transfers, approvals, or balance deltas.

Mechanism:

- The exploit entered through `0x53454355 (unknown selector; calldata begins with ASCII 'SECU')` before reaching the vulnerable accounting path.
- The incident transaction is a zero-value calldata warning message to 0x71f12a5b0e60d2ff8a87fd34e7dcff3c10c914b0.
- The accounting update violated the invariant: Unknown; no enforceable invariant is evidenced by the supplied source, pseudocode, frame, state, RPC, or PoC artifacts.

Key evidence:

- The frontier reports no direct loss, no loss-enabling state change, no entitlement/accounting anomaly, no transfer-only signal, and one zero-value candidate call with no reads, writes, logs, child calls, or asset relevance.
- The verified PoC calls an empty attack() function with value 0 and declares no expected profit legs, so it does not evidence a vulnerable branch.
- PoC execution is marked pass, but attack_flow reports no economic legs were available.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x71f12a5b0e60d2ff8a87fd34e7dcff3c10c914b0` | `unknown` | `frontier candidate target with no runtime code observed` |

## Limitations

- the calldata warning alleges a BarnBridge controller/allowance issue, but the artifacts do not prove the controller lifecycle, allowance state, governance setup, or vulnerable branch.
- invalid_precondition: no storage slot, controller role, allowance table, prior writer, governance proposal/vote/queue operation, or prior setup state is decoded or evidenced.
