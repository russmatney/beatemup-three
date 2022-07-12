extends Control

var char_name_label
var health_label
var lives_label
var score_label
var combo_label

var character

### ready #####################################################################

func _ready():
  char_name_label = find_node("CharName")
  health_label = find_node("Health")
  lives_label = find_node("Lives")
  score_label = find_node("Score")
  combo_label = find_node("Combo")

  hide_labels()

### show/hide labels #####################################################################

func hide_labels():
  char_name_label.visible = false
  health_label.visible = false
  lives_label.visible = false
  score_label.visible = false
  combo_label.visible = false

func show_all_labels():
  char_name_label.visible = true
  health_label.visible = true
  lives_label.visible = true
  # score_label.visible = true
  # combo_label.visible = true

func show_basic_labels():
  char_name_label.visible = true
  health_label.visible = true

### set char #####################################################################

func set_char(ch):
  character = ch
  set_char_label(ch.name)
  set_health(ch.current_health, ch.total_health)
  show_basic_labels()
  if ch.is_player:
    set_lives(ch.lives)
    # set_score(ch.score)
    # set_combos(ch.combos)
    show_all_labels()

func clear_char():
  hide_labels()
  character = null

### update labels #####################################################################

func set_char_label(name):
  char_name_label.bbcode_text = "[right]" + name + "[/right]"

func set_health(current: int, total: int):
  health_label.bbcode_text = "[right]Health: " + str(current) + "/" + str(total) + "[/right]"

func set_lives(current: int):
  lives_label.bbcode_text = "[right]Lives: " + str(current) + "[/right]"

func set_score(current: int):
  score_label.bbcode_text = "[right]Score: " + str(current) + "[/right]"

func set_combos(current: int):
  combo_label.bbcode_text = "[right]Combos: " + str(current) + "[/right]"
