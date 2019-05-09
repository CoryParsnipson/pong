extends Node

export var score_p1 = 0
export var score_p2 = 0

var max_ball_speed = 800
var min_ball_speed = 700

var generate = false
var rand_t1 = 0.0

func _ready():
	start_game()
	
func start_game():
	randomize()
	
	$Ball.position = get_viewport().size / 2
	
	var speed = (randi() % (max_ball_speed - min_ball_speed)) + min_ball_speed
	var dir = (2 * PI) * (1.0 - gaussian_rand(PI / 2, 0.5))
	while (abs(cos(dir)) < 0.3):
		dir = (2 * PI) * (1.0 - gaussian_rand(PI / 2, 0.5))
	
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

func gaussian_rand(mean = 0.0, deviation = 1.0):
	generate = !generate
	
	if (!generate):
		return rand_t1 * deviation + mean
	
	var r1 = 0.0
	var r2 = 0.0
	
	while (abs(r1 - r2) < 0.0000001):
		r1 = randf()
		r2 = randf()
		
	var rand_t2  = sqrt(-2.0 * log(r1)) * cos(PI * 2 * r2)
	rand_t1 = sqrt(-2.0 * log(r1)) * sin(PI * 2 * r2)
	
	return rand_t2 * deviation + mean