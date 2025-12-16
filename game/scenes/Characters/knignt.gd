extends CharacterBody2D

# ---------- БАЗОВЫЕ СТАТЫ ----------
@export var speed: float = 200.0
@export var attack: int = 10
@export var max_health: int = 100

var current_health: int

var last_dir = Vector2.DOWN
var is_attacking = false
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
	
	velocity = input_dir * speed
	
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
	get_input()
	move_and_collide(velocity * delta)
	#z_index = int(global_position.y)


func _ready() -> void:
	add_to_group("player")
	current_health = max_health

func _on_animation_animation_finished() -> void:
	if $Animation.animation.begins_with("lvl1_sword"):
		is_attacking = false
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

var current_interactable: Node = null
var inventory: Array[ItemData] = []   # простой инвентарь игрока

func set_current_interactable(node: Node) -> void:
	current_interactable = node

func clear_current_interactable(node: Node) -> void:
	if current_interactable == node:
		current_interactable = null

func add_item(item: ItemData) -> void:
	inventory.append(item)
	recalculate_bonuses()
	print("Взяли предмет:", item.name)
	print("Инвентарь сейчас:", get_inventory_names())
	print("Атака:", get_attack(), 
		  "Макс. HP:", get_max_health(), 
		  "Скорость:", get_speed())

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
		
