extends BTLeaf


func _tick(agent: Node, blackboard: Blackboard) -> bool:
  # wait_time = blackboard.get_data(time_in_bb)

  # var timer = create_and_start_timer(agent)
  # yield(timer, "timeout")
  # agent.remove_child(timer)

  print("walking right?, tick, tick", agent, blackboard)

  return succeed()
