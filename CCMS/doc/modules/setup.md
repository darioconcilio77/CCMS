# Module: Setup

**Namespace:** `D4P.CCMS.Setup`

## Purpose

Stores the **global configuration** for the CCMS solution. This is a
single-record setup table (singleton pattern) that is auto-created with
default values on first access.

---

## Objects

### Table 62009 – D4P BC Setup

Single-record table (primary key is always blank).

| Field | Type | Default | Description |
|---|---|---|---|
| Primary Key | Code[10] | `''` | Always blank – singleton. |
| Debug Mode | Boolean | `false` | Enables display of raw API responses in `Message()` dialogs for troubleshooting. |
| Admin API Base URL | Text[250] | `https://api.businesscentral.dynamics.com/admin/v2.28` | Base URL for all Admin Center API calls. |
| Automation API Base URL | Text[250] | `https://api.businesscentral.dynamics.com/v2.0` | Base URL for Automation API calls. |
| Customer Nos. | Code[20] | *(blank)* | Number series for auto-assigning customer numbers. |

**Key methods:**

| Method | Description |
|---|---|
| `GetSetup()` | Returns the setup record, auto-creating it with defaults if it does not exist. |
| `IsDebugModeEnabled()` | Returns `true` if debug mode is currently on. Safe to call without prior `Get`. |
| `GetAdminAPIBaseUrl()` | Returns the Admin API base URL, restoring the default if blank. |
| `GetAutomationAPIBaseUrl()` | Returns the Automation API base URL. |
| `RestoreDefaults()` | Resets all fields to the shipped defaults. |

---

### Page – D4P BC Setup

Card page for the single setup record.

**Fields displayed:**
- Admin API Base URL
- Automation API Base URL  
- Customer Number Series
- Debug Mode (checkbox)

**Actions:**
- **Restore Defaults** – calls `RestoreDefaults()`.

Accessible from the **Tenant List** via the *Setup* action.

---

### Codeunit – D4P BC Debug Helper

Provides developer utilities related to debug mode.

| Procedure | Description |
|---|---|
| `TestDebugMode()` | Displays a message showing current debug mode state. Called from the Tenant List *Test Debug Mode* action. |

---

## Debug Mode

When `Debug Mode` is enabled:
- API request bodies and raw JSON responses are shown in `Message()` pop-ups.
- KQL query text (after token replacement) is displayed before execution.
- Result row counts and target table IDs are shown after telemetry query execution.

> **Use in production with caution** – debug messages reveal internal API payloads.

---

## Related Modules

Used by virtually all other modules through `D4P BC Setup.GetSetup()` or helper methods.
