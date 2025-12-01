extends CharacterBody2D

@export var speed = 200

func get_input():
	var input_dir = Input.get_vector("ui_left", 'ui_right', 'ui_up', 'ui_down')
	
	velocity = input_dir*speed
	
	if Input.is_action_pressed('ui_up'):
		$Animation.play('lvl1_run_up')
	elif Input.is_action_pressed('ui_down'):
		$Animation.play('lvl1_run_down')
	elif Input.is_action_pressed('ui_right'):
		$Animation.play('lvl1_run_right')
	elif Input.is_action_pressed('ui_left'):
		$Animation.play('lvl1_run_left')
	else:
		$Animation.play('idle1')


func _physics_process(delta):
	get_input()
	move_and_collide(velocity * delta)
	z_index = int(global_position.y)
	
#func _process(delta):
	#z_index = int(global_position.y)
