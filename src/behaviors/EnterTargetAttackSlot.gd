extends BTLeaf

export(float) var min_complete_distance = 20

# Take the attack slot
func _tick(agent, blackboard):
  var attack_map
  if blackboard.has_data("attack_map"):
    attack_map = blackboard.get_data("attack_map")
  else:
    attack_map = {}
  # TODO probably create the attack map earlier than this, and assert in here

  var target_slots
  if agent.target and agent.target.has_method("attack_slots"):
    target_slots = agent.target.attack_slots()

  var agent_claimed_slot
  for slot in target_slots:
    var attacker_with_claim_id = attack_map.get(slot.get_instance_id())
    if attacker_with_claim_id and attacker_with_claim_id == agent.get_instance_id():
      agent_claimed_slot = slot
      break

  if not agent_claimed_slot:
    print("warning, expected slot claimed for agent, but none found")
    return failed()

  agent.approach_target(agent_claimed_slot.get_global_position())
  agent.face_attacker(agent.target)

  var distance_from_slot = agent.get_global_position().distance_to(agent_claimed_slot.get_global_position())

  if distance_from_slot <= min_complete_distance:
    return succeed()
  else:
    return fail()
