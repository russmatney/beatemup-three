extends BTConditional

func _pre_tick(agent: Node, blackboard: Blackboard) -> void:
  var attack_map
  if blackboard.has_data("attack_map"):
    attack_map = blackboard.get_data("attack_map")
  else:
    attack_map = {}
  # TODO probably create the attack map earlier than this, and assert in here

  verified = false

  var target_slots
  if agent.target and agent.target.has_method("attack_slots"):
    target_slots = agent.target.attack_slots()

  var current_pos = agent.get_global_position()
  var closest_open_slot
  var smallest_dist

  var already_owned_slot_id

  for slot in target_slots:
    var attacker_id = attack_map.get(slot.get_instance_id())

    if attacker_id:
      var inst = instance_from_id(attacker_id)
      if not inst:
        # this attacker is not valid, probably dead
        attacker_id = null

    if attacker_id and attacker_id == agent.get_instance_id():
      already_owned_slot_id = slot.get_instance_id()

    # skip if the attacker_id is not us - that slot is already claimed
    if not attacker_id or (attacker_id and attacker_id == agent.get_instance_id()):
      var dist = slot.get_global_position().distance_to(current_pos)
      if not smallest_dist or dist < smallest_dist:
        smallest_dist = dist
        closest_open_slot = slot

  if already_owned_slot_id and already_owned_slot_id != closest_open_slot.get_instance_id():
    # we should switch to the closer slot
    verified = true
  elif not already_owned_slot_id and closest_open_slot:
    # or we don't have a slot, and one is available
    verified = true
