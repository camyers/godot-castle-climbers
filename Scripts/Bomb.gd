### Bomb.gd

extends Area2D

# default animation on spawn
func _ready():
	$AnimatedSprite2D.play("moving")

func _on_body_entered(body: Node2D) -> void:
	# if the bomb collides with the player, play the explosion animation and start the timer
	if body.name == "Player":
		$AnimatedSprite2D.play("explode")
		$Timer.start()

func _on_timer_timeout() -> void:
	if is_instance_valid(self):
		self.queue_free()
