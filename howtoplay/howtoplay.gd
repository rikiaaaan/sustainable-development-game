extends Node


var page_index:int = 0
var release_cooldown:float = 0.0

@onready var _back_label:Label = $Ui/PageController/Label as Label
@onready var _back_button:Button = $Ui/PageController/BackButton as Button
@onready var _forward_label:Label = $Ui/PageController/Label2 as Label
@onready var _forward_button:Button = $Ui/PageController/ForwardButton as Button

@onready var _current_sdg:RigidBody2D = $Ui/Page0/Node2D/Sdgs/sdg as RigidBody2D
@onready var _sdgs_page0:Node2D = $Ui/Page0/Node2D/Sdgs as Node2D
@onready var _kokuren:PathFollow2D = $Ui/Page0/Node2D/Path2D/kokuren as PathFollow2D

const PAGE_COUNT:int = 3
const BACK_TO_THE_TITLE_TEXT:String = "タイトルに戻る"
const BACK_TEXT:String = "戻る"


func _ready() -> void:

	get_parent().change_button_guide("howtoplay")
	_back_button.grab_focus()
	set_page(0)

	return


func set_page(index:int) -> void:

	for i in range(0, PAGE_COUNT, 1):
		var page:Node = get_node("Ui/Page%d" % [i])
		if i == index:
			page.show()
			page.process_mode = Node.PROCESS_MODE_INHERIT
			pass
		else:
			page.hide()
			page.process_mode = Node.PROCESS_MODE_DISABLED
			pass
		pass
	
	if index == 0:
		_back_label.text = BACK_TO_THE_TITLE_TEXT
		_kokuren.moveable = true
		pass
	else:
		_back_label.text = BACK_TEXT
		_kokuren.moveable = false
		pass
	
	if index+1 == PAGE_COUNT:
		_forward_label.hide()
		_forward_button.hide()
		_back_button.grab_focus()
		pass
	else:
		_forward_label.show()
		_forward_button.show()
		pass
	
	page_index = index

	return


func release_sdg() -> void:

	_current_sdg.freeze = false
	
	var sdg = ResourceLoader.load("res://shared/sdg/sdg.tscn").instantiate()
	sdg.position = Vector2(-100,-100)
	sdg.phase = 4
	
	_current_sdg = sdg
	
	_current_sdg.freeze = true
	_sdgs_page0.add_child(sdg)

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
		release_cooldown = maxf(0, release_cooldown - delta)
		pass

	return


func _physics_process(_delta:float) -> void:

	if _current_sdg != null && release_cooldown < 0.25 && page_index == 0:
		_current_sdg.position = _kokuren.position + Vector2(-23,30) + Vector2(0,20)
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
