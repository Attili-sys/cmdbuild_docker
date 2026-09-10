# 17 — Customization Guide

**Source:** CMDBuild platform knowledge, API evidence, domain analysis  
**Classification:** CMDBUILD PLATFORM capability

---

## Customization Classification

All changes fall into one of these categories:

| Category | Definition | Where done |
|----------|------------|-----------|
| **NO-CODE** | Admin UI configuration, no development | CMDBuild Administration UI |
| **LOW-CODE** | XPDL workflow design, scripting in workflow transitions | CMDBuild Administration UI |
| **CUSTOM DEVELOPMENT** | Java plugins, custom REST endpoints, frontend React changes | Source code / external |
| **EXTERNAL INTEGRATION** | Integration middleware connecting CMDBuild to other systems | External system |
| **SOURCE-CODE MODIFICATION** | Modifying CMDBuild/openMAINT WAR/JAR files | CMDBuild source code |

**Rule of thumb:** Anything that can be configured through the Administration section of the UI is NO-CODE. Changes that require writing scripts or XPDL are LOW-CODE. Changes to the application itself are CUSTOM DEVELOPMENT or SOURCE-CODE MODIFICATION.

---

## Customization Matrix

| Change | Category | Notes |
|--------|----------|-------|
| **Add a new asset class** | NO-CODE | Create class in Administration → Data model → Classes |
| **Add a field to a class** | NO-CODE | Add attribute in class editor |
| **Add a lookup value** | NO-CODE | Administration → Data model → Lookup types |
| **Add a new relationship (domain)** | NO-CODE | Create domain in Administration → Data model → Domains |
| **Add a menu item** | NO-CODE | Administration → User interface → Navigation menus |
| **Create a new dashboard** | NO-CODE | Administration → User interface → Dashboards |
| **Add a chart to a dashboard** | NO-CODE | Dashboard editor supports bar, pie, line charts |
| **Create a new report** | LOW-CODE | JasperReports .jrxml file required; loaded via Administration → Utilities → Reports |
| **Add GIS attribute to a class** | NO-CODE | Administration → GIS → Geoattributes |
| **Change role permissions** | NO-CODE | Administration → User management → Roles → Privileges |
| **Add a new role** | NO-CODE | Administration → User management → Roles |
| **Create a new user** | NO-CODE | Administration → User management → Users |
| **Configure LDAP/AD** | NO-CODE | Administration → System configuration → Authentication |
| **Configure email account** | NO-CODE | Administration → Email → Accounts |
| **Create email template** | NO-CODE | Administration → Email → Templates |
| **Create a scheduled job** | NO-CODE | Administration → Utilities → Scheduled jobs |
| **Configure ETL import** | LOW-CODE | ETL configuration + data mapping |
| **Modify a workflow (add state)** | LOW-CODE | XPDL editor in Administration → Processes |
| **Add workflow scripts** | LOW-CODE | Groovy/JavaScript in XPDL transition scripts |
| **Add workflow notifications** | LOW-CODE | Email templates + XPDL email trigger configuration |
| **Create a new process** | LOW-CODE | New process class + XPDL design |
| **Multi-level approval workflow** | LOW-CODE → CUSTOM | Simple: add states in XPDL. Complex: custom script logic |
| **Custom validation rules** | LOW-CODE | XPDL scripts or CMDBuild attribute validation expressions |
| **Security Incident entity** | NO-CODE | Create class SecurityIncident with relevant attributes |
| **HSE workflow** | LOW-CODE | New process class + XPDL workflow design |
| **Permit to Work workflow** | LOW-CODE | New process class + XPDL |
| **Custom React frontend** | CUSTOM DEVELOPMENT | Modify openMAINT React UI (requires frontend dev) |
| **Self-service portal** | CUSTOM DEVELOPMENT | Build custom web portal calling CMDBuild REST API |
| **Vendor portal** | CUSTOM DEVELOPMENT | Web portal with Supplier role API access |
| **QR code scanning (asset)** | CUSTOM DEVELOPMENT | Mobile app or web page calling asset lookup API |
| **SSO / SAML** | NO-CODE | CMDBuild Administration → System configuration → SAML |
| **OAuth/OIDC** | NOT CONFIRMED | CMDBuild 4.2 capability needs verification |
| **ERP integration** | EXTERNAL INTEGRATION | Middleware calling CMDBuild REST API bidirectionally |
| **HR integration** | EXTERNAL INTEGRATION | Scheduled sync of Employee records via REST API |
| **BMS integration (BACnet/Modbus)** | EXTERNAL INTEGRATION + CUSTOM DEV | Gateway/middleware required |
| **IoT sensor feeds** | EXTERNAL INTEGRATION | Middleware pushes MeterReading records via REST API |
| **Email notifications (custom)** | LOW-CODE | Email templates + workflow triggers |
| **Arabic/RTL support** | NO-CODE | CMDBuild language packs + UI locale setting |
| **Mobile technician access** | CONFIGURATION REQUIRED | Responsive web UI (built-in) + verify mobile app availability |

---

## Recommended AJMN Configuration Sequence

### Phase 1 — NO-CODE Foundation (2–4 weeks)

1. Configure Arabic language pack and locale
2. Set up LDAP/AD authentication
3. Configure AJMN organizational structure (site hierarchy: Complex, Buildings)
4. Define AJMN asset types (extend existing device classes or add new subclasses)
5. Add missing lookup values (studio types, room types, currency QAR, etc.)
6. Configure maintenance categories for AJMN (HVAC, Electrical, Civil, etc.)
7. Set up teams, employees, and roles for AJMN staff
8. Configure SLAs per contract/category
9. Configure email accounts and notification templates

### Phase 2 — LOW-CODE Workflows (4–8 weeks)

1. Design preventive maintenance schedules for each asset type
2. Customize corrective maintenance workflow for AJMN approval chains
3. Create ServiceRequest process (if different from CorrectiveMaint)
4. Create basic HSE/Security Incident class + simple process
5. Configure PM checklists (PrevMaintTask definitions)
6. Create/customize reports for AJMN management

### Phase 3 — Configuration and Integration (ongoing)

1. Configure GIS with AJMN building coordinates and floor plans
2. Load BIM models for AJMN buildings
3. Implement SSO integration
4. Implement HR sync (employee records)
5. Implement email notifications
6. Implement ERP/finance sync (if required)
7. Implement BMS integration (if required)

### Phase 4 — Custom Development (if needed)

1. Self-service portal (if standard UI is insufficient for end users)
2. Vendor portal
3. Mobile app customization
4. Advanced executive dashboard (beyond built-in dashboard engine)

---

## What CANNOT Be Done Without Code

- Changing the CMDBuild platform behavior (e.g., how history is stored, how sessions work)
- Adding new REST API endpoints
- Implementing real-time push notifications to mobile devices
- Modifying the core React UI components without frontend code changes
- Implementing OAuth/OIDC if not supported in CMDBuild 4.2 community edition
- BMS protocol adapters (BACnet, Modbus, OPC-UA) — these require middleware
