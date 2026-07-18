# bunker.finance Incident Report

## Summary

- **Protocol**: bunker.finance
- **Chain**: ethereum (chain_id=1)
- **Tx hash**: [`0x5b9dc05c2636da600a22d13d5a6a01de7ededfec0227df56a5ed1a61e007457a`](https://etherscan.io/tx/0x5b9dc05c2636da600a22d13d5a6a01de7ededfec0227df56a5ed1a61e007457a)
- **Block**: 25544680
- **Economic reproduction**: exact — PoC reproduces 99–101% of incident net loss.
- **Elapsed analysis time**: 1471.02s (1471015 ms)
- **Detected at**: 2026-07-17T07:18:26+00:00
- **Original alert**: https://t.me/c/2360854548/3160

## Impact

- **Estimated loss**: $1346.96
- **Funds valued at**: 2026-07-16T10:37:59Z (price as of block N-1, pre-hack)
- **Main affected assets**: USDC
- **Attacker gain reproduced**: $5624.25 (USD ratio: 1.000x)

## Reproduction

- **PoC status**: `verified`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`

## Root Cause

- **Finding**: Punk cNFT mint overcredits ERC721 collateral from caller-supplied amounts
- **In short**: The vulnerable path is the `CNft.mint(uint256[],uint256[]) with one Punk id and amount 32, followed by bETH/bUSDC borrow(uint256)` flow; it violated the value/accounting invariant below.
- **Severity**: `critical`
- **Confidence**: `high`
- **Violated invariant**: For ERC721-like Punk collateral, each unique escrowed Punk id may mint and count as at most one cNFT collateral unit.

The CNft Punk mint branch verified ownership and bought one CryptoPunk per token id, but it trusted caller-supplied amounts when crediting totalBalance and ERC1155 cNFT balances. Passing amount 32 for one Punk created 32 units of borrowable cNFT collateral.

Mechanism:

- The attacker reached the victim through the `CNft.mint(uint256[],uint256[]) with one Punk id and amount 32, followed by bETH/bUSDC borrow(uint256)` flow during the exploit.
- The CNft Punk mint branch verified ownership and bought one CryptoPunk per token id, but it trusted caller-supplied amounts when crediting totalBalance and ERC1155 cNFT balances.
- The accounting update violated the invariant: For ERC721-like Punk collateral, each unique escrowed Punk id may mint and count as at most one cNFT collateral unit.

Key evidence:

- PoC build, test, and economic reproduction all passed.
- Trace flow places cNFT mint, borrow, redeem, and settlement inside the flash-loan callback with attacker profit.
- PoC passes one Punk id with amount 32 to each CNft.mint, borrows bETH/bUSDC cash, and redeems only one unit to recover the Punk.

## Affected Contracts

| Address | Name | Role |
|---|---|---|
| `0x4d5cab5135271b4f73d5c2071f8a96d4ee5883d3` | `CNft` | `primary vulnerable contract` |
| `0x039a3aab5820d1293369ec93109c9e1929a5af9a` | `CNft` | `primary vulnerable contract` |
| `0x01a9d451b037d5f2556772d11991380d86810a83` | `Comptroller` | `risk calculation consumer of inflated cNFT totalBalance` |

## Limitations

- The concrete NftPriceOracle implementation source was not present in the inspected victim_sources; this does not affect the selected causal claim because the inspected Comptroller branch only consumes a nonzero NFT price after reading the inflated cNFT totalBalance.
- giant mint complete RCA requires the mint amount math/solver operation
