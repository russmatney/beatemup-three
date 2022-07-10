extends BTLeaf

func _tick(agent: Node, _blackboard: Blackboard) -> bool:
  assert(agent.has_method("punch"))

  # this needs to be guarded, or it will punch way too many times
  print("agent punching!")
  agent.punch()

  # TODO refactor into yield until punch-finished signal from agent
  yield(get_tree().create_timer(3.0), "timeout")

  if agent.punching:
    print("punch running!")
    return running()
  else:
    return succeed()
