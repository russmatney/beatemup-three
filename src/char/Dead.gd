extends State

## enter ###########################################################


func enter(_arg = {}):
	if not owner.is_player:
		HUD.set_enemy_status(owner)
		owner.remove_char()
	else:
		HUD.set_player_status(owner)

		if owner.lives > 0:
			owner.lives -= 1
			yield(get_tree().create_timer(owner.dead_time), "timeout")
			transit("Resurrected")
		else:
			owner.remove_dead_player()


## process ###########################################################


func process(_delta):
	pass


## physics ###########################################################


func physics_process(_delta):
	pass
