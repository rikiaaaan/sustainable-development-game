extends Node


var page_index:int = 0
var release_cooldown:float = 0.0

@onready var back_label:Label = $Ui/PageController/Label
@onready var back_button:Button = $Ui/PageController/BackButton
@onready var forward_label:Label = $Ui/PageController/Label2
@onready var forward_button:Button = $Ui/PageController/ForwardButton

@onready var current_sdg:RigidBody2D = $Ui/Page0/Node2D/Sdgs/sdg
@onready var sdgs_page0:Node2D = $Ui/Page0/Node2D/Sdgs
@onready var kokuren:PathFollow2D = $Ui/Page0/Node2D/Path2D/kokuren

const PAGE_COUNT:int = 3
const BACK_TO_THE_TITLE_TEXT:String = "タイトルに戻る"
const BACK_TEXT:String = "戻る"


func _ready() -> void:

	back_button.connect("focus_entered", back_button.release_focus)
	forward_button.connect("focus_entered", forward_button.release_focus)
	
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
		back_label.text = BACK_TO_THE_TITLE_TEXT
		kokuren.moveable = true
		pass
	else:
		back_label.text = BACK_TEXT
		kokuren.moveable = false
		pass
	
	if index+1 == PAGE_COUNT:
		forward_label.hide()
		forward_button.hide()
		pass
	else:
		forward_label.show()
		forward_button.show()
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
	sdgs_page0.add_child(sdg)

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
		current_sdg.position = kokuren.position + Vector2(-23,30) + Vector2(0,20)
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
