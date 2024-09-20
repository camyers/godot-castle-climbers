### CannonHandler.gd

extends Node2D

# when it's loaded into the scene
func _ready():
	# play cannon lighting animation on start
	$Body.play("matching")

func _on_timer_timeout() -> void:
	# randomizes speech
	var random_speech = randi() % 3 # will return 0, 1, or 2
	match random_speech:
		0:
			$SpeechBubble.play("boom")
		1:
			$SpeechBubble.play("attack")
		2:
			$SpeechBubble.play("swearing")

func _process(delta):
	# randomizes speech bubble randomize time
	$Timer.wait_time = randi_range(1, 10)
	
	# idle animation
	if Global.is_bomb_moving == true:
		$Body.play("idle")
		# show speech bubble
		$SpeechBubble.visible = true
	
	# matching animation
	if Global.is_bomb_moving == false:
		$Body.play("matching")
		# hide speech bubble
		$SpeechBubble.visible = false
		
	
