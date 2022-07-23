extends BTConditional

# handles attack slots with a dict from attack_slot.object_id -> attacker.object-id


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

	var agent_claimed_slot
	for slot in target_slots:
		var attacker_with_claim_id = attack_map.get(slot.get_instance_id())
		if attacker_with_claim_id and attacker_with_claim_id == agent.get_instance_id():
			agent_claimed_slot = true
			break

	if agent_claimed_slot:
		verified = true
