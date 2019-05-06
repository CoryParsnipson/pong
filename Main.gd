extends Node

var max_ball_speed = 600
var min_ball_speed = 400

func _ready():
	start_game()
	
func start_game():
	randomize()
	
	var speed = (randi() + min_ball_speed) % max_ball_speed
	var dir = randf() * (PI * 2)
	
	$Ball.velocity.x = cos(dir) * speed;
	$Ball.velocity.y = sin(dir) * speed;