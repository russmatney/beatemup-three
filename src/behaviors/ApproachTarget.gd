extends BTLeaf

func _tick(agent: Node, _blackboard: Blackboard) -> bool:
  assert("target" in agent)
  assert(agent.has_method("approach_target"))

  if agent.target:
    agent.approach_target()

    return succeed()
  else:
    return failed()
