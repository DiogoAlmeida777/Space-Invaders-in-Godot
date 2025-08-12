extends Node2D
class_name SpaceShipSpawner

signal spawn_spaceship(spaceship)
signal spaceship_destroyed(points)

@export var spaceship : PackedScene
@export var spaceship_y_pos : int = 60
@onready var spawncooldown := $SpawnCooldown 

var current_spaceship: SpaceShip 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spawncooldown.wait_time = randf_range(5,50)
	spawncooldown.start()

func _process(delta: float) -> void:
	if current_spaceship == null and spawncooldown.is_stopped(): 
		spawn_space_ship()


func spawn_space_ship():
	var spawned_spaceship = spaceship.instantiate()
	if randi()%2 == 0:
		spawned_spaceship.set("direction",Vector2.RIGHT)
		spawned_spaceship.global_position = Vector2(get_viewport_rect().position.x,spaceship_y_pos)
	else:
		spawned_spaceship.set("direction",Vector2.LEFT)
		spawned_spaceship.global_position = Vector2(get_viewport_rect().end.x,spaceship_y_pos)
	current_spaceship = spawned_spaceship
	current_spaceship.start_cooldown.connect(start_spawn_cooldown)
	current_spaceship.destroyed.connect(on_spaceship_destroyed)
	emit_signal("spawn_spaceship",spawned_spaceship)

func on_spaceship_destroyed(points : int):
	emit_signal("spaceship_destroyed",points)

func start_spawn_cooldown():
	spawncooldown.start()
	

func _on_spawn_cooldown_timeout() -> void:
	spawncooldown.wait_time = randf_range(5,50)
