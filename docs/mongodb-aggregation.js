// Run with mongosh connected to eventcrowd (requires scan data)
db.scan_events.aggregate([
  {$match:{result:'ACCEPTED'}},
  {$group:{_id:{event_id:'$eventId',gate_id:'$eventGateId'},count:{$sum:1}}},
  {$sort:{count:-1}}
]);
db.crowd_observations.aggregate([
  {$group:{_id:'$event_zone_id',peak_estimated_people:{$max:'$estimated_people'},observations:{$sum:1}}},
  {$sort:{peak_estimated_people:-1}}
]);
