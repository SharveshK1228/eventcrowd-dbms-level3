# Remaining external actions

## GitHub source and verification
GitHub write access was restored on 2 November 2026. The project source and GitHub Actions workflow are being published to:
https://github.com/SharveshK1228/eventcrowd-dbms-level3

Check the Actions tab for native PostgreSQL concurrency and MongoDB/HTTP smoke-test results. Local embedded PostgreSQL results alone do not verify those workflows.

## Railway authorization
A dedicated empty project was created:
https://railway.com/project/0b71a2e4-b1aa-4cbf-ae32-48f015e7c9b9

Automatic approval review rejected PostgreSQL/MongoDB provisioning because persistent hosting may incur charges and it did not accept the deployment authorization in the supplied conversation. Explicit user confirmation is required before retrying. Do not route around the rejection using a different service creation method.

Once authorized: provision the two persistent databases, connect web and worker services to the repository, configure secret reference variables, run migrations, verify health and smoke tests, and observe terminal deployment SUCCESS before presenting a live URL. The empty project is not a deployed application.
