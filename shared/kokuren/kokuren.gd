extends Node2D

@export var speed:float = 6.0

const POLYGON_11_x:float = -140
const POLYGON_01_x:float = -145


func _ready() -> void:



	return


func set_raycast_line() -> void:

	var collision_point:Vector2 = $RayCast2D.get_collision_point()
	$Label.text = var_to_str(collision_point)
	$Label.text += "\n" + var_to_str($RayCast2D.get_collision_normal())
	$Polygon2D.polygon[1].y = collision_point.y
	$Polygon2D.polygon[2].y = collision_point.y

	return


func _process(_delta:float) -> void:



	return


func _physics_process(_delta:float) -> void:

	var move_vec:Vector2 = Vector2(int(Input.is_action_pressed("kokuren_move_right")) - int(Input.is_action_pressed("kokuren_move_left")),0)
	position += move_vec * speed
	set_raycast_line()

	return
