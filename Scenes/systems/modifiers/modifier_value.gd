class_name ModifierValue
extends RefCounted
## Simple data type class that stores Modifier data
## Formula = (original_value + <flat_mod_value>) * <1.0 + increased_mod_value> * <1.0 + more_mod_value>
## Increased modifiers stack additively: (100% + 10% +10%) = 120%)
## More modifiers stack multiplicatively: (100% + 10% * 10%) = 121%)
## In general, stacking 'more' modifiers results in higher final values.

## Emitted any time this modifier value changes
signal modifier_changed

## A flat addition modifier. This value is added directly to the value modified
var flat_mod_value : float = 0

## A percentage increase modifier. All sources of 'increased' modifier are stacked additively.
## (Two 10% increase modifiers would result in: (100% + 10% +10%) = 120%)
var increased_mod_value : float = 1.0


## A multiplicative increase modifier. All sources of 'more' modifier are stacked multiplicatively.
## (Two 10% more modifiers would result in: (100% + 10% * 10%) = 121%)
var more_mod_value : float = 1.0


## Accepts a value and applies this Modifier values to it. Returns the resulting value.
func get_modified_value(original_value : float) -> float:
	return (original_value + flat_mod_value) * clamp(increased_mod_value, 0, INF) * clamp(more_mod_value, 0, INF)


## Adds a value to this Modifier's flat_mod_value
func add_flat_mod_value(value):
	flat_mod_value += value
	modifier_changed.emit()


## Subtracts a value from this Modifier's flat_mod_value
func subtract_flat_mod_value(value):
	flat_mod_value -= value
	modifier_changed.emit()


## Adds a value to this Modifiers increased_mod_value
func add_increased_mod_value(value):
	increased_mod_value += value
	modifier_changed.emit()


## Subtracts a value from this Modifiers increased_mod_value
func subtract_increased_mod_value(value):
	increased_mod_value -= value
	modifier_changed.emit()


## Adds a value to this Modifiers more_mod_value (stacks multiplicatively)
func add_more_mod_value(value):
	more_mod_value *= (1.0 + value)
	modifier_changed.emit()


## Subtracts a value from this Modifiers more_mod_value (stacks multiplicatively)
func subtract_more_mod_value(value):
	more_mod_value /= (1.0 + value)
	modifier_changed.emit()
