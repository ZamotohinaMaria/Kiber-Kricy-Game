extends Node2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var hp_bar = $"CanvasLayer/PlayerHUD/hp-bar"
@onready var speed_bar = $"CanvasLayer/PlayerHUD/speed-bar"
@onready var power_bar = $"CanvasLayer/PlayerHUD/power-bar"



func _process(delta: float) -> void:
	if player:
		hp_bar.max_value = 400
		hp_bar.value = player.current_health
		
		speed_bar.max_value = 400
		speed_bar.value = player.get_speed()
		
		power_bar.max_value = 40
		power_bar.value = player.get_attack()
