# Module: General

**Namespace:** `D4P.CCMS.General`

## Purpose

Provides the **Role Center** and supporting UI elements (headlines, cues)
that serve as the main entry point for CCMS users. Also contains the shared
`D4P BC API Helper` codeunit used by all modules to make authenticated
HTTP calls to the BC Admin Center and Automation APIs.

---

## Objects

### Profile – D4P BC Admin

Defines the **D365BC Admin Center** Role Center profile. Users assigned
this profile see the CCMS Role Center as their home page.

- Role Center Page: `D4P BC Admin Role Center`
- Profile ID: `D4P BC ADMIN`

---

### Page – D4P BC Admin Role Center

The main homepage for CCMS administrators. Contains:
- **Headline** part – shows the `D4P BC Admin Headline` page.
- **Cues** part – shows the `D4P BC Admin Center Cues` page.
- Navigation actions to all major list pages.

---

### Page – D4P BC Admin Headline

A headline part page that displays motivational or informational text
at the top of the Role Center (standard BC headline pattern).

---

### Table / Page – D4P BC Admin Center Cue

Activity cue table and page providing KPI tiles on the Role Center, such as:
- Number of customers
- Number of tenants
- Number of active environments
- Environments with pending updates
- Environments with expiring secrets

---

### Codeunit – D4P BC API Helper

The central HTTP communication layer for the entire solution. All modules
call this codeunit to make authenticated API requests.

**Key procedure:**

```al
procedure SendAdminAPIRequest(
    BCTenant: Record "D4P BC Tenant";
    Method: Text;               // 'GET', 'POST', 'PUT', 'PATCH', 'DELETE'
    Endpoint: Text;             // relative path, e.g. '/applications/businesscentral/environments'
    RequestBody: Text;          // JSON string for POST/PUT/PATCH; '' for GET/DELETE
    var ResponseText: Text      // raw JSON response from the API
): Boolean                      // true = HTTP 2xx; false = error
```

**Authentication flow:**
1. Retrieves credentials from the tenant's app registration.
2. Requests an OAuth 2.0 access token from Microsoft Entra using client credentials.
3. Sets the `Authorization: Bearer <token>` header.
4. Constructs the full URL: `Setup.GetAdminAPIBaseUrl() + Endpoint`.
5. Sends the HTTP request and returns the response body.

**Error handling:**
- Returns `false` and sets `ResponseText` to the error body on non-2xx responses.
- Debug mode causes the full response to be shown in a `Message()`.

---

## Related Modules

All modules depend on `D4P BC API Helper` for API communication.
`D4P BC Auth` provides the credentials used by the helper.
