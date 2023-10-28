extends RigidBody2D

signal touched_sdgs
signal fell
signal finished_shake

@export var print_shit:bool = false
@export var phase:int = 0

var gameover_shaking:bool = false
var gameover_shake_timer:float = 0.0
var shake_degree:int = 0
var before_shake_position:Vector2 = Vector2.ZERO

const PHASE_ZERO_SCALE:Vector2 = Vector2(0.2,0.2)


func _ready() -> void:

	hide()
	set_polygon(146/2)
	set_phase()
	show()

	return


func set_phase() -> void:

	phase = clampi(phase, 0, 16)
	var scale_t:Vector2 = PHASE_ZERO_SCALE + (Vector2(0.05,0.05) * phase)
	$Polygon2D.scale = scale_t
	$CollisionPolygon2D.scale = scale_t
	$Polygon2D/Sprite2D.region_rect = Rect2(9+161.2*(phase%6), 11+158*int(phase/6), 146, 146)

	return


func set_polygon(size:float) -> void:
	
	var pv:PackedVector2Array = []
	for i in range(0, 360, 3):
		var v:Vector2 = Vector2.from_angle(deg_to_rad(i)) * size
		pv.append(v)
		pass
	$Polygon2D.polygon = pv
	$CollisionPolygon2D.polygon = pv

	return


func summon_sdg(summon_pos:Vector2, _phase:int=0) -> void:

	var sdg = ResourceLoader.load("res://shared/sdg/sdg.tscn").instantiate()
	sdg.position = summon_pos
	sdg.phase = _phase

	return


func gameover_shake() -> void:

	if !gameover_shaking:
		gameover_shaking = true
		freeze = true
		gameover_shake_timer = 3.0
		before_shake_position = position
		pass

	return


func _process(delta:float) -> void:

	if gameover_shake_timer > 0:
		gameover_shake_timer = max(0, gameover_shake_timer - delta)
		pass

	return


func _physics_process(_delta:float) -> void:

	if !freeze:
		collision_layer = 0b10
		pass
	else:
		collision_layer = 0b00
		pass
	
	set_phase()
	
	if position.y > 1000:
		emit_signal("fell")
		queue_free()
		pass
	
	if !gameover_shaking && !freeze:
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
		pass
	
	if gameover_shake_timer > 0:
		rotation += deg_to_rad(randf_range(-2,2))
		position = before_shake_position + Vector2.from_angle(deg_to_rad(shake_degree)) * 0.4
		shake_degree += 60
		pass
	if gameover_shaking && gameover_shake_timer == 0:
		position = before_shake_position
		gameover_shaking = false
		emit_signal("finished_shake")
		pass

	return
