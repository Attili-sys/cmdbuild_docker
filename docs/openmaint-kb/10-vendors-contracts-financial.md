# 10 — Vendors, Contracts and Financial

**Source:** API class attributes, domain analysis  
**Classification:** STANDARD OPENMAINT

---

## Company Model

openMAINT uses a unified `Company` abstract class for all external organizations:

```
Company  [abstract]
├── Supplier  — external service providers, spare parts vendors
├── Customer  — building occupants, internal customers
└── CorporateGroup  — parent company / holding
```

### Supplier Attributes

| Attribute | Type | Notes |
|-----------|------|-------|
| Code | string | VAT number |
| Name | string | Business name — **Required** |
| Description | string | |
| Address, ZIP, City | string | |
| Country | lookup [COMMON - Country] | |
| Phone1, Phone2 | string | |
| Email | string | |
| Website | link | |

Note: The demo ships with 6 sample suppliers (DEMO DATA).

---

## Contract Model

```
Contract  [abstract]
├── ServiceProvision  — maintenance/service contracts (AMC)
├── PurchAgreement  — framework purchasing agreements
├── Rent  — rental agreements
└── Utility  — electricity, water, gas, telecom contracts
```

### Contract Base Attributes

| Attribute | Type | Notes |
|-----------|------|-------|
| Code | string | Contract reference number |
| Description | string | |
| Supplier | reference → Company | **Required** — the service provider |
| Customer | reference → Company | The beneficiary |
| Site | reference → Site | Which location is covered |
| SigningDate | date | |
| StartingDate | date | Contract start |
| ExpirationDate | date | Contract end / renewal date |
| Notes | text | |

### ServiceProvision (AMC)

ServiceProvision is the primary contract type for maintenance contracts (Annual Maintenance Contracts). Inherits all Contract attributes with no additional standard attributes found in this inspection.

Links:
- `SiteContract` domain — which site(s) the contract covers
- `ContractMaintProcess` domain — work orders under this contract
- `ContractMaintSLA` domain — SLAs defined in this contract
- `ContractPriceList` domain — price lists for this contract
- `ContractAccMov` domain — financial movements

### Rent

Additional attributes:
| Attribute | Type | Notes |
|-----------|------|-------|
| AmountType | lookup [Rent - AmountType] | Annual / Monthly / Weekly |
| DurationUM | lookup [Rent - DurationUM] | Years / Months / Weeks |

### Utility

| Attribute | Type |
|-----------|------|
| Type | lookup [Utility - Type] | Electricity / Electricity+Gas / Gas / Water / Landline + 2 more |

---

## Budget Model

```
Budget  ─── BudgetBudgetCenter ──── BudgetCenter ─── PartitionTBudgetC ──── PartitionTable
       └─── BudgetBudgetItem ────── BudgetItem
```

### Budget

| Attribute | Type | Notes |
|-----------|------|-------|
| Name | string | **Required** |
| Description | string | **Required** |
| Site | reference → Site | Which location |
| StartDate, StopDate | date | Budget period — **Required** |
| ApprovalDate | date | |

### BudgetItem

`BudgetItem - Type` lookup (7 values):
- Rental, Maintenance, Cleaning, Utility, Surveillance + 2 more

### BudgetCenter

Organizational unit for budget allocation. Linked to Site and PartitionTable.

### PartitionTable / PartitionTableRow

| Lookup | Values |
|--------|--------|
| PartitionTable - Type | Water / PostOfficeBox / Property / TVIntercom |
| PartitionTable - UM | Thousandth / M2 / M3 |

Partition tables manage proportional cost allocation between tenants/units (cadastral fractions).

---

## Accounting Movements

`AccountingMov` (abstract superclass) and its subclasses track all financial transactions:

| Class | Purpose |
|-------|---------|
| `GenericAccMov` | Generic cost or revenue |
| `LabourAccMov` | Labour cost |
| `MaterialAccMov` | Material cost |

Key attributes:
| Attribute | Type | Notes |
|-----------|------|-------|
| State | lookup [AccountingMov - State] | Estimate / Actual |
| Type | lookup [AccountingMov - Type] | Cost / Revenue |

Accounting movements are linked to:
- Work orders (`MaintProcAccMov`)
- Sites (`SiteAccMov`)
- Contracts (`ContractAccMov`)
- Site/contract hierarchy for cost reporting

### VAT Rates

`COMMON - VATRate` lookup: 22%, 10%, 4% (Italian standard rates — may need updating for AJMN/Qatar).

### Currency

`COMMON - Currency` lookup: EUR, USD, GBP, JPY, INR, CHF, CNY (7 values). Note: QAR (Qatari Riyal) is not in the standard list — **CONFIGURATION REQUIRED** for AJMN.

---

## Invoice

`Invoice` class links financial documents to assets via `InvoiceCI` domain. Exact Invoice attributes not fully enumerated in this inspection.

---

## ERP Boundary

What openMAINT manages:
- Maintenance cost estimates and actuals
- Material and labour accounting per work order
- Contract register with expiry dates
- Budget allocation and tracking
- Purchase orders for spare parts

What normally stays in ERP:
- GL accounts and journal entries
- AP/AR processing and payment
- Fixed asset accounting
- Payroll
- VAT/tax reporting

Integration: ERP ↔ openMAINT via REST API, syncing:
- Approved purchase orders (openMAINT creates PO, ERP processes payment)
- Actual costs (openMAINT posts actuals, ERP integrates to GL)
- Contract values (ERP holds contract financial terms, openMAINT uses for SLA)
