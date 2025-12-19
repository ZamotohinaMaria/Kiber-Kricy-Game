extends CharacterBody2D

@export var hud: Node
@onready var step_player: AudioStreamPlayer2D = $StepPlayer

# ---------- БАЗОВЫЕ СТАТЫ ----------
@export var speed: float = 200.0
@export var attack: int = 20
@export var max_health: int = 200

var current_health: int
var artefact_count: int

var last_dir = Vector2.DOWN
var is_attacking = false
var _was_moving : bool = false

var current_interactable: Node = null
var inventory: Array[ItemData] = []
var can_move: bool = true
# ---------- БАФЫ ----------
var bonus_speed: float = 0.0
var bonus_attack: int = 0
var bonus_max_health: int = 0


# ---------- ИТОГОВЫЕ СТАТЫ ----------

func get_speed() -> float:
	return speed + bonus_speed

func get_attack() -> int:
	return attack + bonus_attack

func get_max_health() -> int:
	return max_health + bonus_max_health
	
	
func get_input():
	if is_attacking:
		velocity = Vector2.ZERO
		return

	var input_dir = Input.get_vector("ui_left", 'ui_right', 'ui_up', 'ui_down')
	
	velocity = input_dir * get_speed()
	
	if input_dir != Vector2.ZERO:
		last_dir = input_dir

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

func attack_func():
	is_attacking = true

	if abs(last_dir.x) > abs(last_dir.y):
		if last_dir.x > 0:
			$Animation.play("lvl1_sword_right")
		else:
			$Animation.play("lvl1_sword_left")
	else:
		if last_dir.y > 0:
			$Animation.play("lvl1_sword_down")
		else:
			$Animation.play("lvl1_sword_u")

func _physics_process(delta):
	if can_move:
		get_input()
	else:
		velocity = Vector2.ZERO
		$Animation.play("idle1")   # стоим на месте, когда открыт шкаф
		
	move_and_collide(velocity * delta)
	var moving_now := velocity.length() > 0.1

	# только что начали двигаться
	if moving_now and not _was_moving:
		if step_player and not step_player.playing:
			step_player.play()

	# только что остановились
	if not moving_now and _was_moving:
		if step_player and step_player.playing:
			step_player.stop()

	_was_moving = moving_now


func _ready() -> void:
	add_to_group("player")
	current_health = max_health

func _on_animation_animation_finished() -> void:
	if $Animation.animation.begins_with("lvl1_sword"):
		is_attacking = false
		
func set_can_move(value: bool) -> void:
	can_move = value
# ---------- ПЕРЕСЧЁТ БАФОВ ----------

func recalculate_bonuses() -> void:
	# сбрасываем бафы
	bonus_speed = 0.0
	bonus_attack = 0
	bonus_max_health = 0

	# собираем бафы с предметов
	for it in inventory:
		bonus_speed += it.bonus_speed
		bonus_attack += it.bonus_attack
		bonus_max_health += it.bonus_max_health

	# обновляем здоровье, если вырос максимум
	var new_max_health = get_max_health()
	if current_health > new_max_health:
		current_health = new_max_health

# ---------- ИНВЕНТАРЬ ----------

   # простой инвентарь игрока

func set_current_interactable(node: Node) -> void:
	current_interactable = node

func clear_current_interactable(node: Node) -> void:
	if current_interactable == node:
		current_interactable = null

func add_item(item: ItemData) -> void:
	inventory.append(item)
	recalculate_bonuses()
	if item.artefact != 0:
		artefact_count += 1
		if hud and hud.has_method("update_artefacts"):
			hud.update_artefacts(artefact_count)
	if item.key != 0:
		if hud and hud.has_method("update_keys"):
			hud.update_keys(item)
	print("Взяли предмет:", item.name)
	print("Инвентарь сейчас:", get_inventory_names())
	print("Атака:", get_attack(), 
		  "Макс. HP:", get_max_health(), 
		  "Скорость:", get_speed(), 
		  "Артефактов:", artefact_count)

func get_inventory_names() -> Array[String]:
	var names: Array[String] = []
	for it in inventory:
		names.append(it.name)
	return names

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("interract") and current_interactable:
		current_interactable.interact(self)
	if event.is_action_pressed("mouse_left") and not is_attacking:
		attack_func()

func has_key(key_id: int) -> bool:
	for item in inventory:
		if item.key == key_id:
			return true
	return false

func has_artefact_count(required_artefact_count: int) -> bool:
	if artefact_count == required_artefact_count:
			return true
	return false
