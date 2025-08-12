class_name AlienBullet
extends Area2D


@export var speed := 200
var direction := Vector2.DOWN

@onready var animPlayer := $AnimationPlayer
@onready var sprite := $Sprite2D
var configs : Array[Alien_bullet_config] = [preload("res://Resources/bullet_types/alien_bullet_1.tres"),
											preload("res://Resources/bullet_types/alien_bullet_2.tres")]


func _ready() -> void:
	var i = randi()%2
	sprite.texture = configs[i].sprite
	animPlayer.play(configs[i].animation)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += speed*direction*delta



func _on_area_exited(area: Area2D) -> void:
	if area.name == "GameArea":
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		body.kill()
		queue_free()
