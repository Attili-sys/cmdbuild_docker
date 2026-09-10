# openMAINT 2.4.2 Knowledge Base

**Purpose:** Verified technical and operational knowledge base for AJMN CAFM evaluation.  
**Inspection date:** 2026-09-10  
**Inspected by:** Claude Code (automated discovery against live system)

---

## Versions Inspected

| Component | Version |
|-----------|---------|
| openMAINT | 2.4.2 |
| CMDBuild | 4.2.0 |
| Build | 8fa54c4/release/4.2.0 (2026-03-26T19:23:58Z) |
| PostgreSQL | 17.11 |
| PostGIS | 3.5 |
| Apache Tomcat | 11.0.13 |
| JDK | Eclipse Adoptium 21.0.9+10-LTS |
| Docker image (app) | `itmicus/cmdbuild:om-2.4.2-4.2.0` |
| Database dump | `demo.dump.xz` (official openMAINT demo data) |

---

## Purpose

This KB makes it possible for future developers or AI agents to work with this exact openMAINT environment without re-discovering how the system works. It documents:

- What standard openMAINT 2.4.2 provides out of the box
- How it is configured (classes, attributes, domains, lookups, processes, roles, menus, reports)
- How the web application is operated (UI playbook)
- What can be configured without code vs what requires development or integration
- How AJMN CAFM requirements map against what openMAINT provides

---

## Environment

- Local Docker POC on macOS (Apple Silicon, amd64 emulation)
- Application: http://127.0.0.1:8090/cmdbuild/ui/
- API base: http://127.0.0.1:8090/cmdbuild/services/rest/v3
- pgAdmin: http://127.0.0.1:5050
- Credentials: admin/admin (SuperUser) — **default, insecure, POC only**

---

## Methodology

**Evidence hierarchy (highest to lowest):**

1. Running CMDBuild REST API (`/classes`, `/domains`, `/lookup_types`, `/processes`, `/roles`, `/reports`, `/dashboards`)
2. Running PostgreSQL database — read-only queries to `openmaint` database
3. Running web application — UI navigation and verification
4. Local Docker configuration files
5. Official CMDBuild/openMAINT documentation and forum

All claims cite their source. Unverified claims are marked `INFERENCE` or `NOT CONFIRMED`.

**Baseline comparison:** A separate baseline container was not spun up. Standard/demo/local classification uses:
- The `demo.dump.xz` database dump is the official openMAINT demo distribution
- No custom classes, attributes, or lookups were added in this POC beyond the dump
- One AJMN POC customization exists in `Building.Coordinates` text field usage and potential AJMN test records — see `20-local-poc-customizations.md`

---

## Classification Rules

Every item is classified as:

| Label | Meaning |
|-------|---------|
| **CMDBUILD PLATFORM** | Generic CMDBuild functionality, present in any CMDBuild deployment |
| **STANDARD OPENMAINT** | Configuration shipped as part of openMAINT 2.4.2 |
| **DEMO DATA** | Sample business records in `demo.dump.xz` — not product configuration |
| **LOCAL POC** | Anything added/changed after deployment by the AJMN team |
| **NOT CONFIRMED** | Evidence insufficient to confirm |

---

## Summary Counts (from live API + DB)

| Item | Count |
|------|-------|
| Classes | 209 |
| Attributes (across all classes) | 6,105 |
| Domains | 108 |
| Lookup types | 112 |
| Lookup values | 2,025 |
| Process classes | 5 |
| Reports | 15 |
| Dashboards | 4 |
| Roles | 7 |
| GIS-enabled classes | 13 |
| BIM projects (demo) | 3 |
| Scheduled jobs | 5 |

---

## Document Index

| File | Contents |
|------|---------|
| [00-system-overview.md](00-system-overview.md) | Environment, containers, versions, security |
| [01-openmaint-vs-cmdbuild.md](01-openmaint-vs-cmdbuild.md) | Platform vs vertical distinction |
| [02-data-model.md](02-data-model.md) | Full class hierarchy tree |
| [03-classes-and-attributes.md](03-classes-and-attributes.md) | Class inventory with key attributes |
| [04-domains-and-relations.md](04-domains-and-relations.md) | All 108 domains and relationship map |
| [05-lookups.md](05-lookups.md) | All 112 lookup types with values |
| [06-facilities-and-assets.md](06-facilities-and-assets.md) | Site/Building/Floor/Room/Asset model |
| [07-maintenance-model.md](07-maintenance-model.md) | Preventive and corrective maintenance |
| [08-processes-and-workflows.md](08-processes-and-workflows.md) | Process classes and workflow states |
| [09-inventory-and-logistics.md](09-inventory-and-logistics.md) | Consumables, warehouses, stock movements |
| [10-vendors-contracts-financial.md](10-vendors-contracts-financial.md) | Suppliers, contracts, budget, costs |
| [11-gis.md](11-gis.md) | GIS configuration and enabled classes |
| [12-bim.md](12-bim.md) | BIM/IFC configuration |
| [13-users-roles-permissions.md](13-users-roles-permissions.md) | 7 roles and permission model |
| [14-menus-reports-dashboards.md](14-menus-reports-dashboards.md) | Navigation menu, 15 reports, 4 dashboards |
| [15-energy-management.md](15-energy-management.md) | Meter, readings, energy carrier classes |
| [16-api-and-integrations.md](16-api-and-integrations.md) | REST API, authentication, integration patterns |
| [17-customization-guide.md](17-customization-guide.md) | No-code → custom dev classification |
| [18-ajmn-fit-gap.md](18-ajmn-fit-gap.md) | Full AJMN requirements fit-gap analysis |
| [19-ui-operator-playbook.md](19-ui-operator-playbook.md) | How to navigate and operate the UI |
| [20-local-poc-customizations.md](20-local-poc-customizations.md) | Changes made in this POC |
| [21-known-unknowns.md](21-known-unknowns.md) | Items not confidently established |

---

## Raw Machine-Readable Metadata

Located in `raw/`:

| File | Contents |
|------|---------|
| `environment.json` | System versions, containers, URLs, counts |
| `classes.json` | All 209 classes from API |
| `attributes.json` | All 6,105 attributes by class |
| `domains.json` | All 108 domains |
| `lookup-types.json` | All 112 lookup types |
| `lookup-values.json` | All 2,025 lookup values by type |
| `processes.json` | All 5 process classes |
| `process-details.json` | Process activity details |
| `roles.json` | All 7 roles |
| `role-details.json` | Role privilege details |
| `reports.json` | All 15 reports |
| `dashboards.json` | All 4 dashboards |
| `dashboard-details.json` | Dashboard configuration |
| `system-status.json` | Live system status |
| `gis-layers.json` | GIS layer configuration |
| `gis-geoservers.json` | GIS geoserver configuration |
| `class-hierarchy-db.txt` | PostgreSQL inheritance tree (224 rows) |
| `gis-attributes-db.txt` | GIS attributes from `_GisAttribute` table |

---

## How Future Agents Should Use This KB

1. **Start with `00-system-overview.md`** to understand the environment and how to authenticate.
2. **Use `02-data-model.md`** for the class hierarchy before searching for specific classes.
3. **Use `03-classes-and-attributes.md`** when you need attribute-level detail for a class.
4. **Use `04-domains-and-relations.md`** to understand how classes relate to each other.
5. **Use `07-maintenance-model.md`** and `08-processes-and-workflows.md`** for maintenance operations.
6. **Use `18-ajmn-fit-gap.md`** when making AJMN-specific implementation decisions.
7. **Use `19-ui-operator-playbook.md`** when you need to navigate the live UI.
8. **Query raw JSON files** for machine-readable metadata when implementing integrations.
9. **Check `21-known-unknowns.md`** before declaring that something does or does not exist.

---

## How to Regenerate After an Upgrade

1. Authenticate: `POST /services/rest/v3/sessions`
2. Pull all classes, attributes, domains, lookups, processes, roles, reports, dashboards
3. Run DB queries from the methodology sections of this KB
4. Compare counts against the Summary Counts table above
5. Update `raw/` files first, then update the markdown documentation
6. Update `README.md` with new version and date
7. Review `21-known-unknowns.md` — some items may become confirmable after upgrade

---

## Safety Notes

- The active POC was treated as **read-only** throughout this discovery
- No classes, attributes, domains, lookups, or records were modified
- All database operations were `SELECT` only
- No destructive SQL was executed
- No demo data was deleted
- No AJMN POC records were modified
