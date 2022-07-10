extends BTLeaf

# this needs to be guarded, or it will kick way too many times
func _tick(agent: Node, _blackboard: Blackboard) -> bool:
  assert(agent.has_method("kick"))

  var result = agent.call("kick")
  if result is GDScriptFunctionState:
    result = yield(result, "completed")

  return succeed()
