extends Node

@onready var _load_game_data_confirm:Control = $Ui/LoadGameDataConfirm as Control
@onready var _game_start_button:Button = $Ui/Title/GameStartButton as Button
@onready var _load_button:Button = $Ui/LoadGameDataConfirm/ColorRect2/VBoxContainer/HBoxContainer2/YesLoadButton as Button
@onready var _wait_a_minute_button:Button = $Ui/LoadGameDataConfirm/ColorRect2/VBoxContainer/HBoxContainer2/WaitAMinuteButton as Button
@onready var _data_saved_at_label:Label = $Ui/LoadGameDataConfirm/ColorRect2/VBoxContainer/HBoxContainer/Label2 as Label


func _ready() -> void:

	get_parent().change_button_guide("title")
	_load_game_data_confirm.hide()
	_game_start_button.grab_focus()

	return


func change_scene(scene_name:String, with_tween:bool=true) -> void:

	get_parent().change_scene(scene_name, with_tween)

	return


func _on_game_start_button_pressed() -> void:

	_game_start_button.release_focus()
	if Settings.has_saved_game_data():
		var saved_at:int = Settings.get_saved_data_saved_at()
		_data_saved_at_label.text = Time.get_datetime_string_from_unix_time(saved_at, true)
		$AnimationPlayer.play("enter_load_game_data_confirm")
		get_parent().change_button_guide("title2")
		await $AnimationPlayer.animation_finished
		_load_button.grab_focus()
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

	get_parent().change_button_guide("title")
	$AnimationPlayer.play("leave_load_game_data_confirm")
	await $AnimationPlayer.animation_finished
	_game_start_button.grab_focus()

	return
