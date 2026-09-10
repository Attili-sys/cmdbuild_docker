# 05 — Lookups

**Source:** API `/lookup_types` (112 types) and `/lookup_types/{type}/values` (2,025 values)  
**Classification:** STANDARD OPENMAINT

---

## Overview

openMAINT ships with **112 lookup types** and **2,025 lookup values**. Lookups provide controlled vocabularies for class attributes. All 112 types are standard openMAINT configuration.

---

## Key Lookup Types by Domain

### Facility / Location

| Lookup Type | Values | Used by |
|-------------|--------|---------|
| Site - State | Used / Rent / Vacant | Site.State |
| Site - Condition | Excellent / Good / MaintRequired / Poor | Site (all) |
| Building - MainUse | Commercial / Cultural / Office / Residential / Recreational + 2 | Building.MainUse |
| Floor - Level | -3 to 17.5 (21 values) | Floor.Level |
| Room - Use | Office / Depot / Canteen / Cellar / Toilet + 4 | Room.Use |
| Unit - CadastralCategory | A1–A11, B1–B8, C1–C7, D1–D10, etc. (51 values) | Unit.Category |
| OutdoorElement - Access | Free / TicketRequired / LimitedHours | OutdoorElement |

### Assets / CI

| Lookup Type | Values | Used by |
|-------------|--------|---------|
| CI - State | InStock / UnderMaint / Disposed / InUse | CI (all assets) |
| CI - Condition | Working / Inspection / Broken | CI (all assets) |
| CI - Brand | IBM / ACER / SONY / HP / Everbilt + 7 (12 total) | CI (all assets) |
| CI - Type | 324 values | CI.Type (extensive type classification) |
| FireExtinguisher - FireClass | A / B / C / D / E / F (6 values) | FireExtinguisher |
| DmsEnergyPerformCert - Rating | A / B / C / D / E / F / G | EPC documents |
| Peripheral - Technology | Inkjet / Laser / Heat | Peripheral |

### Maintenance

| Lookup Type | Values | Used by |
|-------------|--------|---------|
| MaintProcess - Type | Breakdown / Damage / Extraordinary | CorrectiveMaint |
| MaintProcess - Outcome | Positive / Negative / Canceled | MaintProcess |
| MaintProcess - SuspensionReason | Supplier / Replacement / Other | MaintProcess |
| MaintProcess - EstimateStatus | CM-Accepted / CM-Rejected / CM-Received / CM-Expected / CM-Declined | CorrectiveMaint |
| Process - ProcessStatus | 16 values (CM-Opening through CM-Closure, PM-Execution) | Process instances |
| Process - Action | 31 values (workflow transition actions) | Workflow engine |
| Process - ProcessType | CM-Subtask / CM-Estimate | Sub-process types |
| PrevMaintConfig - FrequencyUM | days / weeks / months / years | PrevMaintConfig.FrequencyUM |
| PrevMaintConfig - ModifyAction | KeepManual / UpdateAll | PrevMaintConfig |
| PrevMaintTasks - Outcome | Ok / Ko / Done / ToDo | PrevMaintTasks |
| FlowStatus | open.running / open.not_running.suspended / closed.completed / closed.aborted | Workflow state |

### SLA and Priority

| Lookup Type | Values | Used by |
|-------------|--------|---------|
| COMMON - Priority | 1 / 2 / 3 / 4 (1=highest) | MaintSLA, MaintProcess |
| MaintSLA - ThresholdUM | Seconds / Minutes / Hours / Days / Weeks / Months | MaintSLA |
| MaintSLA - TimeCalcCriteria | System / Calendar | MaintSLA |

### Financial

| Lookup Type | Values | Used by |
|-------------|--------|---------|
| AccountingMov - State | Estimate / Actual | AccountingMov |
| AccountingMov - Type | Cost / Revenue | AccountingMov |
| BudgetItem - Type | Rental / Maintenance / Cleaning / Utility / Surveillance + 2 | BudgetItem |
| Rent - AmountType | Annual / Monthly / Weekly | Rent |
| Rent - DurationUM | Years / Months / Weeks | Rent |
| Utility - Type | Electricity / Electricity+Gas / Gas / Water / Landline + 2 | Utility |
| COMMON - VATRate | 22 / 10 / 04 | Financial (Italian) |
| COMMON - Currency | EUR / USD / GBP / JPY / INR / CHF / CNY | Financial |
| REP-BudgetSummary - BudgetType | Estimate / Actual / Comparison | Budget report |
| PartitionTable - Type | Water / PostOfficeBox / Property / TVIntercom | PartitionTable |
| PartitionTable - UM | Thousandth / M2 / M3 | PartitionTable |

### Inventory / Logistics

| Lookup Type | Values | Used by |
|-------------|--------|---------|
| Consumable - Category | Cleaning / Electrical / GreaseLubrification / Hydraulic / Measurement + 5 | Consumable |
| Consumable - Type | 97 values | Consumable.Type |
| WrhMovement - Category | Load / Unload / Relocation | WrhMovement |
| WrhMovement - Subcategory | 8 values (Load-PurchaseOrder, Unload-Usage, etc.) | WrhMovement |

### Common / Global

| Lookup Type | Values | Notes |
|-------------|--------|-------|
| COMMON - Country | 248 values (ISO 3166 alpha-3 codes) | Address fields on multiple classes |
| COMMON - Criticality | low / moderate / high / extreme | CI, Site criticality |
| COMMON - Priority | 1–4 | SLA, maintenance priority |
| COMMON - Currency | 7 currencies | ⚠ QAR not included — add for AJMN |
| COMMON - DatePart | Hour / Day / Week / Month / Year | Calendar configuration |
| COMMON - DayOfWeek | MON / TUE / WED / THU / FRI / SAT / SUN | Calendar |
| COMMON - Month | 1–12 | Calendar |
| COMMON - ReadingType | 10 values (ElectricalEnergy, GasVolume, etc.) | MeterReading |
| COMMON - MeasureType | 11 values (Energy, VolumeFlow, etc.) | MeterReading |
| COMMON - YesNo | Yes / No | Boolean lookups |
| CalendarConfig - ServiceStatus | Calendar / Operative / Inoperative | CalendarEntity |
| CalendarConfig - FrequencyUM | Days / Weeks / Months / Years | Calendar events |
| Employee - State | Active / NonActive / Suspended | Employee |

### Topics

| Lookup Type | Values | Notes |
|-------------|--------|-------|
| Topic - Type | Checklist / Documentation / FAQ / Guide / Troubleshooting | Topic knowledge base |
| Topic - State | Draft / Review / Internal / Public | Topic publication state |

### Survey

| Lookup Type | Values | Notes |
|-------------|--------|-------|
| Survey - Agreement | 1–5 | Requester feedback |
| Survey - Quality | 1–5 | |
| Survey - Satisfaction | 1–5 | |

### Calendar

| Lookup Type | Values |
|-------------|--------|
| CalendarCategory | default / contracts / payments / warranties |
| CalendarEndType | never / date / other / number |
| CalendarEventStatus | completed / canceled / expired / active |
| CalendarFrequency | daily / once / yearly / monthly / weekly |
| CalendarPriority | default / 4 / 3 / 2 / 1 |

---

## Report-Specific Lookups (Internal)

Many lookups prefixed with `REP-`, `CRT-`, `CWG-`, `CTX-`, `CustomPageOpm-` are internal to reports, dashboards, and custom pages — they contain translation strings and configuration values for UI components, not business data.

Examples:
- `REP-MaintSLACompliance - Labels` — column header translations for SLA report
- `CustomPageOpm - CorrectiveMaint` — 38 chart/KPI label values for CM dashboard page
- `CustomComponents - Translations` — 105 UI translation strings for custom planner component

These are STANDARD OPENMAINT and should not be modified unless changing report/dashboard labels.

---

## AJMN Lookup Changes Required

| Change | Category |
|--------|----------|
| Add `Studio` to Room - Use | NO-CODE |
| Add `Technical Room` to Room - Use | NO-CODE |
| Add `Control Room` to Room - Use | NO-CODE |
| Add `QAR` (Qatari Riyal) to COMMON - Currency | NO-CODE |
| Add AJMN maintenance categories | NO-CODE (new MaintCategory records) |
| Review CI - Brand list (324 values — many may be demo additions) | Verify |
| Add Arabic translations for lookup descriptions | NO-CODE |
| Review COMMON - VATRate (Italian values — not applicable to Qatar) | NO-CODE update |
