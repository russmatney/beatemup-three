extends Area2D
class_name TileDetector

# copy-pastaed from DetectableTileMap.gd
enum color {BLUE, RED, ORANGE, GREEN}
export(color) var mark_color = color.RED

onready var collision_shape = $CollisionShape2D

func _on_body_entered(body: Node):
  if body is TileMap:
    if body.has_method("add_active_body"):
      body.add_active_body(self)

# Returns an array of vector2s - the overlapping tilemap cell coordinates
func overlapping_cells(tm: TileMap) -> Array:
  # may one day need to support more shapes here
  var extents = collision_shape.shape.extents
  var first_cell = tm.world_to_map(global_position - extents)
  var last_cell = tm.world_to_map(global_position + extents)
  var cells = []
  for x in range(first_cell.x, last_cell.x + 1):
    for y in range(first_cell.y, last_cell.y + 1):
      cells.append(Vector2(x, y))
  return cells
