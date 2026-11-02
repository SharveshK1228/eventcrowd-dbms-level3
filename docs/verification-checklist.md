# Level 3 verification checklist

- [ ] Run PostgreSQL migrations and inspect `\dt` and `\d tickets`
- [ ] Apply MongoDB schema validators and indexes
- [ ] Register sample user and grant organizer/security role through trusted admin
- [ ] Test authorized/unauthorized APIs
- [ ] Exercise attendee ticket issuance UI and download QR
- [ ] Simultaneously scan same ticket; assert one accepted, one rejected
- [ ] Replay request with same idempotency key; assert same result
- [ ] Inspect outbox delivery and MongoDB scan event
- [x] Execute SQL schema and test incident audit/outbox triggers in embedded PostgreSQL
- [ ] Verify dashboards and take authentic screenshots
- [ ] Record `EXPLAIN ANALYZE` query plans with indexes
- [ ] Record named contributions by both team members
- [ ] Build and deploy; attach deployment URLs and screenshots

Embedded PostgreSQL tests passed locally. Native PostgreSQL concurrency and MongoDB/HTTP workflows await CI or a configured environment. See PROJECT-STATUS.md for observed results.
