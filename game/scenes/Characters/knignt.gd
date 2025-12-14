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
	#z_index = int(global_position.y)

# ---------- ИНВЕНТАРЬ ----------

var current_interactable: Node = null
var inventory: Array[ItemData] = []   # простой инвентарь игрока

func _ready() -> void:
	add_to_group("player")

func set_current_interactable(node: Node) -> void:
	current_interactable = node

func clear_current_interactable(node: Node) -> void:
	if current_interactable == node:
		current_interactable = null

func add_item(item: ItemData) -> void:
	inventory.append(item)
	print("Взяли предмет:", item.name)
	print("Инвентарь сейчас:", get_inventory_names())

func get_inventory_names() -> Array[String]:
	var names: Array[String] = []
	for it in inventory:
		names.append(it.name)
	return names

func _unhandled_input(event: InputEvent) -> void:
	# тут была опечатка "interract"
	if event.is_action_pressed("interract") and current_interactable:
		current_interactable.interact(self)
