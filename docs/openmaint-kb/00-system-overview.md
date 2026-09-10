# 00 — System Overview

**Source:** Running API (`/system/status`), Docker container inspection, PostgreSQL, `docker-compose.yml`  
**Classification:** CMDBUILD PLATFORM + local Docker packaging by Itmicus

---

## Verified Versions

| Component | Version | Source |
|-----------|---------|--------|
| openMAINT | 2.4.2 | API `/system/status` → `version_full` |
| CMDBuild | 4.2.0 | API → `version` |
| Build commit | 8fa54c4/release/4.2.0 | API → `build_info` |
| Build date | 2026-03-26 | API → `build_info` |
| PostgreSQL | 17.11 (Alpine) | DB query: `SELECT version()` |
| PostGIS | 3.5 | Docker image `postgis/postgis:17-3.5-alpine` |
| Apache Tomcat | 11.0.13 | Deployment guide (verified from container) |
| JDK | Eclipse Adoptium JDK 21 (21.0.9+10-LTS) | API → `runtime` |
| Docker image (app) | `itmicus/cmdbuild:om-2.4.2-4.2.0` | docker-compose.yml |
| Docker image (DB) | `postgis/postgis:17-3.5-alpine` | docker-compose.yml |
| Docker image (admin) | `dpage/pgadmin4:9.10.0` | docker-compose.yml |
| Database dump | `demo.dump.xz` | `CMDBUILD_DUMP` env var |

---

## Container Architecture

```
Host (localhost only — all ports bound to 127.0.0.1)

┌──────────────────────────────────────────────────────────────────┐
│  openmaint_app                                                   │
│  itmicus/cmdbuild:om-2.4.2-4.2.0                                 │
│  Tomcat 11 / JDK 21 / openMAINT 2.4.2                           │
│  Host port: 127.0.0.1:8090 → Container: 8080                    │
│  CPU limit: 2 cores  Memory: 4–8 GB  JVM: -Xms3g -Xmx6g        │
│  Volume: tomcat (Tomcat application state)                       │
├──────────────────────────────────────────────────────────────────┤
│  openmaint_db                                                    │
│  postgis/postgis:17-3.5-alpine                                   │
│  PostgreSQL 17.11 + PostGIS 3.5                                  │
│  Host port: 127.0.0.1:5432                                       │
│  CPU limit: 2 cores  Memory: 2–4 GB                              │
│  Volume: db (PostgreSQL data)                                    │
├──────────────────────────────────────────────────────────────────┤
│  openmaint_pgadmin                                               │
│  dpage/pgadmin4:9.10.0                                           │
│  Host port: 127.0.0.1:5050 → Container: 80                      │
│  Memory: 256–512 MB                                              │
└──────────────────────────────────────────────────────────────────┘
         │                      │                   │
         └──────────── openmaint-net (bridge) ──────┘
```

---

## Access URLs

| Service | URL | Default credentials |
|---------|-----|-------------------|
| openMAINT web app | http://127.0.0.1:8090/cmdbuild/ui/ | admin / admin |
| CMDBuild REST API | http://127.0.0.1:8090/cmdbuild/services/rest/v3 | (token-based) |
| pgAdmin | http://127.0.0.1:5050 | admin@example.com / admin |
| PostgreSQL direct | 127.0.0.1:5432 | postgres / postgres |

Additional demo users:

| Username | Password | Role |
|----------|----------|------|
| demouser | demouser | Multi-group |
| guest | guest | Guest (read-only) |

---

## Environment Variables (Relevant)

| Variable | Value | Notes |
|----------|-------|-------|
| `CMDBUILD_DUMP` | `demo.dump.xz` | Database dump loaded on first start |
| `JAVA_OPTS` | `-Xmx6000m -Xms3000m` | JVM heap limits |
| `OPENMAINT_DB_USER` | `openmaint` | Application DB user |
| `OPENMAINT_DB_PASSWORD` | `[REDACTED — default: openmaint]` | ⚠ insecure default |
| `POSTGRES_USER` | `postgres` | PostgreSQL superuser |
| `POSTGRES_PASSWORD` | `[REDACTED — default: postgres]` | ⚠ insecure default |
| `POSTGRES_DB` | `openmaint` | Database name |
| `POSTGRES_HOST` | `openmaint_db` | Internal hostname |
| `POSTGRES_PORT` | `5432` | Standard PostgreSQL port |

---

## Enabled Modules (Verified from API)

| Module | Status | Source |
|--------|--------|--------|
| Workflow / BPMN engine | Enabled | API system status |
| GIS module | Enabled | 13 GIS attributes configured in `_GisAttribute` |
| BIM module | Enabled | 3 projects in `_BimProject` |
| DMS (document management) | Enabled, type: postgres | Configured via `cmdbuild.sh restws setconfig` |
| Email service | Configured (disabled by default) | `_Job` table — no email accounts in `_EmailAccount` |

---

## Database Structure

Database name: `openmaint`  
Schemas: `public` (main), `gis` (GIS geometry tables)

Key table categories in `public`:

| Pattern | Examples | Purpose |
|---------|---------|---------|
| Business class tables | `Building`, `Room`, `Asset`, `Supplier` | Persistent business data |
| History tables | `Building_history`, `Room_history` | Audit trail — immutable |
| Map tables | `Map_BuildingFloor`, `Map_RoomCI` | Domain relationship data |
| System tables (`_`) | `_ClassMetadata`, `_GisAttribute`, `_Menu`, `_Job` | Platform configuration |
| GIS tables (schema `gis`) | `Gis_Building_Position`, `Gis_Room_Area` | Geometry storage |

All business class tables inherit from `Class` (PostgreSQL table inheritance).

---

## Scheduled Jobs (from `_Job` table)

| Job code | Type | Description | Enabled |
|----------|------|-------------|---------|
| `PrevMaintAdvanceScheduler` | trigger | Preventive maintenance advance scheduler — runs daily at 06:00 UTC | **Yes** |
| `PrevMaintGeneratorScheduler` | trigger | Preventive maintenance generator — runs daily at 05:00 UTC | **Yes** |
| `MaintProcReplyEmailMgt` | emailService | Reply email management for maintenance processes | No |
| `AutomaticDWGImport` | etl | Automatic DWG/CAD drawing import — runs daily at 01:00 UTC | No |
| `_script_test` | script | Test script (development artifact) | No |

The two active PM schedulers handle automatic generation and advancement of preventive maintenance work orders.

---

## Security Observations

| Risk | Severity | Status |
|------|----------|--------|
| Default admin credentials (`admin`/`admin`) | HIGH | Accepted for local POC — must change before shared access |
| Default PostgreSQL superuser (`postgres`/`postgres`) | HIGH | Accepted for local POC |
| Default application DB user (`openmaint`/`openmaint`) | MEDIUM | Accepted for local POC |
| No TLS/HTTPS | HIGH | Acceptable for localhost only |
| All ports bound to `127.0.0.1` only | Low risk | Corrected from upstream compose — good |
| pgAdmin exposed on localhost | LOW | Acceptable for dev, remove in production |
| Unofficial Docker image publisher (Itmicus) | LOW | Documented; production should build from official SourceForge WAR |
| Apple Silicon amd64 emulation | Performance | Functional but not representative of production performance |
| No backup or DR configuration | HIGH | Not implemented in this POC |

---

## API Authentication

The CMDBuild REST API uses session tokens:

```
POST /services/rest/v3/sessions?scope=service&returnId=true
Content-Type: application/json
{"username":"admin","password":"admin"}
```

Response includes `_id` (session token). Pass as header:
```
CMDBuild-Authorization: <token>
```

Sessions expire; for scripted access use `scope=service` which creates a non-interactive session.

---

## openMAINT vs CMDBuild Relationship

openMAINT 2.4.2 is a CAFM vertical built on CMDBuild 4.2.0.  
The API version and platform functionality come entirely from CMDBuild.  
The data model, processes, menus, lookups, and reports are the openMAINT configuration layer.

See `01-openmaint-vs-cmdbuild.md` for the full distinction.
