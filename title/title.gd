extends Node

func _ready() -> void:



	return


func _on_texture_rect_mouse_entered() -> void:

	$Ui/TextureRect.modulate = Color(1.0, 0.81, 0.06)

	return


func _on_texture_rect_mouse_exited() -> void:

	$Ui/TextureRect.modulate = Color(1,1,1,1)

	return
