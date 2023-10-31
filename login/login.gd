extends Node

var current_index:int = 0

@onready var login_yes_button:Button = $Ui/Page0/AskLogin/HBoxContainer/YesButton

@onready var welcome_message_label:Label = $Ui/Page2/MarginContainer/NewPassInput/WelcomeMessageLabel
@onready var welcome_back_message_label:Label = $Ui/Page3/MarginContainer/PassInput/WelcomeBackMessageLabel
@onready var input_your_name_here_label:Label = $Ui/Page1/MarginContainer/NameInput/InputYourNameHereLabel
@onready var input_your_new_password_here_label:Label = $Ui/Page2/MarginContainer/NewPassInput/InputYourNewPasswordHereLabel
@onready var input_your_password_here_label:Label = $Ui/Page3/MarginContainer/PassInput/InputYourPasswordHereLabel

@onready var user_name_input:TextEdit = $Ui/Page1/MarginContainer/NameInput/HBoxContainer/TextEdit
@onready var new_pass_input:TextEdit = $Ui/Page2/MarginContainer/NewPassInput/HBoxContainer/TextEdit
@onready var pass_input:TextEdit = $Ui/Page3/MarginContainer/PassInput/HBoxContainer/TextEdit

const WELCOME_MESSAGE:String = "ようこそ、%sさん！\nあなたのセーブデータを守るための\n新しく使用するパスワードを入力してください。"
const WELLCOME_BACK_MESSAGE:String = "おかえりなさい、%sさん！\n設定されているパスワードを入力してください。"
const PASSWORD_IS_INCORRECT:String = "パスワードが違います！"
const INPUT_YOUR_PASSWORD_DUMBASS:String = "パスワードを入力してください！"


func _ready() -> void:

	set_page(0, false)
	
	input_your_name_here_label.hide()
	input_your_new_password_here_label.hide()
	input_your_password_here_label.hide()
	
	login_yes_button.grab_focus()

	return


func set_page(index:int, _do_tween:bool=true) -> void:

#	TODO
#	var tween:Tween = create_tween()
#	var before_page:Control = get_node("Page%d" % [current_index])
#	before_page.modulate = Color(1,1,1,1)
#	tween.set_ease(Tween.EASE_OUT_IN)
#	tween.tween_property(before_page,"modulate", Color(1,1,1,0),0.25)
	
	for i in range(0, 4, 1):
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
		
	current_index = index

	return


func go_to_title_scene() -> void:

	get_parent().change_scene("title")

	return


func _on_page_set_button_pressed(index:int) -> void:

	input_your_name_here_label.hide()
	input_your_new_password_here_label.hide()
	input_your_password_here_label.hide()
	set_page(index)

	return


func _on_name_input_button_pressed() -> void:

	var input_name:String = user_name_input.text
	
	if input_name == "":
		input_your_name_here_label.show()
		return
	
	input_your_name_here_label.hide()
	Settings.set_current_user(input_name)
	if Settings.is_user_exists(input_name):
		set_page(3)
		welcome_back_message_label.text = WELLCOME_BACK_MESSAGE % [input_name]
		pass
	else:
		set_page(2)
		welcome_message_label.text = WELCOME_MESSAGE % [input_name]
		pass

	return


func _on_new_pass_input_button_pressed() -> void:

	var input_password:String = new_pass_input.text
	if input_password == "":
		input_your_new_password_here_label.show()
		return
	
	input_your_new_password_here_label.hide()
	Settings.init_user_data(input_password)
	Settings.is_login = true
	go_to_title_scene()

	return


func _on_pass_input_button_pressed() -> void:

	var input_password:String = pass_input.text
	if input_password == "":
		input_your_password_here_label.text = INPUT_YOUR_PASSWORD_DUMBASS
		input_your_password_here_label.show()
		return
	
	if !Settings.is_correct_password(input_password):
		input_your_password_here_label.text = PASSWORD_IS_INCORRECT
		input_your_password_here_label.show()
		return
	
	input_your_password_here_label.hide()
	Settings.login()
	go_to_title_scene()

	return
