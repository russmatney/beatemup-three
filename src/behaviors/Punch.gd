extends BTLeaf


# this needs to be guarded, or it will punch way too many times
func _tick(agent: Node, _blackboard: Blackboard) -> bool:
	assert(agent.has_method("punch"))

	var result = agent.call("punch")
	if result is GDScriptFunctionState:
		result = yield(result, "completed")

	return succeed()
