# 2026-04-04-add-team-join-audit - Full Design (Phase 0.5: Step 1-4)

> This file is the phase 0.5 design source of truth for the current change.

---

## Step 1: Data Structure Design

### 1.1 Database Tables (new or changed)

#### Table `team_join_audit`

| Column | Type | Constraint | Description |
|--------|------|------------|-------------|
| `id` | bigint | PK | audit record id |
| `team_id` | bigint | NOT NULL | team id |
| `user_id` | bigint | NOT NULL | joined user id |
| `event_key` | varchar(64) | UNIQUE | idempotent join event key |
| `created_at` | datetime | NOT NULL | audit timestamp |

### 1.2 Model Layer

- add a team join audit record model

### 1.3 DTO Layer

- none in the first version

### 1.4 Key Data Flow

```text
invitation accepted
  -> membership created
  -> audit event written
```

---

## Step 2: API Contract Definition

### 2.1 API List

No new API in the first version.

### 2.2 Constraints

- audit write failures must be visible to operators
- no user-facing API contract changes

---

## Step 3: Module Coupling Analysis

### 3.1 Dependency Graph

```text
team invitation service
  -> membership flow
  -> audit writer
```

### 3.2 Coupling Analysis

| Shared Resource | Coupling Type | Direction | Risk | Mitigation |
|-----------------|---------------|-----------|------|------------|
| join success event | direct call | membership -> audit | duplicate writes on retry | stable event key |

### 3.3 Shared Ownership

- owner: membership flow
- consumer: audit writer

### 3.4 Transaction And Constraints

- transaction boundary: membership success and audit creation should remain consistent
- lock order: unchanged
- idempotency: avoid duplicate join audit events
- consistency requirement: successful team join must produce one audit record

---

## Step 4: Task Split

### 4.1 Execution Order

| # | Task | Dependency | Files | Complexity |
|---|------|------------|-------|------------|
| 1 | add audit model and write path | none | `team join flow` | medium |
| 2 | document the change lifecycle | 1 | `docs/changes/...` | low |

### 4.2 Acceptance Criteria

- successful team joins create one audit record
- retries do not create duplicate audit records

### 4.3 Risk Points

- duplicate writes if retries do not reuse the same event key
