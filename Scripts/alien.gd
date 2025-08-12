class_name Alien
extends Area2D

signal turnLeft
signal turnRight
signal shot(bulletInstance)
signal died(points)

@onready var sprite := $Sprite2D
@onready var collision := $CollisionShape2D
@onready var animPlayer := $AnimationPlayer
@onready var move_cooldown := $MovingCooldown
@onready var deathsound := $deathsound
@onready var movesound := $movesound

var points : int
var can_shoot : bool
var direction := 0
var alive: bool
var horizontal_jump : int= 20 #value of the jump alien does each time it moves horizontally
var vertical_jump : int= 20
var initial_x : int
@export var time_decrease : float = 0.05
@export var config : Aliens_config
@export var alien_bullet : PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.texture = config.sprite
	collision.shape = config.shape
	points = config.points
	can_shoot = config.can_shoot
	animPlayer.play(config.animation)
	direction = 1
	collision.disabled = false
	alive = true
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if move_cooldown.is_stopped():
		move()
		move_cooldown.start()
	if can_shoot and alive == true:
		if randi()%1000 == 0:
			shoot()

func move():
	position.x += horizontal_jump*direction
	movesound.play()

func down():
	position.y += vertical_jump 
	if move_cooldown.wait_time - time_decrease > 0:
		move_cooldown.wait_time -= time_decrease
		animPlayer.speed_scale += time_decrease

func left():
	if direction == 1:
		direction = -1
		down()

func right():
	if direction == -1:
		direction = 1
		down()

func shoot():
	var bullet = alien_bullet.instantiate()
	bullet.global_position = self.global_position
	emit_signal("shot",bullet)

func kill():
	emit_signal("died",points)
	deathsound.play()
	animPlayer.play("death_animation")

func relive():
	sprite.visible = true
	collision.disabled = false
	alive = true
	position.x = initial_x
	animPlayer.play(config.animation)


func _on_area_entered(area: Area2D) -> void:
	if area.name == "LeftBound":
		emit_signal("turnRight")
	elif area.name == "RightBound":
		emit_signal("turnLeft")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "death_animation":
		sprite.visible = false
		if collision:
			collision.set_deferred("disabled",true)
		alive = false
