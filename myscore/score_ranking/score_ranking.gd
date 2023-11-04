extends VBoxContainer

#0: myscore_daily 1:myscore_total 2:users_daily 3:users_total
@export var mode:int = 0

const TEST_DATA:Array[Dictionary] = [
	{
		"name":"TestUser0000",
		"score":2100
	},
	{
		"name":"TestUser0001",
		"score":2190
	}
]

func _ready() -> void:

	fresh()

	return


func fresh() -> void:

#	if !Settings.is_login && (mode == 0 || mode == 1):
#		return
	
	var ranking_data:Array[Dictionary] = []
	match mode:
		0:
			ranking_data = Settings.get_myscore_daily_data()
			print_debug("Myscore_daily: %s" % [ranking_data])
		1:
			ranking_data = Settings.get_myscore_total_data()
			print_debug("Myscore_total: %s" % [ranking_data])
		2:
			ranking_data = Settings.get_users_daily_data()
			print_debug("users_score_daily: %s" % [ranking_data])
		3:
			ranking_data = Settings.get_users_total_data()
			print_debug("users_score_total: %s" % [ranking_data])
		_:
			print_debug("Unknown ranking mode: %d" % [mode])
			return
	
#	ranking_data = TEST_DATA
	
	var ranking_data_length:int = ranking_data.size()
	for i in range(0, 10, 1):
		var current_rank:Control = get_node("Rank%d" % [i])
		var user_name_label:Label = current_rank.get_node("Label2")
		var score_label:Label = current_rank.get_node("Label3")
		if mode == 0 || mode == 1:
			user_name_label.hide()
			pass
		if i >= ranking_data_length || ranking_data[i] == {}:
			user_name_label.hide()
			score_label.text = "-----"
			continue
		if ranking_data[i].has("user_name"):
			user_name_label.show()
			user_name_label.text = ranking_data[i].user_name
			pass
		if ranking_data[i].has("score"):
			var score:int = ranking_data[i].score
			score_label.text = "%d" % [clampi(score, 0, 99999)]
			pass
		pass

	return
