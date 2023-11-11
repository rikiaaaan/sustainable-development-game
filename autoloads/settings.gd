extends Node

@export var executable_dir:String = OS.get_executable_path().get_base_dir()
@export var current_user_name:String = ""
@export var is_login:bool = false
@export var is_load_save_data:bool = false
@export var is_succeeded_to_load_data_file:bool = false

const FAKE_SAVEDATA_NAME:String = "savedata.json"
const ACTUAL_SAVEDATA_NAME:String = "libaccess_output_file_plugin.lib"
const IGNORE_CHECK_NAME:String = "ignorefilecheck"

const KEY_USER_NAME:String = "user_name"
const KEY_USER_ID:String = "user_id"
const KEY_USER_PASSWORD:String = "pass"

const KEY_SCORE:String = "score"
const KEY_BEST_SCORE:String = "best_score"
const KEY_LATEST_BEST_SCORE:String = "latest_best_score"
const KEY_LATEST_BEST_SCORE_RECORDED_AT:String = "latest_best_score_recorded_at"
const KEY_LATEST_SCORE:String = "latest_score"
const KEY_SCORE_HISTORY:String = "score_history"

const KEY_BEST_SDG:String = "best_sdg"
const KEY_LATEST_SDG:String = "latest_sdg"
const KEY_LATEST_BEST_SDG:String = "latest_best_sdg"
const KEY_NEXT_SDG:String = "next_sdg"
const KEY_CURRENT_SDG:String = "current_sdg"
const KEY_SDGS:String = "sdgs"

const KEY_RECORDED_AT:String = "recorded_at"
const KEY_SCORE_RECORDED_AT:String = "score_recorded_at"
const KEY_BEST_SCORE_RECORDED_AT:String = "best_score_recorded_at"
const KEY_LATEST_SCORE_RECORDED_AT:String = "latest_score_recorded_at"

const KEY_SAVED_GAME_DATA:String = "saved_game_data"
const KEY_SAVED_AT:String = "saved_at"
const KEY_POSITION:String = "position"
const KEY_ROTATION:String = "rotation"
const KEY_PHASE:String = "phase"

const KEY_RESULT_SCREENSHOT:String = "result_screenshot"

#hi everyone! my name is:
const CREATOR_NAME:String = "FairyMD"
const CREATOR_DEFAULT_SCORE:int = 3000
const CREATOR_DEFAULT_SDG:int = 1

const DAY_SECOND:int = 24*60*60

var fake_savedata_dir:String = executable_dir+"/"+FAKE_SAVEDATA_NAME
var actual_savedata_dir:String = executable_dir+"/"+ACTUAL_SAVEDATA_NAME


func _ready() -> void:

	if FileAccess.file_exists(executable_dir+"/"+IGNORE_CHECK_NAME):
		OS.alert("ファイルチェックをスキップしました", "大丈夫かい？")
		is_succeeded_to_load_data_file = true
		return
	if !check_actual_save_data():
		OS.alert("[FATAL_ERROR]外部ライブラリの参照に失敗しました。管理者に報告をしてください。", "致命的なエラー")
		get_tree().quit()
		return
	if !check_fake_save_data():
		OS.alert("[ERROR]セーブデータの読み込みに失敗しました。ゲームを再起動すると直る可能性があります。", "エラー")
		generate_fake_save_data(load_cfg_file())
		get_tree().quit()
		return
	
	generate_fake_save_data(load_cfg_file())
	is_succeeded_to_load_data_file = true

	return


func load_cfg_file() -> ConfigFile:

	var cfg:ConfigFile = ConfigFile.new()
	if cfg.load_encrypted_pass(actual_savedata_dir, Keys.save_key) != OK:
		OS.alert("[ERROR]セーブファイルの読み込みに失敗しました。\nゲームを終了します。", "エラー")
		get_tree().quit()
		return

	return cfg


func save_cfg_file(cfg:ConfigFile) -> void:

	cfg.save_encrypted_pass(actual_savedata_dir, Keys.save_key)
	generate_fake_save_data(cfg)

	return


func check_fake_save_data() -> bool:

	if !FileAccess.file_exists(fake_savedata_dir):
		return false
	
	var file:FileAccess = FileAccess.open(fake_savedata_dir, FileAccess.READ)
	
	if file.get_open_error() != OK:
		print_debug("check_f***_save_data: open failed. error:%d" % [file.get_open_error()])
		return false
	
	var content:String = file.get_as_text()
	var parsed = JSON.parse_string(content)

	return parsed != null


func check_actual_save_data() -> bool:

	var cfg:ConfigFile = ConfigFile.new()
	var key:String = Keys.save_key

	return FileAccess.file_exists(actual_savedata_dir) && cfg.load_encrypted_pass(actual_savedata_dir, key) == OK


func generate_actual_save_data() -> void:

	var cfg:ConfigFile = ConfigFile.new()
	
	var current_unix_time:int = Time.get_unix_time_from_system()+(Time.get_time_zone_from_system().bias*60)
	var score_history:Array[Dictionary] = [
		{
			KEY_SCORE: CREATOR_DEFAULT_SCORE,
			KEY_SCORE_RECORDED_AT: current_unix_time
		}
	]
	
	cfg.set_value(CREATOR_NAME, KEY_USER_NAME, CREATOR_NAME)
	cfg.set_value(CREATOR_NAME, KEY_USER_ID, Keys.generate_user_id())
	cfg.set_value(CREATOR_NAME, KEY_USER_PASSWORD, Keys.creator_password)
	
	cfg.set_value(CREATOR_NAME, KEY_BEST_SCORE, CREATOR_DEFAULT_SCORE)
	cfg.set_value(CREATOR_NAME, KEY_BEST_SDG, CREATOR_DEFAULT_SDG)
	cfg.set_value(CREATOR_NAME, KEY_BEST_SCORE_RECORDED_AT, current_unix_time)
	cfg.set_value(CREATOR_NAME, KEY_LATEST_BEST_SCORE, CREATOR_DEFAULT_SCORE)
	cfg.set_value(CREATOR_NAME, KEY_LATEST_BEST_SCORE_RECORDED_AT, current_unix_time)
	
	cfg.set_value(CREATOR_NAME, KEY_LATEST_SDG, CREATOR_DEFAULT_SDG)
	cfg.set_value(CREATOR_NAME, KEY_LATEST_SCORE, CREATOR_DEFAULT_SCORE)
	cfg.set_value(CREATOR_NAME, KEY_LATEST_SCORE_RECORDED_AT, current_unix_time)
	
	
	cfg.set_value(CREATOR_NAME, KEY_SCORE_HISTORY, score_history)
	cfg.set_value(CREATOR_NAME, KEY_SAVED_GAME_DATA, {})
	
#	cfg.set_value(CREATOR_NAME, KEY_RESULT_SCREENSHOT, Image.new())
	
	save_cfg_file(cfg)

	return


func generate_fake_save_data(cfg:ConfigFile) -> void:

	var data:Dictionary = {
		"userdata":[] as Array[Dictionary]
	}
	
	for user_name in cfg.get_sections():
		var user_data:Dictionary = {}
		for data_key in cfg.get_section_keys(user_name):
			match data_key:
				KEY_USER_NAME:
					var _user_name:String = cfg.get_value(user_name, data_key, "")
					user_data[data_key] = _user_name.uri_encode()
					pass
				KEY_USER_PASSWORD:
					var _pass:String = cfg.get_value(user_name, data_key, "")
					user_data[data_key] = Keys.encode_password(user_name)
					pass
				_:
					user_data[data_key] = cfg.get_value(user_name, data_key, "")
					pass
			pass
		data.userdata.append(user_data)
		pass
	
	var data_string:String = JSON.stringify(data, "", false, true)
	var fake_save_data:FileAccess = FileAccess.open(fake_savedata_dir, FileAccess.WRITE)
	fake_save_data.store_string(data_string)

	return


func init_user_data(password:String) -> void:

	if !is_user_exists(current_user_name):
		var cfg:ConfigFile = load_cfg_file()
		
		cfg.set_value(current_user_name, KEY_USER_NAME, current_user_name)
		cfg.set_value(current_user_name, KEY_USER_ID, Keys.generate_user_id())
		cfg.set_value(current_user_name, KEY_USER_PASSWORD, Keys.encode_password(password))
		
		cfg.set_value(current_user_name, KEY_BEST_SCORE, 0)
		cfg.set_value(current_user_name, KEY_BEST_SDG, 0)
		cfg.set_value(current_user_name, KEY_BEST_SCORE_RECORDED_AT, 0)
		
		cfg.set_value(current_user_name, KEY_LATEST_BEST_SCORE, 0)
		cfg.set_value(current_user_name, KEY_LATEST_BEST_SCORE_RECORDED_AT, 0)
		
		cfg.set_value(current_user_name, KEY_LATEST_SDG, 0)
		cfg.set_value(current_user_name, KEY_LATEST_SCORE, 0)
		cfg.set_value(current_user_name, KEY_LATEST_SCORE_RECORDED_AT, 0)
		
		cfg.set_value(current_user_name, KEY_SCORE_HISTORY, [] as Array[Dictionary])
		cfg.set_value(current_user_name, KEY_SAVED_GAME_DATA, {})
		
#		cfg.set_value(current_user_name, KEY_SCORE, 0)
#		cfg.set_value(current_user_name, KEY_SCORE_RECORDED_AT, 0)
#		cfg.set_value(current_user_name, KEY_RESULT_SCREENSHOT, Image.new())
		
		save_cfg_file(cfg)
		pass

	return


func login() -> void:

	is_login = true

	return 


func save_result_data(data:Dictionary) -> void:

	if is_login:
		var cfg:ConfigFile = load_cfg_file()
		
		var saved_best_score:int = cfg.get_value(current_user_name, KEY_BEST_SCORE)
		var saved_latest_best_score:int = cfg.get_value(current_user_name, KEY_LATEST_BEST_SCORE)
		var saved_latest_best_score_recorded_at:int = cfg.get_value(current_user_name, KEY_LATEST_BEST_SCORE_RECORDED_AT)
		var saved_best_sdg:int = cfg.get_value(current_user_name, KEY_BEST_SDG)
		var today_range:Array[int] = get_today_range()
		
		var saved_score_history:Array[Dictionary] = cfg.get_value(current_user_name, KEY_SCORE_HISTORY)
		
		#ベストスコア更新！やったね！
		if data.score > saved_best_score:
			cfg.set_value(current_user_name, KEY_BEST_SCORE, data.score)
			cfg.set_value(current_user_name, KEY_BEST_SCORE_RECORDED_AT, data.recorded_at)
			pass
		
		if today_range[0] <= saved_latest_best_score_recorded_at && saved_latest_best_score_recorded_at < today_range[1]:
			if data.score > saved_latest_best_score:
				cfg.set_value(current_user_name, KEY_LATEST_BEST_SCORE, data.score)
				cfg.set_value(current_user_name, KEY_BEST_SCORE_RECORDED_AT, data.recorded_at)
				pass
			pass
		else:
			cfg.set_value(current_user_name, KEY_LATEST_BEST_SCORE, data.score)
			cfg.set_value(current_user_name, KEY_LATEST_BEST_SCORE_RECORDED_AT, data.recorded_at)
			pass
		
		##TODO: ベストsdgを作る
#		if data.best_sdg > saved_best_sdg:
#			cfg.set_value(current_user_name, KEY_BEST_SDG, data.best_sdg)
#			pass
		
		cfg.set_value(current_user_name, KEY_LATEST_SCORE, data.score)
		cfg.set_value(current_user_name, KEY_LATEST_SCORE_RECORDED_AT, data.recorded_at)
		
		var score_history:Dictionary = {
			KEY_SCORE: data.score,
			KEY_SCORE_RECORDED_AT: data.recorded_at
		}
		saved_score_history.append(score_history)
		cfg.set_value(current_user_name, KEY_SCORE_HISTORY, saved_score_history)
		
		save_cfg_file(cfg)
		pass

	return


func save_game_data(data:Dictionary) -> void:

	var cfg:ConfigFile = load_cfg_file()
	
	cfg.set_value(current_user_name, KEY_SAVED_GAME_DATA, data)
	
	save_cfg_file(cfg)

	return


func sort_scores_data(data:Array[Dictionary], amount:int=0) -> Array[Dictionary]:

	var data_size:int = data.size()
	if data_size == 1 || data_size < 0:
		return data
	
	if amount == 0 || amount > data_size:
		amount = data_size
		pass
	
	for i in range(0, amount, 1):
		var max:int = data[i].score
		var max_index:int = i
		for j in range(i+1, data_size, 1):
			var current_score:int = data[j].score
			if current_score > max:
				max = current_score
				max_index = j
			pass
		if max_index == i:
			continue
		
		var t:Dictionary = data[i]
		data[i] = data[max_index]
		data[max_index] = t
		pass

	return data.slice(0, amount)


func is_user_exists(user_name:String) -> bool:

	return load_cfg_file().has_section(user_name)


func is_correct_password(password:String) -> bool:

	var cfg:ConfigFile = load_cfg_file()
	var encoded_password:String = cfg.get_value(current_user_name, KEY_USER_PASSWORD)

	return Keys.is_correct_password(password, encoded_password)


func has_saved_game_data() -> bool:

	if !is_login:
		return false
	
	var cfg:ConfigFile = load_cfg_file()
	var saved_game_data:Dictionary = cfg.get_value(current_user_name, KEY_SAVED_GAME_DATA, {})

	return saved_game_data != {} && saved_game_data.has(KEY_SAVED_AT) && saved_game_data.has(KEY_NEXT_SDG)


func get_today_range() -> Array[int]:

	var now_unix:int = Time.get_unix_time_from_system() + (Time.get_time_zone_from_system().bias*60)
	
	var today_start:int = now_unix - (now_unix % DAY_SECOND)
	var tomorrow_start:int = today_start + DAY_SECOND
	
	print_debug("today_start: %s" % [Time.get_datetime_dict_from_unix_time(today_start)])
	print_debug("tomorrow_start: %s" % [Time.get_datetime_dict_from_unix_time(tomorrow_start)])

	print_debug("today_range[0]: %d, [1]: %d" % [today_start, tomorrow_start])
	return [today_start, tomorrow_start]


func get_myscore_daily_data() -> Array[Dictionary]:

	var cfg:ConfigFile = load_cfg_file()
	
	if !is_login || cfg.get_value(current_user_name, KEY_SCORE_HISTORY, []) == []:
		return []
	
	var my_score_history:Array[Dictionary] = cfg.get_value(current_user_name, KEY_SCORE_HISTORY)
	var my_daily_score:Array[Dictionary] = []
	var today_range:Array[int] = get_today_range()
	
	for i in range(0, my_score_history.size(), 1):
		var current_history:Dictionary = my_score_history[i]
		var history_recorded_at:int = current_history.score_recorded_at
		if today_range[0] <= history_recorded_at && history_recorded_at < today_range[1]:
			my_daily_score.append(current_history)
			pass
		pass

	return sort_scores_data(my_daily_score, 10)


func get_myscore_total_data() -> Array[Dictionary]:

	var cfg:ConfigFile = load_cfg_file()
	
	if !is_login || cfg.get_value(current_user_name, KEY_SCORE_HISTORY, []) == []:
		return []
	
	var my_total_scores:Array[Dictionary] = []
	var my_score_history:Array[Dictionary] = cfg.get_value(current_user_name, KEY_SCORE_HISTORY)

	return sort_scores_data(my_score_history, 10)


func get_users_daily_data() -> Array[Dictionary]:

	var cfg:ConfigFile = load_cfg_file()
	
	var user_daily_scores:Array[Dictionary] = []
	var today_range:Array[int] = get_today_range()
	
	for user_name in cfg.get_sections():
		
		print_debug("User Name: %s" % [user_name])
		var user_latest_best_score_recorded_at:int = cfg.get_value(user_name, KEY_LATEST_BEST_SCORE_RECORDED_AT)
		if today_range[0] <= user_latest_best_score_recorded_at && user_latest_best_score_recorded_at < today_range[1]:
			var score_data:Dictionary = {
				KEY_USER_NAME: user_name,
				KEY_SCORE: cfg.get_value(user_name, KEY_LATEST_BEST_SCORE)
			}
			user_daily_scores.append(score_data)
			pass
		
		pass

	return sort_scores_data(user_daily_scores, 10)


func get_users_total_data() -> Array[Dictionary]:

	var cfg:ConfigFile = load_cfg_file()
	
	var user_total_scores:Array[Dictionary] = []
	for user_name in cfg.get_sections():
		print_debug("Current user_name: %s" % [user_name])
		if cfg.get_value(user_name, KEY_BEST_SCORE_RECORDED_AT) != 0:
			var score_data:Dictionary = {
				KEY_USER_NAME: user_name,
				KEY_SCORE: cfg.get_value(user_name, KEY_BEST_SCORE)
			}
			user_total_scores.append(score_data)
			pass
		pass

	return sort_scores_data(user_total_scores, 10)


func get_saved_data_saved_at() -> int:

	if is_login:
		var cfg:ConfigFile = load_cfg_file()
		var saved_data:Dictionary = cfg.get_value(current_user_name, KEY_SAVED_GAME_DATA, {})
		if saved_data.has(KEY_SAVED_AT):
			return saved_data[KEY_SAVED_AT]
		pass

	return 0


func get_saved_game_data() -> Dictionary:

	if is_login:
		var cfg:ConfigFile = load_cfg_file()
		return cfg.get_value(current_user_name, KEY_SAVED_GAME_DATA, {})

	return {}


func set_current_user(user_name:String) -> void:

	current_user_name = user_name

	return
