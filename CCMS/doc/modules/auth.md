# Module: Auth

**Namespace:** `D4P.CCMS.Auth`

## Purpose

Manages Microsoft Entra (Azure AD) **App Registrations** used to authenticate
API calls to the Business Central Admin Center API and Automation API.

The module supports two registration models:

| Type | Description |
|---|---|
| **Individual** | Each tenant has its own dedicated Client ID and secret. |
| **Shared** | A single app registration is reused across multiple tenants. |

Client secrets are **never stored in plain text**. They are stored in BC
**Isolated Storage** keyed by Client ID (GUID), ensuring they are encrypted
at rest and not readable via normal table queries.

---

## Objects

### Table 62008 – D4P BC App Registration

| Field | Type | Description |
|---|---|---|
| Client ID | Guid | Microsoft Entra Application (Client) ID. Primary key. |
| Name | Text[100] | Descriptive name for the registration. |
| Secret Expiration Date | Date | When the client secret expires. Styled red/amber/green on pages. |

**Key methods:**

| Method | Description |
|---|---|
| `HasClientSecret(ClientId)` | Returns `true` if a secret is stored in isolated storage for the given Client ID. |
| `GetClientSecret(ClientId)` | Retrieves the `SecretText` from isolated storage. |
| `SetClientSecret(ClientId, SecretText)` | Stores/updates the secret in isolated storage. |
| `DeleteClientSecret(ClientId)` | Removes the secret from isolated storage. |
| `GetSecretExpirationStyle()` | Returns a page-style value (Favorable / Attention / Unfavorable) based on `Secret Expiration Date`. |
| `SendMissingClientSecretNotification()` | Sends a BC notification prompting the user to enter a missing secret. |

---

### Codeunit – D4P BC App Registration (helper)

Provides the logic for obtaining OAuth 2.0 **access tokens** using the stored
app registration credentials. Called by `D4P BC API Helper` before each API call.

---

### Page 62021 – D4P BC App Registration List

List page for browsing all app registrations. Accessible from the Role Center.

### Page 62022 – D4P BC App Registration Card

Card page for creating and editing a single app registration, including:
- Client ID entry
- Masked client secret input (stored to isolated storage on validate)
- Secret expiration date with colour styling

---

### Enum – D4P BC App Reg. Type

| Value | Caption |
|---|---|
| Individual | Individual |
| Shared | Shared |

---

## Related Modules

- **Tenant** – each tenant references an app registration via `Client ID`.
- **General (API Helper)** – uses app registration credentials to acquire OAuth tokens.
