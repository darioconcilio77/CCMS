# Module: Features

**Namespace:** `D4P.CCMS.Features`

## Purpose

Manages **BC feature flags** for individual environments. BC environments
expose a set of optional/preview features that can be enabled or disabled
via the Admin Center API. This module provides a UI to view and toggle
those features.

---

## Objects

### Table – D4P BC Environment Feature

Stores the feature state for each environment.

| Field | Type | Description |
|---|---|---|
| Customer No. | Code[20] | Reference to the customer. |
| Tenant ID | Guid | Reference to the Entra tenant. |
| Environment Name | Text[100] | Name of the BC environment. |
| Feature ID | Text[100] | Unique identifier of the feature from the API. |
| Feature Name | Text[250] | Display name of the feature. |
| State | Text[50] | Current state: `Enabled`, `Disabled`, or `System` (always on). |
| Data Update Required | Boolean | Whether enabling the feature requires a data upgrade. |

---

### Codeunit – D4P BC Features Helper

Handles API communication for feature management.

**Key procedures:**

| Procedure | Description |
|---|---|
| `GetEnvironmentFeatures(BCEnvironment)` | Calls `GET .../environments/{name}/features` and refreshes the feature table. |
| `SetFeatureState(BCEnvironment, FeatureID, Enable)` | Calls `PUT .../environments/{name}/features/{featureId}` to enable or disable a feature. |

---

### Page – D4P BC Environment Features

List page showing all features for an environment with current state.

**Actions:**
- **Refresh** – fetches current feature states from Admin API.
- **Enable** – enables the selected feature.
- **Disable** – disables the selected feature.

---

## Notes

- Features with `State = System` cannot be toggled; they are always enabled by Microsoft.
- Features that require a data update (`Data Update Required = true`) may take longer to enable.

---

## Related Modules

- **Environment** – features are scoped to a specific environment. Accessible from the Environment Card.
