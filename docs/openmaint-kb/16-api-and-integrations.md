# 16 — API and Integrations

**Source:** Running API, CMDBuild documentation, `system/status` response  
**Classification:** CMDBUILD PLATFORM

---

## REST API v3

CMDBuild 4.2.0 provides a REST API v3 at:
```
http://[host]/cmdbuild/services/rest/v3/
```

### Authentication

```
POST /sessions?scope=service&returnId=true
Content-Type: application/json
{"username":"admin","password":"admin"}

Response: {"data": {"_id": "<token>", ...}}
```

Pass token as header:
```
CMDBuild-Authorization: <token>
```

Use `scope=service` for API clients (non-interactive). Interactive sessions use `scope=ui`.

### Key Endpoints (Verified)

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/sessions` | POST | Login, get token |
| `/sessions/{token}` | DELETE | Logout |
| `/system/status` | GET | System version, uptime, memory |
| `/classes` | GET | All classes |
| `/classes/{name}` | GET | Class detail |
| `/classes/{name}/attributes` | GET | Class attributes |
| `/classes/{name}/cards` | GET/POST | List/create cards |
| `/classes/{name}/cards/{id}` | GET/PUT/DELETE | Read/update/delete card |
| `/domains` | GET | All domains |
| `/domains/{name}/relations` | GET/POST | List/create relations |
| `/lookup_types` | GET | All lookup types |
| `/lookup_types/{type}/values` | GET | Lookup values for type |
| `/processes` | GET | All process classes |
| `/processes/{name}` | GET | Process detail |
| `/processes/{name}/instances` | GET/POST | List/start process instances |
| `/processes/{name}/instances/{id}` | GET | Process instance detail |
| `/processes/{name}/instances/{id}/activities/{activityId}` | POST | Advance process |
| `/roles` | GET | All roles |
| `/reports` | GET | All reports |
| `/dashboards` | GET | All dashboards |
| `/system/config` | GET | System configuration |
| `/gis/layers` | GET | GIS layer configuration |

### Pagination

All list endpoints support:
```
?limit=500&offset=0
```

Responses include `meta.total` for total count.

### Card Filtering

Filter cards using `filter` parameter (JSON):
```
GET /classes/Building/cards?filter={"attribute":{"and":[{"simple":{"attribute":"City","operator":"equal","value":"Rome"}}]}}
```

### Relations (Domains)

```
GET /classes/{sourceClass}/cards/{cardId}/domains/{domainName}/destinationObjects
POST /classes/{sourceClass}/cards/{cardId}/domains/{domainName}/destinationObjects
```

### Attachments / DMS

```
GET /classes/{name}/cards/{id}/attachments
POST /classes/{name}/cards/{id}/attachments  [multipart/form-data]
```

---

## Integration Patterns

### Pattern A: External System via CMDBuild REST API

```
External System (BMS, ERP, HR, IoT)
         ↕
   AJMN Integration Layer / Middleware
         ↕
   CMDBuild REST API v3
         ↕
   openMAINT data model
```

This is the **recommended integration pattern**. The REST API provides full CRUD on all classes, processes, and relations. All operations respect workflow logic, validation, and audit history.

**Do NOT** write directly to the PostgreSQL database for operational integrations — this bypasses workflow, validation, and audit.

### Pattern B: Event-Driven (Webhooks)

**NOT CONFIRMED** — CMDBuild 4.2.0 may support webhook/event configuration. The `_Job` table shows ETL and email service job types that could be adapted. Check official CMDBuild documentation for webhook support.

### Pattern C: Scheduled Import/Export (ETL)

CMDBuild has a built-in ETL engine (`_EtlConfig` table). The `AutomaticDWGImport` job demonstrates this for DWG files. ETL configurations can be created for:
- Importing asset data from spreadsheets
- Exporting maintenance history to reporting systems
- Syncing employee/org data from HR systems

Classification: **NO-CODE** (configured via admin UI) for simple imports, **LOW-CODE** for complex transformations.

---

## Specific Integration Areas

### BMS / Building Management System

BMS integration is **not provided out of the box**. Options:

| Approach | Complexity |
|---------|-----------|
| BMS pushes sensor data → CMDBuild REST API → Meter readings | CUSTOM DEVELOPMENT (integration middleware needed) |
| ModbusConfig class in openMAINT suggests Modbus protocol support | NOT CONFIRMED — class exists but connection mechanism unclear |
| MQTT gateway → CMDBuild ETL | CUSTOM DEVELOPMENT |
| OPC-UA gateway → REST API | EXTERNAL INTEGRATION |

The `ModbusConfig` class (fields: ConversionRule, DataSize, DataType [INT/UINT/IEEE754/BOOL/WORD], State) and its link to assets via `AssetModbusConfig` domain suggest some planned or partial Modbus integration. **NOT CONFIRMED** whether this is functional or a placeholder.

### ERP / Finance Integration

No native ERP connector. Integration approach:
- Purchase orders (`PurchaseOrder`) and accounting movements (`AccountingMov`) can be synced via REST API
- Budget data (`Budget`, `BudgetItem`) can be managed via API
- Financial transactions must flow through CMDBuild logic to maintain audit trail

### HR / Employee Sync

- Employee records (`InternalEmployee`, `ExternalEmployee`) managed via REST API
- `Employee.LoginUser` links to CMDBuild user accounts
- LDAP/AD integration (if configured) handles authentication; HR sync still needed for employee records

### Email / Notifications

- Template engine exists (`_EmailTemplate` table)
- Email accounts need to be configured in `_EmailAccount`
- SMTP server, IMAP for reply processing
- The `MaintProcReplyEmailMgt` job provides email-to-workflow reply support
- No email accounts are configured in the demo POC

### IoT Sensor Integration

No native IoT connector. Options:
- Build a middleware that reads IoT data and creates `MeterReading` records via REST API
- Use ETL jobs for batch imports
- Real-time: REST API + webhook triggers on threshold breach
- `ModbusConfig` may support direct Modbus device reading (NOT CONFIRMED)

---

## CMDBuild Open vs Subscription Features

CMDBuild has an open-source community edition and a commercial subscription. Some features may be subscription-only.

**NOT CONFIRMED** exactly which features in openMAINT 2.4.2 / CMDBuild 4.2.0 require a subscription:
- Advanced BIM features
- Mobile app (native iOS/Android)
- Waterway (IoT integration module)
- Advanced reporting
- Multi-tenancy beyond basic

The Docker image used (`itmicus/cmdbuild:om-2.4.2-4.2.0`) is based on the community edition. Verify licensing requirements before production deployment.

---

## Mobile Access

openMAINT includes mobile-friendly capabilities via the web UI (responsive design) and potentially a native app. **NOT CONFIRMED** which mobile features are available in the community edition vs subscription.

The `_MobileAppMessage` table exists, suggesting mobile push notification infrastructure.

---

## AJMN Integration Priorities

Based on the gap analysis:

| Integration | Priority | Pattern | Complexity |
|-------------|----------|---------|-----------|
| SSO/LDAP (Active Directory) | High | CMDBuild LDAP config | CONFIGURATION REQUIRED |
| Email notifications | High | CMDBuild email accounts + templates | CONFIGURATION REQUIRED |
| ERP/Finance | Medium | REST API bidirectional sync | EXTERNAL INTEGRATION |
| HR/Employee sync | Medium | REST API import | EXTERNAL INTEGRATION |
| BMS (BACnet/Modbus) | Low-Medium | Middleware → REST API | CUSTOM DEVELOPMENT |
| IoT sensors | Low | Middleware → Meter/MeterReading API | EXTERNAL INTEGRATION |
