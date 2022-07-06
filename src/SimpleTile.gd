extends Node2D

onready var tm = $TileMap

# A dictionary by instance_id
var detectors = {}

# cells to reset
var to_reset = {}
# cells to mark active
var to_mark = {}

# correspond to the index of the tiles in the tilemap's tileset
enum {NONE,
    BLUE_LIGHT, BLUE_DARK, RED_LIGHT, RED_DARK,
    ORANGE_LIGHT, ORANGE_DARK, GREEN_LIGHT, GREEN_DARK}
# convenient for supporting various color types
enum {BLUE, RED, ORANGE, GREEN}

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
      mark_tile(v, BLUE)
      to_reset.erase(v)

  for v in to_mark.keys():
    mark_tile(v, RED)
    to_mark.erase(v)
    # store to be reset on the next pass (unless it is marked again)
    to_reset[v] = true

func add_active_body(body):
  detectors[body.get_instance_id()] = body

func remove_active_body(body):
  detectors.erase(body.get_instance_id())

func mark_tile(v: Vector2, color: int = BLUE):
    var colord = color_to_tileset_color(color)
    var new_tile_idx: int = color_for_cell(v, colord["light"], colord["dark"])
    var curr_tile_idx: int = tm.get_cellv(v)
    if curr_tile_idx != new_tile_idx:
      tm.set_cellv(v, new_tile_idx)

func color_for_cell(v: Vector2, light: int, dark: int) -> int:
      return light if _is_even(v.x + v.y) else dark

func color_to_tileset_color(color: int) -> Dictionary:
    match color:
        BLUE:
            return {"light": BLUE_LIGHT, "dark": BLUE_DARK}
        RED:
            return {"light": RED_LIGHT, "dark": RED_DARK}
        ORANGE:
            return {"light": ORANGE_LIGHT, "dark": ORANGE_DARK}
        GREEN:
            return {"light": GREEN_LIGHT, "dark": GREEN_DARK}
    return {}
