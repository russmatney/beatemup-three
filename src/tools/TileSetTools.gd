tool
extends TileSet

### ready #####################################################################


func _ready():
	print("tileSet tool script ready")


func _enter_tree():
	print("tileSet Tool enter tree")


func _exit_tree():
	print("tileSet Tool exit tree")


### generate_collisions #######################################################

export(bool) var dryrun = true
export(bool) var run_gen_collisions = false setget run_gen_colls

export(String) var tile_name = "citybrick"


func run_gen_colls(val):
	# make sure this only runs when we click the checkbox
	if val:
		var used_tile_ids = get_tiles_ids()
		var tile_ids = []
		for t_id in used_tile_ids:
			if tile_name == tile_get_name(t_id):
				tile_ids.append(t_id)

		gen_collisions(tile_ids)


func gen_collisions(tile_ids):
	print("generating collisions for tile_ids: ", tile_ids)

	for t_id in tile_ids:
		var mode = tile_get_tile_mode(t_id)
		match mode:
			2:
				gen_collisions_for_atlas(t_id)
			_:
				print("unsupported tile mode: ", mode, " for tile: ", t_id)


func gen_collisions_for_atlas(tile_id):
	var region_rect = tile_get_region(tile_id)
	var tile_size = autotile_get_size(tile_id).x

	var end_point_x = int(region_rect.size.x) % int(tile_size)  # seems legit?
	var end_point_y = int(region_rect.size.y) % int(tile_size)

	for x in range(0, end_point_x + 1):
		for y in range(0, end_point_y + 1):
			# this value is local to the atlas
			var autotile_coord = Vector2(x, y)
			var shape = create_collision_shape(tile_id)
			if dryrun:
				print(
					"would add collision shape to tile_id: ", tile_id, " at coord: ", autotile_coord
				)
			else:
				print("adding collision shape to tile_id: ", tile_id, " at coord: ", autotile_coord)
				tile_add_shape(tile_id, shape, Transform2D(0, Vector2.ZERO), false, autotile_coord)


func create_collision_shape(tile_id):
	var tile_size = autotile_get_size(tile_id).x
	var shape = ConvexPolygonShape2D.new()
	shape.points = [
		Vector2(0, 0), Vector2(0, tile_size), Vector2(tile_size, tile_size), Vector2(tile_size, 0)
	]
	return shape
