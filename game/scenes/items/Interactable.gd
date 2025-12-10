extends Area2D
class_name Interactable

@export var prompt_text: String = "E - обыскать"

@onready var prompt_label: Label = $Label

func _ready() -> void:
	if prompt_label:
		prompt_label.text = prompt_text
		prompt_label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if prompt_label:
			prompt_label.visible = true
		if body.has_method("set_current_interactable"):
			body.set_current_interactable(self)

func _on_body_exited(body: Node) -> void:
	if body.is_in_group("player"):
		if prompt_label:
			prompt_label.visible = false
		if body.has_method("clear_current_interactable"):
			body.clear_current_interactable(self)

func interact(player: Node) -> void:
	# переопределяется в дочерних скриптах
	pass
