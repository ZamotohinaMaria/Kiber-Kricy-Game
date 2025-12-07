extends Node2D
func _ready():
	# Находим TileMap
	var tilemap = $vase
	
	# Устанавливаем z_index для всего TileMap
	tilemap.z_index = 1  # Выше стола
