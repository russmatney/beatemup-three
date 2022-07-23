extends State


func enter(msg = {}):
	if not owner.is_connected("attack_complete", self, "_on_attack_complete"):
		owner.connect("attack_complete", self, "_on_attack_complete")
	owner.attack()


func _on_attack_complete():
	# go round again
	transit("DukesUp")


func process(_delta: float):
	if owner.kicking:
		owner.animated_sprite.animation = "kick"
	elif owner.punching:
		owner.animated_sprite.animation = "punch"
