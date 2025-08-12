extends Node
class_name PointCounter

var points : int


func _ready() -> void:
	points = 0

func add_points(p : int):
	points += p

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
