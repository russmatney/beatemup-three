extends Node2D

onready var tm = $TileMap

# A dictionary by instance_id
var detectors = {}

# cells to reset
var to_reset = {}
# cells to mark active
var to_mark = {}

enum {NONE, BLUE_LIGHT, BLUE_DARK, RED_LIGHT, RED_DARK}

func _is_even(i: int) -> bool:
  return fmod(i, 2) == 0

func _process(_delta):
  for detector in detectors.values():
    # TODO check if detector is still alive?
    # TODO consider letting the detector/something else determine what to indicate on the map?
    if "extents" in detector:
      var first_cell = tm.world_to_map(detector.global_position - detector.extents)
      var last_cell = tm.world_to_map(detector.global_position + detector.extents)
      for x in range(first_cell.x, last_cell.x + 1):
        for y in range(first_cell.y, last_cell.y + 1):
          to_mark[Vector2(x, y)] = true
    else:
      print("detector without extents!")
      var cell = tm.world_to_map(detector.global_position)
      to_mark[cell] = true

  for v in to_reset.keys():
    if not to_mark.has(v):
      # reset this cell to blue
      var curr_idx: int = tm.get_cellv(v)
      var new_idx: int = BLUE_LIGHT if _is_even(v.x + v.y) else BLUE_DARK
      if curr_idx != new_idx:
        tm.set_cellv(v, new_idx)
      to_reset.erase(v)

  for v in to_mark.keys():
    var curr_idx: int = tm.get_cellv(v)
    var new_idx: int = RED_LIGHT if _is_even(v.x + v.y) else RED_DARK
    if curr_idx != new_idx:
      tm.set_cellv(v, new_idx)
    to_mark.erase(v)
    # store to be reset on the next pass (unless it is marked again)
    to_reset[v] = true

func add_active_body(body):
  detectors[body.get_instance_id()] = body

func remove_active_body(body):
  detectors.erase(body.get_instance_id())
