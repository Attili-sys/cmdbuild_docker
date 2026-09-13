# AJMN CAFM — Module Coverage vs. openMAINT 2.4.2

**Legend**
- ✅ **Exists** — standard openMAINT, needs data/config only
- 🔧 **Config** — exists but needs class/attribute/workflow setup (no code)
- 📝 **Scripting** — config + Groovy scripts (no Java, upgrade-safe)
- 🏗️ **Build** — custom class/XPDL process required (proven pattern, no code)
- 💻 **Code** — requires custom REST adapter or frontend code

---

## 1. Dashboard
**Status: 🔧 Config**
Configurable dashboards and chart widgets exist in openMAINT admin. Needs KPI data sources and chart definitions set up per AJMN requirements.

---

## 2. Asset Master Data
**Status: ✅ Exists**
Full asset hierarchy: Building → Floor → Room → Asset (CI). Attributes for condition, warranty, category, location, supplier already modelled. Add/edit via admin UI.

---

## 3. Maintenance
**Status: ✅ Exists**
- Corrective Maintenance (`CorrectiveMaint`) — full workflow out of the box
- Preventive Maintenance (`PreventiveMaint`) — full workflow with calendar/planner

Work order creation, assignment, state transitions, SLA tracking all built-in.

---

## 4. Inventory & Procurement
**Status: 🏗️ Build**
No inventory/stock module in standard openMAINT. Needs:
- New `InventoryItem` class (admin UI, no code)
- New `PurchaseRequest` process (XPDL config, same pattern as FacilityIncident POC ✅)
- Reorder alert rule (Groovy in workflow or scheduled task)

---

## 5. Contracts
**Status: ✅ Exists**
`Contract` class is standard openMAINT. Vendor link, value, start/end dates, status already modelled. Expiry alert workflow is configurable.

---

## 6. Vendor Management
**Status: ✅ Exists (+ 📝 Scripting for scoring)**
`Supplier` class exists with contact and category fields. Performance score field needs to be added (admin UI). Auto-calculation from work order history needs a Groovy scheduled script — not Java, but is scripting.

---

## 7. Performance Monitoring
**Status: 🔧 Config**
Underlying data (work orders, assets, KPIs) is all present. Needs dashboard charts configured in admin UI to surface completion rates, uptime, and vendor scores as visual panels.

---

## 8. Reporting & Analytics
**Status: ✅ Exists**
JasperReports engine built in. Standard reports: Activity Report, Building Dossier, CI Inventory, etc. Custom reports: upload `.jrxml` template via admin UI — no code required. Exception summaries configurable.

---

## 9. Workflow Automation
**Status: ✅ Exists**
XPDL-based approval workflows fully supported. Purchase request approvals, work order cost overruns, permit approvals — all configurable via XML workflow definitions. Proven in live POC (FacilityIncident ✅).

---

## 10. KPI / SLA Management
**Status: ✅ Exists**
`MaintSLA` class standard in openMAINT. KPI targets and actuals tracked per work order. SLA compliance reporting built in. Additional custom KPIs: add fields via admin UI.

---

## 11. HSE (Health, Safety & Environment)
**Status: 🏗️ Build**
Not in standard openMAINT. Needs:
- New `HseIncident` process class (admin UI, no code)
- XPDL workflow: Near Miss / Incident / Permit to Work / Inspection states
- Same pattern as FacilityIncident POC — already proven end-to-end ✅

---

## 12. Mobile Technician Capability
**Status: 💻 Code**
No native mobile app in openMAINT community edition. Options:
- **Custom PWA/React app** calling openMAINT v4 REST API (proven functional in POC)
- **Third-party mobile CAFM client** with API integration
- openMAINT's own web UI is responsive but not optimised for field use

---

## 13. Enterprise / System Integrations
**Status: 💻 Code (partial 🔧 Config for batch)**
- **Batch data import** (asset lists, DWG floor plans): ETL config module — no code
- **Live BMS sync**: Needs a REST adapter script calling openMAINT v4 API — small, but is code
- **ERP / Financials**: Same — REST adapter required
- **Email / Notifications**: Built-in notification engine, configurable templates — no code
- **HR / Workforce**: REST adapter to pull user/team data — code required

---

## Summary Table

| # | Module | Status | Effort |
|---|--------|--------|--------|
| 1 | Dashboard | 🔧 Config | Low |
| 2 | Asset Master Data | ✅ Exists | None |
| 3 | Maintenance | ✅ Exists | None |
| 4 | Inventory & Procurement | 🏗️ Build | Medium |
| 5 | Contracts | ✅ Exists | None |
| 6 | Vendor Management | ✅ + 📝 Scripting | Low |
| 7 | Performance Monitoring | 🔧 Config | Low |
| 8 | Reporting & Analytics | ✅ Exists | Low |
| 9 | Workflow Automation | ✅ Exists | Low |
| 10 | KPI / SLA Management | ✅ Exists | None |
| 11 | HSE | 🏗️ Build | Medium |
| 12 | Mobile Technician | 💻 Code | High |
| 13 | Enterprise Integrations | 💻 Code (partial config) | Medium–High |

**7 of 13 modules exist today. 4 need config/build with no Java. 2 require custom code.**
