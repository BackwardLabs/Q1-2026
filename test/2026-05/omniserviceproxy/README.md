# LumosKit Run Report — ethereum 0x31e56b47…27664a

_Deterministic final report assembled from existing LumosKit outputs; this finalize step does not call an agent._

## Case overview

- **Chain**: ethereum (chain_id=1)
- **Tx hash**: `0x31e56b4737649e0acdb0ebb4eca44d16aeca25f60c022cbde85f092bde27664a`
- **Block**: 25137572
- **Status**: `pass`
- **Elapsed**: 1086.27s (1086270 ms)
- **Finding**: Retryable bridge message state enabled an unbacked MAPO cross-chain mint

## Pipeline timing

- **Orchestrator wall time**: 565.71s (565707 ms)

- **Current stage-duration sum**: 1086.27s (1086270 ms)

| Stage | Artifact | Duration | Status |
|---|---|---:|---|
| `1` | `cefg` | 173.43s (173427 ms) | `success` |
| `2` | `localize` | 11 ms | `success` |
| `3` | `lift` | 28 ms | `success` |
| `4` | `flow_context` | 1.65s (1653 ms) | `success` |
| `5` | `enrich` | 2.17s (2166 ms) | `success` |
| `6` | `context_pack` | 2 ms | `success` |
| `7` | `asset_delta` | 22 ms | `success` |
| `8` | `poc_sketch` | 10 ms | `success` |
| `9` | `semantic` | 34 ms | `success` |
| `agent_poc` | `agent_poc` | 343.21s (343209 ms) | `success` |
| `rca` | `rca` | 565.71s (565708 ms) | `success` |

## Reproduction quality

- **PoC status**: `verified`
- **Forge build**: `pass`
- **Forge test**: `pass`
- **Proof kind**: `economic_proof`
- **RCA status**: `partial` / `partial`
- **RCA confidence**: `medium`

## Economic reproduction

- **Basis**: incident profit oracle usd
- **Verdict**: exact — PoC reproduces 99–101% of incident net loss.
- **Incident net loss**: unknown
- **PoC net reproduced**: $3053553500000.00
- **USD ratio**: 1.000x

## Attack narrative

_No standalone `attack_flow.md` was available; this section is assembled from RCA `attack_summary` fields._

| Field | Value |
|---|---|
| Entry function | retryMessageIn(uint256,bytes32,address,uint256,bytes,bytes,bytes) |
| Callback is root cause | false |

## Multi-leg reconciliation

_No asset legs were recorded._

## Root cause analysis

- **Title**: Retryable bridge message state enabled an unbacked MAPO cross-chain mint
- **Severity**: `critical`
- **Confidence**: `medium`
- **Violated invariant**: A retryable bridge message must be derived from an authenticated prior cross-chain message and must not allow caller-supplied retry payload fields to create an unbacked token mint.

### Final root cause

The observed transaction calls Bridge.retryMessageIn, which reconstructs a caller-supplied MessageInEvent and accepts it because a pre-existing orderList[_orderId] value matches the computed retry hash. It then forwards the message to MAPO mapoExecute; MAPO accepts the bridge as mos, accepts the trusted source-chain address, decodes INTERCHAIN_TRANSFER, and MORC20Token._createTokenTo mints the supplied amount to the attacker. The exact prior writer/provenance of the bridge stored-message hash is not present in the supplied artifacts, so the patchable cause is isolated to retry-state/message-provenance handling but not fully proven to originate in this transaction.

### Affected contracts

| Address | Name | Role | Implementation |
|---|---|---|---|
| `0x0000317bec33af037b5fab2028f52d14658f6a56` | `OmniServiceProxy / Bridge` | `primary retry-state consumer` | `0x92feada957bbeb17868f9f59aed548e50191283d` |
| `0x66d79b8f60ec93bfce0b56f5ac14a2714e509a99` | `MORC20PermitToken / MORC20Token` | `minted token reached by retry message` | `—` |

### Recommended fixes

- Bind retry records to authenticated message provenance and immutable stored fields, then replay the originally stored message rather than accepting caller-supplied retry fields that merely hash-match pre-existing state.
- Store structured retry data or a domain-separated hash that includes source verification context, target, amount, receiver, message type, and gas policy, and reject retries if any caller-supplied field differs.
- Consider enforcing the original retry gas limit in _transferIn for retries instead of forwarding all remaining gas when _gasleft=true.

### Limitations

- prior_state_provenance_gap: the artifacts do not include the prior transaction or source/state proof showing how orderList[_orderId] became the accepted retry hash.
- tx_scope_gap: this transaction consumes retryable bridge state and realizes the MAPO mint, but the decisive setup/authenticity failure appears to be prior state outside the supplied transaction.
- attack_flow.md was not present under artifacts/agent_poc/, so the PoC path is cited from PoC.t.sol and pseudocode instead.

## Artifacts

| Artifact | Bundle path | Status |
|---|---|---|
| Bundle index | `README.md` | generated |
| Machine run summary | `report/run_summary.json` | generated |
| Final integrated report | `report/REPORT.md` | generated |
| RCA | `report/RCA.md` | included |
| RCA structured report | `report/report.json` | included |
| PoC | `poc/PoC.t.sol` | included |
| PoC base support | `poc/LumosPoCBase.sol` | included |
| Asset deltas | `evidence/asset_deltas.json` | included |
| Fund flows | `evidence/fund_flows.json` | included |
| Asset delta graph | `visuals/asset_deltas.png` | included |
| Fund-flow graph | `visuals/fund_flows.png` | included |
