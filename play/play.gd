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

	if game_started:
		
		if event.is_action_pressed("pause"):
			if !pause_screen_showing:
				$AnimationPlayer.play("pause_enter")
				pause_screen_showing = true
				pass
			pass
		
		pass

	return

func _input(event:InputEvent) -> void:

	if game_started:
		
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

	if release_cooldown > 0:
		release_cooldown = maxf(0, release_cooldown - delta)
		pass

	return


func _physics_process(delta:float) -> void:

	if game_started:
		
		var mouse_movement:Vector2 = Input.get_last_mouse_velocity() * Vector2(1,0)
		var mouse_movement_x:float = mouse_movement.x
		kokuren.progress_ratio += mouse_movement_x * 0.001 * delta
	#	$Ui/Game/Score/VBoxContainer/Label2.text = var_to_str(mouse_movement)
		
		if current_sdg != null && release_cooldown < 0.25:
			current_sdg.position = kokuren.position + Vector2(-23,30) + Vector2(0,20)
			pass
		
		pass

	return


func _on_sdg_touched_sdgs(pos:Vector2, phase:int) -> void:

	summon_sdg(pos, phase, true)

	return


func _on_sdg_fell() -> void:

	print_debug("sdg fell you noob")


	return
