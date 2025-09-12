# Architecture

- CDC from PostgreSQL via Debezium → Kafka → Flink for deduplication and aggregation.
- Sinks to S3 (parquet) and Postgres (balances).

## Trade-offs
- Pros: Exactly-once semantics, replayable pipeline, low ops overhead.
- Cons: Higher initial complexity vs batch.

## Metrics
- Reconciliation time: days → minutes
- Late data rate: < 0.1%

## Retrospective
- CDC schema discipline and idempotent sinks reduced incident rate.
