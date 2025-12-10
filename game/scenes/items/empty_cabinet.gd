extends Interactable

@export var items: Array[String] = ["ключ", "аптечка"]

func interact(player: Node) -> void:
	var ui := get_tree().current_scene.get_node("CanvasLayer/InventoryUI")
	ui.open_cabinet(self, player)
