### Bombspawner.gd

extends Node2D

#Bomb scene reference
var bomb = preload("res://Scenes/Bomb.tscn")

#references to our scene, PathFollow2D path, and AnimationPlayer path
var current_scene_path
var bomb_path
var bomb_animation

#when it's loaded into the scene
func _ready():
	#default animation on load
	$AnimatedSprite2D.play("cannon_idle")   
	#initiates paths
	current_scene_path = "/root/" + Global.current_scene_name + "/" #current scene
	bomb_path = get_node(current_scene_path + "/BombPath/Path2D/PathFollow2D") #PathFollow2D
	bomb_animation = get_node(current_scene_path + "/BombPath/Path2D/AnimationPlayer") #AnimationPlayer
	
	#starts bomb movement
	bomb_animation.play("bomb_movement")

#spawns bomb instance    
func shoot():
	#play cannon shoot animation each time the function is fired off
	$AnimatedSprite2D.play("cannon_fired")
	#sets the bomb to moving and plays bomb animation
	Global.is_bomb_moving = true
	bomb_animation.play("bomb_movement")
	#returns spawned bomb
	var spawned_bomb = bomb.instantiate()
	return spawned_bomb
	
#shoot and spawn bomb onto path
func _on_timer_timeout():
	#reset animation before shooting    
	$AnimatedSprite2D.play("cannon_idle")
	#spawns a bomb onto our path if there are no bombs available
	if bomb_path.get_child_count() <= 0:
		bomb_path.add_child(shoot())
	# Clear all existing bombs	
	if Global.is_bomb_moving == false:
		for bombs in bomb_path.get_children():
			bomb_path.remove_child(bombs)
			bombs.queue_free()
			bomb_animation.stop()
