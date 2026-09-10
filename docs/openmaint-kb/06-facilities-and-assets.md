# 06 — Facilities and Assets

**Source:** Running API `/classes/{name}/attributes`, PostgreSQL hierarchy  
**Classification:** STANDARD OPENMAINT

---

## Location Hierarchy

openMAINT uses a 5-level location hierarchy. All location classes inherit from `Site`.

```
Complex (campus/site group)
  └── Building (physical structure)
        └── Floor (level of a building)
              ├── Unit (tenant unit / apartment / suite)
              │     └── Room (individual space)
              └── Room (directly on floor)
```

Note: Rooms can be linked to Complex, Building, Floor, and Unit simultaneously via separate reference fields. The navigation tree typically follows Building → Floor → Room.

---

## Location Classes — Key Attributes

### Site (abstract superclass — common fields)

All location subclasses inherit:

| Attribute | Type | Notes |
|-----------|------|-------|
| Code | string | Identifier |
| Description | string | Label |
| Name | string | Display name |
| Notes | text | Free text |
| State | lookup [Site - State] | Used / Rent / Vacant |
| Address, ZIP, City | string | |
| Condition | lookup [Site - Condition] | Excellent / Good / MaintRequired / Poor |
| Criticality | lookup [COMMON - Criticality] | low / moderate / high / extreme |
| TotalNetArea, TotalGrossArea | double | Area measurements |
| CoveredArea, CleanableArea, GlazedArea | double | |
| TotalHeatedVolume, TotalVolume | double | |
| TotalRooms, TotalUnits | integer | Summary counters |
| Photo | file | Image attachment |
| ServiceStatus | lookup [CalendarConfig - ServiceStatus] | Calendar / Operative / Inoperative |
| CalendarEntity | reference → CalendarEntity | Links to maintenance calendar |

### Complex

Additional to Site:
| Attribute | Type | Notes |
|-----------|------|-------|
| Country | lookup [COMMON - Country] | |
| TotalBuildings | integer | Summary counter |
| TotalFloors | integer | Summary counter |

### Building

Additional to Site:
| Attribute | Type | Notes |
|-----------|------|-------|
| MainUse | lookupArray [Building - MainUse] | Commercial / Cultural / Office / Residential / Recreational + 2 more |
| Complex | reference → Complex | Parent complex |
| Country | lookup [COMMON - Country] | |
| Coordinates | string | ⚠ Text field — not a GIS geometry. GIS uses `_GisAttribute` Position (point) |

**GIS:** `Building` has a `Position` GIS attribute (point geometry) at zoom 2–17.  
**BIM:** Buildings are linked to BIM projects via `_BimObject`.

### Floor

Additional to Site:
| Attribute | Type | Notes |
|-----------|------|-------|
| Level | lookup [Floor - Level] | Values: -3 to 17.5 |
| Complex | reference → Complex | |
| Building | reference → Building | Parent building |

**GIS:** `Floor` has a `Drawing` GIS attribute (shape type) at zoom 18–25.

### Unit

Additional to Site:
| Attribute | Type | Notes |
|-----------|------|-------|
| Complex | reference → Complex | |
| Building | reference → Building | |
| Floor | reference → Floor | |
| CadastralArea, UrbanSection, Sheet, Plot, Subordinate | string | Cadastral/legal identifiers |
| Category | lookup [Unit - CadastralCategory] | A1–A11, B1–B8, C1–C7, D1–D10, etc. (51 values) |
| Size | double | Net size |
| CadastralIncome | decimal | Financial value |
| PropertyRightsDuties | text | Legal notes |

**GIS:** `Unit` has an `Area` GIS attribute (polygon) at zoom 18–25.

### Room

Additional to Site:
| Attribute | Type | Notes |
|-----------|------|-------|
| Use | lookupArray [Room - Use] | Office / Depot / Canteen / Cellar / Toilet + 4 more |
| Complex | reference → Complex | |
| Building | reference → Building | |
| Floor | reference → Floor | |
| Unit | reference → Unit | |
| Height | double | Room height |
| Heated | boolean | |
| TotalHeatedVolume, TotalVolume | double | Calculated from height × area |

**GIS:** `Room` has an `Area` GIS attribute (polygon) at zoom 18–25.

---

## Asset Hierarchy

All assets inherit from `CI` (Configuration Item). Key shared CI attributes:

| Attribute | Type | Notes |
|-----------|------|-------|
| Code | string | Asset code / serial number area |
| Description | string | |
| Brand | lookup [CI - Brand] | 12 values: IBM, ACER, SONY, HP, Everbilt, etc. |
| State | lookup [CI - State] | InStock / UnderMaint / Disposed / InUse |
| Condition | lookup [CI - Condition] | Working / Inspection / Broken |
| Criticality | lookup [COMMON - Criticality] | low / moderate / high / extreme |
| Type | lookup [CI - Type] | 324 values — very large, covers all asset type variants |

### The CI → Asset → Device Hierarchy

```
CI  (any configuration item)
├── Asset  (physical maintainable asset)
│   ├── Device  (individual equipment item)
│   │   ├── BurglarDevice  → 8 types (access control, barriers, sensors, etc.)
│   │   ├── ClimateControlDevice  → 10 types (AHU, Chiller, Boiler, Split, etc.)
│   │   ├── ConveyorDevice  → 3 types (lifting, handling, movement)
│   │   ├── DisposalDevice  → 3 types (gas, solid, water disposal)
│   │   ├── ElectricalDevice  → 10 types (Generator, UPS/StandbyPower, Panel, Transformer, etc.)
│   │   ├── FireProtectionDevice  → 10 types (Alarm, Detector, Extinguisher, Sprinkler, etc.)
│   │   ├── GasDistroDevice  → 2 types (Compressor, TechnicalGasSupply)
│   │   ├── HealthSafetyDevice  → 2 types (MedicalDevice, PPEDevice)
│   │   ├── MechanicalDevice  → 11 types (workshop/production machinery)
│   │   ├── SanitationDevice  → 5 types (Bathtub, Shower, Sink, Toilet, WaterPump)
│   │   └── TLCDevice  → 6 types (Computer, Server, Network, Phones, Peripheral)
│   ├── Finishing  (non-mechanical interior elements)
│   │   ├── Fixture
│   │   ├── Furniture  → 5 subtypes (Chair/Seat, Bed, Desk/SupportSurface, Accessory, Decor)
│   │   └── Staircase
│   ├── Item  (smaller measured/sensed items)
│   │   ├── Component
│   │   ├── Meter  ← energy/utility meter
│   │   └── Sensor
│   ├── Machinery  (production/industrial machinery)
│   │   ├── Apparatus
│   │   └── ProductionMachinery
│   └── StructuralElement
│       ├── ArchitecturalElement
│       ├── Construction
│       ├── Slab
│       └── Wall
├── Equipment  (standalone equipment, simpler than Device)
├── OutdoorElement
│   ├── Greenery  → GreenArea, Vegetation
│   └── UrbanInfrastructure  → ParkingLot, RoadAsset (Artifact, Tunnel), Signage
└── SystemPlant  (systems and logical groups)
    ├── System  → 11 system types
    └── Plant  → ManufacturingPlant
```

---

## Linking Assets to Locations

Assets are linked to locations through **domains** (not by location reference fields directly on the CI):

| Domain | Links | Description |
|--------|-------|-------------|
| `RoomCI` | Room → CI | Assets physically located in a room |
| `FloorCI` | Floor → CI | Assets on a floor (without a specific room) |
| `BuildingCI` | Building → CI | Assets in a building |
| `ComplexCI` | Complex → CI | Assets in a complex |
| `UnitCI` | Unit → CI | Assets in a unit |

A CI can only be in one location at a time — this is enforced by UI convention, not a database constraint. The nav tree shows the CI hierarchy following these domains.

---

## Systems and Plants

`SystemPlant` is a parallel hierarchy to individual assets. Systems represent logical groupings:

- `FireProtectionSystem` groups all fire protection devices in a location
- `ClimateControlSystem` groups HVAC components
- `ElectricalSystem` groups all electrical devices

The domain `CISubsetCI` supports grouping of CIs into logical subsets (`CISubset`) which is used for batch maintenance configuration.

---

## AJMN Relevance

| AJMN requirement | openMAINT class | Notes |
|-----------------|-----------------|-------|
| Campus / site | Complex | NATIVE |
| Building | Building | NATIVE |
| Floor | Floor | NATIVE |
| Room / space | Room | NATIVE |
| Studio | Room (Use lookup) | Add "Studio" to Room - Use lookup |
| Technical room | Room (Use lookup) | Add "Technical Room" lookup value |
| Security gate | AccessControlDevice + Barrier | Both exist as concrete classes |
| Generator | Generator (ElectricalDevice subclass) | NATIVE |
| HVAC / chiller | AirHandlingUnit, Chiller, CoolingTower, FanCoil, HeatPump, Split | NATIVE — all exist |
| Elevator / lift | LiftingDevice (ConveyorDevice) | NATIVE |
| UPS | AuxiliaryPowerSupply or StandbyPower | NATIVE (two relevant classes) |
| Electrical panels | ElectricalPanel | NATIVE |
| Fire systems | FireProtectionDevice hierarchy | NATIVE — 10 types |
| Technical assets (general) | Device → specific subclass | NATIVE |
| GIS positioning | Building/Position (point), Room/Area (polygon), Floor/Drawing | NATIVE |
