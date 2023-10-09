extends Node

func _input(event:InputEvent) -> void:
	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			pass
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			pass
		pass
	if event.is_action_pressed("summon_sdg"):
		summon_sdg()
		pass
	return

func summon_sdg() -> void:
	var sdg = ResourceLoader.load("res://shared/sdg/sdg.tscn").instantiate()
	var mouse_pos_rel:Vector2i = DisplayServer.mouse_get_position() - DisplayServer.window_get_position()
	print(mouse_pos_rel)
	sdg.position = mouse_pos_rel
	$Node2D/Sdgs.add_child(sdg)
	
	return

func _process(_delta:float) -> void:
	var cam_vec:Vector2 = Vector2.ZERO
	cam_vec.x = int(Input.is_key_pressed(KEY_L)) - int(Input.is_key_pressed(KEY_J))
	cam_vec.y = int(Input.is_key_pressed(KEY_K)) - int(Input.is_key_pressed(KEY_I))
	$Camera2D.position += cam_vec * 3
	$Camera2D.zoom += Vector2(0.1,0.1) * (int(Input.is_key_pressed(KEY_E)) - int(Input.is_key_pressed(KEY_Q)))
	return
