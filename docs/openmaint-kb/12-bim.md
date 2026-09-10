# 12 — BIM

**Source:** DB `_BimProject`, `_BimObject`, `_BimProjectIfc` tables  
**Classification:** STANDARD OPENMAINT (feature), DEMO DATA (3 demo projects)

---

## BIM Configuration

openMAINT/CMDBuild supports BIM (Building Information Modeling) through IFC file management and viewer integration. This is standard CMDBuild platform functionality activated in the openMAINT configuration.

---

## Demo BIM Projects

3 BIM projects are present in the demo database (classification: DEMO DATA):

| Code | Description | Status |
|------|-------------|--------|
| WB14 | WB14 | Active |
| WB01 | WB01 | Active |
| WB02 | WB02 | Active |

These are demo IFC model projects. The codes (WB14, WB01, WB02) correspond to demo building references.

---

## BIM Architecture

CMDBuild BIM architecture:

```
_BimProject  ─── project record (linked to a Building)
    └── _BimProjectIfc  ─── uploaded IFC files for the project
    └── _BimObject  ─── individual IFC objects extracted from the model
                           (walls, rooms, equipment objects from the IFC)
```

Each `_BimObject` can be mapped to a CMDBuild class record (e.g., a Room in the IFC model linked to a `Room` card in CMDBuild).

---

## IFC Support

**INFERENCE:** CMDBuild 4.x supports IFC 2×3 format for BIM model upload. IFC 4 support status for this specific version (4.2.0) is **NOT CONFIRMED** — check official CMDBuild documentation.

BIM functions:
- Upload IFC file to a building project
- Viewer displays the 3D model (Three.js or similar embedded viewer)
- Objects in the IFC are imported as `_BimObject` records
- Objects can be mapped to CMDBuild class cards (Room, Asset, etc.)
- Navigation between BIM object and its CMDBuild card is supported

---

## Standard vs Subscription BIM

CMDBuild documentation references some BIM features as standard and others as subscription/commercial features. **NOT CONFIRMED** exactly which features in CMDBuild 4.2.0 community vs commercial apply. The demo appears to include a working BIM viewer (evidenced by the 3 demo projects with associated IFC data in `_BimObject`).

---

## AJMN BIM Notes

| Requirement | Status | Notes |
|-------------|--------|-------|
| IFC model upload per building | NATIVE | Standard feature |
| 3D viewer in browser | NATIVE (INFERENCE) | Viewer included in openMAINT UI |
| Map BIM objects to CMDBuild cards | NATIVE | `_BimObject` ↔ class card mapping |
| BIM-to-GIS integration | NOT CONFIRMED | Whether BIM coordinates sync to GIS geometry |
| BIM for AJMN studios/floors | CONFIGURATION REQUIRED | Upload AJMN IFC files; map objects to Floor/Room cards |
| BIM subscription features | NOT CONFIRMED | Check CMDBuild licensing for advanced BIM |
