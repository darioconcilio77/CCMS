# Module: Capacity

**Namespace:** `D4P.CCMS.Capacity`

## Purpose

Monitors and displays **storage capacity** consumption for BC environments,
fetched from the Admin Center API. Data is presented in a worksheet view that
supports multiple environments across a tenant.

---

## Objects

### Table – D4P BC Capacity Header

One record per capacity snapshot per environment.

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to the customer. |
| Tenant ID | Guid | Reference to the Entra tenant. |
| Environment Name | Text[100] | Name of the BC environment. |
| Last Updated | DateTime | When capacity data was last refreshed from the API. |

### Table – D4P BC Capacity Line

Detail lines under a capacity header, one per storage category.

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to the customer. |
| Tenant ID | Guid | Reference to the Entra tenant. |
| Environment Name | Text[100] | Name of the BC environment. |
| Line No. | Integer | Sequence within the header. |
| Storage Type | Text[100] | Category of storage (e.g., Database, File). |
| Used (GB) | Decimal | Storage consumed in gigabytes. |
| Allowed (GB) | Decimal | Storage allowance in gigabytes. |

---

### Codeunit – D4P BC Capacity Helper

Handles API calls to retrieve capacity data.

**Key procedure:**

| Procedure | Description |
|---|---|
| `GetCapacityData(BCTenant)` | Calls `GET /applications/businesscentral/environments/*/capacity` for all environments of the tenant and populates the header/line tables. |

---

### Page – D4P BC Capacity Worksheet

The main capacity view, showing a header per environment with subform lines
for each storage category.

**Actions:**
- **Refresh** – re-fetches capacity from the API for all environments in view.

### Page – D4P BC Capacity Subform

Embedded list of capacity lines (storage categories with used/allowed values)
within the worksheet.

### Page – D4P BC Capacity Card

Card view for a single environment's capacity record.

### Page – D4P BC Capacity List

Simple list of all capacity header records (one per environment).

---

## Navigation

Capacity is accessible from:
- The **Tenant Card** via the *Capacity* action.
- The **Tenant List** via the *Capacity* action.
- The **Environment Card** via the *Capacity* action.

---

## Related Modules

- **Tenant** – worksheets are filtered by tenant.
- **Environment** – each capacity record corresponds to one environment.
