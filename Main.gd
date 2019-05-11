extends Node

export var score_p1 = 0
export var score_p2 = 0

export var max_score = 3

export var start_game_delay = 3 # in seconds

var max_ball_speed = 700
var min_ball_speed = 600

var start_game_delay_curr

var generate = false
var rand_t1 = 0.0

func _ready():
	pre_start_game()
	
func pre_start_game():
	# for when the game loads up for the first time
	$GameNodes.visible = false
	$GameNodes/InstructionTimer.start()
	
func start_game():
	$StartScreen.visible = false
	$StartScreen/StartGameButton.disabled = true
	
	$GameNodes.visible = true
	$GameNodes/GameOverMessage.hide()
	
	$GameNodes/RetryButton.text = "RETRY"
	$GameNodes/RetryButton.hide()
	$GameNodes/RetryButton.disabled = true
		
	# reset scores
	score_p1 = 0
	score_p2 = 0
	
	# enable paddles again
	$GameNodes/Player1.disabled = false
	$GameNodes/Player2.disabled = false
	
	$GameNodes/Player1.position.y = 300
	$GameNodes/Player2.position.y = 300
	
	$GameNodes/Player1.velocity = Vector2()
	$GameNodes/Player2.velocity = Vector2()
	
	reset_ball()
	
func reset_ball():
	start_game_delay_curr = start_game_delay
	$GameNodes/Ball.position = get_viewport().size / 2
	$GameNodes/Ball.velocity = Vector2()
	
	$GameNodes/StartGameCountdown.show()

	while (start_game_delay_curr > 0):
		$GameNodes/StartGameCountdown.text = str(start_game_delay_curr)
		$GameNodes/StartGameTimer.start()
		yield($GameNodes/StartGameTimer, "timeout")
	
	$GameNodes/StartGameCountdown.hide()
	
	randomize()
	
	var speed = (randi() % (max_ball_speed - min_ball_speed)) + min_ball_speed
	var dir = (2 * PI) * (1.0 - gaussian_rand(PI / 2, 0.5))
	while (abs(cos(dir)) < 0.3):
		dir = (2 * PI) * (1.0 - gaussian_rand(PI / 2, 0.5))
	
	$GameNodes/Ball.velocity.x = cos(dir) * speed
	$GameNodes/Ball.velocity.y = sin(dir) * speed

func end_game(winning_player_id):
	$GameNodes/GameOverMessage.show()
	
	$GameNodes/RetryButton.show()
	$GameNodes/RetryButton.disabled = false
	
	$GameNodes/Player1.disabled = true
	$GameNodes/Player2.disabled = true
	
	if (winning_player_id == 1):
		$GameNodes/GameOverMessage.text += "\nPLAYER 1 WINS!"
	elif (winning_player_id == 2):
		$GameNodes/GameOverMessage.text += "\nPLAYER 2 WINS!"
	else:
		$GameNodes/GameOverMessage.text += "\nINDECISIVE!!"

func _on_RightGoal_body_entered(body):
	if body.get_name() != "Ball":
		return
	
	score_p1 += 1
	$GameNodes/Label_P1_Score.text = str(score_p1)
	
	if (score_p1 >= max_score):
		end_game(1)
	else:
		reset_ball()

func _on_LeftGoal_body_entered(body):
	if body.get_name() != "Ball":
		return
	
	score_p2 += 1
	$GameNodes/Label_P2_Score.text = str(score_p2)
	
	if (score_p2 >= max_score):
		end_game(2)
	else:
		reset_ball()

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

func _on_StartGameTimer_timeout():
	start_game_delay_curr -= 1


func _on_NewGame_pressed():
	start_game()


func _on_InstructionTimer_timeout():
	$GameNodes/Player1/P1_Instructions.visible = false
	$GameNodes/Player2/P2_Instructions.visible = false
