extends Node


var score:int = 0

var release_cooldown:float = 0

var game_started:bool = false
var game_finished:bool = false
var pause_screen_showing:bool = false
var gameover_screen_shown:bool = false

var current_sdg:RigidBody2D = null

@onready var next_sdg:RigidBody2D = $NextSgd/sdg
@onready var kokuren:PathFollow2D = $Path2D/kokuren
@onready var ui_ready:Control = $Ui/Ready
@onready var ui_pause:Control = $Ui/Pause

@onready var game_score_label:Label = $Ui/Game/Score/VBoxContainer/Label2
@onready var result_score_label:Label = $Ui/Gameover/Result/ColorRect2/VBoxContainer/Label3

@onready var pause_resume_button:Button = $Ui/Pause/ColorRect2/VBoxContainer/VBoxContainer/ResumeGameButton

@onready var result_screenshot:TextureRect = $Ui/Gameover/Result/ColorRect/TextureRect

func _ready() -> void:

	release_sdg()
	$AnimationPlayer.play("ready")
	
	await $AnimationPlayer.animation_finished
	
	game_started = true
	kokuren.moveable = true
	ui_ready.queue_free()

	return


func _unhandled_input(event:InputEvent) -> void:

	if game_started && !game_finished:
		
		if event.is_action_pressed("pause"):
			if !pause_screen_showing:
				show_pause_screen()
				get_tree().paused = true
				pass
			pass
		if event.is_action_pressed("debug_instant_gameover"):
			_on_sdg_fell()
			pass
		
		pass

	return


func _input(event:InputEvent) -> void:

	if game_started && !game_finished:
		
		if event.is_action_pressed("release_sdg"):
			if release_cooldown == 0:
				release_sdg()
				release_cooldown = 0.5
				pass
			pass
		
		pass

	return


func show_pause_screen() -> void:

	ui_pause.show()
	$AnimationPlayer.play("pause_enter")
	await $AnimationPlayer.animation_finished
	pause_resume_button.grab_focus()
	pause_screen_showing = true

	return


func hide_pause_screen() -> void:

	$AnimationPlayer.play("pause_exit")
	await $AnimationPlayer.animation_finished
	ui_pause.hide()
	pause_resume_button.release_focus()
	pause_screen_showing = false

	return


func show_gameover_screen() -> void:

	var current_window_mode:int = DisplayServer.window_get_mode()
	if current_window_mode != DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		
		await get_tree().create_timer(0.6).timeout
		
		var current_screen_image:Image = DisplayServer.screen_get_image(DisplayServer.window_get_current_screen())
		result_screenshot.texture = ImageTexture.create_from_image(current_screen_image)
		DisplayServer.window_set_mode(current_window_mode)
		pass
	else:
		var current_screen_image:Image = DisplayServer.screen_get_image(DisplayServer.window_get_current_screen())
		result_screenshot.texture = ImageTexture.create_from_image(current_screen_image)
		pass
	
	result_score_label.text = "%d" % [score]
	
	save_game_data()
	
	$AnimationPlayer.play("gameover_enter")

	return


func summon_sdg(pos:Vector2, phase:int, evolution:bool=false) -> void:

	var sdg = ResourceLoader.load("res://shared/sdg/sdg.tscn").instantiate()
	sdg.position = pos
	sdg.phase = phase
	sdg.connect("touched_sdgs", _on_sdg_touched_sdgs)
	sdg.connect("fell", _on_sdg_fell)
	sdg.connect("finished_shake", _on_sdg_shake_finished)
	
	if !evolution:
		current_sdg = sdg
		pass
	
	$Sdgs.add_child(sdg)

	return


func release_sdg() -> void:

#	print_debug("release_sgd called")
	if current_sdg != null:
		current_sdg.freeze = false
		pass
	
	summon_sdg(Vector2(-100,-100), next_sdg.phase)
	
	current_sdg.freeze = true
	next_sdg.phase = randi_range(0, 5)

	return


func gameover() -> void:

	kokuren.moveable = false
	game_finished = true
	for sdg in $Sdgs.get_children():
		sdg.gameover_shake()
		pass

	return


func save_game_data() -> void:

	var game_data:Dictionary = {}
	
	var current_unix_time:float = Time.get_unix_time_from_system()
	game_data.score = score
	var current_datetime_dict:Dictionary = Time.get_datetime_dict_from_unix_time(current_unix_time)
	game_data.recorded_at = current_datetime_dict
	
	Settings.save_game_data(game_data)

	return


func _process(delta:float) -> void:

	game_score_label.text = "%d" % [score]
	if release_cooldown > 0:
		release_cooldown = maxf(0, release_cooldown - delta)
		pass

	return


func _physics_process(delta:float) -> void:

	if game_started && !game_finished:
		
		if current_sdg != null && release_cooldown < 0.25:
			current_sdg.position = kokuren.position + Vector2(-23,30) + Vector2(0,20)
			pass
		
		pass

	return


func _on_sdg_touched_sdgs(pos:Vector2, phase:int) -> void:

	summon_sdg(pos, phase, true)
	
	score += ((phase)*(phase+1)) / 2

	return


func _on_sdg_fell() -> void:

	print_debug("sdg fell you noob")
	if !game_finished:
		gameover()
		pass

	return


func _on_sdg_shake_finished() -> void:

	if !gameover_screen_shown:
		print_debug("sdg shake finished")
		gameover_screen_shown = true
		
		await get_tree().create_timer(1).timeout
		
		show_gameover_screen()
		pass

	return


func _on_resume_game_button_pressed() -> void:

	print_debug("resume button clicked")
	get_tree().paused = false
	hide_pause_screen()

	return


func _on_retry_button_pressed() -> void:

	print_debug("retry_button clicked")
	get_tree().paused = false
	#同じシーンに変えることでリトライと同じ動作をする
	get_parent().change_scene("play")

	return


func _on_back_to_the_title_button_pressed() -> void:

	print_debug("back2thetitlebutton clicked")
	get_tree().paused = false
	get_parent().change_scene("title")

	return


func _on_my_score_button_pressed() -> void:

	print_debug("myscorebutton clicked")
	get_tree().paused = false
	get_parent().change_scene("my_score")

	return
	
