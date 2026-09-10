# openMAINT 2.4.2 Gap Analysis — AJMN CAFM Requirements

**Project:** Al Jazeera Media Network (AJMN) CAFM Evaluation  
**Platform assessed:** openMAINT 2.4.2 on CMDBuild 4.2.0  
**Assessment basis:** Local POC deployment, product documentation, and REST API verification  
**Date:** 8 September 2026

---

## 1. Executive Summary

openMAINT is a credible **CAFM platform starting point** for AJMN, but not a finished enterprise solution out of the box.

It is strongest in:
- facility and asset structure
- preventive and corrective maintenance
- contracts, vendors, roles, and attachments
- extensibility through CMDBuild configuration

It is weaker in:
- HSE / safety as a dedicated operating module
- procurement automation
- executive KPI dashboards
- polished self-service UX
- integrations with BMS, ERP, HR, email, and IoT

**Conclusion:** openMAINT should be treated as a platform to **configure and integrate**, not as a turnkey system matching the React mockup.

---

## 2. What Fits, What Does Not

| Area | Assessment | Notes |
|------|------------|-------|
| Facility and asset management | Strong fit | Core hierarchy and technical asset classes are present; AJMN taxonomy still needs configuration |
| Maintenance management | Strong fit | Preventive and corrective workflows exist; routing, priorities, and forms need AJMN setup |
| Contract management | Good fit | Contract register works; alerts and renewal flows need configuration |
| Vendor and contractor management | Partial fit | Basic register and assignment fit; scoring and performance dashboards are not prebuilt |
| Workflow and approvals | Platform fit | Workflow engine exists; AJMN approval chains must be designed |
| KPI and SLA management | Partial fit | SLA support exists; full management KPI pack will need custom reporting or BI |
| Inventory and procurement | Partial fit | Inventory concepts exist; procurement automation is limited |
| HSE / safety | Weak fit | Can be modeled, but this is not a dedicated HSE product |
| Reporting and analytics | Partial fit | Core reports exist; executive dashboards will need work |
| Technician / mobile access | Good fit | Standard mobile capability exists; setup and validation still required |
| Self-service portal | Partial fit | Requester workflow exists; user experience will not match the React mockup without custom UI |
| Integrations | Major gap | REST API exists, but integrations are not delivered |
| Arabic and English | Supported | Must be validated in real usage, especially terminology and RTL behavior |
| Document management | Good fit | Attachments work; enterprise document strategy is still needed |
| Scalability | Platform fit | Production architecture is possible, but this Docker POC is not production-grade |

---

## 3. What Requires Configuration vs Coding

### Mostly configuration

These areas can largely be handled inside openMAINT / CMDBuild administration:
- buildings, rooms, studios, and asset classes
- preventive and corrective maintenance flows
- contracts, vendors, teams, and permissions
- attachment handling
- Arabic/English enablement
- standard reports

### Likely coding or external development

These areas usually require software outside openMAINT:
- BMS integration
- ERP / procurement integration
- HR / workforce sync
- email / enterprise notification integration
- IoT feeds
- custom employee portal matching the React mockup
- advanced KPI dashboards and BI

### Important implementation note

If coding is needed, it should usually happen **outside** openMAINT, using the **CMDBuild REST API**.  
Direct writes to the PostgreSQL database should be avoided for operational integrations because they bypass workflow logic, validation, and audit behavior.

---

## 4. Main Gaps for AJMN

### 4.1 HSE / Safety

This is the weakest native fit. Fire and safety assets can be modeled, but incidents, permits to work, near misses, and broader HSE operations would require significant custom configuration and may still fall short of a dedicated HSE product.

### 4.2 Integrations

openMAINT does not come with AJMN integrations. BMS, ERP, HR, email, and IoT connections would need separate integration work.

### 4.3 Procurement automation

Inventory exists in some form, but automated reorder logic, purchase requests, approvals, and ERP handoff are not a strong out-of-box capability.

### 4.4 Executive reporting and portal UX

The platform can produce reports, but the polished dashboard and self-service experience implied by the React mockup would require extra design, reporting work, and possibly a custom frontend.

---

## 5. Recommended Positioning

AJMN should position openMAINT as:

- a **configurable CAFM platform**
- a good base for **facility structure and maintenance operations**
- a system that will need **configuration, integration, and some extension work**

AJMN should **not** position it as:

- a turnkey enterprise CAFM already matching the mockup
- a no-code solution for the full target scope
- a complete HSE or procurement platform

---

## 6. Suggested Next Steps

1. Validate the strongest areas first: asset model, maintenance workflows, roles, attachments, and Arabic UI.
2. Run focused POC tests for the risky areas: HSE, procurement workflow, mobile use, and self-service.
3. Define the external integration scope early: BMS, ERP, HR, email, and reporting.
4. Decide whether AJMN can accept the standard UI or needs a custom portal layer.

---

## 7. References

- openMAINT product: https://www.openmaint.org
- CMDBuild platform: https://www.cmdbuild.org
- openMAINT 2.4 release notes: https://www.openmaint.org/en/resources/news
- openMAINT available languages: https://www.openmaint.org/en/download/available-languages
- CMDBuild 4.2 changelog: https://www.cmdbuild.org/en/download/changelog
- Local deployment guide: [openmaint-local-deployment.md](./openmaint-local-deployment.md)
