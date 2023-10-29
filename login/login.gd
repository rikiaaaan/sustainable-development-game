extends Node

var current_index:int = 0


func _ready() -> void:

	set_page(0, false)

	return


func set_page(index:int, do_tween:bool=true) -> void:

	for i in range(0, 4, 1):
		var page:Control = get_node("Page%d" % [i])
		if i == index:
			
			pass
		pass
	

	return


func _on_no_button_pressed() -> void:

	get_parent().change_scene("title")

	return
