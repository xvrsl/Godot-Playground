extends Node2D
class_name Mover
@export var speed :float = 10.0
func move(delta: float)->void:
	var vec = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var m = vec * delta * speed
	position += m
