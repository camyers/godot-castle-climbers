### Bomb.gd

extends Area2D

var rotation_speed = 10

# default animation on spawn
func _ready():
	$AnimatedSprite2D.play("moving")

func _on_body_entered(body: Node2D) -> void:
	# if the bomb collides with the player, play the explosion animation and start the timer.
	if body.name == "Player":
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		Global.is_bomb_moving = false
		# Deal damage
		body.take_damage()

	# if the bomb collides with our Wall scene, explode and remove
	if body.name.begins_with("Wall"):
		$AnimatedSprite2D.play("explode")
		$Timer.start()
		Global.is_bomb_moving = false

func _on_timer_timeout() -> void:
	if is_instance_valid(self):
		self.queue_free()

func _physics_process(delta):
	# Rotate the bomb if it hasn't exploded
	if Global.is_bomb_moving == true:
		$AnimatedSprite2D.rotation += rotation_speed * delta
