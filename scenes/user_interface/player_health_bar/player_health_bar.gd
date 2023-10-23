extends ProgressBar

## The HealthBase node this ProgressBar will display health for
@export var player_health : HealthBase

# Called when the node enters the scene tree for the first time.
func _ready():
	#max_value = player_health.max_health
	#value = player_health.health
	SignalBroker.player_health_changed.connect(_on_player_health_changed)
	

func _on_player_health_changed(_prev_health : float, new_health : float, max_health : float):
	max_value = max_health
	value = new_health
