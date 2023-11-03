extends Node

@export var executable_dir:String = OS.get_executable_path().get_base_dir()
@export var current_user_name:String = ""
@export var is_login:bool = false

const FAKE_SAVEDATA_NAME:String = "savedata.json"
const ACTUAL_SAVEDATA_NAME:String = "libaccess_output_file_plugin.lib"
const IGNORE_CHECK_NAME:String = "ignorefilecheck"

const KEY_USER_NAME:String = "user_name"
const KEY_USER_ID:String = "user_id"
const KEY_USER_PASSWORD:String = "pass"
const KEY_SCORE:String = "score"
const KEY_SCORE_RECORDED_AT:String = "score_recorded_at"
const KEY_RESULT_SCREENSHOT:String = "result_screenshot"

#hi everyone! my name is:
const CREATOR_NAME:String = "FairyMD"
const CREATOR_DEFAULT_SCORE:int = 3000

var fake_savedata_dir:String = executable_dir+"/"+FAKE_SAVEDATA_NAME
var actual_savedata_dir:String = executable_dir+"/"+ACTUAL_SAVEDATA_NAME


func _ready() -> void:

	if FileAccess.file_exists(executable_dir+"/"+IGNORE_CHECK_NAME):
		OS.alert("ファイルチェックをスキップしました", "大丈夫かい？")
		return
	if !FileAccess.file_exists(actual_savedata_dir) || !check_actual_save_data():
		OS.alert("[ERROR]外部ライブラリの参照に失敗しました。ゲームを再起動してください。", "致命的なエラー")
		generate_actual_save_data()
		generate_fake_save_data()
		get_tree().quit()
		return
	if !FileAccess.file_exists(fake_savedata_dir):
		return
#	#設定ファイルの存在チェック
#	if !FileAccess.file_exists(config_file_path):
#		OS.alert("[WARNING]設定ファイルが存在しないため、新しい設定ファイルを生成します。\n想定されたパス:%s" % [config_file_path], "設定ファイルが存在しません")
#		create_new_config_file()
#		return
#	#ConfigFileのインスタンスを生成
#	var config_file:ConfigFile = ConfigFile.new()
#	#設定ファイルをロード。もし失敗したらアラート
#	if config_file.load(config_file_path) != OK:
#		OS.alert("[ERROR]設定ファイルのロードに失敗しました。既定の設定を使用します。", "設定ファイルのロードに失敗しました")
#		return
#	#ロードした設定ファイルから設定をセット
#	set_settings_from_loaded_config_file(config_file)

	return


func load_cfg_file() -> ConfigFile:

	var cfg:ConfigFile = ConfigFile.new()
	if cfg.load_encrypted_pass(actual_savedata_dir, Keys.save_key) != OK:
		OS.alert("セーブファイルの読み込みに失敗しました。\nゲームを終了します。", "セーブファイルの読み込みに失敗しました")
		get_tree().quit()
		return

	return cfg

func save_cfg_file(cfg:ConfigFile) -> void:

	cfg.save_encrypted_pass(actual_savedata_dir, Keys.save_key)

	return


func check_actual_save_data() -> bool:

	var cfg:ConfigFile = ConfigFile.new()
	var key:String = Keys.save_key

	return cfg.load_encrypted_pass(actual_savedata_dir, key) == OK


func generate_actual_save_data() -> void:

	var cfg:ConfigFile = ConfigFile.new()
	
	cfg.set_value(CREATOR_NAME, KEY_USER_NAME, CREATOR_NAME)
	cfg.set_value(CREATOR_NAME, KEY_USER_ID, Keys.generate_user_id())
	cfg.set_value(CREATOR_NAME, KEY_USER_PASSWORD, Keys.creator_password)
	cfg.set_value(CREATOR_NAME, KEY_SCORE, CREATOR_DEFAULT_SCORE)
	cfg.set_value(CREATOR_NAME, KEY_SCORE_RECORDED_AT, 0)
#	cfg.set_value(CREATOR_NAME, KEY_RESULT_SCREENSHOT, Image.new())
	
	save_cfg_file(cfg)

	return


func generate_fake_save_data() -> void:



	return


func is_user_exists(user_name:String) -> bool:

	return load_cfg_file().has_section(user_name)


func is_correct_password(password:String) -> bool:

	var cfg:ConfigFile = load_cfg_file()
	var encoded_password:String = cfg.get_value(current_user_name, KEY_USER_PASSWORD)

	return Keys.is_correct_password(password, encoded_password)


func init_user_data(password:String) -> void:

	if !is_user_exists(current_user_name):
		var cfg:ConfigFile = load_cfg_file()
		
		cfg.set_value(current_user_name, KEY_USER_NAME, current_user_name)
		cfg.set_value(current_user_name, KEY_USER_ID, Keys.generate_user_id())
		cfg.set_value(current_user_name, KEY_USER_PASSWORD, Keys.encode_password(password))
		cfg.set_value(current_user_name, KEY_SCORE, 0)
		cfg.set_value(current_user_name, KEY_SCORE_RECORDED_AT, 0)
#		cfg.set_value(current_user_name, KEY_RESULT_SCREENSHOT, Image.new())
		
		save_cfg_file(cfg)
		pass

	return


func login() -> void:

	is_login = true

	return 


func save_game_data(data:Dictionary) -> void:

	if is_login:
		var cfg:ConfigFile = load_cfg_file()
		
		cfg.set_value(current_user_name, KEY_SCORE, data.score)
		cfg.set_value(current_user_name, KEY_SCORE_RECORDED_AT, data.recorded_at)
#		cfg.set_value(current_user_name, KEY_RESULT_SCREENSHOT, data.result_screenshot)
		
		save_cfg_file(cfg)
		pass

	return


func get_myscore_daily_data() -> Dictionary:

	return {}


func get_myscore_total_data() -> Dictionary:

	return {}


func get_users_daily_data() -> Dictionary:

	return {}


func get_users_total_data() -> Dictionary:

	return {}


func set_current_user(user_name:String) -> void:

	current_user_name = user_name

	return
