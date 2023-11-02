extends Control

@export var rank:int = 0
@export var score:int = 0
@export var user_name:String = ""
@export var is_my_score:bool = false

const NORMAL_COLOR:Color = Color(0.0, 0.64, 0.78, 1.0)
const FIRST_COLOR:Color = Color(0.95, 0.83, 0.5, 1.0)
const SECOND_COLOR:Color = Color(0.27, 0.57, 0.63, 1)
const THIRD_COLOR:Color = Color(0.72, 0.45, 0.2, 1.0)


func _process(_delta:float) -> void:

	match rank:
		0:
			$ColorRect.color = FIRST_COLOR
			pass
		1:
			$ColorRect.color = SECOND_COLOR
			pass
		2:
			$ColorRect.color = THIRD_COLOR
			pass
		_:
			$ColorRect.color = NORMAL_COLOR
			pass
	
	$Rank.text = "%d" % [rank+1]
	$UserName.text = user_name
	
	score = clampi(score, 0, 99999)
	$Score.text = "%d" % [score]

	return
