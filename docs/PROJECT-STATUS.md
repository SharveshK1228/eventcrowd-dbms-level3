# EventCrowd verified status — 2 November 2026

## Live deployment

- App: https://eventcrowd-web-production.up.railway.app
- Operations: https://eventcrowd-web-production.up.railway.app/operations
- Railway project: https://railway.com/project/0b71a2e4-b1aa-4cbf-ae32-48f015e7c9b9
- Running application commit: fa1abfe0819b9d14b45f49b3707053efaa0bdcd1.
- Successful web deployment: cc629a60-2da0-4329-93c6-dc1b2f123d7b.
- Postgres 18 and MongoDB 8 have persistent 500 MB volumes and no public ports. Web and worker share one Railway service to fit the three-service free-plan limit. No plan upgrade was performed.
- Startup executes SQL migrations and MongoDB validators/indexes before starting Next.js and the worker. Service build/start/healthcheck settings are configured directly in Railway.

## Observed live verification

Passed against the public HTTPS app, with a same-origin header:

- Both database connections healthy.
- Unauthenticated operational API access denied.
- Administrator login and seeded venue/event configuration.
- New attendee registration/login and QR ticket issuance.
- Accepted entry, replay with the same request key, rejection of duplicate entry, accepted exit.
- Simulated crowd observation queued and processed by the background worker.
- Automatic critical crowd alert and MongoDB scan/crowd analytics.
- Incident reporting and a response that resolves the incident.

Verification used clearly identified demo records. QR secrets and session cookies were not saved in the repository. The test attendee's admission session was closed, and the simulated population was restored to 4,500 after the threshold test.

## CI and local verification

- CI run 41497644787 passed for the deployed source: https://github.com/SharveshK1228/eventcrowd-dbms-level3/actions/runs/41497644787
- Native PostgreSQL tests cover constraints, event ownership, audit/outbox triggers, transaction rollback, simultaneous scans, request replay/mismatch, and exit/reentry rules.
- MongoDB initialization, production Next.js build, and HTTP/worker smoke tests passed in CI.
- Local production build/TypeScript, embedded PostgreSQL behavior tests, static schema checks, and production dependency audit passed. The audit found zero known vulnerabilities at verification time.

## Implemented scope

27 domain SQL tables plus an internal migration-history table; four roles; attendee authentication; QR issuance/download; camera/manual scanner; transactional admissions; gate-zone access; MongoDB event history; current crowd summaries; automatic alerts; incident reporting/responses; SQL audit; transactional outbox; aggregation analytics; deployment settings and CI.

The preliminary design's separate capacity_rules table is consolidated into event_zones thresholds. Vector search is optional and not implemented.

## Remaining course deliverables and extensions

The official Word report, authentic UI/database screenshots, team details and genuine individual contribution history still need to match the final submission. Do not present queue recommendations, staff shift screens, device authentication, hardware crowd measurement, vector search or event-specific organizer tenancy as implemented. Roles currently apply across the platform. Crowd observations in the demo are explicitly simulated and separate from confirmed attendance.
