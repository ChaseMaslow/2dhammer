extends Area2D

@export var damage = 1.0
@export var sharp = false

signal hurt(damage, sharp)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_timer_timeout():
	hurt.emit(damage, sharp)
