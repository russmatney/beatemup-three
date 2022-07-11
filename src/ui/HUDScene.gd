extends Control

var time_count: RichTextLabel
onready var timer = $Timer

var notif_container
onready var text_scene = preload("res://src/ui/NotificationText.tscn")

var playerStatus
var enemyStatus

## ready ############################################################

func _ready():
  time_count = find_node("TimeLabel")
  notif_container = find_node("Notifications")

  playerStatus = find_node("PlayerStatus")
  enemyStatus = find_node("EnemyStatus")

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
  if enemyStatus:
    enemyStatus.set_char(ch)

func set_player(ch):
  if playerStatus:
    playerStatus.set_char(ch)
