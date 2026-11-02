# PostgreSQL data dictionary

Generated from db/schema.sql. Ownership triggers and additional indexes are in db/integrity.sql.

## users

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `text NOT NULL` |
| `email` | `text NOT NULL UNIQUE` |
| `password_hash` | `text NOT NULL` |
| `created_at` | `timestamptz NOT NULL DEFAULT now()` |

## roles

| Attribute or table constraint | Definition |
|---|---|
| `id` | `smallserial PRIMARY KEY` |
| `name` | `text NOT NULL UNIQUE` |

## user_roles

| Attribute or table constraint | Definition |
|---|---|
| `user_id` | `uuid NOT NULL REFERENCES users(id) ON DELETE CASCADE` |
| `role_id` | `smallint NOT NULL REFERENCES roles(id)` |
| `PRIMARY` | `KEY(user_id,role_id)` |

## venues

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `name` | `text NOT NULL` |
| `address` | `text NOT NULL` |
| `capacity` | `integer NOT NULL CHECK(capacity>0)` |

## zones

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `venue_id` | `uuid NOT NULL REFERENCES venues(id)` |
| `name` | `text NOT NULL` |
| `area_m2` | `numeric(12,2) NOT NULL CHECK(area_m2>0)` |
| `UNIQUE(venue_id,name)` | `` |

## gates

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `venue_id` | `uuid NOT NULL REFERENCES venues(id)` |
| `name` | `text NOT NULL` |
| `UNIQUE(venue_id,name)` | `` |

## events

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `venue_id` | `uuid NOT NULL REFERENCES venues(id)` |
| `created_by` | `uuid REFERENCES users(id)` |
| `name` | `text NOT NULL` |
| `starts_at` | `timestamptz NOT NULL` |
| `ends_at` | `timestamptz NOT NULL` |
| `status` | `text NOT NULL DEFAULT 'DRAFT' CHECK(status IN('DRAFT','LIVE','COMPLETED'))` |
| `CHECK(ends_at>starts_at)` | `` |

## event_zones

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `event_id` | `uuid NOT NULL REFERENCES events(id)` |
| `zone_id` | `uuid NOT NULL REFERENCES zones(id)` |
| `capacity` | `integer NOT NULL CHECK(capacity>0)` |
| `warning_pct` | `numeric(5,2) NOT NULL DEFAULT 80 CHECK(warning_pct BETWEEN 0 AND 100)` |
| `critical_pct` | `numeric(5,2) NOT NULL DEFAULT 95 CHECK(critical_pct BETWEEN 0 AND 100)` |
| `CHECK(warning_pct<critical_pct)` | `` |
| `UNIQUE(event_id,zone_id)` | `` |

## event_gates

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `event_id` | `uuid NOT NULL REFERENCES events(id)` |
| `gate_id` | `uuid NOT NULL REFERENCES gates(id)` |
| `is_open` | `boolean NOT NULL DEFAULT true` |
| `UNIQUE(event_id,gate_id)` | `` |

## event_gate_zones

| Attribute or table constraint | Definition |
|---|---|
| `event_gate_id` | `uuid NOT NULL REFERENCES event_gates(id)` |
| `event_zone_id` | `uuid NOT NULL REFERENCES event_zones(id)` |
| `PRIMARY` | `KEY(event_gate_id,event_zone_id)` |

## devices

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `gate_id` | `uuid REFERENCES gates(id)` |
| `device_type` | `text NOT NULL` |
| `device_name` | `text NOT NULL UNIQUE` |
| `status` | `text NOT NULL DEFAULT 'ACTIVE'` |

## attendees

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `user_id` | `uuid NOT NULL UNIQUE REFERENCES users(id)` |
| `emergency_contact` | `text` |

## ticket_types

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `event_id` | `uuid NOT NULL REFERENCES events(id)` |
| `name` | `text NOT NULL` |
| `price` | `numeric(12,2) NOT NULL DEFAULT 0 CHECK(price>=0)` |
| `reentry_allowed` | `boolean NOT NULL DEFAULT false` |
| `UNIQUE(event_id,name)` | `` |

## registrations

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `event_id` | `uuid NOT NULL REFERENCES events(id)` |
| `attendee_id` | `uuid NOT NULL REFERENCES attendees(id)` |
| `created_at` | `timestamptz NOT NULL DEFAULT now()` |
| `UNIQUE(event_id,attendee_id)` | `` |

## tickets

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `registration_id` | `uuid NOT NULL UNIQUE REFERENCES registrations(id)` |
| `ticket_type_id` | `uuid NOT NULL REFERENCES ticket_types(id)` |
| `qr_token_hash` | `text NOT NULL UNIQUE` |
| `status` | `text NOT NULL DEFAULT 'VALID' CHECK(status IN('VALID','REVOKED'))` |

## ticket_zone_access

| Attribute or table constraint | Definition |
|---|---|
| `ticket_type_id` | `uuid NOT NULL REFERENCES ticket_types(id)` |
| `event_zone_id` | `uuid NOT NULL REFERENCES event_zones(id)` |
| `PRIMARY` | `KEY(ticket_type_id,event_zone_id)` |

## scan_attempts

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `ticket_id` | `uuid REFERENCES tickets(id)` |
| `event_gate_id` | `uuid NOT NULL REFERENCES event_gates(id)` |
| `device_id` | `uuid REFERENCES devices(id)` |
| `scan_type` | `text NOT NULL CHECK(scan_type IN('ENTRY','EXIT'))` |
| `result` | `text NOT NULL CHECK(result IN('ACCEPTED','REJECTED'))` |
| `reason` | `text` |
| `scanned_at` | `timestamptz NOT NULL DEFAULT now()` |
| `idempotency_key` | `text NOT NULL UNIQUE` |
| `request_fingerprint` | `text NOT NULL` |

## admission_sessions

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `ticket_id` | `uuid NOT NULL REFERENCES tickets(id)` |
| `entry_scan_id` | `uuid NOT NULL UNIQUE REFERENCES scan_attempts(id)` |
| `exit_scan_id` | `uuid UNIQUE REFERENCES scan_attempts(id)` |
| `entered_at` | `timestamptz NOT NULL DEFAULT now()` |
| `exited_at` | `timestamptz` |
| `CHECK(exited_at` | `IS NULL OR exited_at>=entered_at)` |

## zone_states

| Attribute or table constraint | Definition |
|---|---|
| `event_zone_id` | `uuid PRIMARY KEY REFERENCES event_zones(id)` |
| `estimated_people` | `integer NOT NULL CHECK(estimated_people>=0)` |
| `source_type` | `text NOT NULL` |
| `observed_at` | `timestamptz NOT NULL` |
| `updated_at` | `timestamptz NOT NULL DEFAULT now()` |

## gate_queue_states

| Attribute or table constraint | Definition |
|---|---|
| `event_gate_id` | `uuid PRIMARY KEY REFERENCES event_gates(id)` |
| `people_waiting` | `integer NOT NULL CHECK(people_waiting>=0)` |
| `processing_per_min` | `numeric(9,2) CHECK(processing_per_min>=0)` |
| `observed_at` | `timestamptz NOT NULL` |

## crowd_alerts

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `event_id` | `uuid NOT NULL REFERENCES events(id)` |
| `event_zone_id` | `uuid REFERENCES event_zones(id)` |
| `event_gate_id` | `uuid REFERENCES event_gates(id)` |
| `severity` | `text NOT NULL CHECK(severity IN('INFO','WARNING','CRITICAL'))` |
| `message` | `text NOT NULL` |
| `status` | `text NOT NULL DEFAULT 'OPEN' CHECK(status IN('OPEN','RESOLVED'))` |
| `created_at` | `timestamptz NOT NULL DEFAULT now()` |

## staff_profiles

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `user_id` | `uuid NOT NULL UNIQUE REFERENCES users(id)` |
| `designation` | `text NOT NULL` |

## staff_assignments

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `staff_id` | `uuid NOT NULL REFERENCES staff_profiles(id)` |
| `event_id` | `uuid NOT NULL REFERENCES events(id)` |
| `event_zone_id` | `uuid REFERENCES event_zones(id)` |
| `event_gate_id` | `uuid REFERENCES event_gates(id)` |
| `shift_start` | `timestamptz NOT NULL` |
| `shift_end` | `timestamptz NOT NULL` |
| `CHECK(shift_end>shift_start)` | `` |

## incidents

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `event_id` | `uuid NOT NULL REFERENCES events(id)` |
| `event_zone_id` | `uuid REFERENCES event_zones(id)` |
| `reported_by` | `uuid REFERENCES users(id)` |
| `category` | `text NOT NULL` |
| `severity` | `text NOT NULL CHECK(severity IN('LOW','MEDIUM','HIGH','CRITICAL'))` |
| `description` | `text NOT NULL` |
| `status` | `text NOT NULL DEFAULT 'OPEN' CHECK(status IN('OPEN','INVESTIGATING','RESOLVED'))` |
| `created_at` | `timestamptz NOT NULL DEFAULT now()` |

## incident_responses

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `incident_id` | `uuid NOT NULL REFERENCES incidents(id)` |
| `staff_id` | `uuid REFERENCES staff_profiles(id)` |
| `action_taken` | `text NOT NULL` |
| `created_at` | `timestamptz NOT NULL DEFAULT now()` |

## audit_logs

| Attribute or table constraint | Definition |
|---|---|
| `id` | `bigserial PRIMARY KEY` |
| `user_id` | `uuid REFERENCES users(id)` |
| `action` | `text NOT NULL` |
| `entity` | `text NOT NULL` |
| `entity_id` | `text` |
| `created_at` | `timestamptz NOT NULL DEFAULT now()` |

## outbox_events

| Attribute or table constraint | Definition |
|---|---|
| `id` | `uuid PRIMARY KEY DEFAULT gen_random_uuid()` |
| `event_type` | `text NOT NULL` |
| `payload` | `jsonb NOT NULL` |
| `created_at` | `timestamptz NOT NULL DEFAULT now()` |
| `delivered_at` | `timestamptz` |
| `retries` | `integer NOT NULL DEFAULT 0 CHECK(retries>=0)` |
