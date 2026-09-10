# 20 — Local POC Customizations

**Source:** Git history, docker-compose.yml comparison, deployment guide  
**Classification:** LOCAL POC

---

## Changes Made in This Deployment

### Docker Compose Changes

The following changes were made to `openmaint-2.4.2-4.2.0/docker-compose.yml` before starting:

| Change | Original | Modified | Reason |
|--------|----------|----------|--------|
| Application port binding | `8090:8080` | `127.0.0.1:8090:8080` | Security — localhost only |
| Database port binding | `5432:5432` | `127.0.0.1:5432:5432` | Security — localhost only |
| App container platform | Not specified | `platform: linux/amd64` | Apple Silicon compatibility |
| DB container platform | Not specified | `platform: linux/amd64` | Apple Silicon compatibility |

pgAdmin was already bound to `127.0.0.1:5050:80` in the upstream — not changed.

### DMS Configuration

After starting the containers, the following commands were run to configure document management:

```bash
docker exec openmaint_app /usr/local/tomcat/webapps/cmdbuild/cmdbuild.sh restws setconfig org.cmdbuild.dms.enabled false
docker exec openmaint_app /usr/local/tomcat/webapps/cmdbuild/cmdbuild.sh restws setconfig org.cmdbuild.dms.service.type postgres
docker exec openmaint_app /usr/local/tomcat/webapps/cmdbuild/cmdbuild.sh restws setconfig org.cmdbuild.dms.enabled true
```

This is documented in the upstream Itmicus repository README as a required post-deploy step. Classification: **REQUIRED CONFIGURATION** (not a custom change, but a setup step not in `demo.dump.xz`).

---

## Application Data Changes

**No application data was changed** during knowledge base discovery:
- No classes were added or modified
- No attributes were added or modified
- No domains were added or modified
- No lookup types or values were added or modified
- No users were created (beyond defaults in demo dump)
- No records were created, modified, or deleted
- All database operations during discovery were SELECT-only

---

## AJMN POC Test Records

At the time of this KB inspection (2026-09-10), no AJMN-specific test records were confirmed in the database. The only business data present is the standard openMAINT demo data from `demo.dump.xz`.

If AJMN test records are added (test buildings, rooms, assets, work orders), they should be:
1. Documented here with class name, Code, and Description
2. Classified as **LOCAL POC** or **DEMO DATA**
3. NOT confused with standard openMAINT configuration

---

## Known Upstream Repo Changes

The Attili-sys fork of `itmicus/cmdbuild_docker` has one commit beyond upstream:
- `29378af` — old versions moved to archive
- `530ee6a` — update
- `f126683` — add openmaint 2.4.2

The `openmaint-2.4.2-4.2.0/` directory contains the standard upstream configuration.

---

## Security Defaults Accepted for POC (Must Change for Production)

| Item | POC value | Action required |
|------|-----------|----------------|
| admin password | `admin` | Change immediately when sharing |
| postgres superuser password | `postgres` | Change before any shared use |
| Application DB password | `openmaint` | Change before any shared use |
| pgAdmin password | `admin` | Change or remove |
| TLS | None | Add reverse proxy with HTTPS |
