extends Node
## Autoloaded singleton that serves as a broker for global game-level signals.

## Player Signals ---------------------------------------------------------
## Emitted any time player health changes
signal player_health_changed(previous_value : float, new_value : float, max_health : float)

## Signal emitted when the primary player dies
signal player_death

## Emitted when score changes
signal score_changed(previous_value : int, new_value : int)

## Emitted when player level ups
signal player_level_up(previous_level : int, new_level : int)

## Emitted when player experience changes
signal player_experience_changed(previous_value : int, new_value : int, experience_to_next_level : int)


## Enemy Signals -------------------------------------------------------

## Emitted any time a proc asteroid is spawned
signal asteroid_proc_spawned

## Emitted any time a proc asteroid is killed (or splits)
signal asteroid_proc_killed


## Modifier System Signals --------------------------------------------

## Emitted any time a new modifier should be applied to the player (typically level up selection)
signal apply_levelup_modifier(modifier : ModifierBase)


## User Interface Signals ---------------------------------------------

## Emitted when the player has finished selecting a modifier from the level up screen
signal level_up_selection_complete
