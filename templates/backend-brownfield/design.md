# <change-name> - Full Design (Phase 0.5: Step 1-4)

> This file is the phase 0.5 design source of truth for the current change. Update this file before implementation if the design changes.

---

## Step 1: Data Structure Design

### 1.1 Database Tables (new or changed)

#### Table `<table_name>`

| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| `<column>` | `<type>` | `<constraint>` | `<purpose>` |

### 1.2 Model Layer

- `<model or struct change>`

### 1.3 DTO Layer

- request DTO: `<fields>`
- response DTO: `<fields>`

### 1.4 Key Data Flow

```text
<request>
  -> <service>
  -> <repository>
  -> <storage or response>
```

---

## Step 2: API Contract Definition

### 2.1 API List

| API | Route | Method | Auth | Description |
|-----|-------|--------|------|-------------|
| `<name>` | `<path>` | `<method>` | `<required or not>` | `<summary>` |

### 2.2 Request Contract

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `<field>` | `<type>` | `<yes/no>` | `<meaning>` |

### 2.3 Response Contract

| Field | Type | Description |
|-------|------|-------------|
| `<field>` | `<type>` | `<meaning>` |

### 2.4 Constraints

- `<status/stage or other semantic rule>`
- `<error or compatibility rule>`

---

## Step 3: Module Coupling Analysis

### 3.1 Dependency Graph

```text
<module A>
  -> <module B>
  -> <module C>
```

### 3.2 Coupling Analysis

| Shared Resource | Coupling Type | Direction | Risk | Mitigation |
|-----------------|---------------|-----------|------|------------|
| `<resource>` | `<type>` | `<A->B>` | `<risk>` | `<mitigation>` |

### 3.3 Shared Ownership

- owner: `<module>`
- consumers: `<modules>`

### 3.4 Transaction And Constraints

- transaction boundary: `<details>`
- lock order: `<details>`
- idempotency: `<details>`
- consistency requirement: `<details>`

---

## Step 4: Task Split

### 4.1 Execution Order

| # | Task | Dependency | Files | Complexity |
|---|------|------------|-------|------------|
| 1 | `<task>` | `<dependency>` | `<files>` | `<low/medium/high>` |

### 4.2 Acceptance Criteria

- `<criterion>`
- `<criterion>`

### 4.3 Risk Points

- `<risk>`
- `<risk>`
