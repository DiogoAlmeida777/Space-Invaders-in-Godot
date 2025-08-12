class_name PlayerBullet
extends Area2D


@export var speed := 600

var direction := Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	direction = Vector2.UP


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += speed*direction*delta



func _on_area_entered(area: Area2D) -> void:
	if area is Alien or area is SpaceShip:
		area.kill()
		queue_free()


func _on_area_exited(area: Area2D) -> void:
	if area.name == "GameArea":
		queue_free()
