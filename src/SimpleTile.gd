extends Node2D

onready var tm = $TileMap

var detectors = []

enum {NONE, BLUE_LIGHT, BLUE_DARK, RED_LIGHT, RED_DARK}

func _process(_delta):
  for detector in detectors:
    # var extents = detector.get_shape().get_extents()
    # print("extents", extents)

    var detector_pos:Vector2 = detector.global_position
    var cell:Vector2 = tm.world_to_map(detector_pos)

    tm.set_cell(cell.x, cell.y, RED_LIGHT if fmod(cell.x + cell.y, 2) == 0 else RED_DARK)

func add_active_body(body):
  detectors.append(body)

func remove_active_body(body):
  detectors.erase(body)
