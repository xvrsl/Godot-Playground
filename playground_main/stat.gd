

class_name Stat

enum StatModifierType
{
	Add = 0,
	PercentAdd= 1000,
	Multiply = 2000
}

var baseValue:float
var _modifiers:Array[StatModifier]
var Value:
	get:
		if Dirty:
			_calculate_value()
		return _cachedValue
var _cachedValue:float

var _needResort:bool
var _dirty:bool
var Dirty:
	get:
		if _dirty: 
			return true
		if _needResort:
			return true
		return false

func _calculate_value():
	if _needResort:
		_resort()
	var result := baseValue
	var percentAdding := false
	var percentAddPriority := 0
	var percentAddBuffer := 0.0
	var applyPercentAddingFunc = func ():
		result *= 1+percentAddBuffer
		percentAdding = false
		percentAddBuffer = 0
		percentAddPriority = 0
		
	for modifier in _modifiers:
		if percentAdding && (
			modifier.type != StatModifierType.PercentAdd 
			|| percentAddPriority != modifier.Priority
		): #apply buffer
			applyPercentAddingFunc.call()
		
		match modifier.type:
			StatModifierType.Add:
				result += modifier.value
			StatModifierType.PercentAdd:
				percentAdding = true
				percentAddPriority = modifier.Priority
				percentAddBuffer += modifier.value
			StatModifierType.Multiply:
				result *= modifier.value
	if percentAdding:
		applyPercentAddingFunc.call()
		
	_dirty = false
	
	
func _resort():
	_modifiers.sort_custom(StatModifier.compare)
	_needResort = false
	
func add_modifier(modifier:StatModifier):
	_modifiers.append(modifier)
	_needResort = true
	_dirty = true
		
class StatModifier:
	var value:float
	var type:StatModifierType
	var overridePriority :bool
	var overridePriorityValue := 0
	var Priority:
		get:
			if overridePriority:
				return overridePriorityValue
			return int(type)
	static func compare(a:StatModifier,b:StatModifier):
			return a.Priority < b.Priority
