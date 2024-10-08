### Player.gd

extends CharacterBody2D

# player movement variables
@export var speed = 100
@export var gravity = 200
@export var jump_height = -110

# custom signals
signal update_lives(lives, max_lives)

# Keep track of the last direction (1 for right, -1 for left, 0 for none)
var last_direction = 0

# Check the direction of the player's movement
var current_direction = 0

# Health stats
var max_lives = 3
var lives = 3

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

# animations
func player_animations():
	# on left (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_left") && Global.is_jumping == false:
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = 7

	# on right (add is_action_just_released so you continue running after jumping)
	if Input.is_action_pressed("ui_right") && Global.is_jumping == false:
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play("run")
		$CollisionShape2D.position.x = -7
	
	# on idle if nothing is being pressed
	if !Input.is_anything_pressed():
		$AnimatedSprite2D.play("idle")

func horizontal_movement():
	# if keys are pressed it will return 1 for ui_right, -1 for ui_left, and 0 for neither
	var horizontal_input = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	# horizontal velocity which moves player left or right based on input
	velocity.x = horizontal_input * speed

# takes damage
func take_damage():
	# deduct and update lives
	if lives > 0:
		lives = lives - 1
		update_lives.emit(lives, max_lives)
		print(lives)
		# play damage animation
		$AnimatedSprite2D.play("hit")
		# allows animation to play
		set_physics_process(false)
	
func _process(delta):
	if velocity.x > 0: # Moving right
		current_direction = 1
	elif velocity.x < 0: # Moving left
		current_direction = -1
	
	# If the direction has changed, play the appropriate animation
	if current_direction != last_direction:
		if current_direction == 1:
			# Play the right animation
			$AnimationPlayer.play("move_right")
			
			# limits
			$Camera2D.limit_left = 100
			$Camera2D.limit_bottom = 706
			$Camera2D.limit_top = 40
			$Camera2D.limit_right = 1052
			
		elif current_direction == -1:
			# Play the left animation
			$AnimationPlayer.play("move_left")
			
			# limits
			$Camera2D.limit_left = 100
			$Camera2D.limit_bottom = 706
			$Camera2D.limit_top = 40
			$Camera2D.limit_right = 1052
		
		# Update the last_direction variable
		last_direction = current_direction

func _physics_process(delta):
	# vertical movement velocity (down)
	velocity.y += gravity * delta
	# horizontal movement processing (left, right)
	horizontal_movement()
	
	# applies movement
	move_and_slide()
	
	# applies animations
	if !Global.is_attacking || !Global.is_climbing:
		player_animations()
	
# singular input captures
func _input(event):
	# on attack
	if event.is_action_pressed("ui_attack"):
		Global.is_attacking = true
		$AnimatedSprite2D.play("attack")

	# on jump
	if event.is_action_pressed("ui_jump") and is_on_floor():
		velocity.y = jump_height
		$AnimatedSprite2D.play("jump")
	
	# on climbing ladders
	if Global.is_climbing == true:
		if !Input.is_anything_pressed():
			$AnimatedSprite2D.play("idle")
			
		if Input.is_action_pressed("ui_up"):
			$AnimatedSprite2D.play("climb")
			gravity = 100
			velocity.y = -160
			Global.is_jumping = false
			

	# reset gravity
	else:
		gravity = 200
		Global.is_climbing = false
		Global.is_jumping = false

func _on_animated_sprite_2d_animation_finished():
	Global.is_attacking = false
	set_physics_process(true)

func _ready() -> void:
	current_direction = -1
