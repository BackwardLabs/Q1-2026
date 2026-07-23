# AFX Incident Report

## Summary

- **Protocol**: AFX
- **Chain**: arbitrum (chain_id=42161)
- **Tx hash**: [`0x50d0b3ec6c3f5fce0f10abf81540bbb508f421494aa2b3480c4a264b0436547b`](https://arbiscan.io/tx/0x50d0b3ec6c3f5fce0f10abf81540bbb508f421494aa2b3480c4a264b0436547b)
- **Block**: 486658838
- **Economic reproduction**: victim_loss_exact
- **Elapsed analysis time**: 773.21s (773209 ms)
- **Detected at**: 2026-07-22T23:59:09+00:00
- **Original alert**: https://x.com/blockaid_/status/2080080240265621680

## Impact

- **Estimated loss**: $24149578.51
- **Funds valued at**: 2026-07-22T21:30:25Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDC
- **Attacker gain reproduced**: $24149578.51 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Bridge finalization consumed pre-existing withdrawal and finalizer state to release 24.15M USDC
- **In short**: The vulnerable path is the `batchedFinalizeWithdrawals(bytes32[])` flow; it violated the value/accounting invariant below.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A bridge withdrawal payout must only execute when both the finalizer authority and the stored withdrawal entitlement are provenance-valid and bound to an authorized withdrawal lifecycle.

The incident transaction called Bridge.batchedFinalizeWithdrawals(bytes32[]) and passed checkFinalizer for EOA 0x5553ea7bda594ade7afe91d279779a42b2b84208. finalizeWithdrawal then consumed an already-created withdrawal record for message 0x558a989f405d706935fa15efee8eac6e32fbba7ea3f70dfd930c66436e7ed8c2 with destination 0x2f2974fabc54dba33442261211c06bd20e0fe...

Mechanism:

- The attacker reached the victim through the `batchedFinalizeWithdrawals(bytes32[])` flow during the exploit.
- The incident transaction called Bridge.batchedFinalizeWithdrawals(bytes32[]) and passed checkFinalizer for EOA 0x5553ea7bda594ade7afe91d279779a42b2b84208.
- The accounting update violated the invariant: A bridge withdrawal payout must only execute when both the finalizer authority and the stored withdrawal entitlement are provenance-valid and bound to an authorized withdrawal lifecycle.

Key evidence:

- PoC, build, test, and economic reproduction all passed.
- Attack flow identifies the transaction, bridge target, attacker, and exact 24.15M USDC victim-loss reproduction.
- Frame 1 is the bridge batchedFinalizeWithdrawals call from the EOA and contains the bridge storage reads/writes plus child USDC transfer call.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xcb3b9a3e5668afe84dc7a864b36b845dce062e67` | `Bridge` | `primary contract that finalized the withdrawal and held the lost USDC` |
| `0xaf88d065e77c8cc2239327c5edb3a432268e5831` | `FiatTokenProxy` | `USDC token proxy that executed the downstream transfer` |

## Limitations

- prior_state_provenance_gap: storage_writer_provenance.json is not_applicable, so the artifacts do not identify the writer transaction for finalizers[0x5553ea7bda594ade7afe91d279779a42b2b84208] or createdWithdrawals[0x558a989f405d706935fa15efee8eac6e32fbba7ea3f70dfd930c66436e7ed8c...
- tx_scope_gap: the current transaction finalizes and transfers; it does not create the withdrawal record or grant finalizer authority.
