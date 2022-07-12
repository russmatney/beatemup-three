# HUD.gd
extends CanvasLayer

var hud_scene_res = "res://src/ui/HUDScene.tscn"
var hud_scene
var is_ready = false

var state = {"time": 0}

# ready

func _ready():
  if not hud_scene:
    var s = ResourceLoader.load(hud_scene_res)
    hud_scene = s.instance()
    call_deferred("add_child", hud_scene)

  yield(hud_scene, "ready")
  is_ready = true

# time

func increment_time():
  state.time += 1

# notifs

var default_timeout: int = 4

func notif(message: String, timeout: int = default_timeout):
  hud_scene.create_new_notif({"message": message, "timeout": timeout})

# char names

func set_enemy_status(ch):
  hud_scene.set_enemy(ch)

func set_player_status(ch):
  hud_scene.set_player(ch)
