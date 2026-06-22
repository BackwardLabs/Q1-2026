# ATM Incident Report

## Summary

- **Protocol**: ATM
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0x5c27edc326e38641d8ce6093cd7f15ae5fca039f5fb988b7f10cb432e6e3a056`](https://bscscan.com/tx/0x5c27edc326e38641d8ce6093cd7f15ae5fca039f5fb988b7f10cb432e6e3a056)
- **Block**: 105692847
- **Economic reproduction**: unpriced — raw PoC proof passed, but USD comparison is incomplete.
- **Elapsed analysis time**: 516.69s (516691 ms)
- **Detected at**: 2026-06-22T09:45:24+00:00
- **Original alert**: https://x.com/TenArmorAlert/status/2068993748936151209

## Impact

- **Estimated loss**: $949900.00
- **Main affected assets**: unknown
- **Attacker gain reproduced**: unknown

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Root cause not determined: current transaction is an ordinary Cake-LP transfer
- **In short**: The current transaction calls PancakeERC20 transfer(address,uint256) on 0x9753a64fb7c233fdc43f04dab9cca88e1e229eba and executes the normal _transfer branch.
- **Severity**: `low`
- **Confidence**: `low`
- **Violated invariant**: Undetermined; no violated invariant is visible in the executed transfer branch.

The current transaction calls PancakeERC20 transfer(address,uint256) on 0x9753a64fb7c233fdc43f04dab9cca88e1e229eba and executes the normal _transfer branch. The branch debits the EOA's pre-existing balance and credits the contract address; no mint, approval bypass, oracle/accounting branch, or failed invariant is visible in the supplied current-transaction a...

Mechanism:

- The exploit entered through `transfer(address,uint256)` before reaching the vulnerable accounting path.
- The current transaction calls PancakeERC20 transfer(address,uint256) on 0x9753a64fb7c233fdc43f04dab9cca88e1e229eba and executes the normal _transfer branch.
- The accounting update violated the invariant: Undetermined; no violated invariant is visible in the executed transfer branch.

Key evidence:

- PoC verification passed and reproduced the observed Cake-LP balance effect.
- Foundry ran one test, passed it, and logged 400498341357466415661652 Cake-LP.
- Replay target is the Cake-LP/PancakePair address and the only listed PoC surface is transfer(address,uint256), selector 0xa9059cbb, frame 1.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x9753a64fb7c233fdc43f04dab9cca88e1e229eba` | `PancakePair` | `root target and Cake-LP token; not proven vulnerable root-cause contract` |

## Limitations

- tx_scope_gap: the supplied artifacts contain only the current transfer transaction and no earlier transaction that created the sender's Cake-LP balance.
- prior_state_provenance_gap: the EOA's pre-existing balance is consumed by the transfer, but its provenance and legitimacy are not established by source, frame, or RPC evidence.
