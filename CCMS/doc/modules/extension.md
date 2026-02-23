# Module: Extension

**Namespace:** `D4P.CCMS.Extension`

## Purpose

Manages **installed extensions (apps)** across BC environments, including
discovering installed apps, checking for available updates, and triggering
update processes via the Admin API.

Also manages **PTE Object Ranges** to document the object ID ranges assigned
to per-tenant extensions for a customer.

---

## Objects

### Table 62003 – D4P BC Installed App

**Primary key:** `Customer No.` + `Tenant ID` + `Environment Name` + `App ID`

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to the customer. |
| Tenant ID | Guid | Reference to the Entra tenant. |
| Environment Name | Text[100] | Name of the BC environment. |
| App ID | Guid | Unique identifier of the extension. |
| App Name | Text[100] | Display name of the extension. |
| Publisher | Text[100] | Publisher of the extension. |
| Version | Text[20] | Currently installed version. |
| State | Enum `D4P App State` | Current state (e.g., Installed, Installing, Uninstalling). |
| App Type | Enum `D4P App Type` | Type of app (e.g., PerTenant, Global). |
| Available Update Version | Text[20] | Latest available update version (populated by `GetAvailableAppUpdates`). |

---

### Page – D4P BC Installed Apps List

List of installed apps for one or more environments.

**Actions:**
- **Refresh** – calls `D4P Get Installed Apps` report to fetch apps from Automation API.
- **Get Available Updates** – calls `D4P BC Environment Mgt.GetAvailableAppUpdates`.
- **Update App** – calls `D4P BC Environment Mgt.UpdateApp` for the selected app.

### Page – D4P BC Installed App Card

Card for a single installed app showing all fields.

### Page – D4P BC Installed Apps FactBox

CardPart for embedding on Environment Card showing app count and last refresh info.

---

### Report – D4P Get Installed Apps

Fetches the list of installed apps for an environment from the
**BC Automation API** and upserts them into `D4P BC Installed App`.

Flow: `GET /api/microsoft/automation/{apiVersion}/companies/{companyID}/extensions`

---

### Table 62007 – D4P PTE Object Range

Stores the assigned object ID ranges for PTE extensions per customer/tenant.

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to the customer. |
| Tenant ID | Guid | Reference to the tenant. |
| From ID | Integer | Start of the object ID range. |
| To ID | Integer | End of the object ID range. |
| Description | Text[100] | Description of the range assignment. |

### Page – D4P PTE Object Ranges

List page for managing PTE object ranges. Accessible from the Tenant Card and Tenant List.

---

### Enums

#### D4P App State

| Value | Description |
|---|---|
| Installed | App is fully installed. |
| Installing | Installation in progress. |
| Uninstalling | Uninstallation in progress. |
| Failed | Last operation failed. |

#### D4P App Type

| Value | Description |
|---|---|
| Global | App from AppSource or Microsoft. |
| PerTenant | Per-Tenant Extension. |
| Dev | Developer extension. |

#### D4P Uninstall Attempt Result

Result of an uninstall attempt operation.

#### D4P Update Attempt Result

Result of an update attempt operation.

---

## Related Modules

- **Environment** – `D4P BC Environment Mgt` provides update scheduling logic.
- **Tenant** – PTE Object Ranges are scoped to a customer/tenant pair.
