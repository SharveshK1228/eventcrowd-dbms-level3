# EventCrowd — DBMS Level 3

Next.js crowd operations prototype using PostgreSQL for authoritative admissions and MongoDB for operational observation history. See [actual verification status](docs/PROJECT-STATUS.md); a supplied test is not a claim that it has run.

## Run locally

Requires Node 22+, Docker Compose, Git.

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

## Deploy to Railway

Create a dedicated project with official Postgres and MongoDB templates and persistent volumes. Connect this repository as web and worker services. Keep database services private.

Web variables: DATABASE_URL referencing Postgres.DATABASE_URL; MONGODB_URI referencing MongoDB.MONGO_URL; MONGODB_DB=eventcrowd; AUTH_SECRET (random 32+ characters); ADMIN_EMAIL; ADMIN_PASSWORD. Node version 22.

`railway.json` configures web migration, build, healthcheck and start. For the **worker**, override start with `npm run worker`, remove the HTTP healthcheck, and use the same database variables; run only after migrations finish. Do not expose a worker domain. Verify terminal SUCCESS and /api/health before claiming deployment.

No paid service is provisioned by these instructions automatically.

## Design and advanced DBMS concepts

27 normalized relational tables; keys, FK/CHECK/UNIQUE constraints; SQL transactions and ticket row locks; partial unique active-session index; idempotent request advisory lock; views; stored function; audit and ownership triggers; MongoDB aggregation; retry-safe transactional outbox.

- PostgreSQL owns tickets, users, roles, sessions, incidents, current summaries and alerts.
- MongoDB owns raw simulated observations; scan/incident event history is replicated using outbox UUIDs.
- No cross-database ACID claim: failed delivery retries idempotently. Unprocessed MongoDB observations survive worker restart.
- See db/schema.sql, db/integrity.sql, docs/advanced-queries.sql, docs/mongodb-aggregation.js and docs/architecture.md.

## Course completion checklist

Implemented architecture and operations go beyond CRUD. Before submission: run CI successfully, capture actual working UI/database screenshots, fill both team members' details, retain genuine individual commits, complete the official Word report, and demonstrate the live app. A report must distinguish observed test results from pending tests. Optional vector search is excluded from the core implementation.
