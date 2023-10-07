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
	sdg.position = Vector2(randi_range(360,800),0)
	$Node2D/sdgs.add_child(sdg)
	
	return
