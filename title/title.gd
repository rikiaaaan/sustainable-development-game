extends Node

func _ready() -> void:

	

	return

func change_scene(scene_name:String, with_tween:bool=true) -> void:
	get_node("../").change_scene(scene_name, with_tween)
	return

func _on_game_start_button_pressed() -> void:

	change_scene("play")

	return


func _on_my_score_button_pressed() -> void:

	change_scene("my_score")

	return


func _on_how_to_play_button_pressed() -> void:

	change_scene("howtoplay")

	return
