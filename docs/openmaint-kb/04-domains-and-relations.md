# 04 — Domains and Relationships

**Source:** Running API `/domains` (108 domains)  
**Classification:** STANDARD OPENMAINT

---

## Overview

CMDBuild uses **domains** to represent relationships between classes. Each domain creates a `Map_*` table in PostgreSQL. All 108 domains are standard openMAINT configuration.

---

## Facility Relationship Map

```
Complex ──────── ComplexBuilding ──────── Building ──────── BuildingFloor ──────── Floor
   │                                        │                                         │
   ├── ComplexCI                             ├── BuildingCI                            ├── FloorCI
   ├── ComplexFloor                          ├── BuildingRoom                          ├── FloorRoom
   └── ComplexRoom                           ├── BuildingUnit                          ├── FloorUnit
                                             └── BuildingFloor                         └── FloorMaintProcess

Floor ──── FloorRoom ──── Room ──── RoomCI ──── CI (Assets)
                                 └── RoomMaintProcess

Floor ──── FloorUnit ──── Unit ──── UnitCI ──── CI (Assets)
                                 └── UnitRoom ──── Room
```

---

## Asset Relationship Map

```
CI (any asset)
├── CIMaintProcess ──── MaintProcess (work orders)
├── CIListMaintProcess ──── MaintProcess (list of related maintenance)
├── CIConsumable ──── Consumable (spare parts associated with asset)
├── CISubsetCI ──── CISubset (logical grouping for PM)
├── CITopic ──── Topic (knowledge base)
├── ParentCICI ──── CI (parent-child CI relationship for components)
├── SupplierCI ──── Supplier (who supplies/maintains this asset)
├── InvoiceCI ──── Invoice (invoices for this asset)
└── DimensionsCI ──── Dimensions (dimensional specs)
```

---

## Maintenance Relationship Map

```
PrevMaintConfig ──── PrevConfigPrevMaint ──── PreventiveMaint
PrevMaintDef ──── PrevMaintDefConfig ──── PrevMaintConfig
PrevMaintDef ──── PrevMaintDefTask ──── PrevMaintTask
PreventiveMaint ──── MaintProcTasks ──── PrevMaintTasks (execution tracking)

Team ──── TeamPrevMaintConfig ──── PrevMaintConfig
Team ──── TeamCorrMaintConfig ──── CorrectMaintConfig
Team ──── TeamMaintProcess ──── MaintProcess
Team ──── TeamMaintSLA ──── MaintSLA

Company ──── CompPrevMaintConfig ──── PrevMaintConfig
Company ──── CompCorrectMaintConf ──── CorrectMaintConfig
Company ──── CompanyMaintProcess ──── MaintProcess

MaintSLA ──── ProcessMaintSLA ──── MaintProcess
MaintSLA ──── ContractMaintSLA ──── Contract
MaintSLA ──── SiteMaintSLA ──── Site

MaintCategory ──── MaintCatSubcat ──── MaintSubcategory
MaintCategory ──── CatCorrectMaintConf ──── CorrectMaintConfig
MaintSubcategory ──── SubcatCorrMaintConf ──── CorrectMaintConfig
MaintSubcategory ──── MaintSubcatMaintSLA ──── MaintSLA
MaintSubcategory ──── MaintSubcatMaintProc ──── MaintProcess

MaintenanceManual ──── MaintManualPrevConf ──── PrevMaintConfig
SiteMaintManual ──── Site ──── MaintenanceManual
```

---

## Financial Relationship Map

```
Budget ──── BudgetBudgetCenter ──── BudgetCenter
Budget ──── BudgetBudgetItem ──── BudgetItem
Site ──── SiteBudget ──── Budget
Site ──── SiteBudgetCenter ──── BudgetCenter
PartitionTable ──── PartitionTBudgetC ──── BudgetCenter

MaintProcess ──── MaintProcAccMov ──── AccountingMov (labour/material/generic costs)
Contract ──── ContractAccMov ──── AccountingMov
Site ──── SiteAccMov ──── AccountingMov
Contract ──── ContractPriceList ──── PriceList
PriceList ──── Map_PriceListPriceEntry ──── PriceListEntry
```

---

## Vendor/Contract Relationship Map

```
Company ──── CustomerContract ──── Contract (as customer)
Company ──── SupplierContract ──── Contract (as supplier)
Company ──── CompanyTeam ──── Team
Company ──── CompanyEmployee ──── Employee

Supplier ──── SupplierCI ──── CI (assets supplied by this supplier)
Supplier ──── SupplierPurchOrder ──── PurchaseOrder
Supplier ──── SupplierUser ──── User (portal access)

Contract ──── SiteContract ──── Site (which site is covered)
Contract ──── ContractMaintProcess ──── MaintProcess (work orders under contract)
Contract ──── ContractMaintSLA ──── MaintSLA
```

---

## Logistics Relationship Map

```
WrhMovement ──── WrhMovMovementRow ──── WrhMovementRow
WrhMovementRow ──── ConsblWrhMovRow ──── Consumable
WrhMovement ──── MaintProcWrhMov ──── MaintProcess (materials used in work order)
WrhMovement ──── DstSiteWrhMovement ──── Site (destination warehouse)
WrhMovement ──── SrcSiteWrhMovement ──── Site (source warehouse)
PurchaseOrder ──── PrchOrdWrhMov ──── WrhMovement
PurchaseOrder ──── SupplierPurchOrder ──── Supplier
PurchaseOrder ──── Map_PurchOrderOrderRow ──── PurchaseOrderRow
PurchaseOrderRow ──── PurchOrdRowWrhMovRow ──── WrhMovementRow
Consumable ──── DimensionConsumable ──── Dimensions
```

---

## People Relationship Map

```
Employee ──── UserEmployee ──── User (login account)
Employee ──── CompanyEmployee ──── Company (employer)
Employee ──── SupervisorTeam ──── Team (supervisory role)
Employee ──── EmployeeMaintProcess ──── MaintProcess
Team ──── TeamsEmployees ──── Employee
Team ──── TeamUser ──── User (portal access for team members)
```

---

## Calendar Relationship Map

```
CalendarEntity ──── (referenced from Site, Employee, Team via CalendarEntity attribute)
CalendarConfig (changes, events, mappings) ──── defines working hours per entity
CalendarMapCI ──── maps CalendarEntity to CI
CalendarMapSite ──── maps CalendarEntity to Site
CalendarMapTeam ──── maps CalendarEntity to Team
CalendarMapEmployee ──── maps CalendarEntity to Employee
```

The calendar system determines "working hours" for SLA `TimeCalcCriteria = Calendar`.

---

## Full Domain List (108 domains)

| Domain | Description |
|--------|-------------|
| AssetModbusConfig | Asset - Modbus configurations |
| BudgetBudgetCenter | Budget - Budget centers |
| BudgetBudgetItem | Budget - Budget items |
| BuildingCI | Building - Configuration items |
| BuildingFloor | Building - Floors |
| BuildingRoom | Building - Rooms |
| BuildingUnit | Building - Units |
| CIConsumable | Configuration items - Consumables |
| CIListMaintProcess | Configuration items - Maintenance processes |
| CIMaintProcess | Configuration item - Maintenance processes |
| CISubsetCI | CI subsets - Items |
| CISubsetMaintProcess | CI subset - Maintenance processes |
| CISubsetPrevMaintCnf | CI subset - Prev. maint. configurations |
| CITopic | CI - Topic |
| CatCorrectMaintConf | Category - Corrective maint. configurations |
| CompCorrectMaintConf | Company - Correct. maint. configs |
| CompPrevMaintConfig | Company - Prev. maint. configs |
| CompanyEmployee | Company - Employees |
| CompanyMaintProcess | Company - Maintenance processes |
| CompanyTeam | Company - Teams |
| ComplexBuilding | Complex - Buildings |
| ComplexCI | Complex - Configuration items |
| ComplexFloor | Complex - Floors |
| ComplexRoom | Complex - Rooms |
| ConsblWrhMovRow | Consumable - Warehouse movement rows |
| ContractAccMov | Contract - Accounting movements |
| ContractMaintProcess | Contract - MaintProcesses |
| ContractMaintSLA | Contract - Maintenance SLAs |
| ContractPriceList | Contracts - Price lists |
| CustomerContract | Company - Contracts (as customer) |
| DimensionConsumable | Dimension - Consumables |
| DimensionsCI | Dimensions - CI |
| DstSiteWrhMovement | Site - Warehouse movements (destination) |
| EmployeeMaintProcess | Employee - Maintenance processes |
| FloorCI | Floor - Configuration items |
| FloorMaintProcess | Floor - Maintenance processes |
| FloorRoom | Floor - Rooms |
| FloorUnit | Floor - Units |
| InvoiceCI | Invoice - Configuration items |
| MaintCatMaintProcess | Category - Maintenance processes |
| MaintCatSubcat | Category - Subcategories |
| MaintCatTopic | Category - Topics |
| MaintManualPrevConf | Maintenance manual - Prev. maint. configs |
| MaintProcAccMov | MaintProcess - Accounting movements |
| MaintProcTasks | Maintenance process - Prev. maint. tasks |
| MaintProcWrhMov | Maint process - Warehouse movements |
| MaintProcessTopic | Maintenance processes - Topics |
| MaintSubcatMaintProc | Subcategory - Maintenance processes |
| MaintSubcatMaintSLA | Subcategory - Maintenance SLAs |
| MaintSubcatTopic | Subcategory - Topics |
| ParentCICI | Parent CI - CIs (component relationship) |
| PartitionTBudgetC | Partition table - Budget centers |
| PrchOrdWrhMov | Purchase order - Warehouse movements |
| PrevConfigPrevMaint | Prev. maint. configuration - Preventive maintenances |
| PrevMaintDefConfig | Prev. maint. definition - Prev. maint. configs |
| PrevMaintDefTask | PrevMaintDef - PrevMaintTask |
| ProcessMaintSLA | Processes - Maintenance SLAs |
| PurchOrdRowWrhMovRow | Purch. order row - Wrh. movement rows |
| RequesterMaintProc | Requester - Maintenance processes |
| RoomCI | Room - Configuration items |
| RoomMaintProcess | Room - Maintenance processes |
| SiteAccMov | Site - Accounting movements |
| SiteBudget | Site - Budgets |
| SiteBudgetCenter | Site - Budget centers |
| SiteCISubset | Site - CI subsets |
| SiteContract | Site - Contracts |
| SiteCorrMaintConfig | Sites - Corrective maint. configurations |
| SiteMaintManual | Site - Maintenance manuals |
| SiteMaintProcess | Site - Maintenance processes |
| SiteMaintSLA | Site - Maintenance SLAs |
| SitePartitionTable | Site - Partition tables |
| SitePrevMaintConfig | Site - Prev. maint. configurations |
| SrcSiteWrhMovement | Site - Warehouse movements (source) |
| SubcatCorrMaintConf | Subcategory - Corrective maint. configurations |
| SupervisorTeam | Employee - Teams (supervisory) |
| SupplierCI | Supplier - Configuration items |
| SupplierContract | Company - Contracts (as supplier) |
| SupplierPurchOrder | Supplier - Purchase orders |
| SupplierUser | Suppliers - Users |
| TeamCorrMaintConfig | Team - Corrective maint. configurations |
| TeamMaintProcess | Team - Maintenance processes |
| TeamMaintSLA | Team - Maintenance SLAs |
| TeamPrevMaintConfig | Team - Prev. maint. configurations |
| TeamUser | Teams - Users |
| TeamsEmployees | Teams - Employees |
| UnitCI | Unit - Configuration items |
| UnitPartitionTableR | Unit - Partition tables |
| UnitRoom | Unit - Rooms |
| UserConfigUser | User config - Users |
| UserEmployee | User - Employees |
| WrhMovMovementRow | Warehouse movement - Warehouse movement rows |

*Note: 108 domains retrieved from API; some calendar-specific domains are in the DB but may not appear in all API responses.*
