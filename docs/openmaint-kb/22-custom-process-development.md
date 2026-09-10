# 22 — Custom Process Development Guide

**Source:** Live POC — FacilityIncident process built and tested 2026-09-10  
**Classification:** CONFIRMED (live test)

---

## Overview

CMDBuild 4.2 supports fully custom process classes alongside the existing openMAINT maintenance model. A custom process requires:

1. A CMDBuild **Process class** with attributes
2. An **XPDL workflow plan** stored in `_Plan`
3. **Performer templates** in `_Templates` for each activity
4. **Grant rows** in `_Grant` for access control
5. A **menu entry** in `_Menu` for navigation

---

## XPDL Structure Requirements

### WorkflowProcess-level ExtendedAttributes (mandatory)

```xml
<xpdl:ExtendedAttributes>
    <xpdl:ExtendedAttribute Name="cmdbuildBindToClass" Value="YourClassName"/>
    <xpdl:ExtendedAttribute Name="CM_SCRIPT_ENGINE" Value="groovy"/>
</xpdl:ExtendedAttributes>
```

Without `cmdbuildBindToClass`, the app throws `NullPointerException: plan attr not found for key = cmdbuildBindToClass` on first process start.

### Performer format (single element, quoted template reference)

```xml
<xpdl:Performers>
    <xpdl:Performer>"{dbtmpl:ActivityId_StartingRoles}"</xpdl:Performer>
</xpdl:Performers>
```

Rules:
- **Exactly one** `<xpdl:Performer>` element — River's `Iterables.getOnlyElement()` rejects multiple elements
- The value must be surrounded by **literal double quotes** (`"` in XML text content)
- The template name must exist in `_Templates` table as `{dbtmpl:TemplateName}`

### Each user activity needs 3 system sub-activities

```xml
<xpdl:Activity Id="STATE-ID" Name="State Name">
    <xpdl:Implementation><xpdl:No/></xpdl:Implementation>
    <xpdl:Performers>
        <xpdl:Performer>"{dbtmpl:STATE-ID_StartingRoles}"</xpdl:Performer>
    </xpdl:Performers>
    <!-- field ExtendedAttributes here -->
</xpdl:Activity>
<xpdl:Activity Id="STATE-ID-Sys-PreOperations">
    <xpdl:BlockActivity ActivitySetId="YourClass-BA-PreOperations"/>
</xpdl:Activity>
<xpdl:Activity Id="STATE-ID-Sys-StepOperations"/>
<xpdl:Activity Id="STATE-ID-Sys-PostOperations">
    <xpdl:BlockActivity ActivitySetId="YourClass-BA-PostOperations"/>
</xpdl:Activity>
```

### Transition pattern

```xml
<!-- User activity → Sys-PreOps (conditional on stepAction) -->
<xpdl:Transition From="STATE-ID" To="STATE-ID-Sys-PreOperations">
    <xpdl:Condition Type="CONDITION"><![CDATA["Advance".equals(stepAction)]]></xpdl:Condition>
</xpdl:Transition>
<!-- Sys sub-activities are unconditional -->
<xpdl:Transition From="STATE-ID-Sys-PreOperations" To="STATE-ID-Sys-StepOperations"/>
<xpdl:Transition From="STATE-ID-Sys-StepOperations" To="STATE-ID-Sys-PostOperations"/>
<!-- PostOps → next user activity (or end if last) -->
<xpdl:Transition From="STATE-ID-Sys-PostOperations" To="NEXT-STATE-ID"/>
```

### stepAction and auto-advance behaviour

The PreOperations Groovy script (copied from CM-BA-PreOperations) sets `stepAction = "Advance"` as default if no `Action` lookup value is provided. This means:

- If the logged-in user is a **performer in all activities** (e.g., SuperUser), the workflow runs through all states in one API call. This is **expected** — it is not a bug.
- With proper **role separation**, the workflow stops at each activity when a user who is NOT a performer reaches that state.
- For a production implementation, add **"Process - Action"** lookup values per state (e.g., `FI-Reported_Advance`) so the UI can set `stepAction` via the `Action` field.

---

## v4 REST API for Process Workflow

### Create a process instance

```
POST /cmdbuild/services/rest/v4/processes/{ClassName}/instances
Content-Type: application/json

{ "Description": "...", "FieldName": "value", ... }
```

### Get the current activity

```
GET /cmdbuild/services/rest/v4/processes/{ClassName}/instances/{instanceId}/activities
```

Returns: `[{ "_id": "activityInstanceId", "_definition": "STATE-ID", "writable": true, ... }]`

### Advance the workflow one step

```
PUT /cmdbuild/services/rest/v4/processes/{ClassName}/instances/{instanceId}
Content-Type: application/json

{
  "_advance": true,
  "_activity": "{activityInstanceId}",
  "stepAction": "Advance",
  "FieldName": "value"
}
```

**Critical:** `_activity` uses an underscore prefix. Discovered by decompiling `WsFlowData.class`:
- `_advance` → `WsFlowData.advance` (boolean)
- `_activity` → `WsFlowData.taskId` (string, returned via `getActivity()`)
- All other keys → `WsFlowData.values` (Map passed to workflow engine)

Without `_activity`: server returns 500 `must set 'activity' param`.

---

## _Plan Table

| Column | Description |
|--------|-------------|
| `Code` | Plan ID (arbitrary string, must match `ClassId`) |
| `ClassId` | varchar — the CMDBuild class name this plan binds to |
| `Data` | XPDL XML text |
| `Status` | `'A'` = active, `'U'` = historical (old versions) |

**To update an existing plan:**
```sql
UPDATE "_Plan"
SET "Data" = $TAG$<...new xpdl...>$TAG$
WHERE "Code" = 'your-plan-id' AND "Status" = 'A';
```

The Guava LoadingCache caches parsed XPDL; cleared only by app restart (`docker restart openmaint_app`).

---

## _Templates Table

Resolves `{dbtmpl:TemplateName}` performer references. One row per activity state:

```sql
INSERT INTO "_Template" ("Code", "Description", "Name", "Template", "Status")
VALUES ('tmpl-code', 'Human description', 'ActivityId_StartingRoles',
        'SuperUser,RoleA,RoleB', 'A');
```

`Template` is a comma-separated list of CMDBuild role names.

---

## Navigation Menu

The nav menu is stored as a single JSONB blob in `_Menu` where `Code = '_default_default'`.

To add a process class entry:
```json
{
  "code": "<uuid>",
  "type": "processclass",
  "target": "YourClassName",
  "children": [],
  "description": "Human-readable label"
}
```

Insert this into the correct position in the JSON tree and UPDATE the `_Menu` row. The UI picks up menu changes on next page load (no app restart required).

---

## Checklist for a New Custom Process

- [ ] Create process class via CMDBuild Admin UI (or SQL)
- [ ] Add attributes to the class
- [ ] Write XPDL (start from `build_fi_xpdl.py` as template)
- [ ] Add `cmdbuildBindToClass` ExtendedAttribute to `WorkflowProcess`
- [ ] Copy PreOperations/PostOperations ActivitySets from CM XPDL
- [ ] Insert/update `_Plan` row with the XPDL
- [ ] Restart app to clear Guava XPDL cache
- [ ] Insert `_Template` rows for each activity's StartingRoles
- [ ] Insert `_Grant` rows for process permissions
- [ ] Add `processclass` entry to `_Menu` JSONB
- [ ] Test: POST to create instance → GET activities → PUT to advance
