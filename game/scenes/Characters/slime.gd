extends CharacterBody2D

var chase = false
var speed = 120
@onready var anim = $AnimatedSprite2D
var alive = true

func play_move_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		if direction.x > 0:
			anim.play("run_right")
		else:
			anim.play("run_left")
	else:
		if direction.y > 0:
			anim.play("run_down")
		else:
			anim.play("run_up")

func _physics_process(delta):
	var player = $"../../CharacterBody2D"
	var direction = (player.position - self.position).normalized()
	if alive == true:
		if chase == true:
			velocity = direction * speed
			play_move_animation(direction)
		else:
			velocity = Vector2(0, 0)
			anim.play("idle")
			
	move_and_collide(velocity * delta)
	
func _on_detector_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		chase = true

func _on_detector_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		chase = false
		
func death():
	alive = false
	anim.play("death")
	await anim.animation_finished
	queue_free()
