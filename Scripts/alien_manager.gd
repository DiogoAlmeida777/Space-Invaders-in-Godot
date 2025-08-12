class_name AlienManager
extends Node2D

signal alien_bullet(bulletInstance)
signal alien_died(points)
signal all_aliens_dead

const rows : int = 5
const columns : int = 11
var aliens_total := rows * columns
@export var first_x : int = 400
@export var first_y : int = 100
@export var horizontal_space : int = 40
@export var vertical_space : int = 40

@export var alien_scene : PackedScene 
var alien1_config : Aliens_config = preload("res://Resources/alien_types/alien1_config.tres")
var alien2_config : Aliens_config = preload("res://Resources/alien_types/alien2_config.tres")
var alien3_config : Aliens_config = preload("res://Resources/alien_types/alien3_config.tres")

var aliens : Array[Alien] = []


func _ready() -> void:
	var config
	for r in rows:
		if r == 0:
			config = alien1_config
		elif r == 1 or r == 2:
			config = alien2_config
		else:
			config = alien3_config
		
		for c in columns:
			var x_pos = first_x + c * horizontal_space
			var y_pos = first_y + r * vertical_space
			var pos = Vector2(x_pos,y_pos)
			spawn_alien(config,pos)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if aliens.all(check_alien_is_dead):
		emit_signal("all_aliens_dead")
		for a in aliens:
			a.relive()

func check_alien_is_dead(a : Alien):
	return !a.alive


func spawn_alien(c : Aliens_config,pos : Vector2):
	var alien = alien_scene.instantiate()
	alien.config = c
	alien.global_position = pos
	alien.initial_x = pos.x
	alien.turnLeft.connect(aliens_turn_left)
	alien.turnRight.connect(aliens_turn_right)
	alien.shot.connect(alien_shot)
	alien.died.connect(on_alien_killed)
	aliens.append(alien)
	add_child(alien)

func on_alien_killed(points: int):
	emit_signal("alien_died",points)

func aliens_turn_left():
	for a in aliens:
		a.left()

func aliens_turn_right():
	for a in aliens:
		a.right()

func alien_shot(bullet):
	emit_signal("alien_bullet",bullet)
