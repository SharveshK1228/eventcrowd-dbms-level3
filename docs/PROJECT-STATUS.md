# EventCrowd verification status — 2 November 2026

## Completed source
Next.js production application; attendee registration/login; four roles; one-time QR issuance/download; camera/manual scanner; transactional entry and exit; duplicate-entry and reentry checks; gate-to-zone access check; simulated crowd ingestion; durable MongoDB observation processing; threshold alerts; incident responses; SQL audit and incident/scanner outbox; MongoDB analytics; migrations; deployment configuration; CI.

27 SQL tables are implemented. The preliminary 28-table design's capacity_rules table is consolidated into event_zones.warning_pct and critical_pct. Vector search is optional and not implemented.

## Observed local verification
- Next.js 16.4.4 production build and TypeScript check: pass.
- Production dependency audit: zero known vulnerabilities at verification time.
- Three static schema checks: pass.
- Five database behavior checks plus parent test: pass using PGlite (embedded PostgreSQL): table/view creation, capacity constraint, event ownership, audit/outbox trigger, transaction rollback.
- GitHub CI run 41480004274 passed with PostgreSQL 16 and MongoDB 7: concurrent scans, request replay and mismatch checks, exit/reentry rules, MongoDB validators/indexes, production build, HTTP authentication, ticket issuance, outbox delivery, crowd processing, threshold alert and analytics.
- Verified implementation commit: 9c38a9c4bb6da19f19f1e3eb938dc01cf8912caa.
- Evidence: https://github.com/SharveshK1228/eventcrowd-dbms-level3/actions/runs/41480004274

## External status
- All 51 project files are published on main at SharveshK1228/eventcrowd-dbms-level3. GitHub CI completed successfully.
- Separate Railway project created. No database services or application deployed. Automatic approval review rejected provisioning PostgreSQL and MongoDB due to charge risk and requested explicit hosting authorization.
- No live website URL exists.

## Scope limits
Academic prototype; simulated observations, no hardware accuracy claims. Zone estimates and confirmed entry count are separate metrics. Queue/device collections are modeled but queue recommendations, staff shift management screens, and semantic retrieval remain extensions. Roles are platform-wide; organizer tenancy/event-specific scoping remains future work. Admin is provisioned with environment variables; there is no public role escalation. No individual contribution history has been fabricated.
