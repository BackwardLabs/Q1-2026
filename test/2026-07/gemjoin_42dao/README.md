# GemJoin / 42DAO Incident Report

## Summary

- **Protocol**: GemJoin / 42DAO
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0xe7abe6416e386332b41d63cf5f16903251dc178942cd79bf080fe61058587628`](https://bscscan.com/tx/0xe7abe6416e386332b41d63cf5f16903251dc178942cd79bf080fe61058587628)
- **Block**: 111351152
- **Economic reproduction**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Elapsed analysis time**: 1335.83s (1335827 ms)
- **Detected at**: 2026-07-22T01:13:42+00:00
- **Original alert**: https://x.com/TenArmorAlert/status/2079736611605274771

## Impact

- **Estimated loss**: $712488.04
- **Funds valued at**: 2026-07-21T21:00:01Z (price as of block N-1, pre-hack)
- **Main affected assets**: BTCB
- **Attacker gain reproduced**: $761337.23 (USD ratio: 1.069x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Inflated BTCB spot let Vat.frob accept unsafe debt minting and collateral withdrawal
- **In short**: The attacker refreshed the BTCB price/spot path and then called Vat.frob for the BTCB ilk.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A CDP debt mint or collateral withdrawal must be accepted only when the position remains safe under a trustworthy, fresh, manipulation-resistant collateral price.

The attacker refreshed the BTCB price/spot path and then called Vat.frob for the BTCB ilk. Vat.frob used the mutable ilk.spot operand in the solvency condition tab <= urn.ink * ilk.spot, so the inflated spot made collateral withdrawal and additional BLC debt minting appear safe.

Mechanism:

- The exploit entered through `0x0a7e6fe3` before reaching the vulnerable accounting path.
- The attacker refreshed the BTCB price/spot path and then called Vat.frob for the BTCB ilk.
- The accounting update violated the invariant: A CDP debt mint or collateral withdrawal must be accepted only when the position remains safe under a trustworthy, fresh, manipulation-resistant collateral price.

Key evidence:

- PoC build, execution, and economic reproduction all pass.
- Trace order shows oracle poke, Spotter poke, Vat frob, exits, approvals, and swap realization.
- Verified PoC calls the same oracle, Vat, join, approval, and swap sequence with observed calldata and amounts.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xfa7cea82f8a6254ccebad71350125aa6171b8a84` | `Vat` | `primary vulnerable accounting and solvency gate` |
| `0x849dc2416cbe54995a1d725afe526c0e38829228` | `unknown` | `spot updater that called Vat.file for BTCB` |
| `0x2f950d6c97d8813182c7ec2043f4f6deed956239` | `unknown` | `OSM-like oracle wrapper consumed by the spot path` |

## Limitations

- the supplied artifacts do not decode the ultimate oracle source/formula behind the 0x2f950d6c... peek() call, so the precise upstream price-manipulation formula is not proven.
- prior_state_provenance_gap: rpc_observations.json anchors OSM-like slots 2, 3, and 4 as consumed pre-state, but storage_writer_provenance.json is not_applicable and does not identify earlier writers or full slot semantics.
