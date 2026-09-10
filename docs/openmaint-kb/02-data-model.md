# 02 — Data Model Overview

**Source:** PostgreSQL `pg_inherits` / `pg_class` (read-only)  
**Classification:** STANDARD OPENMAINT

---

## Class Hierarchy Tree

The following hierarchy is derived from PostgreSQL table inheritance, which is how CMDBuild implements class inheritance. Every business class inherits from `Class`. Every Map (domain) table inherits from `Map`.

```
Class (root)
├── AccountingMov  [abstract superclass]
│   ├── GenericAccMov
│   ├── LabourAccMov
│   └── MaterialAccMov
├── Activity  [process superclass, abstract]
│   └── Process  [abstract]
│       └── MaintProcess  [abstract]
│           ├── CorrectiveMaint  ← ACTIVE PROCESS
│           └── PreventiveMaint  ← ACTIVE PROCESS
├── Budget
├── BudgetCenter
├── BudgetItem
├── CI  [Configuration Item — abstract superclass for all assets]
│   ├── Asset  [abstract]
│   │   ├── Device  [abstract]
│   │   │   ├── BurglarDevice  [abstract]
│   │   │   │   ├── AccessControlDevice
│   │   │   │   ├── Barrier
│   │   │   │   ├── CommandUnit
│   │   │   │   ├── ControlUnit
│   │   │   │   ├── DoorWindowSensor
│   │   │   │   ├── MotionSensor
│   │   │   │   ├── Siren
│   │   │   │   └── SurveillanceDevice
│   │   │   ├── ClimateControlDevice  [abstract]
│   │   │   │   ├── AirHandlingUnit
│   │   │   │   ├── Boiler
│   │   │   │   ├── Chiller
│   │   │   │   ├── CoolingTower
│   │   │   │   ├── FanCoil
│   │   │   │   ├── HeatPump
│   │   │   │   ├── Radiator
│   │   │   │   ├── SolarThermal
│   │   │   │   ├── Split
│   │   │   │   └── WaterHeater
│   │   │   ├── ConveyorDevice  [abstract]
│   │   │   │   ├── HandlingDevice
│   │   │   │   ├── LiftingDevice
│   │   │   │   └── MovementDevice
│   │   │   ├── DisposalDevice  [abstract]
│   │   │   │   ├── GasDisposal
│   │   │   │   ├── SolidDisposal
│   │   │   │   └── WaterDisposal
│   │   │   ├── ElectricalDevice  [abstract]
│   │   │   │   ├── AuxiliaryPowerSupply
│   │   │   │   ├── Disconnector
│   │   │   │   ├── ElectricalPanel
│   │   │   │   ├── Generator
│   │   │   │   ├── Grounding
│   │   │   │   ├── LightingFixture
│   │   │   │   ├── PFC
│   │   │   │   ├── PowerSubstation
│   │   │   │   ├── StandbyPower
│   │   │   │   └── Transformer
│   │   │   ├── FireProtectionDevice  [abstract]
│   │   │   │   ├── Alarm
│   │   │   │   ├── Detector
│   │   │   │   ├── EmergencyLightingDev
│   │   │   │   ├── Evacuator
│   │   │   │   ├── FireExtinguisher
│   │   │   │   ├── FireHoseReel
│   │   │   │   ├── FireHydrant
│   │   │   │   ├── FirePartition
│   │   │   │   ├── ReleaseButton
│   │   │   │   └── Sprinkler
│   │   │   ├── GasDistroDevice  [abstract]
│   │   │   │   ├── Compressor
│   │   │   │   └── TechnicalGasSupply
│   │   │   ├── HealthSafetyDevice  [abstract]
│   │   │   │   ├── MedicalDevice
│   │   │   │   └── PPEDevice
│   │   │   ├── MechanicalDevice  [abstract]
│   │   │   │   ├── Drill
│   │   │   │   ├── GrindingMachine
│   │   │   │   ├── Lathe
│   │   │   │   ├── MarkingMachine
│   │   │   │   ├── MillingMachine
│   │   │   │   ├── PartsWasher
│   │   │   │   ├── SawingMachine
│   │   │   │   ├── Sharpener
│   │   │   │   ├── Shredder
│   │   │   │   └── WeldingMachine
│   │   │   ├── SanitationDevice  [abstract]
│   │   │   │   ├── Bathtub
│   │   │   │   ├── Shower
│   │   │   │   ├── Sink
│   │   │   │   ├── Toilet
│   │   │   │   └── WaterPump
│   │   │   └── TLCDevice  [abstract — Telecom]
│   │   │       ├── Computer
│   │   │       ├── FixedTelephony
│   │   │       ├── MobileTelephony
│   │   │       ├── Network
│   │   │       ├── Peripheral
│   │   │       └── Server
│   │   ├── Finishing  [abstract]
│   │   │   ├── Fixture
│   │   │   ├── Furniture  [abstract]
│   │   │   │   ├── Accessory
│   │   │   │   ├── Bed
│   │   │   │   ├── Decor
│   │   │   │   ├── Seat
│   │   │   │   └── SupportSurface
│   │   │   └── Staircase
│   │   ├── Item  [abstract]
│   │   │   ├── Component
│   │   │   ├── Meter
│   │   │   └── Sensor
│   │   ├── Machinery  [abstract]
│   │   │   ├── Apparatus
│   │   │   └── ProductionMachinery
│   │   └── StructuralElement  [abstract]
│   │       ├── ArchitecturalElement
│   │       ├── Construction
│   │       ├── Slab
│   │       └── Wall
│   ├── Equipment
│   ├── OutdoorElement  [abstract]
│   │   ├── Greenery  [abstract]
│   │   │   ├── GreenArea
│   │   │   └── Vegetation
│   │   └── UrbanInfrastructure  [abstract]
│   │       ├── ParkingLot
│   │       ├── RoadAsset  [abstract]
│   │       │   ├── Artifact
│   │       │   └── Tunnel
│   │       └── Signage
│   └── SystemPlant  [abstract — systems and plants]
│       ├── Plant  [abstract]
│       │   └── ManufacturingPlant
│       └── System  [abstract]
│           ├── BurglarSystem
│           ├── ClimateControlSystem
│           ├── ConveyorSystem
│           ├── DisposalSystem
│           ├── ElectricalSystem
│           ├── FireProtectionSystem
│           ├── GasDistroSystem
│           ├── GroundingSystem
│           ├── MechanicalSystem
│           ├── SanitationSystem
│           └── TLCSystem
├── CISubset
├── CalendarConfig  [abstract]
│   ├── CalendarChange  [abstract]
│   │   ├── CalendarChgCI
│   │   ├── CalendarChgDefault
│   │   ├── CalendarChgEmployee
│   │   ├── CalendarChgSite
│   │   └── CalendarChgTeam
│   ├── CalendarEvent
│   └── CalendarMapping  [abstract]
│       ├── CalendarMapCI
│       ├── CalendarMapDefault
│       ├── CalendarMapEmployee
│       ├── CalendarMapSite
│       └── CalendarMapTeam
├── CalendarEntity
├── Company  [abstract]
│   ├── CorporateGroup
│   ├── Customer
│   └── Supplier
├── Consumable
├── Contract  [abstract]
│   ├── PurchAgreement
│   ├── Rent
│   ├── ServiceProvision
│   └── Utility
├── CorrectMaintConfig
├── Dimensions
├── DmsModel  [abstract — document classes]
│   ├── BaseDocument
│   └── DmsEnergyPerformCert
├── Email
├── Employee  [abstract]
│   ├── CustomerEmployee
│   ├── ExternalEmployee
│   ├── InternalEmployee
│   └── SupplierEmployee
├── Invoice
├── LookUp  [system]
├── MaintCategory
├── MaintSLA
├── MaintSubcategory
├── MaintenanceManual
├── ModbusConfig
├── NewsItem
├── Parameter
├── PartitionTable
├── PartitionTableRow
├── PrevMaintConfig
├── PrevMaintDef
├── PrevMaintTask
├── PrevMaintTasks
├── PriceList
├── PriceListEntry  [abstract]
│   ├── LabourPriceList
│   └── MaterialPriceList
├── PurchaseOrder
├── PurchaseOrderRow
├── Role  [system]
├── Site  [abstract — locations]
│   ├── Complex
│   ├── Building
│   ├── Floor
│   ├── Unit
│   └── Room
├── Survey
├── Team
├── Topic
├── User  [system]
├── WrhMovement
└── WrhMovementRow

SimpleClass  [root for non-card simple records]
├── Consumption
├── MeterReading
├── PortalSession
└── ProcessFlowLog
```

---

## Key Counts

| Category | Count |
|----------|-------|
| Total classes (API) | 209 |
| Abstract/superclass | ~40 |
| Concrete leaf classes | ~169 |
| Location classes | 6 (Complex, Building, Floor, Unit, Room + Site superclass) |
| Asset leaf classes | ~80 |
| System/Plant classes | 12 |
| Employee types | 4 |
| Company types | 3 |
| Contract types | 4 |
| Process classes | 5 |
| Document classes | 2 |

---

## Notes on the Model

1. **`Site` is the abstract superclass** for all locations. Buildings, floors, rooms, and complexes all inherit from Site and carry common fields (address, areas, condition, criticality, service status).

2. **`CI` (Configuration Item) is the abstract superclass** for all physical assets. Every concrete asset type ultimately inherits from CI.

3. **`SystemPlant`** represents logical systems and plants — a level above individual devices. A `FireProtectionSystem` contains `FireExtinguisher`, `Sprinkler`, `Alarm`, etc. items.

4. **`MaintProcess` is the abstract workflow superclass** — `PreventiveMaint` and `CorrectiveMaint` are the two concrete workflow types that users start and progress.

5. **`Company` covers both suppliers and customers** — `Supplier` and `Customer` are both subclasses of Company.

6. **`Employee` types are separate classes** (not just a field value): Internal, External, SupplierEmployee, CustomerEmployee.

7. **`Consumable`** is a standalone class — NOT in the CI hierarchy. This is the spare-parts/materials class used in warehouse movements and work orders.
