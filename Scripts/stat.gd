class_name Stat

var _base_value : float
var _modifiers : Array[Modifier]

var __dirty:bool
var __require_resort:bool
var __cached_base_value:float
var __cached_value:float

var value: float:
	get:
		if __require_resort:
			resort()
			recalculate()
		if __dirty || __cached_base_value!=_base_value:
			recalculate()
		return __cached_value

func resort():
	_modifiers.sort_custom(Modifier.compare)
	__require_resort = false

func recalculate():
	__cached_base_value = _base_value
	var data := {
		result = _base_value,
		p_adding = false,
		buffer_value = 0.0,
		buffer_priority = 0
	}
	
	var apply_func:=func():
		data.result *= 1.0 + data.buffer_value
		data.p_adding = false
		data.buffer_value = 0
		
	for modifier in _modifiers:
		if data.p_adding && (
			modifier.modifier_type != ModifierType.P_ADD
			|| modifier.priority != data.buffer_priority
		):
			apply_func.call()
		match modifier.modifier_type:
			ModifierType.ADD:
				data.result += modifier.value
			ModifierType.P_ADD:
				data.p_adding = true
				data.buffer_priority = modifier.priority
				data.buffer_value += modifier.value
			ModifierType.P_MULTIPLY:
				data.result *= 1+modifier.value
	
	if data.p_adding:
		apply_func.call()
		
	__cached_value = data.result
	__dirty = false

func add_modifier(modifier:Modifier):
	_modifiers.append(modifier)
	__require_resort = true

func create_and_add_modifier(modifier_type:ModifierType,value:float,source:Object=null,priority:int=0)->Modifier:
	var modifier = Modifier.new(modifier_type,value,source,priority)
	add_modifier(modifier)
	return modifier

func remove_modifier(modifier:Modifier):
	_modifiers.erase(modifier)
	__dirty=true

func remove_modifiers_from_source(source:Object):
	var filtered = _modifiers.filter(func(e:Modifier): e.source!=source)
	_modifiers.clear()
	_modifiers.append_array(filtered)
	__dirty= true

enum ModifierType
{
	ADD=0,
	P_ADD=1000,
	P_MULTIPLY = 2000
}

class Modifier:
	var modifier_type: ModifierType
	var value: float
	var override_priority:int
	var priority:int:
		get:
			if override_priority!=0:
				return override_priority
			return modifier_type
	var source:Object
	
	static func compare(a:Modifier,b:Modifier)->bool:
		return a.priority<b.priority				
	
	func _init(modifier_type:ModifierType, value:float,source:Object=null,priority:int=0):
		self.modifier_type = modifier_type
		self.value = value
		self.override_priority = priority
		self.source = source
		
