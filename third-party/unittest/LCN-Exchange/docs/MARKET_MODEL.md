# Market Structure

## Sessions

LCN tracks `preopen`, `open`, `halted`, and `closed` session states. The official static reference uses a deterministic simulation with official data controls.

## Order lifecycle

`created → validated → queued → partially_filled → filled`, with alternative terminal states `rejected`, `expired`, or `cancelled`.

All client order requests include an idempotency key and immutable client timestamp. The simulator emits replayable events for UI testing.

## Data quality

Quotes carry source timestamps. Clients must show delayed or stale indicators when source data exceeds the configured threshold.
