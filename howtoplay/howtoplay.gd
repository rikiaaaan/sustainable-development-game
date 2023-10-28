extends Node


func _ready() -> void:

	$Ui/PageController/Back/Button.connect("focus_entered", $Ui/PageController/Back/Button.release_focus)
	$Ui/PageController/Forward/Button.connect("focus_entered", $Ui/PageController/Forward/Button.release_focus)

	return

