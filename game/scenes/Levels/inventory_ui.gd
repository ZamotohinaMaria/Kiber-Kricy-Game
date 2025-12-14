extends Control

var current_cabinet: Node = null
var player: Node = null

@onready var items_label: Label = $TextureRect/MarginContainer/VBoxContainer/ItemsLabel
@onready var slots_grid: GridContainer = $TextureRect/MarginContainer/VBoxContainer/CenterContainer/SlotsGrid

const ITEM_SLOT_SCENE := preload("res://scenes/items/ItemSlot.tscn")

func _ready() -> void:
	visible = false
	process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	slots_grid.columns = 4

func open_cabinet(cabinet: Node, player_ref: Node) -> void:
	current_cabinet = cabinet
	player = player_ref
	visible = true
	get_tree().paused = true
	_refresh()

func _refresh() -> void:
	# чистим старые слоты
	for child in slots_grid.get_children():
		child.queue_free()

	if not current_cabinet or current_cabinet.items.is_empty():
		items_label.text = "Шкаф пуст"
		return

	items_label.text = "Содержимое шкафа:"

	for i in current_cabinet.items.size():
		var item: ItemData = current_cabinet.items[i]

		var slot: TextureButton = ITEM_SLOT_SCENE.instantiate()
		slot.texture_normal = item.icon
		slot.tooltip_text = item.name         # имя по наведению
		slot.pressed.connect(_on_slot_pressed.bind(i))
		slots_grid.add_child(slot)

func _on_slot_pressed(index: int) -> void:
	if not current_cabinet or not player:
		return
	if index < 0 or index >= current_cabinet.items.size():
		return

	var item: ItemData = current_cabinet.items[index]
	player.add_item(item)                    # ты можешь хранить сам ресурс или только его name
	current_cabinet.items.remove_at(index)
	_refresh()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel"):
		_close()

func _close() -> void:
	get_tree().paused = false
	visible = false
	current_cabinet = null
	player = null


#func _ready() -> void:
	#visible = false
	#process_mode = Node.PROCESS_MODE_WHEN_PAUSED  # вместо pause_mode    # UI работает во время паузы
	#slots_grid.columns = 4                  # сколько столбцов в сетке (можешь поменять)
#
#func open_cabinet(cabinet: Node, player_ref: Node) -> void:
	#current_cabinet = cabinet
	#player = player_ref
	#visible = true
	#get_tree().paused = true
	#_refresh()
#
#func _refresh() -> void:
	## очищаем старые слоты
	#for child in slots_grid.get_children():
		#child.queue_free()
#
	#if not current_cabinet or current_cabinet.items.is_empty():
		#items_label.text = "Шкаф пуст"
		#return
#
	#items_label.text = "Содержимое шкафа:"
#
	#for i in current_cabinet.items.size():
		#var item_name: String = current_cabinet.items[i]
#
		#var btn := Button.new()
		#btn.text = item_name
		#btn.custom_minimum_size = Vector2(40,60)  # размер слота, поиграйся числами
		#btn.focus_mode = Control.FOCUS_NONE
#
		## при нажатии вызываем _on_slot_pressed с индексом предмета
		#btn.pressed.connect(_on_slot_pressed.bind(i))
#
		#slots_grid.add_child(btn)
#
#func _on_slot_pressed(index: int) -> void:
	#if not current_cabinet or not player:
		#return
	#if index < 0 or index >= current_cabinet.items.size():
		#return
#
	#var item = current_cabinet.items[index]
	#player.add_item(item)                     # кладём предмет в инвентарь игрока
	#current_cabinet.items.remove_at(index)    # выкидываем из шкафа
#
	#if current_cabinet.items.is_empty():
		#_close()
	#else:
		#_refresh()    # перерисовать сетку без этого предмета
#
#func _unhandled_input(event: InputEvent) -> void:
	#if not visible:
		#return
	## закрывать окно по E или Esc
	#if event.is_action_pressed("interact") or event.is_action_pressed("ui_cancel"):
		#_close()
#
#func _close() -> void:
	#get_tree().paused = false
	#visible = false
	#current_cabinet = null
	#player = null
