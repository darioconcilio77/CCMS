# Module: Permissions

**Namespace:** `D4P.CCMS.Permissions`

## Purpose

Defines the permission sets that control access to CCMS objects. Assign
these to users or user groups to grant appropriate levels of access.

---

## Permission Sets

### D4P BC ADMIN – Full Access

**Permission Set ID:** `62000`  
**Caption:** D365BC Admin Center – Full Access  
**Assignable:** Yes

Grants **RIMD** (Read, Insert, Modify, Delete) on all CCMS data tables plus
execution (`X`) rights on all table objects, pages, codeunits, and reports.

Intended for administrators who need to manage customers, tenants, environments,
and all related features.

---

### D4P BC ADMIN READ – Read Only Access

**Permission Set ID:** `62001`  
**Caption:** D365BC Admin Center – Read Only Access  
**Assignable:** Yes

Grants **R** (Read only) on most data tables; grants **RIMD** on KQL result
tables (Page Executions, Report Executions, Slow AL Methods, Extension Lifecycle)
since these are populated during in-session telemetry queries.

Intended for users who need to view operational data without being able to
modify configuration or trigger API actions.

---

### D4P BC SETUP

**Permission Set ID:** `62002`  
**Caption:** D365BC Admin Center – Setup  
**Assignable:** Yes

Grants access limited to the Setup table and page only.

Intended for users responsible solely for configuring the solution's global
settings (API URLs, number series, debug mode).

---

### D4P BC TELEMETRY

**Permission Set ID:** `62003`  
**Caption:** D365BC Admin Center – Telemetry  
**Assignable:** Yes

Grants access to all telemetry-related objects:
- `D4P AppInsights Connection` (RIMD)
- `D4P KQL Query Store` (RIMD)
- All KQL result tables (RIMD)
- Telemetry pages, codeunits, and the `D4P Load Data` report.

Intended for users who only need to run and review Application Insights
telemetry queries without access to administrative operations.

---

## Permission Matrix Summary

| Object Category | ADMIN | ADMIN READ | SETUP | TELEMETRY |
|---|:---:|:---:|:---:|:---:|
| Customers, Tenants, App Registrations | RIMD | R | – | – |
| Environments, Installed Apps | RIMD | R | – | – |
| Backups, Capacity, Features, Sessions | RIMD | R | – | – |
| Operations | RIMD | R | – | – |
| Setup | RIMD | R | RIMD | – |
| KQL Query Store | RIMD | R | – | RIMD |
| KQL Result tables (executions etc.) | RIMD | RIMD | – | RIMD |
| AppInsights Connections | RIMD | R | – | RIMD |
| All pages and codeunits | X | X (most) | Setup only | Telemetry only |

---

## Assignment Recommendations

| User Role | Recommended Permission Set(s) |
|---|---|
| Solution administrator | `D4P BC ADMIN` |
| Read-only reviewer / monitor | `D4P BC ADMIN READ` |
| Configuration manager | `D4P BC SETUP` |
| Telemetry analyst | `D4P BC TELEMETRY` |
