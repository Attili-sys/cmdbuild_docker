# 01 — openMAINT vs CMDBuild

**Source:** API, DB schema, official documentation  
**Classification:** CMDBUILD PLATFORM / STANDARD OPENMAINT

---

## Core Concept

**CMDBuild** is a configurable CMDB and process platform. It provides:
- A metadata-driven data model engine (classes, attributes, domains, lookups)
- A workflow engine (XPDL/BPMN processes)
- A REST API (v3)
- A web UI framework (React-based in 4.x)
- GIS, BIM, DMS, email, and reporting subsystems
- Role-based access control
- Multi-tenancy support

**openMAINT** is a vertical CAFM application shipped as a configured CMDBuild instance. It provides:
- A pre-built facility and asset data model (209 classes, 108 domains, 112 lookup types)
- Pre-built maintenance workflows (PreventiveMaint, CorrectiveMaint processes)
- Pre-built roles (AdminOffice, MaintOffice, Requester, Supplier, Team, Guest)
- Pre-built navigation menus
- Pre-built reports (15) and dashboards (4)
- Pre-built GIS configuration (13 classes)
- Pre-built BIM configuration
- Pre-built scheduled jobs (PM generator and advance scheduler)

There is no separate openMAINT binary. The openMAINT release is a CMDBuild WAR plus a database dump (`.dump.xz`) that contains all of the above configuration as database records.

---

## What Belongs to Each Layer

### CMDBuild Platform (always present in any CMDBuild deployment)

| Feature | Notes |
|---------|-------|
| REST API v3 | All `/services/rest/v3/*` endpoints |
| Class metadata engine | `_ClassMetadata`, `_AttributeMetadata` tables |
| Domain engine | Relationship management |
| Lookup engine | Controlled-vocabulary management |
| Workflow engine | BPMN process execution |
| GIS subsystem | `_GisAttribute`, `gis.*` schema |
| BIM subsystem | `_BimProject`, `_BimObject` tables |
| DMS subsystem | Attachment/document management |
| Email engine | `_EmailAccount`, `_EmailTemplate`, `_Job` (emailService type) |
| Scheduled jobs | `_Job` table, cron-based execution |
| Role/permission engine | `_Grant`, `Role` table |
| Reporting engine | `_Report` table, JasperReports integration |
| Dashboard engine | `_Dashboard` table |
| Navigation menu | `_Menu` table |
| Audit history | `*_history` tables, automatic change tracking |
| Multi-tenancy | `IdTenant` column on all business tables |
| Session management | `_Session` table |
| ETL/Import engine | `_EtlConfig`, `_Job` (etl type) |
| Notification templates | `_EmailTemplate` |

### Standard openMAINT (delivered in `demo.dump.xz` configuration)

| Feature | Classification |
|---------|---------------|
| Site → Complex → Building → Floor → Unit → Room hierarchy | STANDARD OPENMAINT |
| CI → Asset → Device → (60+ device subclasses) hierarchy | STANDARD OPENMAINT |
| SystemPlant → System / Plant hierarchy | STANDARD OPENMAINT |
| Employee types (Internal, External, Supplier, Customer) | STANDARD OPENMAINT |
| Company → Supplier / Customer / CorporateGroup | STANDARD OPENMAINT |
| Contract types (ServiceProvision, Rent, Utility, PurchAgreement) | STANDARD OPENMAINT |
| MaintProcess → PreventiveMaint / CorrectiveMaint processes | STANDARD OPENMAINT |
| PrevMaintConfig / PrevMaintDef / PrevMaintTask | STANDARD OPENMAINT |
| MaintSLA with threshold calculation | STANDARD OPENMAINT |
| MaintCategory / MaintSubcategory / Topic | STANDARD OPENMAINT |
| WrhMovement / WrhMovementRow / Consumable | STANDARD OPENMAINT |
| Budget / BudgetCenter / BudgetItem | STANDARD OPENMAINT |
| AccountingMov / PriceList / PriceListEntry | STANDARD OPENMAINT |
| PurchaseOrder / PurchaseOrderRow | STANDARD OPENMAINT |
| Survey (satisfaction/quality scoring) | STANDARD OPENMAINT |
| Meter / MeterReading / Consumption | STANDARD OPENMAINT |
| CalendarConfig / CalendarEntity | STANDARD OPENMAINT |
| 7 roles (SuperUser, AdminOffice, MaintOffice, Requester, Supplier, Team, Guest) | STANDARD OPENMAINT |
| 112 lookup types | STANDARD OPENMAINT |
| GIS attributes on 13 classes | STANDARD OPENMAINT |
| BIM configuration | STANDARD OPENMAINT |
| 15 reports (JasperReports) | STANDARD OPENMAINT |
| 4 dashboards | STANDARD OPENMAINT |
| Navigation menu (274 items) | STANDARD OPENMAINT |
| PM advance and generator scheduled jobs | STANDARD OPENMAINT |

### Demo Data (in `demo.dump.xz` — NOT product configuration)

These are sample business records, not product configuration. Do NOT treat them as product capabilities.

| Demo records | Notes |
|-------------|-------|
| Sample buildings, floors, rooms | 5 buildings, 25 floors, 82 rooms (approximate) |
| Sample assets (357 items) | Computers, chairs, extinguishers, HVAC units, etc. |
| Sample suppliers (6) | Fictitious company names |
| Sample contracts (7) | Fictitious contracts |
| Sample teams (15) | Fictitious maintenance teams |
| Sample employees | Linked to demo users |
| Sample maintenance SLAs (6) | Demo SLA configurations |
| Sample work orders | Preventive and corrective demo processes |
| Sample BIM projects (3) | Demo IFC models — WB14, WB01, WB02 |
| Sample GIS coordinates | Demo building/room positions |
| Sample inventory | Demo stock levels |
| Sample CI Type lookup values (324 items) | Very large CI brand/type list — some may be demo additions |

---

## Customization Boundary

Changes made inside the CMDBuild admin UI (Administration mode) produce records in the database. They are:
- Persistent across restarts
- Exported in database dumps
- NOT stored as code files (except XPDL workflow definitions)

Workflow XPDL files are stored in the database (`_Report`, process tables) and can be exported via API. There is no application code to modify for admin-level configuration.

Changes that require code modification:
- Modifying the CMDBuild/openMAINT React frontend JavaScript
- Adding server-side Java plugins (CMDBuild plugin API)
- Modifying the CMDBuild WAR/JAR files

For AJMN: almost all CAFM configuration should happen through the admin UI, not code.  
External integrations (BMS, ERP, HR) connect via the REST API from outside the application.
