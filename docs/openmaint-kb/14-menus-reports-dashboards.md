# 14 — Menus, Reports and Dashboards

**Source:** DB `_Menu`, API `/reports`, API `/dashboards`  
**Classification:** STANDARD OPENMAINT

---

## Navigation Menu Structure

The openMAINT default navigation menu (`_default` group, `navmenu` type) contains **274 items**. Below is the high-level structure with folder names (class UUIDs from raw data resolved where possible):

```
Dashboard (custom page)
Reporting overview (report PDF)

Facilities and assets
  ├── Locations
  │   ├── NavTree (facility location tree view)
  │   ├── Complex
  │   ├── Building
  │   ├── Floor
  │   ├── Unit
  │   ├── Room
  │   └── Report: Building Dossier
  ├── Elements
  │   ├── NavTree (asset hierarchy tree)
  │   ├── Report: CI Inventory
  │   ├── Dashboard: CI Summary
  │   ├── Equipment (CI generic)
  │   ├── Systems / Plants
  │   │   ├── CI (all)
  │   │   ├── Plants (ManufacturingPlant, Plant)
  │   │   └── Systems (BurglarSystem, ClimateControlSystem, ConveyorSystem,
  │   │               DisposalSystem, ElectricalSystem, FireProtectionSystem,
  │   │               GasDistroSystem, GroundingSystem, MechanicalSystem,
  │   │               SanitationSystem, TLCSystem)
  │   └── Assets
  │       ├── CI (all assets)
  │       ├── Devices
  │       │   ├── Burglar devices (9 classes)
  │       │   ├── Climate control devices (11 classes)
  │       │   ├── Conveyor devices (4 classes)
  │       │   ├── Disposal devices (4 classes)
  │       │   ├── Electrical devices (11 classes)
  │       │   ├── Fire protection devices (11 classes)
  │       │   ├── Gas distribution devices (3 classes)
  │       │   ├── Health and safety devices (3 classes)
  │       │   ├── Mechanical devices (11 classes)
  │       │   ├── Sanitation devices (6 classes)
  │       │   └── Telecommunications devices (7 classes)
  │       ├── Finishings (Fixture, Furniture types, Staircase, ArchitecturalElement)
  │       ├── Items (Component, Meter, Sensor)
  │       ├── Machineries (Apparatus, ProductionMachinery, ManufacturingPlant)
  │       └── Structural elements

Maintenance
  ├── Reports (PM calendar, PM tasks status, SLA compliance, accounting overview)
  ├── Dashboards (PM summary, CM summary)
  ├── Preventive maintenance (process)
  ├── Custom pages (PM planner)
  ├── PrevMaintConfig
  ├── PrevMaintDef
  ├── CISubset
  └── MaintSLA

Human resources
  ├── Employees (Internal, External, Supplier, Customer types)
  ├── Teams
  └── Suppliers

Contracts and finance
  ├── Contracts (ServiceProvision, Rent, Utility, PurchAgreement)
  ├── PurchaseOrder
  └── Reports (Budget summary, Budget partition matrix, Accounting recap)
  └── Dashboards

Logistics
  ├── Consumable
  ├── WrhMovement
  └── Reports (Consumable stocks)
```

*Note: The menu uses internal UUIDs for class references. The structure above is derived from folder labels and item types; full class name resolution for all UUID items requires cross-referencing with the `_NavTree` table which was not fully queried in this inspection.*

---

## Reports (15)

All 15 reports are JasperReports-based. Classification: STANDARD OPENMAINT.

| Code | Description | Module | Key parameters |
|------|-------------|--------|---------------|
| AccountingRecap | Accounting recap | Finance | FilterType (OpeningDate/ClosureDate), ReportDetail (Site/Process/AccountingMov) |
| ActivityReport | Activity report | Maintenance | Date range, team, process type |
| AttachmentList | Attachment list | General | Document/attachment listing |
| BudgetPartitionMatrix | Budget partition matrix | Finance | BudgetType (Estimate/Actual) |
| BudgetSummary | Budget summary | Finance | BudgetType (Estimate/Actual/Comparison), ReportDetail (Budget/BudgetCenter/BudgetItem/AccountingMov) |
| BuildingDossier | Building dossier | Facilities | Building selection — generates full dossier |
| CIInventory | CI inventory | Assets | ReportGrouping (None/Complex/Building/Floor/Unit/Room) |
| ConsumableStocks | Consumable stocks | Logistics | Stock levels per consumable per location |
| MaintAccMovOverview | Maintenance accounting overview | Finance/Maint | FilterType, ReportDetail (Site/Process/AccountingMov) |
| MaintSLACompliance | Maintenance SLA compliance | Maintenance | FilterType, Sorting (Timings/Site/Team/OpeningDate), show SLA on time |
| PrevMaintCalendar | Preventive maintenance calendar | PM | Date range — shows PM schedule as calendar |
| PrevMaintConfigIssues | PM configuration issues | PM | Reports PM configs with scheduling problems |
| PrevMaintTasks | Preventive maintenance tasks | PM | Task listing by PM |
| PrevMaintTasksStatus | PM tasks status | PM | Task completion status summary |
| ServiceStatusOverview | Service status overview | Facilities | Overview of facility/asset service statuses |

---

## Dashboards (4)

| ID | Name | Module | Charts |
|----|------|--------|--------|
| 280447 | CI summary | Assets | CIProperty (pie — condition/state breakdown), CILastCheck (bar — last maintenance date) |
| 280448 | Preventive maintenance summary | PM | TaskStatus (pie), TeamWorkload (bar), PMC/PrevMaintCompliance (pie), PMP/PlannedMaintenancePercentage (pie) |
| 326350 | Reading and consumption summary | Energy | ReadingsTrend (line), ReadingsConsumption (bar), Consumptions (bar), ReadingsType (pie) |
| 421653 | Corrective maintenance summary | CM | MTTR/MeanTimeToRepair (bar), MTBF/MeanTimeBetweenFailure (bar) |

### Dashboard Notes

- **CM Dashboard** provides MTTR and MTBF calculations — important KPIs for corrective maintenance
- **PM Dashboard** provides task status, team workload, and compliance metrics
- **Energy Dashboard** provides reading trends and consumption analysis
- **CI Dashboard** shows asset condition and last check status

---

## GIS Menu

A separate GIS menu (`_default` group, `gismenu` type) exists. Contents were not fully enumerated in this inspection — **PARTIALLY CONFIRMED**. The GIS menu provides access to the map view with GIS-enabled classes.

---

## AJMN Notes

The 15 standard reports cover:
- PM planning and compliance (strong)
- CM cost accounting (good)
- Asset inventory (good)
- Budget and financial (good)
- SLA compliance (good)

**Gaps for AJMN:**
- No vendor performance report
- No HSE incident report
- No procurement status report
- No custom KPI dashboard for AJMN executive view
- Arabic-language report output: **NOT CONFIRMED** — depends on JasperReports locale configuration
