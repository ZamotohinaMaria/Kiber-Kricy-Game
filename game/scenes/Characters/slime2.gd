extends CharacterBody2D

var chase = false
var speed = 120
@onready var anim = $AnimatedSprite2D
@onready var animP = $AnimationPlayer
var alive = true
@export var max_health := 50
var health := max_health
var slime_attack = 20

var player_in_attack_zone := false
var is_attacking := false
var can_attack := true

func take_damage(amount: int) -> void:
	health -= amount
	print("Slime HP:", health)

	if health <= 0:
		death()


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
	if not alive:
		return

	if is_attacking:
		velocity = Vector2.ZERO
		move_and_collide(velocity * delta)
		return

	if player_in_attack_zone and can_attack:
		start_attack()
		return
	var player = get_player()
	if player == null:
		chase = false
		velocity = Vector2.ZERO
		anim.play("idle")
		move_and_slide()
		return

	var direction = (player.position - position).normalized()

	if chase:
		velocity = direction * speed
		play_move_animation(direction)
	else:
		velocity = Vector2.ZERO
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

func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.take_damage(slime_attack)

func _on_att_zone_body_entered(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_in_attack_zone = true

func _on_att_zone_body_exited(body: Node2D) -> void:
	if body.name == "CharacterBody2D":
		player_in_attack_zone = false
		
func start_attack():
	is_attacking = true
	can_attack = false
	velocity = Vector2.ZERO

	var player = $"../../CharacterBody2D"
	var dir = (player.position - position).normalized()

	if abs(dir.x) > abs(dir.y):
		animP.play("attack_right" if dir.x > 0 else "attack_left")
	else:
		animP.play("attack_down" if dir.y > 0 else "attack_up")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name.begins_with("attack"):
		is_attacking = false
		await get_tree().create_timer(0.8).timeout
		can_attack = true
		
func _ready():
	add_to_group("enemy")
	
func get_player() -> Node2D:
	var players = get_tree().get_nodes_in_group("player")
	if players.is_empty():
		return null
	return players[0]
