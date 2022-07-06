extends Area2D
# tightly coupled to SimpleTile.gd

onready var extents = null

func _ready():
  if $CollisionShape2D:
    extents = $CollisionShape2D.shape.extents
  else:
    Notif.notif("tile detector ought to know it's own extents!")

func _on_TileDetector_body_entered(body):
  if body is TileMap:
    if body.get_parent().has_method("add_active_body"):
      body.get_parent().add_active_body(self)


# area2ds fire body_exited when tilemap set_cell is called
# func _on_TileDetector_body_exited(body:Node):
#   if body is TileMap:
#     if body.get_parent().has_method("remove_active_body"):
#       body.get_parent().remove_active_body(self)
