extends Node


var score:int = 0

var release_cooldown:float = 0
var ranking_cooldown:float = 0

var game_started:bool = false
var game_finished:bool = false
var pause_screen_showing:bool = false
var gameover_screen_shown:bool = false

var current_sdg:RigidBody2D = null

const RANKING_TEXTS:Array[String] = ["マイデイリースコア", "マイトータルスコア", "デイリースコア", "トータルスコア"]

@onready var next_sdg:RigidBody2D = $NextSgd/sdg
@onready var kokuren:PathFollow2D = $Path2D/kokuren
@onready var ui_ready:Control = $Ui/Ready
@onready var ui_pause:Control = $Ui/Pause

@onready var ranking_label:Label = $Ui/Game/Ranking/Label
@onready var score_ranking:VBoxContainer = $Ui/Game/Ranking/ScrollContainer/ScoreRanking
@onready var result_ranking_label:Label = $Ui/Gameover/Result/ColorRect2/Label
@onready var result_score_ranking:VBoxContainer = $Ui/Gameover/Result/ColorRect2/ScrollContainer/ScoreRanking

@onready var game_score_label:Label = $Ui/Game/Score/VBoxContainer/Label2
@onready var result_score_label:Label = $Ui/Gameover/Result/ColorRect2/VBoxContainer/Label3
@onready var result_user_name_label:Label = $Ui/Gameover/Result/ColorRect2/VBoxContainer/Label2

@onready var pause_resume_button:Button = $Ui/Pause/ColorRect2/VBoxContainer/VBoxContainer/ResumeGameButton
@onready var pause_save_and_go_to_title_button:Button = $Ui/Pause/ColorRect2/VBoxContainer/VBoxContainer/SaveAndBackToTheTitleButton

@onready var result_screenshot:TextureRect = $Ui/Gameover/Result/ColorRect/TextureRect

func _ready() -> void:

	release_sdg()
	if Settings.is_load_save_data:
		var game_data:Dictionary = Settings.get_saved_game_data()
		score = game_data.score
		current_sdg.phase = game_data.current_sdg
		next_sdg.phase = game_data.next_sdg
		for sdg_data in game_data.sdgs:
			var sdg = ResourceLoader.load("res://shared/sdg/sdg.tscn").instantiate()
			sdg.position = sdg_data.position
			sdg.rotation = sdg_data.rotation
			sdg.phase = sdg_data.phase
			sdg.freeze = true
			sdg.connect("touched_sdgs", _on_sdg_touched_sdgs)
			sdg.connect("fell", _on_sdg_fell)
			sdg.connect("finished_shake", _on_sdg_shake_finished)
			$Sdgs.add_child(sdg)
			pass
		pass
	
	$AnimationPlayer.play("ready")
	await $AnimationPlayer.animation_finished
	
	if Settings.is_load_save_data:
		for sdg in $Sdgs.get_children():
			if sdg != current_sdg:
				sdg.freeze = false
				pass
			pass
		pass
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
		if event.is_action_pressed("debug_print_max_sdg"):
			print_debug(get_max_sdg())
			pass
		
		pass
	if ranking_cooldown == 0:
		
		if event.is_action_pressed("ranking_change_minus"):
			change_ranking(-1)
			pass
		if event.is_action_pressed("ranking_change_plus"):
			change_ranking(1)
			pass
		if event.is_action_pressed("ranking_refresh"):
			fresh_ranking()
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
	pause_save_and_go_to_title_button.disabled = !Settings.is_login
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
	if Settings.is_login:
		result_user_name_label.text = Settings.current_user_name
		pass
	else:
		result_user_name_label.text = ""
		pass
	
	save_result_data()
	
	$AnimationPlayer.play("gameover_enter")

	return


func change_ranking(v:int) -> void:

	if ranking_cooldown == 0:
		ranking_cooldown = 3
		if !game_finished:
			score_ranking.mode += v
			if score_ranking.mode < 0:
				score_ranking.mode = 3
				pass
			if score_ranking.mode > 3:
				score_ranking.mode = 0
				pass
			score_ranking.fresh()
			ranking_label.text = RANKING_TEXTS[score_ranking.mode]
			pass
		else:
			result_score_ranking.mode += v
			if result_score_ranking.mode < 0:
				result_score_ranking.mode = 3
				pass
			if result_score_ranking.mode > 3:
				result_score_ranking.mode = 0
				pass
			result_score_ranking.fresh()
			result_ranking_label.text = RANKING_TEXTS[result_score_ranking.mode]
			pass
		pass

	return


func fresh_ranking() -> void:

	if ranking_cooldown == 0:
		ranking_cooldown = 3
		if game_finished:
			result_score_ranking.fresh()
			pass
		else:
			score_ranking.fresh()
			pass
		pass

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

	if Settings.is_login:
		var game_data:Dictionary = {
			"score": score,
			"next_sdg": next_sdg.phase,
			"current_sdg": current_sdg.phase,
			"saved_at": int(Time.get_unix_time_from_system())+(Time.get_time_zone_from_system().bias*60),
			"sdgs": [] as Array[Dictionary]
		}
		for sdg in $Sdgs.get_children():
			if sdg == current_sdg:
				continue
			var sdg_data:Dictionary = {}
			sdg_data.position = sdg.position
			sdg_data.rotation = sdg.rotation
			sdg_data.phase = sdg.phase
			game_data.sdgs.append(sdg_data)
			pass
		Settings.save_game_data(game_data)
		pass

	return


func save_result_data() -> void:

	var game_data:Dictionary = {}
	
	game_data.score = score
	game_data.recorded_at = int(Time.get_unix_time_from_system()+(Time.get_time_zone_from_system().bias*60))
	
	Settings.save_result_data(game_data)

	return


func get_max_sdg() -> int:

	var current_max:int = 0
	for sdg in $Sdgs.get_children():
		if sdg.get("phase"):
			current_max = maxi(current_max, sdg.phase)
			pass
		pass

	return current_max


func _process(delta:float) -> void:

	game_score_label.text = "%d" % [score]
	if release_cooldown > 0:
		release_cooldown = maxf(0, release_cooldown - delta)
		pass
	if ranking_cooldown > 0:
		ranking_cooldown = maxf(0, ranking_cooldown - delta)
		pass

	return


func _physics_process(_delta:float) -> void:

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
	get_parent().change_scene("myscore")

	return


func _on_save_and_back_to_the_title_button_pressed() -> void:

	print_debug("saveandback2thetitlescnee clicked")
	save_game_data()
	print_debug("game saved (maybe)")
	get_tree().paused = false
	get_parent().change_scene("title")

	return
