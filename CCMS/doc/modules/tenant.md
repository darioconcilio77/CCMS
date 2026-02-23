# Module: Tenant

**Namespace:** `D4P.CCMS.Tenant`

## Purpose

Links a **Customer** to one or more Microsoft **Entra tenants** (Azure AD tenants).
Each tenant record holds the authentication configuration for API access and the
Azure Storage configuration for environment backups.

---

## Objects

### Table 62001 – D4P BC Tenant

**Primary key:** `Customer No.` + `Tenant ID`

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to `D4P BC Customer`. |
| Tenant ID | Guid | Microsoft Entra (AAD) Tenant GUID. |
| Tenant Name | Text[100] | Descriptive name for the tenant. |
| Client ID | Guid | Entra App (Client) ID for API auth. References `D4P BC App Registration` when type = Shared. |
| ~~Client Secret~~ | ~~Text[100]~~ | Obsolete since v0.0.1.0. Secrets moved to isolated storage. |
| Secret Expiration Date | Date | Expiration of the individual client secret (used when `App Registration Type` = Individual). |
| Backup SAS URI | Text[250] | Azure Storage SAS URI for environment backups. |
| Backup Container Name | Text[250] | Azure Storage container name for backups. |
| Backup SAS Token Exp. Date | Date | Expiration of the SAS token. |
| App Registration Type | Enum `D4P BC App Reg. Type` | Individual or Shared. Defaults to Individual. |
| Customer Name | FlowField | Calculated from `D4P BC Customer`. |

**Key methods:**

| Method | Description |
|---|---|
| `GetClientSecret()` | Returns `SecretText` from isolated storage via `D4P BC App Registration`. |
| `OpenAdminCenter()` | Opens the BC Admin Center URL for this tenant in a browser. |

---

### Page 62002 – D4P BC Tenant List

List of all Entra tenants across all customers.

**Actions:**
- **Admin Center** – opens `https://businesscentral.dynamics.com/{TenantID}/admin`
- **Environments** – navigates to Environment List filtered by tenant.
- **Capacity** – opens Capacity Worksheet filtered by tenant.
- **PTE Object Ranges** – navigates to PTE Object Ranges for the tenant.
- **Setup** – opens the global CCMS Setup page.
- **Test Debug Mode** – invokes `D4P BC Debug Helper.TestDebugMode()`.

### Page 62011 – D4P BC Tenant Card

Full card for a tenant with:
- **General** tab: customer link, tenant GUID and name.
- **Authentication** tab:
  - App Registration Type selector.
  - Shared: lookup to `D4P BC App Registration`.
  - Individual: Client ID + masked secret input + expiration date with colour styling.
- **Backup Configuration** tab: SAS URI, container name, SAS token expiration with colour styling.
- **FactBoxes**: Tenant Details + Environments FactBox.

### Page 62012 – D4P BC Tenant FactBox

CardPart summary of authentication and backup configuration for a tenant.

### Page 62017 – D4P Tenant Migration Dialog

Standard dialog for initiating a **Tenant-to-Tenant Migration**. Captures:
- Source: Customer No., Tenant ID, Environment Name.
- Target: Customer No., Tenant ID, Environment Name.
- Options: Migrate Data, Migrate Apps, Description.

> **Note:** Migration logic is marked as TODO and not yet implemented.

---

## Expiration Colour Coding

Both secret expiration and SAS token expiration fields use dynamic styling:

| Days to Expiry | Style |
|---|---|
| Already expired | Unfavorable (red) |
| ≤ 30 days | Attention (amber) |
| > 30 days | Favorable (green) |

---

## Related Modules

- **Auth** – provides app registrations referenced by the tenant.
- **Environment** – environments are scoped to a tenant.
- **Capacity** – capacity worksheets are filtered by tenant.
- **Extension** – PTE object ranges are scoped to a customer/tenant.
