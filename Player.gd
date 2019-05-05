extends Area2D

export var max_speed = 1200
export var velocity = Vector2()
export var margin = Vector2(10, 5)

var screen_size = Vector2()
var lower_bound = Vector2()
var upper_bound = Vector2()
var hitting_side = false

var disable_control = false

func _ready():
	screen_size = get_viewport_rect().size
	
	lower_bound.x = margin.x + $Polygon2D.polygon[2].x / 2
	lower_bound.y = margin.y + $Polygon2D.polygon[2].y / 2
	
	upper_bound.x = screen_size.x - margin.x - $Polygon2D.polygon[2].x / 2
	upper_bound.y = screen_size.y - margin.y - $Polygon2D.polygon[2].y / 2

func _process(delta):	
	if Input.is_action_pressed("ui_up") && !disable_control:
		velocity.y = clamp(min(velocity.y, -0.4) * 13, -max_speed, 0)	
	elif Input.is_action_pressed("ui_down") && !disable_control:
		velocity.y = clamp(max(velocity.y, 0.4) * 13, 0, max_speed)
	else:
		velocity.y /= 1.1
		if (position.y > lower_bound.y && !disable_control):
			hitting_side = false
		
	position += velocity * delta
	
	var old_position = position;
	position.x = clamp(position.x, lower_bound.x, upper_bound.x)
	position.y = clamp(position.y, lower_bound.y, upper_bound.y)
	
	if old_position.y > position.y && position.y == upper_bound.y && !hitting_side:
		velocity.y = -1 * velocity.y / 20
		hitting_side = true
		disable_control = true
		$BounceTimer.start()
	elif old_position.y < position.y && position.y == lower_bound.y && !hitting_side:
		velocity.y = -1 * velocity.y / 20
		hitting_side = true
		disable_control = true
		$BounceTimer.start()

func _on_Timer_timeout():
	disable_control = false
