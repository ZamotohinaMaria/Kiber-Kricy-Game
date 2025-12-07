extends Node2D
func _process(delta):
	z_index = int(global_position.y)
	
func _ready():
	# Фиксированный z_index, чтобы быть поверх стола
	z_index = 0  # или другое положительное значение
