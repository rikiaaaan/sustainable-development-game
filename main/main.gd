extends Node

var current_scene_name:String = ""

const BUTTON_GUIDE_DATA:Dictionary = {
	"login":[
		[
			{
				"type": "img",
				"path": "key_left"
			},
			{
				"type": "img",
				"path": "key_right"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"path": "key_enter"
			},
			{
				"type": "text",
				"text": "決定"
			}
		]
	],
	"title":[
		[
			{
				"type": "img",
				"path": "key_up"
			},
			{
				"type": "img",
				"path": "key_down"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"path": "key_enter"
			},
			{
				"type": "text",
				"text": "決定"
			}
		]
	],
	"title2":[
		[
			{
				"type": "img",
				"path": "key_left"
			},
			{
				"type": "img",
				"path": "key_right"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"path": "key_enter"
			},
			{
				"type": "text",
				"text": "決定"
			}
		]
	],
	"myscore":[
		[
			{
				"type": "img",
				"path": "key_ctrl"
			},
			{
				"type": "text",
				"text": "+"
			},
			{
				"type": "img",
				"path": "key_left"
			},
			{
				"type": "img",
				"path": "key_right"
			},
			{
				"type": "text",
				"text": "ランキングを変更する"
			}
		],
		[
			{
				"type": "img",
				"path": "key_enter"
			},
			{
				"type": "text",
				"text": "決定"
			}
		]
	],
	"howtoplay":[
		[
			{
				"type": "img",
				"path": "key_left"
			},
			{
				"type": "img",
				"path": "key_right"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"path": "key_enter"
			},
			{
				"type": "text",
				"text": "決定"
			}
		]
	],
	"play":[
		[
			{
				"type": "img",
				"path": "key_left"
			},
			{
				"type": "img",
				"path": "key_right"
			},
			{
				"type": "text",
				"text": "or"
			},
			{
				"type": "img",
				"path": "key_a"
			},
			{
				"type": "img",
				"path": "key_d"
			},
			{
				"type": "text",
				"text": "移動"
			}
		],
		[
			{
				"type": "img",
				"path": "key_space"
			},
			{
				"type": "text",
				"text": "落下"
			}
		],
		[
			{
				"type": "img",
				"path": "key_enter"
			},
			{
				"type": "text",
				"text": "メニュー"
			}
		],
		[
			{
				"type": "img",
				"path": "key_ctrl"
			},
			{
				"type": "text",
				"text": "+"
			},
			{
				"type": "img",
				"path": "key_left"
			},
			{
				"type": "img",
				"path": "key_right"
			},
			{
				"type": "text",
				"text": "ランキングを変更する"
			}
		]
	],
	"pause":[
		[
			{
				"type": "img",
				"path": "key_up"
			},
			{
				"type": "img",
				"path": "key_down"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"path": "key_enter"
			},
			{
				"type": "text",
				"text": "決定"
			}
		]
	],
	"result":[
		[
			{
				"type": "img",
				"path": "key_left"
			},
			{
				"type": "img",
				"path": "key_right"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"path": "key_enter"
			},
			{
				"type": "text",
				"text": "決定"
			}
		]
	],
	"test":[
		[
			{
				"type": "img",
				"path": "key_ctrl"
			},
			{
				"type": "text",
				"text": "Hello World!"
			}
		]
	]
	
}

func _ready() -> void:

	if Settings.is_succeeded_to_load_data_file:
		change_scene("login", false)
		pass

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

	print_debug("scene_name: "+scene_name)
	print_debug("with_tween: "+var_to_str(with_tween))
	
	var tween:Tween
	
	if with_tween:
		$CanvasLayer/ColorRect.modulate = Color(1,1,1,0)
		$CanvasLayer.show()
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT_IN)
		tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(1,1,1,1),0.25)
		await tween.finished
		pass
	
	if current_scene_name != "":
		var current_scene:Node = get_node("./"+current_scene_name)
		for child in current_scene.get_children():
			current_scene.remove_child(child)
			child.queue_free()
			pass
		remove_child(current_scene)
		current_scene.queue_free()
		pass
	
	var scene_path:String = "res://"+scene_name+"/"+scene_name+".tscn"
	var scene
	
	if !ResourceLoader.exists(scene_path):
		OS.alert("[ERROR]This scene(%s) does not exist." % [scene_name], "ERROR")
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
	
	if with_tween:
		tween = create_tween()
		tween.set_ease(Tween.EASE_OUT_IN)
		tween.tween_property($CanvasLayer/ColorRect, "modulate", Color(1,1,1,0), 0.25)
		await tween.finished
		$CanvasLayer.hide()
		pass
	
	scene.process_mode = Node.PROCESS_MODE_INHERIT

	return
