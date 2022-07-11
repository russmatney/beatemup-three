extends Control

onready var char_name = $VBoxContainer/CharName

var character

func set_char(ch):
  print("setting char", ch)

  char_name.bbcode_text = "[right]" + ch.name + "[/right]"
