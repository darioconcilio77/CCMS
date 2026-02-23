# Module: Customer

**Namespace:** `D4P.CCMS.Customer`

## Purpose

Provides the **customer master** that groups Entra tenants and their BC
environments. Each customer record is the top-level entity in the CCMS
hierarchy.

---

## Objects

### Table 62000 – D4P BC Customer

| Field | Type | Description |
|---|---|---|
| No. | Code[20] | Customer number. Assigned from number series configured in Setup. |
| Name | Text[100] | Customer name. |

**Primary key:** `No.`

---

### Page 62003 – D4P BC Customers List

List page showing all customers. Entry point from the Role Center.

**Actions available:**
- Navigate to Tenant List filtered by customer.
- Navigate to Environment List filtered by customer.

### Page 62004 – D4P BC Customer Card

Card page for a single customer. Includes the **Customer FactBox** showing
a summary of associated tenants and environments.

### Page – D4P BC Customer FactBox

CardPart showing count of tenants and environments for the current customer.

---

## Related Modules

- **Tenant** – each tenant record has `Customer No.` as part of its primary key.
- **Setup** – `Customer Nos.` field defines the number series used for auto-assignment.
