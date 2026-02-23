# Module: Environment

**Namespace:** `D4P.CCMS.Environment`

## Purpose

The Environment module is the **core administrative module** of CCMS. It manages
the full lifecycle of Dynamics 365 Business Central environments through the
**BC Admin Center API (v2.28)**.

---

## Objects

### Table 62002 – D4P BC Environment

**Primary key:** `Customer No.` + `Tenant ID` + `Name`

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to the customer. |
| Tenant ID | Guid | Reference to the Entra tenant. |
| Name | Text[100] | Environment name (e.g., `Production`, `Sandbox`). |
| Type | Text[20] | Environment type string from the API (e.g., `Production`, `Sandbox`). |
| State | Text[20] | Current state from the API (e.g., `Active`, `Preparing`). |
| Country Code | Code[2] | Localization/country code. |
| Application Family | Text[50] | Application family (e.g., `businesscentral`). |
| Version | Text[20] | Currently installed BC version. |
| Application Insights String | Text[250] | Azure Application Insights connection string for telemetry. |
| Target Version | Text[100] | Update target version selected from Admin API. |
| Available | Boolean | Whether the selected update version is available. |
| Target Version Type | Text[50] | Type of the selected update (e.g., `Cumulative`, `Major`). |
| Selected DateTime | DateTime | Scheduled date/time for the update. |
| Latest Selectable Date | DateTime | Latest date the update can be scheduled. |
| Ignore Update Window | Boolean | Whether to bypass the maintenance window for the update. |
| Rollout Status | Text[50] | Rollout status of the update (from API). |
| Expected Availability | Text[20] | Expected availability for unreleased versions (YYYY/MM format). |

---

### Codeunit – D4P BC Environment Mgt

The main business logic codeunit. Communicates directly with the Admin API.

**Environment lifecycle operations:**

| Procedure | API Call | Description |
|---|---|---|
| `GetBCEnvironments(BCTenant)` | `GET /applications/businesscentral/environments` | Fetches all environments for a tenant and upserts them. |
| `CreateNewBCEnvironment(...)` | `PUT /applications/businesscentral/environments/{name}` | Creates a new environment with type and country code. |
| `CopyBCEnvironment(...)` | `POST /applications/businesscentral/environments/{name}/copy` | Copies an existing environment to a new name/type. |
| `RenameBCEnvironment(...)` | `POST /applications/businesscentral/environments/{name}/rename/` | Renames an environment. |
| `DeleteBCEnvironment(...)` | `DELETE /applications/businesscentral/environments/{name}` | Marks an environment for deletion. |

**Update management:**

| Procedure | Description |
|---|---|
| `GetSelectedUpdateVersion(BCEnvironment, ShowMessage)` | Fetches the currently selected update version from the API and stores it on the environment record. |
| `GetAvailableUpdates(BCEnvironment, TempAvailableUpdate)` | Returns all available update versions into a temporary table with scheduling details. |
| `GetAllAvailableAppUpdates(ShowProgressDialog)` | Batch-fetches app updates for all active environments with a progress dialog. |
| `SelectTargetVersion(BCEnvironment, TargetVersion, SelectedDate, ...)` | Calls `PATCH .../updates/{version}` to select a target version and optional schedule date. |
| `RescheduleBCEnvironmentUpgrade(...)` | Reschedules an existing upgrade to a different date/time. |

**Other operations:**

| Procedure | Description |
|---|---|
| `SetApplicationInsightsConnectionString(BCEnvironment)` | Sets or removes the Application Insights key via `POST .../settings/appinsightskey`. |
| `GetAvailableAppUpdates(BCEnvironment, ShowMessage)` | Fetches available extension update versions and stores them on `D4P BC Installed App`. |
| `UpdateApp(BCEnvironment, AppId, showNotification)` | Schedules an extension update to its available version. |

---

### Codeunit – D4P BC Environment Helper

Utility procedures for environment-related UI operations (dialogs, navigation helpers).

---

### Page 62005 – D4P BC Environment List

List of all environments. Filterable by customer and tenant.

**Key actions:**
- Refresh Environments (calls `GetBCEnvironments`)
- Open environment card
- Navigate to installed apps, backups, sessions, features, operations

### Page 62006 – D4P BC Environment Card

Full card for a single environment showing all stored fields.

**Actions include:**
- Refresh from API
- Create / Copy / Rename / Delete environment (via dialogs)
- Get / Select update version
- Set Application Insights connection string
- Navigate to: Installed Apps, Environment Backups, Sessions, Features, Operations, Telemetry

### Page – D4P BC Environments FactBox

CardPart used in the Tenant Card/List showing environments at a glance.

### Dialog Pages

| Page | Purpose |
|---|---|
| `D4P New Environment Dialog` | Captures name, localization, and type for `CreateNewBCEnvironment`. |
| `D4P Copy Environment Dialog` | Captures source name, target name, and target type for `CopyBCEnvironment`. |
| `D4P Rename Environment Dialog` | Captures new name for `RenameBCEnvironment`. |
| `D4P Update Selection Dialog` | Displays available updates in a list and captures the user's version and date selection. |

---

### Table – D4P BC Available Update (temporary)

Temporary table used to pass update data from the API response to the
`D4P Update Selection Dialog`.

| Field | Description |
|---|---|
| Entry No. | Sequence. |
| Target Version | Version string. |
| Available | Whether this version is available now. |
| Selected | Currently selected version. |
| Target Version Type | Cumulative / Major / etc. |
| Selected DateTime | Scheduled update date. |
| Latest Selectable Date | Latest allowable schedule date. |
| Ignore Update Window | Skip maintenance window flag. |
| Rollout Status | API rollout status. |
| Expected Month / Year | For unreleased versions. |

---

### Enum – D4P Environment Type

| Value | Caption |
|---|---|
| Production | Production |
| Sandbox | Sandbox |

---

## Related Modules

- **Tenant** – environments belong to a tenant.
- **Extension** – installed apps and their updates are per environment.
- **Backup** – backups are per environment.
- **Capacity** – capacity lines are per environment.
- **Session** – sessions are per environment.
- **Features** – BC feature flags are per environment.
- **Operation** – operations are per environment.
- **Telemetry** – KQL queries use the environment's Application Insights string.
