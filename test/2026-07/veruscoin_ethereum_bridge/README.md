# VerusCoin Ethereum Bridge Incident Report

## Summary

- **Protocol**: VerusCoin Ethereum Bridge
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0xa1f1e65c1cea4dba4ae439cd4dcdba6cc2dbda0ed1228e61f29ae9c9324eb099`](https://etherscan.io/tx/0xa1f1e65c1cea4dba4ae439cd4dcdba6cc2dbda0ed1228e61f29ae9c9324eb099)
- **Block**: 25592836
- **Economic reproduction**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Elapsed analysis time**: 982.29s (982294 ms)
- **Detected at**: 2026-07-23T04:21:18+00:00
- **Original alert**: https://x.com/exvulsec/status/2080146208455287196

## Impact

- **Estimated loss**: $7324473.52
- **Funds valued at**: 2026-07-23T03:45:47Z (price as of block N-1, pre-hack)
- **Main affected assets**: tBTC, ETH, USDC, scrvUSD, MKR
- **Attacker gain reproduced**: $7544791.41 (USD ratio: 1.030x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Verus bridge accepted a proven import that authorized multi-asset reserve payouts, but the upstream CCE authorization cause is outside the supplied artifacts
- **In short**: The Ethereum transaction calls the Verus bridge import path, not a standalone token approval or transfer bug.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: Ethereum bridge reserves may be released only for source-chain reserve transfers whose CCE creation, authorization, transfer hash, count, and economic backing are all proven under the expected bridge lifecycle.

The Ethereum transaction calls the Verus bridge import path, not a standalone token approval or transfer bug. SubmitImports._createImports validates a supplied CReserveTransferImport, then TokenManager.processTransactions consumes the accepted serializedTransfers and releases ETH/ERC20 assets or routes DAI through the DSR/DaiJoin exit path.

Mechanism:

- The exploit entered through `submitImports(((uint8,uint8,(uint8,(uint8,uint32,uint32,uint8,bytes32[]))[],(uint8,uint8,bytes,(uint8,(uint8,uint32,uint32,uint8,bytes32[]))[])[]),bytes)) -> _createImports(bytes)` before reaching the vulnerable accounting path.
- The Ethereum transaction calls the Verus bridge import path, not a standalone token approval or transfer bug.
- The accounting update violated the invariant: Ethereum bridge reserves may be released only for source-chain reserve transfers whose CCE creation, authorization, transfer hash, count, and economic backing are all proven under the expected bridge lifecycle.

Key evidence:

- PoC status, forge build, forge test, and economic reproduction all passed.
- Identifies the verified attack transaction, bridge target, attacker, and reproduced multi-asset losses.
- Frame 2 is the bridge delegatecall into selector 0x2babda4c, the _createImports(bytes) import path, with storage writes and child proof/payout calls.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x71518580f36feceffe0721f06ba4703218cd7f63` | `Verus bridge storage/proxy contract` | `primary affected bridge reserve holder` |
| `0x27c76df6912698e6d4c55aaa87cf88c30db90cf7` | `SubmitImports` | `import entrypoint implementation` |
| `0x54e03a1682fd0bb065b669f6296f97028dcfd4ce` | `VerusProof` | `import proof verifier` |
| `0xc45eedc99a98bc2e5ce717bb3ba16bde1725730a` | `TokenManager` | `accepted transfer payout processor` |

## Limitations

- tx_scope_gap: the decisive upstream Verus-side CCE creation/authorization lifecycle is outside the supplied Ethereum artifacts.
- closed-world evidence proves the Ethereum bridge accepted and processed the import, but does not prove why the source-chain CCE was valid or malicious.
