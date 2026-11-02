# EventCrowd verification status — 2 November 2026

## Completed source
Next.js production application; attendee registration/login; four roles; one-time QR issuance/download; camera/manual scanner; transactional entry and exit; duplicate-entry and reentry checks; gate-to-zone access check; simulated crowd ingestion; durable MongoDB observation processing; threshold alerts; incident responses; SQL audit and incident/scanner outbox; MongoDB analytics; migrations; deployment configuration; CI.

27 SQL tables are implemented. The preliminary 28-table design's capacity_rules table is consolidated into event_zones.warning_pct and critical_pct. Vector search is optional and not implemented.

## Observed local verification
- Next.js 16.4.4 production build and TypeScript check: pass.
- Production dependency audit: zero known vulnerabilities at verification time.
- Three static schema checks: pass.
- Five database behavior checks plus parent test: pass using PGlite (embedded PostgreSQL): table/view creation, capacity constraint, event ownership, audit/outbox trigger, transaction rollback.
- Native PostgreSQL concurrent row-lock tests and full MongoDB/HTTP smoke tests are supplied in GitHub CI; they have NOT run in this environment.

## External status
- GitHub write access was restored on 2 November 2026. Source is being published to SharveshK1228/eventcrowd-dbms-level3; inspect GitHub Actions for the native PostgreSQL/MongoDB verification result.
- Separate Railway project created. No database services or application deployed. Automatic approval review rejected provisioning PostgreSQL and MongoDB due to charge risk and requested explicit hosting authorization.
- No live website URL exists.

## Scope limits
Academic prototype; simulated observations, no hardware accuracy claims. Zone estimates and confirmed entry count are separate metrics. Queue/device collections are modeled but queue recommendations, staff shift management screens, and semantic retrieval remain extensions. Roles are platform-wide; organizer tenancy/event-specific scoping remains future work. Admin is provisioned with environment variables; there is no public role escalation. No individual contribution history has been fabricated.
