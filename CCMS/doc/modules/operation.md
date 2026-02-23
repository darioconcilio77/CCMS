# Module: Operation

**Namespace:** `D4P.CCMS.Operations`

## Purpose

Tracks **long-running asynchronous operations** triggered through the Admin
Center API (e.g., environment creation, copy, deletion, update). The Admin API
returns an operation ID for such requests; this module stores and monitors the
resulting operation status.

---

## Objects

### Table – D4P BC Environment Operation

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to the customer. |
| Tenant ID | Guid | Reference to the Entra tenant. |
| Operation ID | Guid | Unique identifier returned by the Admin API for the async operation. |
| Environment Name | Text[100] | Environment the operation relates to. |
| Operation Type | Text[100] | Type of operation (e.g., `EnvironmentCopy`, `EnvironmentCreate`, `EnvironmentUpdate`). |
| Status | Text[50] | Current status: `Scheduled`, `Running`, `Succeeded`, `Failed`, `Canceled`. |
| Created At | DateTime | When the operation was created. |
| Last Modified At | DateTime | When the status was last updated. |
| Error Message | Text[250] | Error details if the operation failed. |

---

### Codeunit – D4P BC Operations Helper

Handles polling of ongoing operation status.

**Key procedures:**

| Procedure | Description |
|---|---|
| `GetEnvironmentOperations(BCEnvironment)` | Calls `GET .../environments/{name}/operations` and refreshes the operations table. |
| `RefreshOperationStatus(Operation)` | Calls `GET .../operations/{operationId}` to update the status of a single operation. |

---

### Page – D4P BC Environment Operations

List page showing all tracked operations for an environment.

**Actions:**
- **Refresh** – re-polls the API for updated statuses of all listed operations.
- **Refresh Selected** – updates only the selected operation's status.

---

## Operation Lifecycle

```
Scheduled → Running → Succeeded
                    ↘ Failed
                    ↘ Canceled
```

Failed operations include an error message from the API response.

---

## Related Modules

- **Environment** – operations are tied to a specific environment. Accessible from the Environment Card.
