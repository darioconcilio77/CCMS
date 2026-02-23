# Cloud Customer Management Solution (CCMS)

**Publisher:** Directions for partners  
**Version:** 0.0.2.0  
**Runtime:** BC 16.0 (application 27.0.0.0+)  
**Object ID Range:** 62000 – 62049

## Overview

CCMS is a Per-Tenant Extension (PTE) for Microsoft Dynamics 365 Business Central
designed to let Microsoft Dynamics partners administer **multiple BC environments
at scale** from within a single BC company.

Through the **BC Admin Center API (v2.28)** and the **Automation API (v2.0)**, the
solution provides a unified interface to manage customers, Entra tenants, environments,
installed extensions, backups, sessions, capacity, features, and telemetry – all
without leaving Business Central.

---

## Architecture

The solution is structured into 14 functional modules, each in its own AL namespace:

| Module | Namespace | Purpose |
|---|---|---|
| [Auth](modules/auth.md) | `D4P.CCMS.Auth` | Microsoft Entra app registrations for API authentication |
| [Customer](modules/customer.md) | `D4P.CCMS.Customer` | Customer master records |
| [Tenant](modules/tenant.md) | `D4P.CCMS.Tenant` | Entra tenant management per customer |
| [Environment](modules/environment.md) | `D4P.CCMS.Environment` | BC environment lifecycle management |
| [Extension](modules/extension.md) | `D4P.CCMS.Extension` | Installed apps and update management |
| [Backup](modules/backup.md) | `D4P.CCMS.Backup` | Environment export/restore via Azure Storage |
| [Capacity](modules/capacity.md) | `D4P.CCMS.Capacity` | Storage capacity monitoring |
| [Features](modules/features.md) | `D4P.CCMS.Features` | BC feature flag management per environment |
| [Session](modules/session.md) | `D4P.CCMS.Session` | Active session monitoring and termination |
| [Operation](modules/operation.md) | `D4P.CCMS.Operations` | Long-running async operation tracking |
| [Telemetry](modules/telemetry.md) | `D4P.CCMS.Telemetry` | Application Insights KQL query execution |
| [Setup](modules/setup.md) | `D4P.CCMS.Setup` | Global configuration (API URLs, debug mode) |
| [General](modules/general.md) | `D4P.CCMS.General` | Role Center, cues, headline, API helper |
| [Permissions](modules/permissions.md) | `D4P.CCMS.Permissions` | Permission sets |

---

## Data Model

```
D4P BC Customer
    └── D4P BC Tenant (Customer No. + Tenant ID)
            ├── D4P BC Environment (Customer No. + Tenant ID + Name)
            │       ├── D4P BC Installed App
            │       ├── D4P BC Environment Backup
            │       ├── D4P BC Capacity Header / Line
            │       ├── D4P BC Environment Feature
            │       ├── D4P BC Environment Session
            │       ├── D4P BC Available Update
            │       └── D4P BC Environment Operation
            └── D4P PTE Object Range
```

---

## API Integration

| API | Base URL | Usage |
|---|---|---|
| BC Admin Center API | `https://api.businesscentral.dynamics.com/admin/v2.28` | Environment CRUD, updates, backups, sessions, features, capacity |
| BC Automation API | `https://api.businesscentral.dynamics.com/v2.0` | Installed apps, scheduled tasks |
| Azure Application Insights REST | From connection string per environment | KQL telemetry queries |

Authentication uses **OAuth 2.0 client credentials flow** via Microsoft Entra app
registrations. Client secrets are stored securely in **BC Isolated Storage**.

---

## Permission Sets

| Permission Set | Caption | Access Level |
|---|---|---|
| `D4P BC ADMIN` | D365BC Admin Center – Full Access | RIMD on all tables + all objects |
| `D4P BC ADMIN READ` | D365BC Admin Center – Read Only Access | R on most tables, RIMD on KQL result tables |
| `D4P BC SETUP` | D365BC Admin Center – Setup | Setup table only |
| `D4P BC TELEMETRY` | D365BC Admin Center – Telemetry | Telemetry tables and objects |

---

## Getting Started

1. Assign the `D4P BC ADMIN` permission set to the administrator user.
2. Open **Setup** (from the Tenant List page) and configure:
   - Admin API Base URL (default: `https://api.businesscentral.dynamics.com/admin/v2.28`)
   - Automation API Base URL (default: `https://api.businesscentral.dynamics.com/v2.0`)
   - Customer Number Series
3. Create **App Registration** records with Client ID and Client Secret.
4. Create **Customer** records, then **Tenant** records linking customers to Entra tenants.
5. Fetch environments using the **Refresh Environments** action on the Tenant Card.

---

## Translations

The solution ships with translation files for 8 languages:

`da-DK` · `de-DE` · `es-ES` · `fi-FI` · `fr-FR` · `it-IT` · `nb-NO`
