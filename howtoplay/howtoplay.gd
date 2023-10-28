extends Node


var page_index:int = 0
var release_cooldown:float = 0.0
var current_sdg:RigidBody2D = null

const PAGE_COUNT:int = 3


func _ready() -> void:

	$Ui/PageController/Back/BackButton.connect("focus_entered", $Ui/PageController/Back/BackButton.release_focus)
	$Ui/PageController/Forward/ForwardButton.connect("focus_entered", $Ui/PageController/Forward/ForwardButton.release_focus)
	
	set_page(0)
	
	current_sdg = $Ui/Page0/Node2D/Sdgs/sdg

	return


func set_page(index:int) -> void:

	for i in range(0,PAGE_COUNT,1):
		if i == index:
			get_node("Ui/Page%d" % [i]).show()
			pass
		else:
			get_node("Ui/Page%d" % [i]).hide()
			pass
		pass
	
	if index == 0:
		$Ui/PageController/Back/Label.text = "タイトル画面に戻る"
		$Ui/Page0/Node2D/Path2D/kokuren.moveable = true
		pass
	else:
		$Ui/PageController/Back/Label.text = "戻る"
		$Ui/Page0/Node2D/Path2D/kokuren.moveable = false
		pass
	
	if index+1 == PAGE_COUNT:
		$Ui/PageController/Forward.hide()
		pass
	else:
		$Ui/PageController/Forward.show()
		pass
	
	page_index = index

	return


func release_sdg() -> void:

	current_sdg.freeze = false
	
	var sdg = ResourceLoader.load("res://shared/sdg/sdg.tscn").instantiate()
	sdg.position = Vector2(-100,-100)
	sdg.phase = 4
	
	current_sdg = sdg
	
	current_sdg.freeze = true
	$Ui/Page0/Node2D/Sdgs.add_child(sdg)

	return


func _input(event:InputEvent) -> void:

	if event.is_action_pressed("release_sdg"):
		if release_cooldown == 0:
			release_cooldown = 0.5
			release_sdg()
			pass
		pass

	return


func _process(delta:float) -> void:

	if release_cooldown > 0:
		release_cooldown = max(0, release_cooldown - delta)
		pass

	return


func _physics_process(_delta:float) -> void:

	if current_sdg != null && release_cooldown < 0.25 && page_index == 0:
		current_sdg.position = $Ui/Page0/Node2D/Path2D/kokuren.position + Vector2(-23,30) + Vector2(0,20)
		pass

	return


func _on_back_button_pressed() -> void:

	if page_index == 0:
		get_parent().change_scene("title")
		return
	set_page(page_index - 1)

	return


func _on_forward_button_pressed() -> void:

	if page_index+1 < PAGE_COUNT:
		set_page(page_index + 1)
		pass

	return
