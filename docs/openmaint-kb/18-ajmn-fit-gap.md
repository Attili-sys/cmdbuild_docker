# 18 — AJMN Fit-Gap Analysis

**Source:** Discovered configuration + AJMN requirements  
**Classification:** Analysis based on STANDARD OPENMAINT evidence

---

## Status Definitions

| Status | Meaning |
|--------|---------|
| **NATIVE** | Fully supported out of the box with no configuration |
| **CONFIGURATION REQUIRED** | Feature exists; needs setup/data entry |
| **LOW-CODE** | Requires XPDL workflow design or scripting in admin UI |
| **CUSTOM DEVELOPMENT** | Requires software development outside openMAINT |
| **EXTERNAL INTEGRATION** | Requires external system/middleware |
| **NOT CONFIRMED** | Evidence insufficient |

---

## Fit-Gap Table

| AJMN Requirement | openMAINT Capability | Status | Recommended Approach |
|-----------------|---------------------|--------|---------------------|
| **LOCATIONS** | | | |
| Multiple campuses / sites | Complex class | NATIVE | Create one Complex per AJMN campus |
| Buildings | Building class | NATIVE | Create Building records per campus |
| Floors | Floor class | NATIVE | Create Floor per building |
| Rooms / spaces | Room class with Use lookup | NATIVE | Create Room; add Studio/Technical Room to Use lookup |
| Studios | Room (extend Use lookup) | CONFIGURATION REQUIRED | Add "Studio" to Room - Use lookup |
| Technical rooms | Room (extend Use lookup) | CONFIGURATION REQUIRED | Add "Technical Room" to Room - Use lookup |
| Control rooms | Room (extend Use lookup) | CONFIGURATION REQUIRED | Add "Control Room" lookup value |
| Security gates / checkpoints | AccessControlDevice + Barrier classes | NATIVE | Use existing class hierarchy |
| **ASSETS** | | | |
| Generators | Generator class (ElectricalDevice) | NATIVE | Use existing class |
| HVAC / air handling | AirHandlingUnit, FanCoil, Split | NATIVE | Use existing classes |
| Chillers | Chiller class | NATIVE | Use existing class |
| Cooling towers | CoolingTower class | NATIVE | |
| Elevators / lifts | LiftingDevice class | NATIVE | |
| UPS | AuxiliaryPowerSupply or StandbyPower | NATIVE | Two relevant classes exist |
| Electrical panels | ElectricalPanel class | NATIVE | |
| Transformers | Transformer class | NATIVE | |
| Fire detection | Detector, Alarm classes | NATIVE | |
| Fire suppression | Sprinkler, FireHoseReel, FireHydrant | NATIVE | |
| Fire extinguishers | FireExtinguisher class (with GIS) | NATIVE | |
| Emergency lighting | EmergencyLightingDev class | NATIVE | |
| BMS / building automation | No dedicated BMS class | EXTERNAL INTEGRATION | ModbusConfig class exists but functionality NOT CONFIRMED |
| Technical assets (general) | Device hierarchy (80+ types) | NATIVE | |
| **MAINTENANCE** | | | |
| Preventive maintenance | PreventiveMaint process + PrevMaintConfig | NATIVE | |
| PM scheduling | PrevMaintConfig (frequency, team, dates) | NATIVE | |
| PM checklists | PrevMaintTask / PrevMaintDef | NATIVE | |
| PM auto-generation | PrevMaintGeneratorScheduler job | NATIVE | |
| Corrective maintenance | CorrectiveMaint process | NATIVE | |
| Maintenance requests | CorrectiveMaint (Opening state) | NATIVE | Requester role submits |
| Work orders | CorrectiveMaint / PreventiveMaint instances | NATIVE | |
| Assignment to technician/team | CM-Assignment workflow state | NATIVE | |
| Maintenance execution tracking | CM-Management → Control states | NATIVE | |
| Work order closure | CM-Closure state with Outcome | NATIVE | |
| Approval workflow | CM-Estimate and CM-Control states | NATIVE | |
| Multi-level approval | Limited by current XPDL design | LOW-CODE | Add approval states to XPDL |
| Priority | COMMON - Priority lookup (1–4) | NATIVE | |
| Maintenance categories | MaintCategory / MaintSubcategory | NATIVE | Add AJMN-specific categories |
| **SLA / KPI** | | | |
| SLA tracking | MaintSLA class with threshold config | NATIVE | |
| SLA per contract | ContractMaintSLA domain | NATIVE | |
| SLA per site | SiteMaintSLA domain | NATIVE | |
| SLA per subcategory | MaintSubcatMaintSLA domain | NATIVE | |
| MTTR / MTBF | CM dashboard charts | NATIVE | |
| PM compliance | PM dashboard (PMC pie chart) | NATIVE | |
| SLA compliance report | MaintSLACompliance report | NATIVE | |
| Custom KPI executive dashboard | Not in standard dashboards | CUSTOM DEVELOPMENT | BI tool via REST API or custom dashboard |
| **VENDORS / CONTRACTS** | | | |
| Supplier / vendor register | Supplier class | NATIVE | |
| Internal technicians | InternalEmployee class | NATIVE | |
| External contractors | ExternalEmployee / SupplierEmployee | NATIVE | |
| Teams | Team class | NATIVE | |
| AMC contracts | ServiceProvision class | NATIVE | |
| Contract expiry tracking | ExpirationDate field on Contract | NATIVE | Add calendar/alert job for expiry |
| Contract-linked SLAs | ContractMaintSLA domain | NATIVE | |
| Vendor performance dashboard | Not standard | CUSTOM DEVELOPMENT | |
| **INVENTORY** | | | |
| Spare parts catalog | Consumable class (97 types) | NATIVE | |
| Warehouse / store | Site class (used as warehouse location) | NATIVE | Use a Site record as "warehouse" |
| Stock movements | WrhMovement / WrhMovementRow | NATIVE | |
| Material consumption in WO | MaintProcWrhMov domain | NATIVE | |
| Purchase orders | PurchaseOrder class | NATIVE | |
| Reorder alerts / minimum stock | Not native | CUSTOM DEVELOPMENT | Scheduled job checking stock levels |
| Procurement integration (ERP) | REST API bidirectional | EXTERNAL INTEGRATION | |
| **HSE** | | | |
| Safety incidents | Not a native class | LOW-CODE | Create SecurityIncident or HSEIncident class + simple data capture |
| Near miss reporting | Not native | LOW-CODE | Create NearMiss class |
| Permit to Work | Not native | LOW-CODE | New process class with approval workflow |
| Risk assessments | Not native | LOW-CODE → CUSTOM | Class + form; complex risk matrix = custom |
| Safety inspections | Not native | LOW-CODE | Create SafetyInspection class/process |
| Fire drills | Not native | LOW-CODE | Create FireDrill class linked to Site |
| Corrective safety actions | CorrectiveMaint can be used | CONFIGURATION REQUIRED | Use maintenance category "Safety" |
| **DOCUMENTS** | | | |
| Document management | DMS (postgres backend) | NATIVE | |
| Attachments on any card | Standard CMDBuild feature | NATIVE | |
| Technical drawings | BaseDocument class + GIS shapes | NATIVE | |
| BIM models | BIM subsystem | NATIVE | |
| Energy certificates | DmsEnergyPerformCert class | NATIVE | |
| Version control for documents | NOT CONFIRMED | Investigate CMDBuild DMS versioning |
| **PEOPLE / USERS** | | | |
| Internal staff access | User + InternalEmployee + roles | NATIVE | |
| Contractor access | Supplier role + SupplierEmployee | NATIVE | |
| Self-service portal | Requester role (basic) | CONFIGURATION REQUIRED | Standard UI has limited end-user UX |
| Polished self-service portal | Not standard | CUSTOM DEVELOPMENT | Custom web portal via REST API |
| Vendor portal | Supplier role | CONFIGURATION REQUIRED | Limited to standard UI |
| Mobile technician access | Responsive web UI | CONFIGURATION REQUIRED | Validate mobile UI; native app = NOT CONFIRMED |
| QR / barcode scanning | Not confirmed in web UI | NOT CONFIRMED | May need mobile app or custom page |
| **LOCALIZATION** | | | |
| Arabic language | CMDBuild language packs | CONFIGURATION REQUIRED | Load Arabic translation pack |
| RTL layout | NOT CONFIRMED | CMDBuild 4.x React UI — verify RTL support |
| Arabic terminology | Lookup values, descriptions | CONFIGURATION REQUIRED | Translate lookup values and descriptions |
| **AUTHENTICATION** | | | |
| Local username/password | Active (demo) | NATIVE | |
| LDAP / Active Directory | CMDBuild supports LDAP | CONFIGURATION REQUIRED | Configure in System configuration |
| SSO / SAML | CMDBuild has SAML support | CONFIGURATION REQUIRED | Configure SAML provider |
| OAuth/OIDC | NOT CONFIRMED for CMDBuild 4.2 | Investigate | |
| **INTEGRATIONS** | | | |
| Email notifications | CMDBuild email engine | CONFIGURATION REQUIRED | Configure SMTP account + templates |
| ERP / Finance sync | REST API | EXTERNAL INTEGRATION | Middleware required |
| HR / workforce sync | REST API | EXTERNAL INTEGRATION | Scheduled sync of Employee records |
| BMS (BACnet/Modbus) | No native protocol support | EXTERNAL INTEGRATION + CUSTOM DEV | IoT gateway → REST API |
| IoT sensors | REST API for MeterReading | EXTERNAL INTEGRATION | Middleware → MeterReading creation |
| Push notifications (mobile) | `_MobileAppMessage` table exists | NOT CONFIRMED | Verify mobile app availability |
| **AUDIT / HISTORY** | | | |
| Audit trail on all records | `*_history` tables — automatic | NATIVE | |
| Who changed what and when | History tab on every card | NATIVE | |
| Process flow log | ProcessFlowLog SimpleClass | NATIVE | |
| **GIS** | | | |
| Building map (outdoor) | Building → Position (point) | NATIVE | |
| Floor plan | Floor → Drawing, Room → Area | NATIVE (requires CAD/data) |
| Asset positioning | 13 classes with GIS attributes | NATIVE | |
| Additional GIS classes | Add via admin UI | CONFIGURATION REQUIRED | |
| **BIM** | | | |
| IFC model upload | BIM subsystem | NATIVE | |
| 3D model viewer | NATIVE (INFERENCE) | Verify in browser |
| BIM-to-card mapping | _BimObject ↔ class card | NATIVE | |

---

## Summary — Strongest Fit for AJMN

1. **Facility and location hierarchy** — Complex/Building/Floor/Room model is a direct match
2. **Asset management** — 80+ device types cover all AJMN technical assets
3. **Preventive maintenance** — full PM scheduling with auto-generation
4. **Corrective maintenance** — multi-state workflow with approval
5. **SLA tracking** — flexible SLA configuration per contract/site/category
6. **Document management** — DMS integrated on all cards
7. **Role-based access** — 7 roles covering main stakeholder types
8. **GIS** — building positioning and floor plan support

## Summary — Biggest Gaps for AJMN

1. **HSE / safety** — no dedicated classes or workflows; requires LOW-CODE creation
2. **Polished self-service portal** — standard UI is functional but not consumer-grade
3. **Integration middleware** — BMS, ERP, HR, IoT connections require external development
4. **Arabic RTL** — needs verification; language packs need loading
5. **Executive KPI dashboard** — standard dashboards are limited; custom BI likely needed
6. **Reorder / procurement automation** — inventory exists but smart reorder is missing
7. **QR/barcode scanning** — not confirmed in current deployment
8. **Mobile native app** — needs verification for community edition
