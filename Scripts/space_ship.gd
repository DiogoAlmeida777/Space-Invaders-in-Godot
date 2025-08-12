extends Area2D
class_name SpaceShip

signal start_cooldown
signal destroyed(points)

var points : Array[int] = [50,100,150,200,300]
var index : int
var direction : Vector2 = Vector2.ZERO : 
	set(value): 
		direction = value
@export var speed : int = 100
@onready var spaceshipscore := $SpaceShipScore
@onready var anim := $AnimationPlayer
@onready var sound := $sound
@onready var deathsound := $deathsound
func _ready() -> void:
	anim.play("idle")
	index = randi()%5
	spaceshipscore.text = str(points[index])
	sound.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	global_position += direction*speed*delta
	



func kill():
	emit_signal("destroyed",points[index])
	speed = 0
	sound.stop()
	deathsound.play()
	anim.play("death")
	

func _on_area_exited(area: Area2D) -> void:
	if area.name == "GameArea":
		queue_free()


func _on_tree_exited() -> void:
	emit_signal("start_cooldown")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death":
		queue_free()
