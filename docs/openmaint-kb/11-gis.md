# 11 — GIS

**Source:** DB `_GisAttribute` table, `gis` schema tables  
**Classification:** STANDARD OPENMAINT

---

## GIS Configuration Summary

openMAINT ships with GIS attributes configured on 13 classes. All are verified from the `_GisAttribute` table.

| Class | Attribute Name | Geometry Type | Zoom Min | Zoom Max | Schema Table |
|-------|---------------|---------------|----------|----------|--------------|
| Building | Position | point | 2 | 17 | `gis.Gis_Building_Position` |
| Computer | Position | point | 20 | 25 | `gis.Gis_Computer_Position` |
| FireExtinguisher | Position | point | 20 | 25 | `gis.Gis_FireExtinguisher_Position` |
| Floor | Drawing | shape | 18 | 25 | *(Floor GIS table)* |
| GreenArea | Area | polygon | 18 | 25 | `gis.Gis_GreenArea_Area` |
| Meter | Position | point | 20 | 25 | `gis.Gis_Meter_Position` |
| ParkingLot | Area | polygon | 18 | 25 | `gis.Gis_ParkingLot_Area` |
| Room | Area | polygon | 18 | 25 | `gis.Gis_Room_Area` |
| Sink | Position | point | 20 | 25 | `gis.Gis_Sink_Position` |
| Split | Position | point | 20 | 25 | `gis.Gis_Split_Position` |
| SupportSurface | Area | polygon | 20 | 25 | `gis.Gis_SupportSurface_Area` |
| Toilet | Position | point | 20 | 25 | `gis.Gis_Toilet_Position` |
| Unit | Area | polygon | 18 | 25 | `gis.Gis_Unit_Area` |

All 13 GIS attributes are **active** (`Active = true`).

---

## GIS Geometry Types

| Type | Description | Used for |
|------|-------------|---------|
| **point** | Single coordinate (lat/lng) | Buildings (campus map), individual assets (fire extinguishers, meters) |
| **polygon** | Closed area boundary | Rooms, Units, GreenAreas, ParkingLots (floor plan areas) |
| **shape** | Generic shape (line/polygon) | Floor drawings / CAD floor plans |

---

## Important Distinction: GIS Geometry vs Text Coordinates

The `Building` class has **two** coordinate-related fields:

1. **`Coordinates` (string attribute on Building)** — A plain text field. This is NOT a GIS geometry. It stores text like "45.123, 9.456" for human reference. Classification: STANDARD OPENMAINT (attribute on class).

2. **`Position` (GIS attribute on Building)** — A true PostGIS geometry stored in `gis.Gis_Building_Position`. This is the real GIS field used by the map viewer. Classification: STANDARD OPENMAINT.

When integrating GIS: always use the GIS geometry attribute, not the text Coordinates field.

---

## Floor Plans (DWG/CAD Import)

The `Floor.Drawing` GIS attribute (shape type) is linked to the DWG/CAD import functionality:

- The scheduled job `AutomaticDWGImport` (disabled in demo) imports DWG files and creates floor plan shapes
- CAD drawings are stored as GIS shapes associated with Floor records
- The BIM viewer can also display floor plans from IFC files

---

## Indoor vs Outdoor GIS

| Category | Classes with GIS | Level |
|----------|-----------------|-------|
| Outdoor / Campus | Building (Position, point) | Zoom 2–17 (city to building level) |
| Indoor / Floor plan | Room (Area, polygon), Unit (Area), Floor (Drawing) | Zoom 18–25 (indoor level) |
| Asset positioning | Computer, FireExtinguisher, Meter, Sink, Split, SupportSurface, Toilet | Zoom 20–25 (room level) |
| Outdoor areas | GreenArea, ParkingLot | Zoom 18–25 |

This zoom-level stratification means the map shows different layers depending on how much the user zooms in.

---

## GIS Map Configuration

GIS layer and geoserver configuration from API:
- `gis-layers.json` — configured layers (may be empty if no geoserver is configured)
- `gis-geoservers.json` — WMS/WFS geoserver settings

**NOT CONFIRMED:** Whether a geoserver (e.g., GeoServer, MapServer) is configured in this POC. The demo likely uses OpenStreetMap as the base map layer with asset overlays. The `gis-geoservers.json` response requires inspection to confirm.

---

## GIS for AJMN

| AJMN requirement | openMAINT GIS capability | Status |
|-----------------|-------------------------|--------|
| Map campus buildings | Building → Position (point) | NATIVE |
| Show floor plans | Floor → Drawing (shape) + Room → Area | NATIVE (requires CAD/DWG import or manual polygon drawing) |
| Position fire extinguishers on floor plan | FireExtinguisher → Position (point) | NATIVE |
| Position HVAC / Split units | Split → Position (point) | NATIVE — Split class has GIS attribute |
| Room-level asset positioning | Room/Area + asset Position attributes | NATIVE |
| GIS attributes on additional classes | Can add via `_GisAttribute` | NO-CODE configuration |
| External basemap (satellite, OSM) | Configurable via geoserver/layer setup | CONFIGURATION REQUIRED |
| GIS for security gates/access control | AccessControlDevice — no GIS attribute by default | CONFIGURATION REQUIRED (add GIS attribute) |
| GIS for generators | Generator — no GIS attribute by default | CONFIGURATION REQUIRED |
| Link BIM model to GIS | Via BIM + GIS integration | See `12-bim.md` |
