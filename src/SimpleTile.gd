extends Node2D

onready var tm = $TileMap

enum {NONE, BLUE_LIGHT, BLUE_DARK, RED_LIGHT, RED_DARK}

func _ready():
  Notif.notif("some notif")
  print(tm)
  var c = tm.get_cell(0, 0)
  print(c)

  var ts = tm.tile_set
  print(ts)
  print(ts.get_tiles_ids())


func _process(_delta):
  # check for collisions/tiles to flip

  tm.set_cell(0, 0, RED_LIGHT)
  tm.set_cell(0, 1, RED_DARK)
