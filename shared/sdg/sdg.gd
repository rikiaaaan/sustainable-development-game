extends RigidBody2D

signal touched_sdgs
signal fell

@export var print_shit:bool = false
@export var phase:int = 0

const PHASE_ZERO_SCALE:Vector2 = Vector2(0.2,0.2)


func _init() -> void:


	return


func _ready() -> void:

	hide()
	set_polygon(146/2)
	set_phase()
	show()

	return


func set_phase() -> void:

	phase = clampi(phase, 0, 16)
	$Polygon2D.scale = PHASE_ZERO_SCALE + (Vector2(0.075,0.075) * phase)
	$CollisionPolygon2D.scale = PHASE_ZERO_SCALE + (Vector2(0.075,0.075) * phase)
	$Polygon2D/Sprite2D.region_rect = Rect2(9+161.2*(phase%6), 11+158*int(phase/6), 146, 146)

	return


func set_polygon(size:float) -> void:
	
	var pv:PackedVector2Array
	for i in range(0, 360, 4):
		var v:Vector2 = Vector2.from_angle(deg_to_rad(i)) * size
		pv.append(v)
		pass
	$Polygon2D.polygon = pv
	$CollisionPolygon2D.polygon = pv

	return


func summon_sdg(summon_pos:Vector2, phase:int=0) -> void:

	var sdg = ResourceLoader.load("res://shared/sdg/sdg.tscn").instantiate()
	sdg.position = summon_pos
	sdg.phase = phase

	return


func _physics_process(delta:float) -> void:

	set_phase()
	if position.y > 1000:
		emit_signal("fell")
		queue_free()
		pass
	
	for body in get_colliding_bodies():
		if body.get("phase") == null:
			continue
		if body.phase == phase && !body.freeze && phase < 16:
			freeze = true
			body.freeze = true
			body.collision_layer = 0
			collision_layer = 0
			
			emit_signal("touched_sdgs", (position+body.position)/2, phase+1)
			
			body.queue_free()
			queue_free()
			pass
		pass

	return
