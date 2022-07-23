extends BTConditional

export(float) var approach_complete_distance = 20


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	assert("target" in agent)

	verified = false

	if agent.target:
		# TODO if agent.target is valid
		var distance_from_target = agent.get_global_position().distance_to(
			agent.target.get_global_position()
		)

		if distance_from_target <= approach_complete_distance:
			verified = true
