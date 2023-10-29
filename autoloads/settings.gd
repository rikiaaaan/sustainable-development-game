extends Node

@export var executable_dir:String = OS.get_executable_path().get_base_dir()

const fake_savedata_name:String = "savedata.json"
const actual_savedata_name:String = "libaccess_output_file_plugin.dll"

var fake_savedata_dir:String = executable_dir+"/"+fake_savedata_name
var actual_savedata_dir:String = executable_dir+"/"+actual_savedata_name


func _init() -> void:

	if !FileAccess.file_exists(actual_savedata_dir) && check_actual_save_data():
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


func _get_key() -> String:

	

	return ""


func check_actual_save_data() -> bool:

	var cfg:ConfigFile = ConfigFile.new()
	var key:String = _get_key()

	return cfg.load_encrypted_pass(actual_savedata_dir, key) == OK



func generate_actual_save_data() -> void:



	return


func generate_fake_save_data() -> void:



	return
