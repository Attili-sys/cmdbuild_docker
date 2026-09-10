# 19 — UI Operator Playbook

**Source:** Running web application at http://127.0.0.1:8090/cmdbuild/ui/  
**Classification:** CMDBUILD PLATFORM

---

## Overview

This playbook enables a future developer or AI agent to navigate the openMAINT web application without rediscovering the layout.

---

## Login

```
URL: http://127.0.0.1:8090/cmdbuild/ui/
Username: admin
Password: admin
Role: SuperUser (selected automatically for admin)
```

Multi-role users see a role selector on login. The active role changes the visible menu.

---

## Main Interface Layout

```
┌──────────────────────────────────────────────────────────┐
│  Top bar: Logo | Module switcher | Search | User menu    │
├─────────────────┬────────────────────────────────────────┤
│  Left sidebar   │  Main content area                     │
│  (navigation    │  (card list, card detail,              │
│   menu)         │   process form, map, etc.)             │
│                 │                                         │
│  Tree of        │  Standard card view:                   │
│  folders and    │  - Filter bar at top                   │
│  class links    │  - Table/list of records               │
│                 │  - Click a record → detail panel       │
└─────────────────┴────────────────────────────────────────┘
```

The module switcher (top bar) switches between:
- **Data Management** (the main CAFM module — normal user view)
- **Administration** (configuration and metadata management — admin only)

---

## Data Management Section

### Finding and Viewing Records

| Task | Path |
|------|------|
| View all buildings | Left menu → Facilities and assets → Locations → Building |
| View a building | Click any row in the building list → detail panel opens on right |
| View building's floors | In building detail → Relations tab → Floors |
| View assets in a room | Left menu → Facilities and assets → Locations → Room → select room → Relations tab → CI (Configuration items) |
| View all assets | Left menu → Facilities and assets → Elements → Assets → CI |
| View assets by type | Left menu → Facilities and assets → Elements → Assets → Devices → [device category] → [specific type] |
| Find a specific asset | Use the search/filter bar at the top of any class list |

### Navigation Tree

The **NavTree** (visible as a tree icon in the Locations and Elements sections) shows the facility hierarchy as a collapsible tree:
- Complex → Building → Floor → Unit → Room
- Click a node to filter the main panel to items within that location

### Viewing Relations

Every card detail view has a **Relations** tab showing linked records via domains:

```
Building card:
  Tabs: Details | Relations | History | Documents | GIS | BIM
  
  Relations tab shows:
  - Floors (BuildingFloor domain)
  - Rooms (BuildingRoom domain)  
  - CI (BuildingCI domain — assets in the building)
  - Contracts (SiteContract domain)
  - Maintenance processes (SiteMaintProcess domain)
```

### Documents / Attachments

Every card has a **Documents** tab (when DMS is enabled). Click to view, upload, or download attachments. Supported formats: PDF, images, DWG, IFC, etc.

### History

Every card has a **History** tab showing all field changes with timestamp and user. This is the audit trail from `*_history` tables.

---

## Administration Section

**Access:** Top bar → Administration (gear icon or module switcher)

### Data Model

| Task | Path |
|------|------|
| View all classes | Administration → Data model → Classes |
| View class attributes | Classes → select class → Attributes tab |
| View class domains | Classes → select class → Domains tab |
| Inspect a lookup type | Administration → Data model → Lookup types → select type → Values tab |
| View all domains | Administration → Data model → Domains |
| View domain details | Domains → select domain → details |

### Processes

| Task | Path |
|------|------|
| View process classes | Administration → Processes |
| View process attributes | Processes → select process → Attributes tab |
| View/edit XPDL workflow | Processes → select process → Workflow tab |
| View process activities | Processes → select process → Activities (shows XPDL states) |

### Roles and Permissions

| Task | Path |
|------|------|
| View roles | Administration → User management → Roles |
| View role privileges | Roles → select role → Privileges tab |
| View class permissions | Roles → select role → Privileges → Data model |
| View process permissions | Roles → select role → Privileges → Processes |
| Manage users | Administration → User management → Users |

### GIS Configuration

| Task | Path |
|------|------|
| View GIS attributes | Administration → GIS → Geoattributes |
| Configure map layers | Administration → GIS → Map layers |
| Configure geoservers | Administration → GIS → Geoservers |

### BIM Configuration

| Task | Path |
|------|------|
| View BIM projects | Administration → BIM → Projects |
| View BIM objects | Administration → BIM → Objects |

### Reports and Dashboards

| Task | Path |
|------|------|
| View reports | Administration → Utilities → Reports |
| View dashboards | Administration → User interface → Dashboards |
| View menus | Administration → User interface → Navigation menus |

### System Configuration

| Task | Path |
|------|------|
| View scheduled jobs | Administration → Utilities → Scheduled jobs |
| View email accounts | Administration → Email → Accounts |
| View email templates | Administration → Email → Templates |
| System configuration | Administration → System configuration |

---

## Working with Maintenance Processes

### Starting a Corrective Maintenance Request

```
Path: Left menu → Maintenance → Corrective maintenance
Action: Click "New" button
Form fills: Type, Priority, CI (asset), Site, description, opening notes
Submit: advances to CM-Opening state
```

### Starting a Preventive Maintenance Work Order (Manual)

PM work orders are normally auto-generated by the scheduler. To manually create one:
```
Path: Left menu → Maintenance → Preventive maintenance
Action: Click "New" button (only available to SuperUser/MaintOffice)
```

### Advancing a Work Order

```
Path: Open a work order → click "Advance" or the state-specific action button
Different roles see different actions based on their permitted state transitions
```

### Setting Up PM Schedule (PrevMaintConfig)

```
Path: Administration or Maintenance → Preventive maintenance config
Action: New PrevMaintConfig
Required: Site, CISubset (assets), PrevMaintDef (activity), Team, Frequency, First dates
```

---

## Working with GIS

```
Path: GIS menu (top or left menu GIS section)
Map shows: Buildings as points at city zoom, Rooms as polygons at indoor zoom
Click a marker: Opens linked card detail
Add position: Open building card → GIS tab → set Position on map
```

---

## Working with Reports

```
Path: Left menu → Maintenance (or Finance) → [Report name]
OR: Left menu → Reports section
Click report: Parameters dialog opens → set date range, filters → Generate
Output: PDF (in-browser) or download
```

---

## REST API Quick Reference

```bash
# Login
curl -X POST "http://127.0.0.1:8090/cmdbuild/services/rest/v3/sessions?scope=service&returnId=true" \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin"}'

# Get all buildings
curl -H "CMDBuild-Authorization: <token>" \
  "http://127.0.0.1:8090/cmdbuild/services/rest/v3/classes/Building/cards?limit=100"

# Get all active PM configs
curl -H "CMDBuild-Authorization: <token>" \
  "http://127.0.0.1:8090/cmdbuild/services/rest/v3/classes/PrevMaintConfig/cards?limit=500"

# Get open corrective maintenance work orders
curl -H "CMDBuild-Authorization: <token>" \
  "http://127.0.0.1:8090/cmdbuild/services/rest/v3/processes/CorrectiveMaint/instances?limit=100"

# Get class metadata
curl -H "CMDBuild-Authorization: <token>" \
  "http://127.0.0.1:8090/cmdbuild/services/rest/v3/classes/Building"
```

---

## Common Pitfalls

| Issue | Cause | Fix |
|-------|-------|-----|
| Session token expired | Tokens expire after inactivity | Re-authenticate via POST /sessions |
| "generic error" on some API endpoints | Endpoint may require specific permissions or may not exist | Check with SuperUser; verify endpoint in docs |
| Menus show UUIDs instead of class names | Menu items use internal UUIDs — resolve via class list | Cross-reference `classes.json` raw file |
| PM work orders not being generated | `PrevMaintGeneratorScheduler` may not be enabled | Check _Job table or Administration → Scheduled jobs |
| No attachments appearing | DMS not configured | Run the three `setconfig` commands for DMS (already done in this POC) |
