extends Node

var current_scene_name:String = ""

const BUTTON_GUIDE_DATA:Dictionary = {
	"login":[
		[
			{
				"type": "img",
				"img": "key_left"
			},
			{
				"type": "img",
				"img": "key_right"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"img": "key_enter"
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
				"img": "key_up"
			},
			{
				"type": "img",
				"img": "key_down"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"img": "key_enter"
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
				"img": "key_left"
			},
			{
				"type": "img",
				"img": "key_right"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"img": "key_enter"
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
				"img": "key_ctrl"
			},
			{
				"type": "text",
				"text": "+"
			},
			{
				"type": "img",
				"img": "key_left"
			},
			{
				"type": "img",
				"img": "key_right"
			},
			{
				"type": "text",
				"text": "ランキングを変更する"
			}
		],
		[
			{
				"type": "img",
				"img": "key_enter"
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
				"img": "key_left"
			},
			{
				"type": "img",
				"img": "key_right"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"img": "key_enter"
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
				"img": "key_left"
			},
			{
				"type": "img",
				"img": "key_right"
			},
			{
				"type": "text",
				"text": "or"
			},
			{
				"type": "img",
				"img": "key_a"
			},
			{
				"type": "img",
				"img": "key_d"
			},
			{
				"type": "text",
				"text": "移動"
			}
		],
		[
			{
				"type": "img",
				"img": "key_space"
			},
			{
				"type": "text",
				"text": "落下"
			}
		],
		[
			{
				"type": "img",
				"img": "key_enter"
			},
			{
				"type": "text",
				"text": "メニュー"
			}
		],
		[
			{
				"type": "img",
				"img": "key_ctrl"
			},
			{
				"type": "text",
				"text": "+"
			},
			{
				"type": "img",
				"img": "key_left"
			},
			{
				"type": "img",
				"img": "key_right"
			},
			{
				"type": "text",
				"text": "ランキングを変更する"
			}
		],
		[
			{
				"type": "img",
				"img": "key_ctrl"
			},
			{
				"type": "text",
				"text": "+"
			},
			{
				"type": "img",
				"img": "key_r"
			},
			{
				"type": "text",
				"text": "ランキングを更新する"
			}
		]
	],
	"pause":[
		[
			{
				"type": "img",
				"img": "key_up"
			},
			{
				"type": "img",
				"img": "key_down"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"img": "key_enter"
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
				"img": "key_left"
			},
			{
				"type": "img",
				"img": "key_right"
			},
			{
				"type": "text",
				"text": "選択"
			}
		],
		[
			{
				"type": "img",
				"img": "key_enter"
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
				"img": "key_ctrl"
			},
			{
				"type": "text",
				"text": "Hello World!"
			}
		]
	]
	
}

@onready var _button_guide:CanvasLayer = $ButtonGuide as CanvasLayer
@onready var _button_guide_container:HBoxContainer = $ButtonGuide/ColorRect/HBoxContainer as HBoxContainer


func _ready() -> void:

	_button_guide.hide()
	if Settings.is_succeeded_to_load_data_file:
		_button_guide.show()
		change_button_guide("login")
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


func load_button_img(_name:String) -> Image:

	var img = ResourceLoader.load("res://shared/img/"+_name, "", ResourceLoader.CACHE_MODE_REPLACE)
	print_debug("img typeof: %d" % [typeof(img)])

	return img.get_image()


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


func change_button_guide(guide_name:String) -> void:

	if BUTTON_GUIDE_DATA.has(guide_name):
		
		for guide in _button_guide_container.get_children():
			_button_guide_container.remove_child(guide)
			guide.queue_free()
			pass
		var button_guide:Array = BUTTON_GUIDE_DATA[guide_name]
		
		var label_settings:LabelSettings = LabelSettings.new()
		label_settings.font_size = 25
		label_settings.shadow_color = Color(0, 0, 0, 0.39)
		label_settings.font = ResourceLoader.load("res://shared/font/Corporate-Logo-Rounded-Bold-ver3.otf", "", ResourceLoader.CACHE_MODE_REPLACE)
		
		for section in button_guide:
			var section_container:HBoxContainer = HBoxContainer.new()
			for data in section:
				match data.type:
					"img":
						var texture_rect:TextureRect = TextureRect.new()
						var button_image:Image = load_button_img(data.img+".png")
						texture_rect.texture = ImageTexture.create_from_image(button_image)
						texture_rect.custom_minimum_size = Vector2(40, 40)
						section_container.add_child(texture_rect)
						pass
					"text":
						var label:Label = Label.new()
						label.text = data.text
						label.label_settings = label_settings
						section_container.add_child(label)
						pass
					_:
						continue
				pass
				_button_guide_container.add_child(section_container)
			pass
		
		pass

	return
