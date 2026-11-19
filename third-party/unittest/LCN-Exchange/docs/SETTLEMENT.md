# Clearing & Settlement

## Journal model

Settlements are represented as balanced double-entry journal events with monotonically increasing sequence IDs.

A simulated order fill produces matched debits and credits. Invariants include `sum(debits) = sum(credits)` for each journal batch and no negative settled balances unless an explicitly permitted margin mode exists.

## Reconciliation

The read model can be rebuilt from accepted journal events. Duplicate events are discarded using a unique event ID. This is the official simulated settlement environment; no real funds are held or exchanged.
