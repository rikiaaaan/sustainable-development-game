extends Node

var current_scene_name:String = ""
var did_tween:bool = false

func _ready() -> void:

	change_scene("title", false)

	return

func _input(event:InputEvent) -> void:

	if event.is_action_pressed("fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			pass
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			pass
		pass

	return


func change_scene(scene_name:String, with_tween:bool=true) -> void:

	print_debug("change_scene called")
	print_debug("scene_name: "+scene_name)
	print_debug("with_tween: "+var_to_str(with_tween))
	

	var tween:Tween
	did_tween = false
	
	if current_scene_name != "":
		
		did_tween = true
		$CanvasLayer/ColorRect.modulate = Color(1,1,1,0)
		$CanvasLayer.show()
		
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT_IN)
		tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(1,1,1,1),0.25)
		await tween.finished
		
		var current_scene = get_node("./"+current_scene_name)
		for child in current_scene.get_children():
			current_scene.remove_child(child)
			child.queue_free()
		remove_child(current_scene)
		current_scene.queue_free()
	
	var scene_path:String = "res://scenes/"+scene_name+"/"+scene_name+".tscn"
	var scene
	
	if !ResourceLoader.exists(scene_path):
		OS.alert("This scene(%s) does not exist." % [scene_name])
		get_tree().quit()
		return
	elif ResourceLoader.has_cached(scene_path):
		print_debug("This scene has already cached! yay!")
		scene = ResourceLoader.load(scene_path).instantiate()
		pass
	else:
		print_debug("This scene has not cached yet!")
		ResourceLoader.load_threaded_request(scene_path, "", true, ResourceLoader.CACHE_MODE_REPLACE)
		scene = ResourceLoader.load(scene_path).instantiate()
		pass
	
	scene.name = scene_name
	current_scene_name = scene_name
	
	scene.process_mode = Node.PROCESS_MODE_DISABLED
	add_child(scene, true)

	if did_tween:
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT_IN)
		tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(1,1,1,0), 0.25)
		await tween.finished
		pass
		
	$CanvasLayer.hide()
	scene.process_mode = Node.PROCESS_MODE_INHERIT
	
	return
