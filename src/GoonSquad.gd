extends Node2D

var waves = [
  {"name": "Wave 1", "goon_count": 3, "goon_opts": [{"total_health": 4}, {"total_health": 3}]},
  {"name": "Wave 2", "goon_count": 1, "goon_opts": [{"total_health": 4}]},
  {"name": "Wave 3", "goon_count": 3, "goon_opts": [{"total_health": 1}]},
  {"name": "Wave 4", "goon_count": 2, "goon_opts": [{"total_health": 5}]},
]

var next_wave_idx = 0
var goons = []

onready var wave_timer = $WaveTimer
onready var next_wave_ui_timer = $NextWaveUITimer
export(float) var wave_break_time = 2.0

onready var blackboard = $Blackboard
onready var goon_scene = preload("res://src/Char.tscn")
onready var goon_behavior_tree = preload("res://src/behaviors/GoonBehaviorTree.tscn")

### ready #####################################################################

func _ready():
  queue_wave()

func queue_wave():
  # could move to popping waves off instead of using an index...
  if next_wave_idx < waves.size():
    next_wave_ui_timer.start()
    wave_timer.start(wave_break_time)
  else:
    # TODO handle victory
    HUD.notif("No more waves!")

func _on_WaveTimer_timeout():
  next_wave_ui_timer.stop()
  launch_next_wave()
  HUD.hide_time_until_wave()

func _on_NextWaveUITimer_timeout():
  HUD.next_wave_in(int(wave_timer.time_left))

### process #####################################################################

func _process(_delta):
  pass


### launch wave logic #####################################################################

func launch_next_wave():
  if next_wave_idx < waves.size():
    launch_wave(waves[next_wave_idx])
    next_wave_idx += 1

func launch_wave(wave_opts):
  var wave_name = wave_opts.get("name", "Unnamed Wave")
  var count = wave_opts.get("goon_count", 1)
  var goon_opts = wave_opts.get("goon_opts", [])

  # TODO switch to Hud temp title/banner/jumbotron
  HUD.notif(wave_name)

  goon_opts.shuffle()
  for i in range(count):
    var opts
    if goon_opts.size() > 0:
      var opt_i = i % goon_opts.size()
      opts = goon_opts[opt_i]

    # create goon node
    var goon_node = goon_scene.instance()

    # merge from wave opts
    if opts:
      for k in opts:
        if k in goon_node:
          goon_node[k] = opts[k]

    # TODO pick spawn points

    # connect to goon death
    goon_node.connect("died", self, "_on_goon_died", [goon_node])

    # add to local goon list
    goons.append(goon_node)

    # add goon
    add_child(goon_node)

    # add behavior tree to goon (after it has a node_path)
    add_behavior_tree(goon_node)

    HUD.set_goons_count(goons.size())

    # wait a blip before adding the next one
    yield(get_tree().create_timer(0.3), "timeout")

func _on_goon_died(goon):
  goons.erase(goon)

  HUD.set_goons_count(goons.size())

  if goons.size() <= 0:
    queue_wave()

func add_behavior_tree(goon):
  # add behavior tree
  var bt = goon_behavior_tree.instance()
  bt._blackboard = blackboard.get_path()
  bt._agent = goon.get_path()
  goon.add_child(bt)

  bt.is_active = true
