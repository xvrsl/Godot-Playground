extends Node

@export var valueDisplay := 0.0

var stat:Stat

func _ready():
	stat = Stat.new()
	stat.baseValue 

func _process(delta:float)->void:
	valueDisplay = stat.Value
	if Input.is_action_just_pressed("ui_accept"):
		var mod = Stat.StatModifier.new()
		mod.value = 1
		stat.add_modifier(mod)
	if Input.is_action_just_pressed("ui_cancel"):
		var mod = Stat.StatModifier.new()
		mod.type = Stat.StatModifierType.PercentAdd
		mod.value = 0.1
		stat.add_modifier(mod)
