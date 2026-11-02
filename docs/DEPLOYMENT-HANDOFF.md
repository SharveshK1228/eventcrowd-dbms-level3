# Deployment and administrator access

## Open the app

https://eventcrowd-web-production.up.railway.app/operations

Administrator email: `admin@eventcrowd.local`.
The generated administrator password is stored in Railway → eventcrowd-web → Variables → ADMIN_PASSWORD. It is not included in source code. AUTH_SECRET and database credentials are also private environment variables.

Railway service: https://railway.com/project/0b71a2e4-b1aa-4cbf-ae32-48f015e7c9b9/service/49f0758e-b8c4-4286-847d-7fb66be8af35?environmentId=b52b6c46-9734-40d9-8efc-0735140d2c72

Attendees can register normally. Public registration always creates ATTENDEE and cannot grant operational roles. Use separate browser profiles to demonstrate attendee and administrator sessions.

## Running architecture

Three services: Postgres, MongoDB, eventcrowd-web. The web service supervises Next.js and the worker together; there is no separate worker service. Both databases have persistent volumes and private networking. This fits the current free-plan service count; no upgrade was performed.

The web service starts with `node scripts/start.mjs`, which initializes the databases before launching web and worker processes. Refer to README.md for exact service settings and MongoDB's demo-volume disk reserve configuration. The app is pinned to the verified application commit. Reconnect the source without a commit pin if automatic deployment from main is wanted.

## Verification evidence

Railway application deployment cc629a60-2da0-4329-93c6-dc1b2f123d7b reached SUCCESS. Live authentication, ticket scanning, worker delivery, crowd alerts, analytics and incident response passed. See PROJECT-STATUS.md for details and the successful CI link.

## Operator checklist

- Open the dashboard and operations screens.
- Register a fresh attendee and save the one-time admission QR.
- Use an admin/security session to scan entry and exit.
- Submit a simulated crowd reading and observe automatic alerts.
- Report and resolve an incident.
- Capture actual screenshots for the course report and demonstrate both members' contributions honestly.
