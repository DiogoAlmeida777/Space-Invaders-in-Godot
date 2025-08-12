class_name Player
extends CharacterBody2D

signal player_shot(bullet)
signal player_killed(lives)
signal no_lives

@export var lives : int = 3
@export var speed : int = 200
var current_speed : int
@export var bullet : PackedScene 
@onready var cooldown := $Cooldown
@onready var shooting_pos := $ShootingPosition
@onready var animated_sprite := $AnimatedSprite2D
@onready var shootingsound := $shootingsound
@onready var deathsound := $deathsound
var bullet_fired : PlayerBullet 

func _ready() -> void:
	current_speed = speed
	animated_sprite.play("idle")

func _physics_process(delta: float) -> void:
	var move_direction := Vector2.ZERO
	if Input.is_action_pressed("turn_right"):
		move_direction = Vector2.RIGHT
	if Input.is_action_pressed("turn_left"):
		move_direction = Vector2.LEFT
	move_direction.normalized()
	move_and_collide(move_direction*current_speed*delta)
	if Input.is_action_pressed("shoot"):
		shoot()

func shoot():
	if bullet_fired == null:
		var bulletShot = bullet.instantiate()
		bulletShot.global_position = shooting_pos.global_position
		bullet_fired = bulletShot
		emit_signal("player_shot",bulletShot)
		shootingsound.play()
		cooldown.start()

func kill():
	lives -= 1
	current_speed = 0
	emit_signal("player_killed",lives)
	deathsound.play()
	animated_sprite.play("death")
	

func add_lives():
	lives+=1

func _on_animated_sprite_2d_animation_finished() -> void:
	if lives > 0:
		current_speed = speed
		animated_sprite.play("idle")
	else:
		emit_signal("no_lives")
		queue_free()
