extends Control

var time_count: RichTextLabel
onready var timer = $Timer

onready var enemy_status_timer = $EnemyStatusTimer
export(float) var enemy_status_timeout = 3.0

var notif_container
onready var text_scene = preload("res://src/ui/NotificationText.tscn")

var player_status
var enemy_status

## ready ############################################################

func _ready():
  time_count = find_node("TimeLabel")
  notif_container = find_node("Notifications")

  player_status = find_node("PlayerStatus")
  enemy_status = find_node("EnemyStatus")

  set_time(0)
  print(timer)
  print(timer.is_stopped())

## time ############################################################

func set_time(t: int):
  time_count.bbcode_text = "[right]Time: " + str(t) + "[/right]"

func _on_Timer_timeout():
  HUD.increment_time()
  print("timer timing out")
  set_time(HUD.state.time)


## notifications ############################################################

func remove_node_after(node, t):
  yield(get_tree().create_timer(t), "timeout")
  node.queue_free()

func create_new_notif(notif):
  var timeout = notif.timeout if notif.timeout else HUD.default_timeout
  var node = text_scene.instance()
  node.bbcode_text = "[right]" + notif.message + "[/right]"
  notif_container.add_child(node)
  remove_node_after(node, timeout)

## status ############################################################

func set_enemy(ch):
  if enemy_status:
    enemy_status.set_char(ch)
    enemy_status_timer.start(enemy_status_timeout)

func set_player(ch):
  if player_status:
    player_status.set_char(ch)

func _on_EnemyStatusTimer_timeout():
  if enemy_status:
    enemy_status.clear_char()
