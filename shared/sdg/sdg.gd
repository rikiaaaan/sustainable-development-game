extends RigidBody2D

func _physics_process(delta:float) -> void:
	if position.y > 1000:
		queue_free()
		pass
	return
