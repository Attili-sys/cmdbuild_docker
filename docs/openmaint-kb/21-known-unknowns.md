# 21 — Known Unknowns

**Purpose:** Items not confidently established in this inspection.  
Unknown is preferable to invented.

---

## Process / Workflow

| Item | Status | How to resolve |
|------|--------|---------------|
| Exact XPDL content for CorrectiveMaint | NOT CONFIRMED | Export XPDL from Administration → Processes → CorrectiveMaint → Workflow |
| Exact XPDL content for PreventiveMaint | NOT CONFIRMED | Export from admin UI |
| Email notification trigger points in workflows | NOT CONFIRMED | Review XPDL and email template list |
| Exact list of email templates (`_EmailTemplate`) | NOT CONFIRMED | Query `_EmailTemplate` table |
| Role assignments per workflow activity | NOT CONFIRMED | Export XPDL and inspect `performer` elements |
| Script/expression logic in workflow transitions | NOT CONFIRMED | Inspect XPDL transition scripts |
| PM work order fields beyond PrevMaintConfig link | PARTIALLY CONFIRMED | Inspect PreventiveMaint process instance attributes |
| CM work order field list (beyond lookup analysis) | PARTIALLY CONFIRMED | Inspect CorrectiveMaint process instance attributes |

---

## Menus

| Item | Status | How to resolve |
|------|--------|---------------|
| Full menu item → class name resolution | PARTIALLY CONFIRMED | Menu items use UUIDs; cross-reference with `_NavTree` table and class API |
| GIS menu structure and items | NOT CONFIRMED | Query `_Menu` where `Type='gismenu'` |
| Administration section menu structure | NOT CONFIRMED | Navigate admin UI and document |
| Role-specific menu differences | NOT CONFIRMED | Log in as each role and compare menus |

---

## GIS

| Item | Status | How to resolve |
|------|--------|---------------|
| Configured geoserver/WMS base map | NOT CONFIRMED | Inspect `gis-geoservers.json` and admin UI → GIS → Geoservers |
| Exact GIS coordinate system used | NOT CONFIRMED | Query PostGIS `Find_SRID` for `gis.Gis_Building_Position` |
| Whether demo GIS data contains real coordinates | NOT CONFIRMED | Query `gis.Gis_Building_Position` for values |
| GIS layer visibility per role | NOT CONFIRMED | Test with different role accounts |

---

## BIM

| Item | Status | How to resolve |
|------|--------|---------------|
| IFC format version supported (2x3 vs IFC4) | NOT CONFIRMED | CMDBuild documentation or test upload |
| BIM viewer technology (Three.js vs other) | NOT CONFIRMED | Inspect browser devtools when viewing BIM |
| Whether BIM subscription is required for advanced features | NOT CONFIRMED | CMDBuild licensing documentation |
| BIM-to-GIS coordinate integration | NOT CONFIRMED | Test in admin UI or query `_BimObject` geometry columns |

---

## Mobile and Portal

| Item | Status | How to resolve |
|------|--------|---------------|
| Native mobile app availability (community edition) | NOT CONFIRMED | CMDBuild documentation / App Store |
| Mobile push notification support | NOT CONFIRMED | `_MobileAppMessage` table exists; mechanism unclear |
| Portal self-service URL (separate from admin UI) | NOT CONFIRMED | Check for separate portal path in Tomcat webapps |
| QR/barcode scanning capability | NOT CONFIRMED | Test with mobile device |

---

## Authentication

| Item | Status | How to resolve |
|------|--------|---------------|
| LDAP configuration options | NOT CONFIRMED | CMDBuild System Configuration → Authentication |
| SAML configuration options | NOT CONFIRMED | CMDBuild System Configuration → SAML |
| OAuth/OIDC support in CMDBuild 4.2 | NOT CONFIRMED | CMDBuild 4.2 changelog and documentation |

---

## Reports and Dashboards

| Item | Status | How to resolve |
|------|--------|---------------|
| Report parameters beyond lookup analysis | PARTIALLY CONFIRMED | Open each report dialog in UI and capture full parameter list |
| Dashboard data sources (which DB views/queries) | NOT CONFIRMED | Inspect dashboard chart configuration in admin UI |
| Arabic/RTL support in JasperReports output | NOT CONFIRMED | Test with Arabic locale; inspect .jrxml files |
| Whether report parameters support date ranges beyond lookup | NOT CONFIRMED | Open report parameter dialogs |

---

## Integration

| Item | Status | How to resolve |
|------|--------|---------------|
| ModbusConfig functional connection mechanism | NOT CONFIRMED | Search CMDBuild forum / source for Modbus implementation |
| Webhook/event publish capability | NOT CONFIRMED | CMDBuild 4.2 changelog |
| ETL engine capabilities and supported formats | PARTIALLY CONFIRMED | Review `_EtlConfig` table and CMDBuild documentation |
| Waterway module status | NOT CONFIRMED | CMDBuild documentation — may be subscription |

---

## Lookup Values

| Item | Status | How to resolve |
|------|--------|---------------|
| CI - Brand (12 values) — are these standard or demo additions? | NOT CONFIRMED | Compare with a clean openMAINT 2.4.2 database without demo data |
| CI - Type (324 values) — classification | NOT CONFIRMED | The large count suggests some may be demo additions |
| Whether custom lookup values were added in this POC | NOT CONFIRMED | No lookups were added during discovery; original dump content unverified |

---

## Financial

| Item | Status | How to resolve |
|------|--------|---------------|
| Invoice class full attribute list | PARTIALLY CONFIRMED | Query API `/classes/Invoice/attributes` |
| Currency field usage across all financial classes | NOT CONFIRMED | Review AccountingMov, PriceListEntry attribute detail |
| Whether currency is stored on individual transactions | NOT CONFIRMED | Inspect AccountingMov attributes |

---

## System

| Item | Status | How to resolve |
|------|--------|---------------|
| CMDBuild community vs commercial feature boundary for this version | NOT CONFIRMED | Review cmdbuild.org licensing documentation |
| Multi-tenancy behavior (IdTenant column) | NOT CONFIRMED | All records have IdTenant; single-tenant vs multi-tenant config unclear |
| Performance characteristics under load | NOT CONFIRMED | POC runs under amd64 emulation; not representative |
| Database backup configuration | NOT CONFIRMED | Not configured in this POC |
