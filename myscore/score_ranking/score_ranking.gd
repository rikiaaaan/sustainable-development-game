extends VBoxContainer

#0: myscore_daily 1:myscore_total 2:users_daily 3:users_total
@export var mode:int = 0
@export var is_my_score:bool = true

func _ready() -> void:

	fresh()

	return


func fresh() -> void:

	var ranking_data:Dictionary = {}
	match mode:
		0:
			ranking_data = Settings.get_myscore_daily_data()
		1:
			ranking_data = Settings.get_myscore_total_data()
		2:
			ranking_data = Settings.get_users_daily_data()
		3:
			ranking_data = Settings.get_users_total_data()
		_:
			print_debug("Unknown ranking mode: %d" % [mode])
			return
	
	for i in range(0, 10, 1):
		if is_my_score:
			var user_name_label:Label = get_node("Rank%d/Label2" % [i])
			user_name_label.hide()
			pass
		pass

	return
