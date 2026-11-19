# System Architecture

## Overview

The market terminal separates interaction, market-data delivery, simulation, and accounting. Each service has a narrow responsibility and an explicit failure mode.

| Boundary                 | Inputs                   | Outputs                 | Failure behavior               |
| ------------------------ | ------------------------ | ----------------------- | ------------------------------ |
| Client → Gateway         | asset and order queries  | normalized responses    | rate limit / request rejection |
| Gateway → Registry       | symbol or mint reference | validated metadata      | unrecognized asset             |
| Market Data → Client     | quotes, candles          | timestamped snapshots   | stale-data banner              |
| Order Simulator → Ledger | accepted simulated fills | debit/credit event pair | idempotent retry               |

## Domain primitives

- `Asset`: symbol, identifier, network label, listing state, verification flags.
- `Quote`: bid/ask, last, source timestamp, arrival timestamp, stale flag.
- `Order`: client order key, side, quantity, limit, lifecycle state.
- `LedgerEntry`: account, debit/credit, event ID, immutable sequence.
