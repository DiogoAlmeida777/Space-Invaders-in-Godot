extends Area2D
class_name BunkerPart

@export var config : Bunker_config
var damage_sprites : Array[Texture2D]
@onready var sprite := $Sprite2D
const MAX_STRENGHT := 4
var strenght : int


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	damage_sprites = config.sprites
	strenght = MAX_STRENGHT
	update_sprite()
	

func update_sprite():
	sprite.texture = damage_sprites[MAX_STRENGHT - strenght]

func damage():
	strenght -=1
	if strenght > 0:
		update_sprite()
	else:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is AlienBullet or area is PlayerBullet:
		damage()
		area.queue_free()
