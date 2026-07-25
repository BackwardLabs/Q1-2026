# Guru Fund Incident Report

## Summary

- **Protocol**: Guru Fund
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0x549839188e0c47db2643a0a4e1cc3943a29351a51d2e277ea1f3e908073c993d`](https://etherscan.io/tx/0x549839188e0c47db2643a0a4e1cc3943a29351a51d2e277ea1f3e908073c993d)
- **Block**: 25602279
- **Economic reproduction**: close — PoC reproduces the incident within the 80–110% net-loss band.
- **Elapsed analysis time**: 2201.64s (2201644 ms)
- **Detected at**: 2026-07-24T15:33:00Z
- **Original alert**: https://t.me/c/2360854548/3187

## Impact

- **Estimated loss**: $26038.37
- **Funds valued at**: 2026-07-24T11:23:59Z (price as of block N-1, pre-hack)
- **Main affected assets**: ONDO, HTS, DMTR, TOKEN, SMT
- **Attacker gain reproduced**: $28244.90 (USD ratio: 1.085x)
- **USD incomplete**: 2 unpriced leg(s); estimated loss is a lower bound

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: FundController deposit external calls leaked FundVault allowance authority to the attacker
- **In short**: FundController deposit delegated to a deposit implementation that processed user-supplied external adapter calls through FundVault's controller-only arbitrary call/delegatecall authority.
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A user-controlled deposit external-call path must not create third-party allowances or otherwise leave FundVault assets spendable by an untrusted depositor/attack child.

FundController deposit delegated to a deposit implementation that processed user-supplied external adapter calls through FundVault's controller-only arbitrary call/delegatecall authority. In the incident transaction, those adapter calls caused FundVault to approve the attack child for uint256.max over multiple vault assets, after which the attack child used ...

Mechanism:

- The exploit entered through `deposit(Deposit) / selector 0x0dced77b` before reaching the vulnerable accounting path.
- FundController deposit delegated to a deposit implementation that processed user-supplied external adapter calls through FundVault's controller-only arbitrary call/delegatecall authority.
- The accounting update violated the invariant: A user-controlled deposit external-call path must not create third-party allowances or otherwise leave FundVault assets spendable by an untrusted depositor/attack child.

Key evidence:

- PoC, forge build, forge test, and economic proof all pass.
- Attack flow shows Balancer flash loan, callback into the attack child, and FundVault asset losses across multiple tokens.
- PoC approves USDC to FundController, submits raw deposit calldata, then calls transferFrom from FundVault for multiple vault assets.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0xf9357a85e79c388c13fb83b237ff759675cc5977` | `FundController` | `primary vulnerable entrypoint` |
| `0x868847e1a5ca7489371184edc19594e2c5f2d8ee` | `FundVault` | `vault authority surface and asset holder` |
| `0x6b7fba419afe1fa90d6f5eb4c0af832ebd85d656` | `FundLedger/BOOST` | `fund ledger/share token affected by deposit` |

## Limitations

- the concrete delegated DepositController implementation and adapter selector 0xaf31c1fe source or semantic-CSIR branch are absent, so the exact vulnerable branch line cannot be cited.
- The PoC economics include a reliable=false incident-basis-quality note for holder-net USD comparison because the profit-token basis and victim token set differ, although forge and economic proof statuses pass.
