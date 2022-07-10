extends BTLeaf

enum { LEFT, RIGHT }

export(float) var min_x = -40
export(float) var max_x = 40
export(float) var min_y = -40
export(float) var max_y = 40

export(float) var min_t = 0.3
export(float) var max_t = 0.8
export(float) var return_min_t = 0.6

export(float) var allowed_wander_distance = 100

func _tick(agent: Node, _blackboard: Blackboard) -> bool:
  assert("move_in_dir" in agent)
  assert("patrol_points" in agent)

  var time: float
  var direction = Vector2()
  var current_pos = agent.get_global_position()

  var closest_point
  var closest_point_distance
  for point in agent.patrol_points:
    var dist = current_pos.distance_to(point)
    if not closest_point or dist < closest_point_distance:
      closest_point_distance = dist
      closest_point = point

  if closest_point_distance > allowed_wander_distance:
    direction = current_pos.direction_to(closest_point)
    time = rand_range(return_min_t, max_t)
  else:
    direction = Vector2(rand_range(min_x, max_x), rand_range(min_y, max_y))
    time = rand_range(min_t, max_t)

  agent.move_in_dir = direction.normalized()
  yield(get_tree().create_timer(time), "timeout")

  agent.move_in_dir = Vector2.ZERO

  return succeed()
