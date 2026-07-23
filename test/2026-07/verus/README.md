# Verus Incident Report

## Summary

- **Protocol**: Verus
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0x8f21bd8f0fce72ac959caa93a9923d85f902dfc6eddac2785ac5bc49c3b28d8f`](https://etherscan.io/tx/0x8f21bd8f0fce72ac959caa93a9923d85f902dfc6eddac2785ac5bc49c3b28d8f)
- **Block**: 25592725
- **Economic reproduction**: usd_pricing_unavailable — historical USD pricing was unavailable.
- **Elapsed analysis time**: 1691.39s (1691389 ms)
- **Detected at**: 2026-07-23T17:16:14+00:00
- **Original alert**: https://x.com/BlockSecTeam/status/2080341230794522925

## Impact

- **Estimated loss**: unknown
- **Main affected assets**: unknown
- **Attacker gain reproduced**: unknown

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Attacker-submitted latest-data payload advanced bridge state through delegate validation
- **In short**: The vulnerable path is the `setLatestData(bytes,bytes32,uint32,bytes)` flow; it violated the value/accounting invariant below.
- **Severity**: `high`
- **Confidence**: `medium`
- **Violated invariant**: Bridge/latest-data state must only advance after a source-proven authorized and semantically valid predecessor, signer/quorum, and state-root linkage check; attacker-controlled payloads must not directly commit latest-state slots.

The incident transaction directly calls 0x71518580f36feceffe0721f06ba4703218cd7f63.setLatestData(bytes,bytes32,uint32,bytes) from attacker EOA 0xbda71b58cec0b1c20a8f87ccd52fa0679747855c. The call delegates through code 0x9ce91aa0f6d1d316a9535a36951143bc141318b8 and helper selector 0x24f2cf86 on code 0x95b8005c4d9fe80f0aee5b7adce53766080600fb, passes storage-...

Mechanism:

- The attacker reached the victim through the `setLatestData(bytes,bytes32,uint32,bytes)` flow during the exploit.
- The incident transaction directly calls 0x71518580f36feceffe0721f06ba4703218cd7f63.setLatestData(bytes,bytes32,uint32,bytes) from attacker EOA 0xbda71b58cec0b1c20a8f87ccd52fa0679747855c.
- The accounting update violated the invariant: Bridge/latest-data state must only advance after a source-proven authorized and semantically valid predecessor, signer/quorum, and state-root linkage check; attacker-controlled payloads must not directly commit latest-state slots.

Key evidence:

- PoC reproduction status, forge build, and forge test all passed.
- Verification passed for transaction 0x8f21bd8f0fce72ac959caa93a9923d85f902dfc6eddac2785ac5bc49c3b28d8f, with no available economic legs.
- The PoC pranks the attacker EOA and calls setLatestData on 0x71518580f36feceffe0721f06ba4703218cd7f63 with attacker-supplied bytes payloads.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x71518580f36feceffe0721f06ba4703218cd7f63` | `unknown` | `primary state-updated contract` |
| `0x95b8005c4d9fe80f0aee5b7adce53766080600fb` | `unknown` | `delegated helper with semantic CSIR evidence` |

## Limitations

- No verified victim source was available under [internal artifact].
- No semantic CSIR was supplied for the main frame-2 implementation code address 0x9ce91aa0f6d1d316a9535a36951143bc141318b8.
