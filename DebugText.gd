extends CanvasLayer

@export var speed_interval = 0.5

var speed_updated = false

@onready var speedometer = $Speedometer
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Player_speed(speed):
	if speed_updated == false:
		speedometer.text = str(speed)
		speed_updated = true
		timer.start(speed_interval)

func _on_Player_dash():
	speedometer.text = "DASH"


func _on_Timer_timeout():
	speed_updated = false
