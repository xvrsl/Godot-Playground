extends Node
@export var label:Label
@export var mover_1:Mover
@export var mover_2:Mover
@export var mover_3:Mover

var current_mover:Mover

func _ready() -> void:
	current_mover= mover_1

func _process(delta: float) -> void:
	label.text = current_mover.name
	if(Input.is_key_pressed(KEY_1)):
		current_mover = mover_1
	if(Input.is_key_pressed(KEY_2)):
		current_mover = mover_2
	if(Input.is_key_pressed(KEY_3)):
		current_mover = mover_3
	current_mover.move(delta)
