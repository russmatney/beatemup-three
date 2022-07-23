extends BTConditional


func _pre_tick(agent: Node, _blackboard: Blackboard) -> void:
	assert("target" in agent)

	if agent.can_attack():
		# ie. not punching and not kicking and not stunned and not knocked_back
		if agent.target:
			if agent.target in agent.in_punchbox:
				verified = true
