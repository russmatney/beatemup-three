extends BTConditional

# True if the agent's target has an open attack slot
func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
  var attack_map
  if blackboard.has_data("attack_map"):
    attack_map = blackboard.get_data("attack_map")
  else:
    attack_map = {}
  # TODO probably create the attack map earlier than this, and assert in here

  var target_slots
  if agent.target and agent.target.has_method("attack_slots"):
    target_slots = agent.target.attack_slots()

  var open_slot = false
  for slot in target_slots:
    var attacker_id = attack_map.get(slot.get_instance_id())
    if attacker_id == agent.get_instance_id():
      # this agent already has an attack slot
      # so we can't claim another one
      verified = false
      return

    if not attacker_id:
      open_slot = true
      break

  verified = open_slot
