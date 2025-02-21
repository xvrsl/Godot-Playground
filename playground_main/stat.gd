class Stat:
	var baseValue:float
	var modifiers:Array[StatModifier]
	var Value:
		get:
			if _dirty:
				CalculateValue()
			return _cachedValue
	var _cachedValue:float
	
	var _dirty:bool
	func CalculateValue():
		_dirty = false
		
class StatModifier:
	var value:float
	var modifierType:StatModifierType

enum StatModifierType
{
	Add,
	PercentAdd,
	Multiply
}
