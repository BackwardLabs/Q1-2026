# Pro token Incident Report

## Summary

- **Protocol**: Pro token
- **Chain**: bsc (chain_id=56)
- **Tx hash**: [`0x4baf136bda10390fb657556c46a19c91b82c2a4c86a058884727c30a66449a50`](https://bscscan.com/tx/0x4baf136bda10390fb657556c46a19c91b82c2a4c86a058884727c30a66449a50)
- **Block**: 112658164
- **Economic reproduction**: position_delta_exact
- **Elapsed analysis time**: 2640.97s (2640965 ms)
- **Detected at**: 2026-07-29T01:36:56+00:00
- **Original alert**: https://x.com/TenArmorAlert/status/2082279173138358457

## Impact

- **Estimated loss**: $100000.00
- **Funds valued at**: 2026-07-28T16:29:17Z (price as of block N-1, pre-hack)
- **Main affected assets**: Pro
- **Attacker gain reproduced**: $229691.58 (USD ratio: 1.000x)
- **USD incomplete**: 1 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Public proxy exec() lets any caller sell proxy-held Pro through PancakeRouter
- **In short**: The vulnerable path is the `exec()` flow; it violated the value/accounting invariant below.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Only an authorized operator may spend or route the proxy's held Pro balance through PancakeRouter.

Proxy 0xc44f2accac20598a3f2b4d489a970fcf52a04a3c delegates exec() to implementation 0x7fba63d0c45f265c1bea3ed2e49f0691a9d9aa87. The exec() branch is public in semantic CSIR and performs allowance/approve, router quote, PancakeRouter swapExactTokensForTokensSupportingFeeOnTransferTokens, and receiver cursor mutation without a visible caller authorization gate...

Mechanism:

- The attacker reached the victim through the `exec()` flow during the exploit.
- Proxy 0xc44f2accac20598a3f2b4d489a970fcf52a04a3c delegates exec() to implementation 0x7fba63d0c45f265c1bea3ed2e49f0691a9d9aa87.
- The accounting update violated the invariant: Only an authorized operator may spend or route the proxy's held Pro balance through PancakeRouter.

Key evidence:

- PoC, Forge build/test, and economic proof all passed.
- Trace flow shows attacker entry repeatedly calling proxy exec()-related frames.
- Proxy exec frame calls PancakeRouter, which calls PancakePair swap frame 17.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xc44f2accac20598a3f2b4d489a970fcf52a04a3c` | `TransparentUpgradeableProxy` | `primary vulnerable proxy storage contract` |
| `0x7fba63d0c45f265c1bea3ed2e49f0691a9d9aa87` | `unknown implementation` | `primary vulnerable implementation code` |

## Limitations

- source_verification_gap: implementation 0x7fba63d0c45f265c1bea3ed2e49f0691a9d9aa87 has no verified Solidity source under victim_sources; semantic CSIR verification is partial, so analysis_status is partial.
- contradiction: complete status would conflict with the decompiler partial-verification limitation for the selected causal branch.
