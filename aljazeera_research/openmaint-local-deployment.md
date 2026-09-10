# openMAINT 2.4.2 Local Deployment Guide

**Project:** Al Jazeera Media Network (AJMN) CAFM Evaluation  
**Platform:** openMAINT 2.4.2 on CMDBuild 4.2.0  
**Repository:** [Attili-sys/cmdbuild_docker](https://github.com/Attili-sys/cmdbuild_docker) (fork of [itmicus/cmdbuild_docker](https://github.com/itmicus/cmdbuild_docker))  
**Deployment type:** Local proof-of-concept (POC)  
**Date:** 8 September 2026  
**Environment:** macOS (Apple Silicon), Docker Desktop 29.5.3, Docker Compose v5.1.4

---

## 1. Purpose

This document records how the openMAINT web application was deployed locally for AJMN's CAFM evaluation. The objective was to stand up a working instance of openMAINT 2.4.2 on CMDBuild 4.2.0 with the demo database, verify that the application starts correctly, and provide access for functional assessment against AJMN requirements.

This deployment is intended for **local evaluation only**. It is not a production-ready configuration.

---

## 2. Platform Overview

| Component | Value |
|-----------|-------|
| Application | openMAINT 2.4.2 |
| Core engine | CMDBuild 4.2.0 |
| Application server | Apache Tomcat 11.0.13 (JDK 21) |
| Database | PostgreSQL 17 with PostGIS 3.5 |
| Database dump | `demo.dump.xz` (pre-populated demo data) |
| Docker image (app) | `itmicus/cmdbuild:om-2.4.2-4.2.0` |
| Docker image (DB) | `postgis/postgis:17-3.5-alpine` |
| Docker image (admin) | `dpage/pgadmin4:9.10.0` |

openMAINT is a preconfigured vertical application built on CMDBuild. CMDBuild provides the platform engine (data model, workflows, REST API, UI); openMAINT adds a facility-management data model, maintenance workflows, and CAFM-specific functionality.

---

## 3. Pre-Deployment Security Review

Before starting any containers, the repository and referenced images were reviewed for safety and legitimacy.

### 3.1 Repository Assessment

| Check | Result |
|-------|--------|
| Fork alignment with upstream | Commit `29378aff` matches upstream `itmicus/cmdbuild_docker` exactly |
| Suspicious scripts or commands | None identified (no reverse shells, miners, or unexpected network callbacks) |
| Privileged containers | Not used |
| Docker socket mounts | Not present |
| Host network mode | Not used |
| Application process user | `tomcat` (non-root) |
| Tomcat manager / host-manager | Removed in the application image |

### 3.2 Image Assessment

| Image | Digest / Notes |
|-------|----------------|
| `itmicus/cmdbuild:om-2.4.2-4.2.0` | `sha256:b6fbc9a072d3c5a70cd1eff65545c326a3cecd1b4364cdfb5f6db3106576ea92` |
| Image layers | Match the repository Dockerfile; built from official Tomcat 11 and Eclipse Temurin JDK 21 base images |
| Bundled JDBC driver | `postgresql-42.7.3.jar` — SHA-256 matches the official Maven Central artifact |
| Product version (verified in container) | `CMDBuild-Version: 4.2.0`, vertical `openMAINT 2.4.2` |

The official openMAINT 2.4.2 release exists on [SourceForge](https://sourceforge.net/projects/openmaint/files/2.4/Core%20updates/openmaint-2.4-4.2.0/) (published 27 March 2026). The Docker image is an unofficial community packaging by Itmicus, not an official Tecnoteca/PAT distribution.

### 3.3 Identified Risks (POC Context)

| Risk | Mitigation applied |
|------|-------------------|
| Default credentials (`admin`/`admin`, `postgres`/`postgres`) | Accepted for local POC; must be changed before any shared use |
| PostgreSQL and application exposed on all interfaces (original compose) | Bound to `127.0.0.1` only |
| No TLS | Acceptable for localhost POC only |
| Unofficial Docker image publisher | Documented; production should consider building from official SourceForge WAR |
| Apple Silicon requires amd64 emulation | `platform: linux/amd64` set on app and DB containers |

---

## 4. Changes Made for Safe Local Testing

The following changes were applied to `openmaint-2.4.2-4.2.0/docker-compose.yml` before deployment. No application functionality was modified.

| Change | Original | Modified |
|--------|----------|----------|
| Application port binding | `8090:8080` | `127.0.0.1:8090:8080` |
| Database port binding | `5432:5432` | `127.0.0.1:5432:5432` |
| App container platform | Not specified | `platform: linux/amd64` |
| DB container platform | Not specified | `platform: linux/amd64` |

pgAdmin was already bound to localhost (`127.0.0.1:5050:80`) in the upstream compose file.

Environment variables in `.env` were left at upstream defaults to allow immediate login during evaluation.

---

## 5. Deployment Steps

### 5.1 Prerequisites

- Docker Desktop installed and running
- Minimum ~12 GB RAM available (JVM configured for 3–6 GB heap; DB limited to 4 GB)
- Ports 8090, 5432, and 5050 available on localhost

### 5.2 Pull Images

```bash
docker pull itmicus/cmdbuild:om-2.4.2-4.2.0
docker pull --platform linux/amd64 postgis/postgis:17-3.5-alpine
docker pull dpage/pgadmin4:9.10.0
```

Note: The application and PostGIS images are amd64-only. On Apple Silicon Macs, Docker runs them under Rosetta/QEMU emulation.

### 5.3 Start the Stack

```bash
cd openmaint-2.4.2-4.2.0
docker compose up -d
```

First startup takes several minutes. The application container waits for PostgreSQL to become healthy, then runs `dbconfig create demo.dump.xz` to initialise the database.

### 5.4 Configure Document Management (Attachments)

After the application container is running, configure the document management system (DMS) to store attachments in PostgreSQL:

```bash
docker exec openmaint_app /usr/local/tomcat/webapps/cmdbuild/cmdbuild.sh restws setconfig org.cmdbuild.dms.enabled false
docker exec openmaint_app /usr/local/tomcat/webapps/cmdbuild/cmdbuild.sh restws setconfig org.cmdbuild.dms.service.type postgres
docker exec openmaint_app /usr/local/tomcat/webapps/cmdbuild/cmdbuild.sh restws setconfig org.cmdbuild.dms.enabled true
```

This step is documented in the upstream repository README and is required for attachment storage in the Docker environment.

---

## 6. Access Information

### 6.1 openMAINT Web Application

| Field | Value |
|-------|-------|
| URL | http://127.0.0.1:8090/cmdbuild/ui/ |
| Username | `admin` |
| Password | `admin` |
| Role | SuperUser |

Additional demo users (from upstream documentation):

| Username | Password | Role |
|----------|----------|------|
| `demouser` | `demouser` | Multi-group |
| `guest` | `guest` | Read-only |

### 6.2 pgAdmin (Database Administration)

| Field | Value |
|-------|-------|
| URL | http://127.0.0.1:5050 |
| Email | `admin@example.com` |
| Password | `admin` |

The PostgreSQL server is pre-configured in pgAdmin via Docker Compose configs.

### 6.3 PostgreSQL (Direct Connection)

| Field | Value |
|-------|-------|
| Host | `127.0.0.1` |
| Port | `5432` |
| Database | `openmaint` |
| Superuser | `postgres` / `postgres` |
| Application user | `openmaint` / `openmaint` |

---

## 7. Post-Deployment Verification

The following checks were performed after deployment and confirmed successful.

### 7.1 Container Health

All three containers reported healthy status:

| Container | Status |
|-----------|--------|
| `openmaint_app` | Healthy |
| `openmaint_db` | Healthy |
| `openmaint_pgadmin` | Healthy |

### 7.2 Application Status

| Check | Result |
|-------|--------|
| UI HTTP response | HTTP 200 at `/cmdbuild/ui/` |
| Boot status (REST API) | `READY` |
| REST login (`admin`) | Successful; role `SuperUser` |
| Product vertical | `openMAINT` version `2.4.2` |
| Instance name | `DEMO` |
| DMS service type | `postgres` (enabled) |
| Workflow engine | Enabled |
| GIS module | Enabled |

### 7.3 Demo Database Content

| Entity | Count (demo) |
|--------|-------------|
| Data classes | 209 |
| Workflow processes | 5 |
| Reports | 15 |
| Buildings | 5 |
| Sites | 140 |
| Floors | 25 |
| Rooms | 82 |
| Assets | 357 |
| Contracts | 7 |
| Suppliers | 6 |
| Teams | 15 |
| Maintenance SLAs | 6 |

Workflow processes present: `PreventiveMaint`, `CorrectiveMaint`, `MaintProcess`, `Activity`, `Process`.

Available user roles: `SuperUser`, `AdminOffice`, `MaintOffice`, `Requester`, `Supplier`, `Team`, `Guest`.

### 7.4 Known Non-Critical Issues

| Issue | Impact |
|-------|--------|
| Logback `NullPointerException` during first Tomcat startup | Application recovered; boot status `READY` |
| Early PostgreSQL log: `password authentication failed for user "openmaint"` | Expected before `dbconfig create` creates the application database role |
| amd64 emulation on Apple Silicon | Functional but slower than native; not representative of production performance |

---

## 8. Container Architecture

```
┌─────────────────────────────────────────────────────────┐
│  Host (localhost only)                                  │
│                                                         │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ openmaint_app│  │ openmaint_db │  │openmaint_    │  │
│  │ Tomcat 11    │──│ PostgreSQL 17│──│pgadmin       │  │
│  │ openMAINT    │  │ PostGIS 3.5  │  │ pgAdmin 4    │  │
│  │ :8090→8080   │  │ :5432        │  │ :5050→80     │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│         │                  │                            │
│         └──── openmaint-net (bridge) ────┘              │
│                                                         │
│  Volumes: db (PostgreSQL data), tomcat (Tomcat state)   │
└─────────────────────────────────────────────────────────┘
```

---

## 9. Stopping and Removing

To stop the stack without deleting data:

```bash
cd openmaint-2.4.2-4.2.0
docker compose down
```

To stop and remove volumes (resets the database):

```bash
docker compose down -v
```

---

## 10. Limitations of This Deployment

This POC deployment should not be used beyond local evaluation without addressing the following:

- Default credentials on all services
- No TLS/HTTPS
- No backup or disaster recovery configuration
- No high availability or clustering
- No mobile app push notification infrastructure
- No integration with BMS, ERP, HR, or other AJMN systems
- Unofficial Docker image (not built from official SourceForge WAR in this deployment)
- Resource limits may be insufficient for large-scale load testing
- pgAdmin included for convenience; should not be deployed in production environments

---

## 11. References

- Upstream repository: https://github.com/itmicus/cmdbuild_docker
- openMAINT product: https://www.openmaint.org
- CMDBuild platform: https://www.cmdbuild.org
- Official openMAINT 2.4.2 download: https://sourceforge.net/projects/openmaint/files/2.4/Core%20updates/openmaint-2.4-4.2.0/
- Docker Hub image: https://hub.docker.com/r/itmicus/cmdbuild/tags?name=om-2.4.2





notes:

Yep — that data is demo data, not yours. The Docker setup you used loads demo.dump.xz by default, and openMAINT officially ships a data model in two variants: with demo data and without data. So the buildings/assets/work orders you see were preloaded specifically so you can learn and test the system.