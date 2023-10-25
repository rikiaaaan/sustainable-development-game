extends PathFollow2D

@export var speed:float = 1.0


func _ready() -> void:

	progress_ratio = 0.5

	return


func set_raycast_line() -> void:

#	$RayCast2D.target_position = Vector2(position.x, 720)
	var collision_point:Vector2 = $RayCast2D.get_collision_point() - Vector2(0, 30)
	$Label.text = var_to_str(collision_point)
	$Label.text += "\n" + var_to_str($RayCast2D.get_collision_normal())
	$Polygon2D.polygon[1].y = collision_point.y
	$Polygon2D.polygon[2].y = collision_point.y

	return


func _process(_delta:float) -> void:



	return


func _physics_process(_delta:float) -> void:

	progress_ratio += speed * (int(Input.is_action_pressed("kokuren_move_right")) - int(Input.is_action_pressed("kokuren_move_left"))) * 0.01
	set_raycast_line()

	return
