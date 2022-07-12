extends BTConditional

export(String) var target_group = "char-body"

func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
  assert(target_group)
  assert("in_detectbox" in agent)
  assert("target" in agent)

  var attack_map
  if blackboard.has_data("attack_map"):
    attack_map = blackboard.get_data("attack_map")
  else:
    attack_map = {}
  # TODO probably create the attack map earlier than this, and assert in here

  var current_pos = agent.get_global_position()

  var closest_target
  var closest_target_dist

  var closest_open_target
  var closest_open_target_dist
  for ch in agent.in_detectbox:
    if ch.is_in_group(target_group):
      # TODO consider raycast for line-of-sight check
      var dist = current_pos.distance_to(ch.get_global_position())
      if not closest_target_dist or dist < closest_target_dist:
        closest_target = ch
        closest_target_dist = dist

      var has_open_slot = false
      for slot in ch.attack_slots():
        var attacker_id = attack_map.get(slot.get_instance_id())
        if not attacker_id:
          has_open_slot = true
          break
        # TODO probably want to include 'dying' and 'dead' states as open slots here
        var attacker = instance_from_id(attacker_id)
        if not attacker:
          has_open_slot = true
          break

      if has_open_slot and (not closest_open_target_dist or dist < closest_open_target_dist):
        closest_open_target = ch
        closest_open_target_dist = dist

  # prefer targets with open slots
  if closest_open_target:
    # TODO consider a pause and 'tell' here
    agent.assign_target(closest_target)
    verified = true
  if closest_target:
    agent.assign_target(closest_target)
    # TODO consider a pause and 'tell' here
    verified = true
  else:
    verified = false
