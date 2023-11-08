extends PathFollow2D

@export var speed:float = 1.0
@export var moveable:bool = false

func _ready() -> void:

	progress_ratio = 0.5

	return


func _input(event:InputEvent) -> void:

	if event.is_action_pressed("reset_kokuren_position"):
		progress_ratio = 0.5
		pass

	return


func set_raycast_line() -> void:

#	$RayCast2D.target_position = Vector2(position.x, 720)
	
	#Vector(0, 30)を引いているのは微調整の努力の結晶なんです
	var collision_point:Vector2 = $RayCast2D.get_collision_point() - Vector2(0, 30)
	$Label.text = var_to_str(collision_point)
	$Label.text += "\n" + var_to_str($RayCast2D.get_collision_normal())
	$Polygon2D.polygon[1].y = collision_point.y
	$Polygon2D.polygon[2].y = collision_point.y

	return


func _physics_process(delta:float) -> void:

	if moveable:
		var mouse_movement_x:float = Input.get_last_mouse_velocity().x
		progress_ratio += mouse_movement_x * 0.001 * delta
		
		progress_ratio += speed * (int(Input.is_action_pressed("kokuren_move_right")) - int(Input.is_action_pressed("kokuren_move_left"))) * 0.01
		set_raycast_line()
		pass

	return
