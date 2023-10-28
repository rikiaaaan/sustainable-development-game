extends Node


var score:int = 0

var release_cooldown:float = 0

var game_started:bool = false
var game_finished:bool = false
var pause_screen_showing:bool = false

var current_sdg:RigidBody2D = null

@onready var next_sdg:RigidBody2D = $NextSgd/sdg
@onready var kokuren:PathFollow2D = $Path2D/kokuren

func _ready() -> void:

	release_sdg()
	$AnimationPlayer.play("ready")
	
	await $AnimationPlayer.animation_finished
	
	game_started = true

	return


func _unhandled_input(event:InputEvent) -> void:

	if game_started && !game_finished:
		
		if event.is_action_pressed("pause"):
			if !pause_screen_showing:
				show_pause_screen()
				get_tree().paused = true
				pass
			pass
		
		pass

	return


func _input(event:InputEvent) -> void:

	if game_started && !game_finished:
		
		if event.is_action_pressed("release_sdg"):
	#		print_debug(release_cooldown)
			if release_cooldown == 0:
				release_sdg()
				release_cooldown = 0.5
				pass
			pass
		
		if event.is_action_pressed("reset_kokuren_position"):
			kokuren.progress_ratio = 0.5
			pass
		pass

	return


func show_pause_screen() -> void:

	$Ui/Pause.show()
	$AnimationPlayer.play("pause_enter")
	await $AnimationPlayer.animation_finished
	$Ui/Pause/ColorRect2/VBoxContainer/VBoxContainer/ResumeGameButton.grab_focus()
	pause_screen_showing = true

	return


func hide_pause_screen() -> void:

	$AnimationPlayer.play("pause_exit")
	await $AnimationPlayer.animation_finished
	$Ui/Pause.hide()
	$Ui/Pause/ColorRect2/VBoxContainer/VBoxContainer/ResumeGameButton.release_focus()
	pause_screen_showing = false

	return


func summon_sdg(pos:Vector2, phase:int, evolution:bool=false) -> void:

	var sdg = ResourceLoader.load("res://shared/sdg/sdg.tscn").instantiate()
	sdg.position = pos
	sdg.phase = phase
	sdg.connect("touched_sdgs", _on_sdg_touched_sdgs)
	sdg.connect("fell", _on_sdg_fell)
	
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


func _process(delta:float) -> void:

	$Ui/Game/Score/VBoxContainer/Label2.text = "%d" % [score]
	if release_cooldown > 0:
		release_cooldown = maxf(0, release_cooldown - delta)
		pass

	return


func _physics_process(delta:float) -> void:

	if game_started && !game_finished:
		
		var mouse_movement_x:float = Input.get_last_mouse_velocity().x
		kokuren.progress_ratio += mouse_movement_x * 0.001 * delta
	#	$Ui/Game/Score/VBoxContainer/Label2.text = var_to_str(mouse_movement)
		
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
	game_finished = true
	for sdg in $Sdgs.get_children():
		sdg.gameover_shake()
		pass

	return


func _on_resume_game_button_pressed() -> void:

	print_debug("resume button clicked")
	get_tree().paused = false
	hide_pause_screen()

	return
