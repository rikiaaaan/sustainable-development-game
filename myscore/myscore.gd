extends Node

@onready var score_tab:TabContainer = $Ui/TabContainer
@onready var _back_to_the_title_button:Button = $Ui/BackToTheTitleButton as Button


func _ready() -> void:

	get_parent().change_button_guide("myscore")
	_back_to_the_title_button.grab_focus()

	return


func _input(event:InputEvent) -> void:

	if event.is_action_pressed("ranking_change_minus"):
		if score_tab.current_tab == 0:
			score_tab.current_tab = 2
			return
		score_tab.current_tab -= 1
		pass
	if event.is_action_pressed("ranking_change_plus"):
		if score_tab.current_tab == 2:
			score_tab.current_tab = 0
			return
		score_tab.current_tab += 1
		pass

	return


func _on_back_to_the_title_button_pressed() -> void:

	get_parent().change_scene("title")

	return
