extends RigidBody2D

@export var print_shit:bool = false
@export var phase:int = 0

const PHASE_ZERO_SCALE:Vector2 = Vector2(0.2,0.2)

func _init() -> void:
	return

func _ready() -> void:
	set_polygon(146/2)
	return
	
func set_phase() -> void:
	phase = clampi(phase, 0, 16)
	$Polygon2D/Sprite2D.region_rect = Rect2(9+161.2*(phase%6), 11+158*int(phase/6), 146, 146)
	return

func set_polygon(size:float) -> void:
	var pv:PackedVector2Array
	for i in range(0, 360, 4):
		var v:Vector2 = Vector2.from_angle(deg_to_rad(i)) * size
		pv.append(v)
		pass
	$Polygon2D.polygon = pv
	return

func _physics_process(delta:float) -> void:
	set_phase()
	if position.y > 1000:
		queue_free()
		pass
	
	if print_shit:
		for body in get_colliding_bodies():
			print("get_collidingbody")
			print(body.name)
			pass
		pass
	return
