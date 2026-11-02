# EventCrowd — DBMS Level 3

Next.js crowd operations prototype using PostgreSQL for authoritative admissions and MongoDB for operational observation history. See [actual verification status](docs/PROJECT-STATUS.md); a supplied test is not a claim that it has run.

## Run locally

Requires Node 24+, Docker Compose, Git.

1. `npm ci`
2. Copy `.env.example` to `.env.local` and replace placeholders.
3. `docker compose up -d`
4. `node --env-file=.env.local scripts/setup.mjs`
5. `node --env-file=.env.local scripts/outbox-worker.mjs` (keep running)
6. `npm run dev` (Next.js loads `.env.local`)
7. Open http://localhost:3000/operations. Register an attendee and issue/download its QR. Sign in with the admin provisioned by setup in a separate browser profile. Scan the attendee QR using the camera or its decoded token.

`ADMIN_EMAIL` and `ADMIN_PASSWORD` provision the first admin only when that email does not yet exist. Use a unique email and a strong password of at least 14 characters. Registration always creates ATTENDEE; it cannot request elevated roles. Never commit actual environment files or QR bearer tokens.

## Demo sequence

- Attendee issues a ticket (one per event); QR is displayed once.
- Admin/security validates ENTRY. Repeating it with a new request key returns ALREADY_INSIDE. Repeating the same request key replays the existing result.
- EXIT closes the admission session. A single-entry ticket rejects reentry.
- Submit 7,900 simulated people in Main Stage (capacity 8,000). Worker stores current SQL summary and creates a CRITICAL alert. Lowering the reading resolves it. Old observations cannot overwrite newer state.
- Report an incident, record a response, and inspect audit/outbox history.
- Dashboard polls SQL every ten seconds; Operations refresh shows MongoDB aggregation over the last 24 hours.

## Verification

- `npm test`: static schema checks.
- `npm run test:integration`: executes schema and behavior checks in embedded PostgreSQL when TEST_DATABASE_URL is absent.
- Set TEST_DATABASE_URL to a **fresh disposable PostgreSQL database** to additionally test real concurrent entry/retry behavior. The test creates schema and data; never use an existing production database.
- `npm run build`: production compile and type check.
- `.github/workflows/ci.yml`: fresh PostgreSQL + MongoDB, integration tests, production build, and HTTP/worker smoke test.

## Railway deployment

Live app: https://eventcrowd-web-production.up.railway.app
Operations: https://eventcrowd-web-production.up.railway.app/operations
Project: https://railway.com/project/0b71a2e4-b1aa-4cbf-ae32-48f015e7c9b9

The current free-plan setup uses three services: Postgres, MongoDB, and eventcrowd-web. The web service supervises Next.js and the background worker together through `node scripts/start.mjs`. If either process exits unexpectedly, both are stopped so Railway can restart the service consistently. Startup applies versioned SQL migrations and idempotent MongoDB setup before accepting traffic.

The administrator account is `admin@eventcrowd.local`. Its generated password is stored only in eventcrowd-web's Railway Variables as ADMIN_PASSWORD. AUTH_SECRET and database credentials are also environment variables. Never copy them into the repository.

Service settings: Node 24, build `npm ci && npm run build`, start `node scripts/start.mjs`, PORT=3000, healthcheck `/api/health` with a 180-second startup window. DATABASE_URL and MONGODB_URI reference the private Postgres and MongoDB service variables; MONGODB_DB=eventcrowd. Only the web service has a public domain.

MongoDB's 500 MB demo volume requires a smaller index-build free-space reserve. Its start command is `docker-entrypoint.sh mongod --ipv6 --bind_ip ::,0.0.0.0 --setParameter diagnosticDataCollectionEnabled=false --setParameter indexBuildMinAvailableDiskSpaceMB=64`. This reserve is for the small academic dataset; monitor space before adding substantial data.

The deployment is pinned to commit fa1abfe0819b9d14b45f49b3707053efaa0bdcd1. Reconnect the source without a commit pin if automatic deployments from main are wanted. Railway service settings are authoritative; the legacy JSON configuration files are retained as references. A separate worker service can be used on a plan that permits more services, but is not provisioned here.

## Design and advanced DBMS concepts

27 normalized relational tables; keys, FK/CHECK/UNIQUE constraints; SQL transactions and ticket row locks; partial unique active-session index; idempotent request advisory lock; views; stored function; audit and ownership triggers; MongoDB aggregation; retry-safe transactional outbox.

- PostgreSQL owns tickets, users, roles, sessions, incidents, current summaries and alerts.
- MongoDB owns raw simulated observations; scan/incident event history is replicated using outbox UUIDs.
- No cross-database ACID claim: failed delivery retries idempotently. Unprocessed MongoDB observations survive worker restart.
- See db/schema.sql, db/integrity.sql, docs/advanced-queries.sql, docs/mongodb-aggregation.js and docs/architecture.md.

## Course completion checklist

Implemented architecture and operations go beyond CRUD. Before submission: run CI successfully, capture actual working UI/database screenshots, fill both team members' details, retain genuine individual commits, complete the official Word report, and demonstrate the live app. A report must distinguish observed test results from pending tests. Optional vector search is excluded from the core implementation.
