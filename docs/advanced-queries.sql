-- Relational join + aggregate + HAVING
SELECT e.name,g.name AS gate_name,COUNT(*) AS accepted_scans
FROM scan_attempts s JOIN event_gates eg ON eg.id=s.event_gate_id
JOIN gates g ON g.id=eg.gate_id JOIN events e ON e.id=eg.event_id
WHERE s.result='ACCEPTED' GROUP BY e.name,g.name HAVING COUNT(*)>=1
ORDER BY accepted_scans DESC;
-- CTE and subquery for per-event alert counts
WITH alert_counts AS (SELECT event_id,COUNT(*) AS total FROM crowd_alerts GROUP BY event_id)
SELECT e.name,COALESCE(a.total,0) total_alerts FROM events e LEFT JOIN alert_counts a ON a.event_id=e.id ORDER BY total_alerts DESC;
-- Window query for latest scan per gate
SELECT event_gate_id,scanned_at,result,ROW_NUMBER() OVER(PARTITION BY event_gate_id ORDER BY scanned_at DESC) AS recency_rank FROM scan_attempts;
-- Benchmark with EXPLAIN ANALYZE
EXPLAIN ANALYZE SELECT * FROM scan_attempts WHERE event_gate_id='00000000-0000-4000-8000-000000000008' ORDER BY scanned_at DESC LIMIT 50;
