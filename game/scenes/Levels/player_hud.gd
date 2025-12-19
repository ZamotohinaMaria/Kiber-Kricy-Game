extends Control   # или CanvasLayer, смотри что у тебя

# слоты с ключами
@onready var key_slots: Array[TextureRect] = [
	$key1,
	$key2,
	$key3,
	$key4,
]

@onready var artefact_label: Label = $artefacts

# картинка пустого слота (рамка без ключа)
@export var empty_slot_texture: Texture2D

func update_keys(item: ItemData) -> void:
	var slot := key_slots[item.key-1]
	slot.texture = item.icon

func update_artefacts(artefact_count: int) -> void:
	artefact_label.text = ("Артефактов: %d/4" % artefact_count)
