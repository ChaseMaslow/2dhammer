extends Node2D

@onready var LV = $LinearVector
@onready var AV = $AddVector

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_Player_vector(pos, velocity, addvelocity):
	LV.set_point_position(0, pos)
	LV.set_point_position(1, pos + velocity)
	AV.set_point_position(0, pos)
	AV.set_point_position(1, pos + addvelocity)
