# 15 — Energy Management

**Source:** API class attributes, lookup analysis  
**Classification:** STANDARD OPENMAINT

---

## Overview

openMAINT includes basic energy and utility management through the `Meter`, `MeterReading`, `Consumption`, and `Utility` classes. This is a lightweight energy tracking module, not a full ISO 50001 energy management system.

---

## Classes

### Meter

`Meter` is a subclass of `Item` (in the CI/Asset hierarchy). Meters are physical measurement devices.

| Attribute | Type | Notes |
|-----------|------|-------|
| Code, Description | string | |
| Brand, State, Condition | inherited from CI | |
| Type | lookup [CI - Type] | |

Meter has a GIS attribute: **Position** (point) at zoom 20–25.

Meters are linked to assets (the thing being measured) via the standard CI domain structure.

### MeterReading (SimpleClass)

Individual meter readings are stored as `MeterReading` (a SimpleClass, not a full card):

| Attribute | Type | Notes |
|-----------|------|-------|
| ReadingType | lookup [COMMON - ReadingType] | BatteryStatus / DeviceStatus / ElectricalEnergy / GasVolume / RadioLevel / etc. (10 values) |
| MeasureType | lookup [COMMON - MeasureType] | Alarm / Energy / Identifier / RadioLevel / VolumeFlow / etc. (11 values) |

Readings are linked to meters. The full reading attribute list was not enumerated in this inspection — **PARTIALLY CONFIRMED**.

### Consumption (SimpleClass)

`Consumption` tracks aggregated consumption data (derived from readings).

### Utility Contract

The `Utility` contract subclass tracks utility service agreements:

| Utility - Type lookup values |
|------------------------------|
| Electricity |
| Electricity + Gas |
| Gas |
| Water |
| Landline |
| + 2 more |

Utility contracts are linked to sites via `SiteContract`.

### DmsEnergyPerformCert

`DmsEnergyPerformCert` (subclass of `DmsModel`) stores Energy Performance Certificates as documents:

| Attribute | Type | Values |
|-----------|------|--------|
| Rating | lookup | A / B / C / D / E / F / G |
| Seasonal rating | lookup | Low / Medium / High |

---

## ModbusConfig

The `ModbusConfig` class exists with attributes for Modbus protocol configuration:

| Attribute | Type | Values |
|-----------|------|--------|
| ConversionRule | lookup | Ratio / Mask |
| DataSize | lookup | 16 / 32 bit |
| DataType | lookup | INT / UINT / IEEE754 / BOOL / WORD |
| State | lookup | Active / NotActive |

Linked to assets via `AssetModbusConfig` domain. This suggests a planned or partial Modbus sensor/BMS integration capability. **NOT CONFIRMED** whether this results in live data reading or is purely a configuration reference.

---

## AJMN Notes

openMAINT's energy management is basic — suitable for:
- Recording utility meter readings manually
- Attaching energy performance certificates to buildings
- Tracking utility contracts (electricity, water, gas)

**Gaps for AJMN:**
- No real-time BMS integration (would require middleware)
- No automated meter reading collection
- No energy KPI dashboards out of the box
- No ISO 50001 compliance tracking
- No utility billing integration

For AJMN's energy monitoring needs: integrate a dedicated energy management system or IoT middleware that pushes readings to openMAINT `MeterReading` records via REST API.
