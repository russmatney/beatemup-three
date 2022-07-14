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

# waves

func set_goons_count(ct: int):
  hud_scene.set_goons_count(ct)

func next_wave_in(t: int):
  hud_scene.set_time_until_wave(t)

func hide_time_until_wave():
  hud_scene.hide_time_until_wave()

# notifs

var default_timeout: int = 4

func notif(message: String, timeout: int = default_timeout):
  hud_scene.create_new_notif({"message": message, "timeout": timeout})

# banner

func banner(message: String, timeout: int = default_timeout):
  hud_scene.set_banner({"message": message, "timeout": timeout})

# char names

func set_enemy_status(ch):
  hud_scene.set_enemy(ch)

func set_player_status(ch):
  hud_scene.set_player(ch)
