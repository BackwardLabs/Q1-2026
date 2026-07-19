# CrowdRingCircle Incident Report

## Summary

- **Protocol**: CrowdRingCircle
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0xeaef22325e02ac65a8e1f2e1a3a43f7b7ac8d2323ce6f698a90813e77017c834`](https://bscscan.com/tx/0xeaef22325e02ac65a8e1f2e1a3a43f7b7ac8d2323ce6f698a90813e77017c834)
- **Block**: 110301524
- **Economic reproduction**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Elapsed analysis time**: 3740.03s (3740028 ms)
- **Detected at**: 2026-07-17T01:18:39+00:00
- **Original alert**: https://x.com/TenArmorAlert/status/2077925916228120766

## Impact

- **Estimated loss**: $209650.34
- **Funds valued at**: 2026-07-16T09:44:27Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDT, BNB, 众环CRC
- **Attacker gain reproduced**: $201166.18 (USD ratio: 0.960x)
- **USD incomplete**: 1 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: CRC sell hook burns and syncs the AMM pair before swap accounting, corrupting reserves
- **In short**: CrowdRingCircle._update burns tokens from a DEX pair and calls pair.sync() during a transfer into that pair before crediting the incoming CRC.
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: An ERC20 transfer into an AMM pair must not mutate the pair's reserves or burn the pair's existing balance before the pair/router swap accounting computes input and enforces the constant-product check.

CrowdRingCircle._update burns tokens from a DEX pair and calls pair.sync() during a transfer into that pair before crediting the incoming CRC. When PancakeRouter later computes supporting-fee swap input and PancakePair enforces K, both consume the manipulated reserve baseline.

Mechanism:

- The exploit entered through `CREATE attack contract, then attack child selector 0x6c6fbfe6 and flash callbacks` before reaching the vulnerable accounting path.
- CrowdRingCircle._update burns tokens from a DEX pair and calls pair.sync() during a transfer into that pair before crediting the incoming CRC.
- The accounting update violated the invariant: An ERC20 transfer into an AMM pair must not mutate the pair's reserves or burn the pair's existing balance before the pair/router swap accounting computes input and enforces the constant-product check.

Key evidence:

- PoC and economic reproduction passed.
- Identifies the replayed BSC transaction, attacker, verification gate, and LP/USDT economic losses.
- Shows direct asset loss, no giant mint token, PancakePair losses, and attacker USDT gain.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x8581433150f2c48ff2efe5a22b17c7d405054509` | `CrowdRingCircle` | `primary vulnerable contract` |
| `0xd8799a644850c065388c22df4ee0c28472922526` | `PancakePair` | `victim AMM pair whose reserves were mutated` |

## Limitations

- The exact deployment/configuration history that set the CRC/USDT pair as a DEX pair was not reconstructed; this does not affect the selected in-transaction branch because the burn/sync branch execution is trace-evidenced.
- [internal artifact] did not resolve a prior writer for the queried Vault settle slot because the incident pre-block RPC value was zero and did not match the trace read value; no prior-writer or same-transaction writer claim is used in this RCA.
