extends Interactable

@export var required_key_id: int = 1      # номер ключа, который открывает дверь
@export var keyhole_texture: Texture2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var solid_shape: CollisionShape2D = $StaticBody2D/CollisionShape2D
@onready var label: Label = $Label
@onready var keyhole_sprite: Sprite2D = $KeyholeSprite
@onready var open_sound: AudioStreamPlayer2D = $OpenSound

var is_open: bool = false

func _ready() -> void:
	# сначала запускаем базовый Interactable (подписка на body_entered/body_exited)
	super._ready()

	is_open = false
	if solid_shape:
		solid_shape.disabled = false
	label.text = "E - открыть"
	if keyhole_sprite and keyhole_texture:
		keyhole_sprite.texture = keyhole_texture
	# ставим закрытую анимацию
	if anim and anim.sprite_frames.has_animation("closed"):
		anim.play("closed")

func interact(player: Node) -> void:
	if is_open:
		return

	if not player.has_method("has_key"):
		return

	if player.has_key(required_key_id):
		_open(player)
	else:
		label.text = "Дверь заперта. Нужен ключ."
		print("Дверь заперта. Нужен ключ №%d" % required_key_id)

func _open(player: Node) -> void:
	is_open = true

	# запускаем анимацию
	if anim and anim.sprite_frames and anim.sprite_frames.has_animation("open"):
		anim.play("open")
	
	if open_sound:
		open_sound.play()
	# сразу убираем коллизию двери
	solid_shape.disabled = true
	keyhole_sprite.hide()
	
