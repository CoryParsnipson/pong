extends Node

export var score_p1 = 0
export var score_p2 = 0

var max_ball_speed = 800
var min_ball_speed = 700

func _ready():
	start_game()
	
func start_game():
	randomize()
	
	$Ball.position = get_viewport().size / 2
	
	var speed = (randi() % (max_ball_speed - min_ball_speed)) + min_ball_speed
	var dir = randf() * (PI * 2)
	
	$Ball.velocity.x = cos(dir) * speed;
	$Ball.velocity.y = sin(dir) * speed;

func _on_RightGoal_body_entered(body):
	score_p1 += 1
	$Label_P1_Score.text = str(score_p1)
	start_game()

func _on_LeftGoal_body_entered(body):
	score_p2 += 1
	$Label_P2_Score.text = str(score_p2)
	start_game()
