# 13 — Users, Roles and Permissions

**Source:** API `/roles`, `role-details.json`, `roles.json`  
**Classification:** STANDARD OPENMAINT

---

## Roles

openMAINT ships with 7 pre-configured roles. All verified from the running API.

| Role | Internal ID | Type | Purpose |
|------|-------------|------|---------|
| SuperUser | 192180 | Admin | Full access — no restrictions |
| AdminOffice | 261338 | Normal | Administrative office staff |
| MaintOffice | 261340 | Normal | Maintenance office — manages work orders |
| Requester | 261342 | Normal | Users who can submit maintenance requests |
| Team | 261344 | Normal | Maintenance team / technicians |
| Supplier | 279376 | Normal | External supplier portal access |
| Guest | 279643 | Normal | Read-only access |

---

## Role Descriptions

### SuperUser
- Full platform administration access
- Can access both Data Management and Administration sections
- No data or class restrictions
- Used by the `admin` system account

### AdminOffice
- Administrative management role
- Access to facility data (buildings, floors, rooms, assets)
- Contract and supplier management
- Budget and financial overview
- Reports and dashboards

### MaintOffice
- Maintenance management role
- Creates and assigns corrective maintenance work orders
- Monitors preventive maintenance schedules
- Access to SLA compliance reports
- Cannot access financial configuration

### Requester
- End-user role for raising maintenance requests
- Limited to submitting new corrective maintenance requests
- Can track status of their own requests
- No access to administration or configuration

### Team
- Technician/team role
- Can receive and execute assigned work orders
- Can add labour and material costs, notes, photos
- Can advance work order to next state
- Portal access via `PortalUsername` field on Employee

### Supplier
- External supplier portal access
- Very limited — can view and update work orders assigned to their company
- Linked via `SupplierUser` domain (Supplier → User)
- Access to their own contracts and assigned work orders

### Guest
- Read-only access to basic facility and asset data
- No write permissions
- No process access

---

## Permission Model

CMDBuild uses a grant-based permission model stored in `_Grant` table. Permissions cover:

| Permission level | Scope |
|-----------------|-------|
| Class permissions | Read / Write / None per class per role |
| Row-level permissions | Filter-based (NOT CONFIRMED — standard CMDBuild feature) |
| Attribute permissions | Show/hide per attribute per role (NOT CONFIRMED extent in this deployment) |
| Process permissions | Start / Read / Write per process per role |
| Report permissions | Read per report per role |
| Dashboard permissions | Read per dashboard per role |
| Menu visibility | Which menu items are visible per role |

The `_Grant` table structure was not fully enumerated in this inspection. Full grant detail is accessible via Admin UI → Roles → [role] → Privileges.

---

## Multi-Role Behavior

Users can belong to multiple roles. The `demouser` account ships with the demo and has multiple roles. When a multi-role user logs in, they select their active role for the session. Each role sees a different menu and different data.

The `multigroup` field on the session response indicates whether the logged-in user has multiple roles available.

---

## Authentication Methods

| Method | Status | Notes |
|--------|--------|-------|
| Username/password | Active | Default — stored in CMDBuild database |
| LDAP / Active Directory | NOT CONFIRMED | CMDBuild platform supports LDAP; not configured in this POC |
| SAML / SSO | NOT CONFIRMED | CMDBuild 4.x has SAML support; not configured in this POC |
| OAuth/OIDC | NOT CONFIRMED | Needs verification against CMDBuild 4.2 capabilities |

LDAP, SAML, and OAuth configuration would be done in CMDBuild administration — not in application code.

---

## User-Employee Link

Each CMDBuild user (`User` class) can be linked to an `Employee` record via `UserEmployee` domain. This allows:
- Associating a system login with a real person
- Using the employee's contact details in processes
- Linking users to teams (`TeamUser` domain)
- Supplier portal access (`SupplierUser` domain)

The `Employee.LoginUser` attribute (reference → User) provides the reverse link.

---

## Portal Access

The `Employee.PortalUsername` attribute (string) stores a portal username, enabling a separate portal login scenario. The `Team.Email` attribute supports email notifications for team-based assignments.

Supplier portal access is managed through:
1. Create a `User` account
2. Assign `Supplier` role
3. Link to a `Supplier` record via `SupplierUser` domain
4. Restrict visibility to relevant work orders

---

## Security Recommendations (POC → Production)

1. Change all default passwords immediately
2. Configure LDAP/SSO integration (integrates with AJMN Active Directory)
3. Review `_Grant` table to ensure role permissions are correctly scoped
4. Remove or restrict `Guest` role if not needed
5. Disable pgAdmin in production
6. Enable TLS/HTTPS
7. Audit `SuperUser` role — limit to administrators only
8. Consider row-level security for multi-site deployments (Site-based filtering per role)
