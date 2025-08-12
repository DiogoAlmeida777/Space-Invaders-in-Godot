extends Node2D

@onready var player := $Player
@onready var alienmanager := $AlienManager
@onready var spaceshipspawner := $SpaceShipSpawner
@onready var pointcounter := $PointCounter
@onready var UI := $UI
var game_is_over : bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_is_over = false
	alienmanager.alien_bullet.connect(spawn_alien_bullet)
	alienmanager.alien_died.connect(update_point_counter)
	alienmanager.all_aliens_dead.connect(increase_player_lives)
	player.player_shot.connect(spawn_player_bullet)
	player.player_killed.connect(on_player_killed)
	player.no_lives.connect(gameover)
	spaceshipspawner.spawn_spaceship.connect(add_spaceship)
	spaceshipspawner.spaceship_destroyed.connect(update_point_counter)
	UI.update_pointslabel(pointcounter.points)
	UI.update_liveslabel(player.lives)

func increase_player_lives():
	player.add_lives()
	UI.update_liveslabel(player.lives)

func on_player_killed(lives : int):
	UI.update_liveslabel(lives)
	remove_bullets()

func remove_bullets():
	for c in get_children():
		if c is AlienBullet:
			c.queue_free()

func spawn_alien_bullet(bullet):
	add_child(bullet)

func spawn_player_bullet(bullet):
	add_child(bullet)

func add_spaceship(spaceship):
	add_child(spaceship)

func update_point_counter(points : int):
	pointcounter.add_points(points)
	UI.update_pointslabel(pointcounter.points)

func gameover():
	player.current_speed = 0
	alienmanager.queue_free()
	spaceshipspawner.queue_free()
	UI.gameover_screen()
	game_is_over = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		if game_is_over:
			get_tree().reload_current_scene()

func _on_game_over_area_area_entered(area: Area2D) -> void:
	if area is Alien:
		gameover()
