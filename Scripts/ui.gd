extends CanvasLayer

@onready var pointslabel := $MarginContainer/PointsLabel
@onready var liveslabel := $MarginContainer/LivesLabel
@onready var gameover : = $GameOver
@onready var restart_anim := $GameOver/VBoxContainer/RestartLabel/AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_pointslabel(points:int):
	pointslabel.text = "SCORE: " +  str(points)

func update_liveslabel(lives:int):
	liveslabel.text = "LIVES: " + str(lives)

func gameover_screen():
	gameover.visible = true
	restart_anim.play("blinking_anim")
