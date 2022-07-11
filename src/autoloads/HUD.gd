# HUD.gd
extends CanvasLayer

var hud_scene = "res://src/ui/HUDScene.tscn"
var scene
var is_ready = false

var state = {"time": 0}

func _ready():
  if not scene:
    var s = ResourceLoader.load(hud_scene)
    scene = s.instance()
    call_deferred("add_child", scene)

  yield(scene, "ready")
  is_ready = true

func increment_time():
  state.time += 1

var default_timeout: int = 4

func notif(message: String, timeout: int = default_timeout):
  scene.create_new_notif({"message": message, "timeout": timeout})

func set_enemy_status(ch):
  scene.set_enemy(ch)

func set_player_status(ch):
  scene.set_player(ch)
