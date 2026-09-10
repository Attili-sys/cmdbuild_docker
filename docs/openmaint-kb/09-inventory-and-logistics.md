# 09 — Inventory and Logistics

**Source:** API class attributes, domain analysis  
**Classification:** STANDARD OPENMAINT

---

## Overview

openMAINT manages inventory through three interconnected concepts:
1. **Consumable** — spare parts, materials, and PPE items in the catalog
2. **WrhMovement** (Warehouse Movement) — stock transactions
3. **WrhMovementRow** — individual line items within a movement
4. **PurchaseOrder / PurchaseOrderRow** — procurement orders linked to warehouse loads

---

## Consumable — Spare Parts Catalog

`Consumable` is a standalone class (not in the CI hierarchy). It represents items held in stock.

| Attribute | Type | Notes |
|-----------|------|-------|
| Code | string | Item code |
| Description | string | Item name/description |
| Notes | text | |
| Category | lookup [Consumable - Category] | Cleaning / Electrical / GreaseLubrification / Hydraulic / Measurement + 5 more |
| Type | lookup [Consumable - Type] | 97 values covering specific item types |

Key related domains:
- `CIConsumable` — links a Consumable to a CI (compatible spare part for an asset)
- `DimensionConsumable` — dimensional specifications for the consumable
- `ConsblWrhMovRow` — links Consumable to WrhMovementRow (stock transaction lines)

---

## WrhMovement — Warehouse Movements

Stock movements are recorded as `WrhMovement` (header) + `WrhMovementRow` (lines).

### WrhMovement Header

| Attribute | Type | Notes |
|-----------|------|-------|
| Code | string | Movement code |
| Description | string | |
| Name | string | |
| Date | date | Movement date — **Required** |
| Category | lookup [WrhMovement - Category] | **Required** — Load / Unload / Relocation |
| Subcategory | lookup [WrhMovement - Subcategory] | **Required** — see values below |
| SrcSite | reference → Site | Source location (for Unload and Relocation) |
| DstSite | reference → Site | Destination location (for Load and Relocation) |
| MaintProcess | reference → MaintProcess | Work order consuming these materials |
| PurchaseOrder | reference → PurchaseOrder | Source purchase order (for Load-PurchaseOrder) |
| Details | text | Free text |

### Movement Categories and Subcategories

| Category | Subcategory | Description |
|----------|-------------|-------------|
| Load | Load-PurchaseOrder | Goods received from purchase order |
| Load | Load-Dismantling | Items recovered from dismantled assets |
| Load | Load-PositiveAdjustment | Manual stock increase |
| Unload | Unload-Usage | Materials consumed in a maintenance work order |
| Unload | Unload-SupplierReturn | Returned to supplier |
| Unload | Unload-NegativeAdjustment | Manual stock reduction |
| Relocation | *(subcategories not confirmed)* | Transfer between locations |

### WrhMovementRow — Line Items

| Attribute | Type | Notes |
|-----------|------|-------|
| Consumable | reference → Consumable | Which item — **Required** |
| Quantity | decimal | Amount — **Required** |
| WrhMovement | reference → WrhMovement | Parent movement — **Required** |
| PurchaseOrderRow | reference → PurchaseOrderRow | Source order line (for PO loads) |
| Description | string | |

---

## Stock Calculation

**NOT CONFIRMED** — openMAINT does not appear to have a dedicated "current stock level" field on the Consumable class itself. Stock is calculated by summing all Load minus all Unload movements for a given Consumable at a given Site.

Reports (`REP-ConsumableStocks`) calculate current stock from movement totals.

**Reorder logic:** No native reorder point or minimum stock alert was found. This is a **GAP** — automatic reorder alerts would require either a scheduled job (LOW-CODE) or external logic.

---

## Purchase Orders

`PurchaseOrder` and `PurchaseOrderRow` handle procurement:

| Class | Purpose |
|-------|---------|
| `PurchaseOrder` | Purchase order header — linked to Supplier |
| `PurchaseOrderRow` | Individual line items on the PO |

PO lifecycle:
1. PO created and linked to Supplier via `SupplierPurchOrder`
2. PO lines link to Consumables
3. When goods received: WrhMovement (Load-PurchaseOrder) created, linked to PO
4. WrhMovementRow lines link to PurchaseOrderRow lines via `PurchOrdRowWrhMovRow`

**PurchAgreement** is a contract subtype for framework agreements with suppliers.

---

## Material Consumption in Work Orders

When a maintenance work order uses materials:

```
MaintProcess (work order)
    └── MaintProcWrhMov domain
          └── WrhMovement (Unload-Usage)
                └── WrhMovementRow
                      └── Consumable (which spare part was used)
                      └── Quantity
```

This creates a traceable link between:
- Which work order consumed materials
- Which consumables were used
- How much was consumed
- Which site's stock was reduced

---

## Price Lists

| Class | Purpose |
|-------|---------|
| `PriceList` | Price list header (linked to contracts via `ContractPriceList`) |
| `LabourPriceList` | Labour hourly rates |
| `MaterialPriceList` | Material unit prices |

These feed into `AccountingMov` estimates when creating cost entries on work orders.

---

## AJMN Inventory Notes

| Requirement | Status | Notes |
|-------------|--------|-------|
| Spare parts catalog | NATIVE | Consumable class with 97 type values |
| Stock loading (receiving) | NATIVE | WrhMovement Load categories |
| Material consumption in work orders | NATIVE | MaintProcWrhMov domain |
| Reorder alerts / minimum stock | GAP | Not native — needs scheduled job or external logic |
| Procurement orders | NATIVE | PurchaseOrder → PurchaseOrderRow |
| Price lists | NATIVE | Labour and material price lists |
| ERP integration for procurement | EXTERNAL INTEGRATION | REST API from ERP system |
| QR code / barcode scanning | NOT CONFIRMED | Mobile app may support — needs verification |
