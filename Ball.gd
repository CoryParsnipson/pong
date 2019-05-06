extends KinematicBody2D

export var velocity = Vector2()

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _physics_process(delta):
	var collision = move_and_collide(velocity * delta)
	if (collision):
		velocity = velocity.bounce(collision.normal)