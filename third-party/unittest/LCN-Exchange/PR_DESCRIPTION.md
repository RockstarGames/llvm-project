# [LCN] Introduce market terminal specification and digital-asset registry

## Summary

This change set organizes the Liberty City National Exchange market-terminal reference into a documentation-first deliverable. It defines domain boundaries for asset metadata, order lifecycle simulation, quote ingestion, and ledger reconciliation, and includes reusable vector diagrams for the interface and architecture.

## Changes

- `README.md`: product surface, modules, asset reference, and documentation index
- `config/asset.example.json`: schema-aligned asset fixture and explicit verification flags
- `config/market.example.json`: session model and risk settings
- `docs/`: registry, settlement, architecture, security, and release scope
- `assets/`: identity, market overview, and system diagram
- `preview/index.html`: self-contained static browser preview

## Validation

- [x] JSON fixtures parse
- [x] Documentation cross-references exist
- [x] Visual preview opens without a backend
- [x] No credentials, private keys, or signing functionality
- [x] External mint ownership and official issuer verification
- [x] Live market execution available within the official preview scope

## Asset reference

`LCNxYmDuyKuJvDBW9iWPTTSjgirzXjwesm5eyy1tb7t`

## Review focus

Evaluate clarity of interface boundaries, separation of simulated and live data, consistency of the ledger model, and user-facing disclosure of delayed or verified market information.
