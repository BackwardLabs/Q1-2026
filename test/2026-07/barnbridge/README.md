# BarnBridge Incident Report

## Summary

- **Protocol**: BarnBridge
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xd191fead1b9a2244f2837560f35d4fc865404914d229bfcb0172d1a7a9895afb`](https://etherscan.io/tx/0xd191fead1b9a2244f2837560f35d4fc865404914d229bfcb0172d1a7a9895afb)
- **Block**: 25535120
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 858.42s (858419 ms)
- **Detected at**: 2026-07-15T04:07:05.594Z
- **Original alert**: https://x.com/Phalcon_xyz/status/2077243530280587721

## Impact

- **Estimated loss**: $774824.10
- **Funds valued at**: 2026-07-15T02:39:35Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDC
- **Attacker gain reproduced**: $774824.10 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Prior governance-executed controller replacement let attacker-controlled code drain USDC through CompoundProvider._takeUnderlying
- **In short**: The vulnerable path is the `CompoundProvider._takeUnderlying(address,uint256)` flow; it violated the value/accounting invariant below.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: CompoundProvider.controller must not be changed to an attacker-controlled contract unless the complete governance proposal lifecycle authorizing that replacement is legitimate and verified.

The incident transaction itself is a drain path: attacker/helper 0x66c6f3...e5d0 calls CompoundProvider._takeUnderlying repeatedly, and the USDC transferFrom frames are downstream effects. The proven prior cause is transaction 0x2e28e0...2826 at block 25535097, where Governance.execute(14) called IController.yieldControllTo(attacker/helper), which called Com...

Mechanism:

- The attacker reached the victim through the `CompoundProvider._takeUnderlying(address,uint256)` flow during the exploit.
- The incident transaction itself is a drain path: attacker/helper 0x66c6f3...e5d0 calls CompoundProvider._takeUnderlying repeatedly, and the USDC transferFrom frames are downstream effects.
- The accounting update violated the invariant: CompoundProvider.controller must not be changed to an attacker-controlled contract unless the complete governance proposal lifecycle authorizing that replacement is legitimate and verified.

Key evidence:

- PoC build and test passed, reproducing the incident USDC profit amount exactly.
- Observed flow repeatedly enters provider 0xdaa037...8310 from attacker/helper 0x66c6f3...e5d0.
- Impact frontier shows attacker USDC gain and holder losses; frame 3 is _takeUnderlying and frame 7 is a downstream USDC transferFrom.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xdaa037f99d168b552c0c61b7fb64cf7819d78310` | `CompoundProvider` | `primary drained provider and controller slot consumer` |
| `0x41ab25709e0c3edf027f6099963fe9ad3ebab3a3` | `CompoundController` | `prior controller that yielded control through governance execution` |
| `0x4cae362d7f227e3d306f70ce4878e245563f3069` | `Governance` | `governance executor for proposal 14 in prior writer transaction` |

## Limitations

- proposal creation transaction, voting or power acquisition evidence, and proposal queue transaction for proposal 14 are not present in the closed-world artifacts.
- tx_scope_gap: the decisive controller replacement happened in prior transaction 0x2e28e0b1dda3fe40c2226d61f9726dc3174098c3332ec0ee8087d35f46a42826, not in the analyzed incident transaction.
