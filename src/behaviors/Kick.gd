extends BTLeaf

func _tick(agent: Node, _blackboard: Blackboard) -> bool:
  assert(agent.has_method("kick"))

  # this needs to be guarded, or it will kick way too many times
  print("agent kicking!")
  agent.kick()

  # TODO do these already wait until the method is done?
  # b/c punch/kick yields? that would be excellent.

  # TODO refactor into yield until punch-finished signal from agent
  yield(get_tree().create_timer(3.0), "timeout")

  if agent.kicking:
    print("kick running!")
    return running()
  else:
    return succeed()
