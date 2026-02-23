# Module: Telemetry

**Namespace:** `D4P.CCMS.Telemetry`

## Purpose

Provides an interface to query **Azure Application Insights** telemetry data
associated with BC environments directly from within Business Central.
Administrators can run pre-defined or custom **KQL (Kusto Query Language)**
queries, with results stored locally for browsing and analysis.

---

## Architecture

```
D4P AppInsights Connection  (connection strings registry)
        │
        ▼
D4P AppInsights Client      (REST API client, executes KQL)
        │
        ▼
D4P KQL Query Store         (library of saved KQL queries)
        │
        ▼
D4P Load Data  (report)
        │
        ├──► D4P KQL Page Execution
        ├──► D4P KQL Report Execution
        ├──► D4P KQL Slow AL Method
        └──► D4P KQL Extension Lifecycle
```

---

## Objects

### Table – D4P AppInsights Connection

Registry of Application Insights connections that can be reused across
environments.

| Field | Type | Description |
|---|---|---|
| Code | Code[20] | Unique identifier for the connection. |
| Name | Text[100] | Display name. |
| Connection String | Text[250] | Full Application Insights connection string. |

### Page – D4P AppInsights Conn List / Card

List and card pages for managing connection string records.

---

### Table – D4P KQL Query Store

Library of saved KQL queries.

| Field | Type | Description |
|---|---|---|
| Code | Code[20] | Unique query code. Primary key. |
| Name | Text[100] | Descriptive name. |
| Description | Text[250] | Longer description of what the query analyses. |
| Query | Blob | The full KQL query text (stored as a BLOB). |
| Result Table ID | Integer | BC Table ID where results will be stored (0 = no persistent storage). |

**Supported token substitutions in KQL queries:**

| Token | Replaced with |
|---|---|
| `{{FROM}}` | Start date/time of the query window. |
| `{{TO}}` | End date/time of the query window. |
| `{{DATEFILTER}}` | Pre-formatted date range filter expression. |
| `{{TIMESTAMP_COMPRESSION}}` | `bin(timestamp, <interval>)` or plain `timestamp`. |
| `{{TIMECOMPRESSION}}` | Compression interval string (backwards compatibility). |
| `{{AADTENANTID}}` | Entra Tenant ID (lowercase, no curly braces). |
| `{{ENVIRONMENTTYPE}}` | Environment type string. |
| `{{ENVIRONMENTNAME}}` | Environment name. |

### Codeunit – D4P KQL Query Store Init

Initialises the `D4P KQL Query Store` table with the built-in default queries
on first use.

### Page – D4P KQL Queries

Main page for browsing and selecting KQL queries associated with an environment.
Called from the Environment Card via `D4P Telemetry Helper.OpenKQLQueriesPage`.

### Page – D4P KQL Query Preview

Shows the raw KQL text of a selected query before execution.

### Page – D4P KQL Query Selection

Lookup page used by `D4P Load Data` to choose which stored query to run.

---

### Codeunit – D4P AppInsights Client

Low-level REST client for the Application Insights REST API.

**Key responsibilities:**
- Authenticates using the environment's connection string.
- Posts KQL queries to the Application Insights query endpoint.
- Parses the tabular JSON response.
- Exposes row-by-row iteration (`GetNextRow`, `GetFields`, `GetValueAsText`).

---

### Report – D4P Load Data

The report that orchestrates a telemetry query execution.

**Initialisation:**
- `InitRequestFromEnvironment(Environment, QueryCode)` – sets environment context
  (tenant ID, environment name/type, Application Insights connection string)
  and the query code to execute.

**Execution flow:**
1. Loads the selected `D4P KQL Query Store` record.
2. Applies token substitutions (date range, tenant ID, environment context).
3. Calls `D4P AppInsights Client` to execute the KQL query.
4. Saves results into the appropriate result table based on `Result Table ID`.
5. Opens the corresponding result page (e.g., Page Executions, Slow AL Methods).

**Debug mode support:** When `D4P BC Setup."Debug Mode"` is `true`, the report
displays the raw KQL query and API response via `Message()` for troubleshooting.

---

### Result Tables and Pages

#### D4P KQL Page Execution / D4P KQL Page Executions

Stores page execution telemetry (page ID, user, duration, etc.).

#### D4P KQL Report Execution / D4P KQL Report Executions

Stores report execution telemetry (report ID, user, duration, etc.).

#### D4P KQL Slow AL Method / D4P KQL Slow AL Methods

Stores slow AL method telemetry (object type, method name, duration, etc.).

#### D4P KQL Extension Lifecycle / D4P KQL Extension Lifecycle (page)

Stores extension lifecycle events (install, uninstall, upgrade, etc.) from
Application Insights traces.

---

### Codeunit – D4P Telemetry Helper

Provides higher-level methods called from the Environment Card.

| Procedure | Description |
|---|---|
| `ValidateEnvironmentTelemetrySetup(Environment)` | Validates that the environment has an Application Insights string configured. Errors if not. |
| `OpenKQLQueriesPage(Environment)` | Validates setup then opens `D4P KQL Queries` with the environment context. |
| `RunTelemetryQuery(Environment)` | Validates setup, lets the user pick a query via `D4P KQL Query Selection`, then runs `D4P Load Data`. |

---

## Setup Requirements

For telemetry queries to work an environment must have its
**Application Insights String** field populated.  
This can be set via the *Set Application Insights Key* action on the
Environment Card (which also pushes it to the BC Admin API).

---

## Related Modules

- **Environment** – the Application Insights connection string is stored on the environment record.
- **Setup** – debug mode flag affects telemetry query diagnostic output.
