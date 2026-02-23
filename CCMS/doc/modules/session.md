# Module: Session

**Namespace:** `D4P.CCMS.Session`

## Purpose

Provides visibility into **active user sessions** running in a BC environment
and allows administrators to terminate hanging or unwanted sessions via the
Admin Center API.

---

## Objects

### Table – D4P BC Environment Session

Stores a snapshot of active sessions retrieved from the API.

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to the customer. |
| Tenant ID | Guid | Reference to the Entra tenant. |
| Environment Name | Text[100] | Name of the BC environment. |
| Session ID | Integer | BC session identifier. |
| User ID | Text[250] | AAD Object ID or name of the user who owns the session. |
| Login Date | DateTime | When the session was started. |
| Status | Text[50] | Session status (e.g., Active, Idle). |
| Client Type | Text[50] | Type of client (e.g., WebClient, Background, ODataV4). |

---

### Codeunit – D4P BC Session Helper

Handles API communication for session management.

**Key procedures:**

| Procedure | Description |
|---|---|
| `GetEnvironmentSessions(BCEnvironment)` | Calls `GET .../environments/{name}/sessions` and refreshes the session table. |
| `StopSession(BCEnvironment, SessionID)` | Calls `DELETE .../environments/{name}/sessions/{sessionId}` to terminate the session. |

---

### Page – D4P BC Environment Sessions

List page showing all active sessions for an environment.

**Actions:**
- **Refresh** – fetches current sessions from Admin API.
- **Stop Session** – terminates the selected session after user confirmation.

### Page – D4P BC Environment Sess Card

Card view for a single session record showing full details.

---

## Related Modules

- **Environment** – sessions are scoped to an environment. Accessible from the Environment Card.
