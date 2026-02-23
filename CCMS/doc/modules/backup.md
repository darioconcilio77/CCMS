# Module: Backup

**Namespace:** `D4P.CCMS.Backup`

## Purpose

Allows administrators to trigger and track **environment exports (backups)**
to Azure Blob Storage and to monitor previous export operations.

Backup storage credentials (SAS URI and container name) are configured on
the **Tenant** record.

---

## Objects

### Table – D4P BC Environment Backup

Stores the history of backup operations for an environment.

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to the customer. |
| Tenant ID | Guid | Reference to the Entra tenant. |
| Environment Name | Text[100] | Name of the environment that was backed up. |
| Entry No. | Integer | Auto-incremented sequence key. |
| Created At | DateTime | When the backup was initiated. |
| Status | Enum `D4P Export Status` | Current status of the export operation. |
| Download URL | Text[250] | Azure Storage URL for downloading the backup. |
| Expires At | DateTime | When the download URL expires. |

---

### Codeunit – D4P BC Backup Helper

Contains the API call logic for environment export operations.

**Key procedures:**

| Procedure | Description |
|---|---|
| `ExportEnvironment(BCEnvironment)` | Calls the Admin API to initiate an environment export to Azure Blob Storage. |
| `GetEnvironmentBackups(BCEnvironment)` | Fetches the list of existing backups from the API and refreshes `D4P BC Environment Backup`. |

---

### Page – D4P BC Environment Backups

List page showing the backup history for an environment.

**Actions:**
- **Refresh** – fetches latest backup status from API.
- **Export** – initiates a new environment export.
- **Open Download URL** – opens the backup download link in a browser.

### Page – D4P Export History Dialog

Dialog page displayed during or after an export operation, showing progress
and the resulting download URL.

---

### Enum – D4P Export Status

| Value | Description |
|---|---|
| Pending | Export has been requested but not yet started. |
| InProgress | Export is currently running. |
| Succeeded | Export completed successfully. |
| Failed | Export failed. |

---

## Prerequisites

Before using backup functionality, configure the following on the **Tenant Card**:
- **Backup SAS URI** – the Azure Storage SAS URI for the target container.
- **Backup Container Name** – the name of the Azure Blob container.
- **Backup SAS Token Exp. Date** – monitor expiration to ensure the SAS token is still valid.

---

## Related Modules

- **Tenant** – backup SAS credentials are stored on the tenant record.
- **Environment** – backups are scoped to a specific environment.
