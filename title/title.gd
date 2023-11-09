extends Node

@onready var game_start_button:Button = $Ui/Title/GameStartButton
@onready var load_button:Button = $Ui/LoadGameDataConfirm/ColorRect2/VBoxContainer/HBoxContainer2/YesLoadButton
@onready var wait_a_minute_button:Button = $Ui/LoadGameDataConfirm/ColorRect2/VBoxContainer/HBoxContainer2/WaitAMinuteButton
@onready var data_saved_at_label:Label = $Ui/LoadGameDataConfirm/ColorRect2/VBoxContainer/HBoxContainer/Label2


func _ready() -> void:

	$Ui/LoadGameDataConfirm.hide()
	game_start_button.grab_focus()

	return


func change_scene(scene_name:String, with_tween:bool=true) -> void:

	get_node("../").change_scene(scene_name, with_tween)

	return


func _on_game_start_button_pressed() -> void:

	game_start_button.release_focus()
	if Settings.has_saved_game_data():
		var saved_at:int = Settings.get_saved_data_saved_at()
		data_saved_at_label.text = Time.get_datetime_string_from_unix_time(saved_at, true)
		$AnimationPlayer.play("enter_load_game_data_confirm")
		await $AnimationPlayer.animation_finished
		load_button.grab_focus()
		pass
	else:
		change_scene("play")
		pass

	return


func _on_my_score_button_pressed() -> void:

	change_scene("myscore")

	return


func _on_how_to_play_button_pressed() -> void:

	change_scene("howtoplay")

	return


func _on_yes_load_button_pressed() -> void:

	Settings.is_load_save_data = true
	change_scene("play")

	return


func _on_no_load_button_pressed() -> void:

	Settings.is_load_save_data = false
	change_scene("play")

	return


func _on_wait_a_minute_button_pressed() -> void:

	$AnimationPlayer.play("leave_load_game_data_confirm")
	await $AnimationPlayer.animation_finished
	game_start_button.grab_focus()

	return
