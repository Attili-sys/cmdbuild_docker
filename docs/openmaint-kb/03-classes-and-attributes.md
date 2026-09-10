# 03 — Classes and Attributes

**Source:** API `/classes` (209 classes), `/classes/{name}/attributes` (6,105 attributes)  
**Classification:** STANDARD OPENMAINT

---

## Summary

| Metric | Count |
|--------|-------|
| Total classes | 209 |
| Prototype (abstract) | ~40 |
| Concrete (non-prototype) | ~169 |
| Attributes across all classes | 6,105 |

For the full class hierarchy, see `02-data-model.md`.  
For domain relationships between classes, see `04-domains-and-relations.md`.

---

## Class Categories

### Location / Facility Classes (all inherit from Site)

| Class | Prototype | Parent | Key purpose |
|-------|-----------|--------|-------------|
| Site | Yes | Class | Abstract superclass for all locations |
| Complex | No | Site | Campus, business park, or complex |
| Building | No | Site | Physical building structure |
| Floor | No | Site | Level within a building |
| Unit | No | Site | Tenant unit, apartment, or suite |
| Room | No | Site | Individual room or space |

Common Site attributes (inherited by all): Code, Description, Name, Notes, State, Address, ZIP, City, Condition, Criticality, area fields, Photo, ServiceStatus, CalendarEntity. See `06-facilities-and-assets.md` for full attribute lists.

---

### Asset / CI Classes (all inherit from CI)

**CI (Configuration Item)** — abstract root  
Common CI attributes (inherited by all): Code, Description, Brand, State, Condition, Criticality, Type

#### Device classes (inherit from Device → Asset → CI)

| Device Category | Concrete Classes |
|----------------|-----------------|
| BurglarDevice | AccessControlDevice, Barrier, CommandUnit, ControlUnit, DoorWindowSensor, MotionSensor, Siren, SurveillanceDevice |
| ClimateControlDevice | AirHandlingUnit, Boiler, Chiller, CoolingTower, FanCoil, HeatPump, Radiator, SolarThermal, Split, WaterHeater |
| ConveyorDevice | HandlingDevice, LiftingDevice, MovementDevice |
| DisposalDevice | GasDisposal, SolidDisposal, WaterDisposal |
| ElectricalDevice | AuxiliaryPowerSupply, Disconnector, ElectricalPanel, Generator, Grounding, LightingFixture, PFC, PowerSubstation, StandbyPower, Transformer |
| FireProtectionDevice | Alarm, Detector, EmergencyLightingDev, Evacuator, FireExtinguisher, FireHoseReel, FireHydrant, FirePartition, ReleaseButton, Sprinkler |
| GasDistroDevice | Compressor, TechnicalGasSupply |
| HealthSafetyDevice | MedicalDevice, PPEDevice |
| MechanicalDevice | Drill, GrindingMachine, Lathe, MarkingMachine, MillingMachine, PartsWasher, SawingMachine, Sharpener, Shredder, WeldingMachine |
| SanitationDevice | Bathtub, Shower, Sink, Toilet, WaterPump |
| TLCDevice | Computer, FixedTelephony, MobileTelephony, Network, Peripheral, Server |

Note: `FireExtinguisher` has additional attribute `FireClass` [A/B/C/D/E/F].

#### Finishing classes (inherit from Finishing → Asset → CI)

| Class | Notes |
|-------|-------|
| Fixture | Fixed interior fittings |
| Furniture | Abstract for furniture items |
| Accessory | Small furniture accessory |
| Bed | Bed/medical bed |
| Decor | Decorative furniture |
| Seat | Chair, bench, seating |
| SupportSurface | Desk, table, counter — has GIS area attribute |
| Staircase | Interior staircase |

#### Item classes (inherit from Item → Asset → CI)

| Class | Notes |
|-------|-------|
| Component | Component part of another asset |
| Meter | Utility meter — has GIS position attribute |
| Sensor | Sensor device |

#### Machinery classes

| Class | Notes |
|-------|-------|
| Apparatus | General apparatus |
| ProductionMachinery | Production/manufacturing machinery |
| ManufacturingPlant | Manufacturing plant |

#### Structural element classes

| Class | Notes |
|-------|-------|
| ArchitecturalElement | Architectural feature |
| Construction | Building element |
| Slab | Concrete slab |
| Wall | Wall — structural or partition |

#### Outdoor / other CI classes

| Class | Notes |
|-------|-------|
| Equipment | General equipment (simpler than Device) |
| GreenArea | Outdoor green/garden area — GIS polygon |
| Vegetation | Outdoor vegetation |
| ParkingLot | Parking area — GIS polygon |
| RoadAsset | Road asset (abstract) |
| Artifact | Road artifact |
| Tunnel | Tunnel |
| Signage | Outdoor signage |

---

### System/Plant Classes (inherit from SystemPlant → CI)

| Class | Notes |
|-------|-------|
| BurglarSystem | Security system grouping |
| ClimateControlSystem | HVAC system grouping |
| ConveyorSystem | Elevator/lift system grouping |
| DisposalSystem | Waste/drainage system |
| ElectricalSystem | Electrical system grouping |
| FireProtectionSystem | Fire safety system |
| GasDistroSystem | Gas distribution system |
| GroundingSystem | Grounding system |
| MechanicalSystem | Mechanical system |
| SanitationSystem | Sanitation/plumbing system |
| TLCSystem | Telecom/IT system |
| Plant | Abstract — facility plant |
| ManufacturingPlant | Subclass of Plant |

---

### Process Classes

| Class | Prototype | Parent | Startable |
|-------|-----------|--------|-----------|
| Activity | Yes | Class | No |
| Process | Yes | Activity | No |
| MaintProcess | Yes | Process | No |
| CorrectiveMaint | No | MaintProcess | **Yes** |
| PreventiveMaint | No | MaintProcess | **Yes** |

---

### Company / People Classes

| Class | Parent | Notes |
|-------|--------|-------|
| Company | Class | Abstract |
| Supplier | Company | External service provider |
| Customer | Company | Building occupant / internal customer |
| CorporateGroup | Company | Holding / parent company |
| Employee | Class | Abstract |
| InternalEmployee | Employee | Staff member |
| ExternalEmployee | Employee | External person |
| SupplierEmployee | Employee | Supplier staff |
| CustomerEmployee | Employee | Customer staff |
| Team | Class | Maintenance team |
| User | Class | System user (login) |
| Role | Class | System role |

---

### Contract Classes

| Class | Parent | Notes |
|-------|--------|-------|
| Contract | Class | Abstract superclass |
| ServiceProvision | Contract | Maintenance/service AMC |
| PurchAgreement | Contract | Framework purchasing agreement |
| Rent | Contract | Rental agreement |
| Utility | Contract | Electricity, water, gas, telecom |

---

### Maintenance Support Classes

| Class | Parent | Notes |
|-------|--------|-------|
| MaintCategory | Class | Maintenance category (top-level) |
| MaintSubcategory | Class | Sub-category (linked to MaintCategory) |
| MaintSLA | Class | SLA definition |
| PrevMaintConfig | Class | PM schedule configuration |
| PrevMaintDef | Class | PM activity definition |
| PrevMaintTask | Class | PM checklist task |
| PrevMaintTasks | Class | PM task execution tracking |
| MaintenanceManual | Class | Maintenance documentation |
| CorrectMaintConfig | Class | CM category configuration |
| CISubset | Class | Asset grouping for PM |
| Topic | Class | Knowledge base entry |
| Survey | Class | Requester satisfaction feedback |

---

### Financial / Logistics Classes

| Class | Parent | Notes |
|-------|--------|-------|
| Budget | Class | Budget record |
| BudgetCenter | Class | Organizational budget center |
| BudgetItem | Class | Budget line item |
| AccountingMov | Class | Abstract cost/revenue movement |
| GenericAccMov | AccountingMov | Generic cost entry |
| LabourAccMov | AccountingMov | Labour cost |
| MaterialAccMov | AccountingMov | Material cost |
| PriceList | Class | Price list header |
| PriceListEntry | Class | Abstract |
| LabourPriceList | PriceListEntry | Labour rate |
| MaterialPriceList | PriceListEntry | Material price |
| PurchaseOrder | Class | Purchase order header |
| PurchaseOrderRow | Class | PO line item |
| Invoice | Class | Invoice document |
| Consumable | Class | Spare part / material catalog item |
| WrhMovement | Class | Warehouse movement header |
| WrhMovementRow | Class | Warehouse movement line |
| PartitionTable | Class | Cadastral partition for cost allocation |
| PartitionTableRow | Class | Partition table row |

---

### Document Classes

| Class | Parent | Notes |
|-------|--------|-------|
| DmsModel | Class | Abstract document superclass |
| BaseDocument | DmsModel | General document |
| DmsEnergyPerformCert | DmsModel | Energy performance certificate |

---

### Calendar Classes

| Class | Notes |
|-------|-------|
| CalendarEntity | Calendar schedule entity |
| CalendarConfig | Abstract config |
| CalendarChange | Change record |
| CalendarChgCI/Default/Employee/Site/Team | Specific change types |
| CalendarEvent | Calendar event |
| CalendarMapping | Resource mapping |
| CalendarMapCI/Default/Employee/Site/Team | Specific mapping types |

---

### Energy / Monitoring Classes

| Class | Notes |
|-------|-------|
| Meter | Item subclass — physical meter (has GIS) |
| MeterReading | SimpleClass — individual reading |
| Consumption | SimpleClass — aggregated consumption |
| ModbusConfig | Modbus protocol configuration |
| Sensor | Item subclass — sensing device |

---

### System / Platform Classes

| Class | Notes |
|-------|-------|
| NewsItem | Internal news/announcements |
| Parameter | System parameter |
| Dimensions | Physical dimensions specification |
| Email | Email record |
| Survey | Satisfaction survey |
| ProcessFlowLog | SimpleClass — workflow audit log |
| PortalSession | SimpleClass — portal session tracking |
