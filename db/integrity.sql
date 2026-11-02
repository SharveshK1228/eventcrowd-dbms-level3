BEGIN;
-- Cross-table ownership cannot be enforced by a CHECK constraint.
CREATE OR REPLACE FUNCTION validate_event_ownership() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE a uuid; b uuid;
BEGIN
IF TG_TABLE_NAME='event_zones' THEN SELECT venue_id INTO a FROM events WHERE id=NEW.event_id; SELECT venue_id INTO b FROM zones WHERE id=NEW.zone_id;
ELSIF TG_TABLE_NAME='event_gates' THEN SELECT venue_id INTO a FROM events WHERE id=NEW.event_id; SELECT venue_id INTO b FROM gates WHERE id=NEW.gate_id;
ELSIF TG_TABLE_NAME='event_gate_zones' THEN SELECT event_id INTO a FROM event_gates WHERE id=NEW.event_gate_id; SELECT event_id INTO b FROM event_zones WHERE id=NEW.event_zone_id;
ELSIF TG_TABLE_NAME='ticket_zone_access' THEN SELECT event_id INTO a FROM ticket_types WHERE id=NEW.ticket_type_id; SELECT event_id INTO b FROM event_zones WHERE id=NEW.event_zone_id;
ELSIF TG_TABLE_NAME='tickets' THEN SELECT event_id INTO a FROM registrations WHERE id=NEW.registration_id; SELECT event_id INTO b FROM ticket_types WHERE id=NEW.ticket_type_id;
ELSIF TG_TABLE_NAME IN ('incidents','crowd_alerts','staff_assignments') AND NEW.event_zone_id IS NOT NULL THEN a:=NEW.event_id; SELECT event_id INTO b FROM event_zones WHERE id=NEW.event_zone_id;
ELSE RETURN NEW; END IF;
IF a IS DISTINCT FROM b THEN RAISE EXCEPTION 'Event or venue ownership mismatch'; END IF;RETURN NEW;END $$;
CREATE TRIGGER ownership_event_zones BEFORE INSERT OR UPDATE ON event_zones FOR EACH ROW EXECUTE FUNCTION validate_event_ownership();
CREATE TRIGGER ownership_event_gates BEFORE INSERT OR UPDATE ON event_gates FOR EACH ROW EXECUTE FUNCTION validate_event_ownership();
CREATE TRIGGER ownership_gate_zones BEFORE INSERT OR UPDATE ON event_gate_zones FOR EACH ROW EXECUTE FUNCTION validate_event_ownership();
CREATE TRIGGER ownership_ticket_access BEFORE INSERT OR UPDATE ON ticket_zone_access FOR EACH ROW EXECUTE FUNCTION validate_event_ownership();
CREATE TRIGGER ownership_tickets BEFORE INSERT OR UPDATE ON tickets FOR EACH ROW EXECUTE FUNCTION validate_event_ownership();
CREATE TRIGGER ownership_incidents BEFORE INSERT OR UPDATE ON incidents FOR EACH ROW EXECUTE FUNCTION validate_event_ownership();
CREATE TRIGGER ownership_alerts BEFORE INSERT OR UPDATE ON crowd_alerts FOR EACH ROW EXECUTE FUNCTION validate_event_ownership();
CREATE TRIGGER ownership_assignments BEFORE INSERT OR UPDATE ON staff_assignments FOR EACH ROW EXECUTE FUNCTION validate_event_ownership();
CREATE UNIQUE INDEX uq_open_zone_alert ON crowd_alerts(event_zone_id) WHERE status='OPEN' AND event_zone_id IS NOT NULL;
CREATE OR REPLACE FUNCTION incident_outbox() RETURNS trigger LANGUAGE plpgsql AS $$ BEGIN INSERT INTO outbox_events(event_type,payload) VALUES('INCIDENT_CHANGED',jsonb_build_object('incident_id',NEW.id,'event_id',NEW.event_id,'event_type',TG_OP,'status',NEW.status,'occurred_at',now()));RETURN NEW;END $$;
CREATE TRIGGER incident_outbox_event AFTER INSERT OR UPDATE ON incidents FOR EACH ROW EXECUTE FUNCTION incident_outbox();
COMMIT;
