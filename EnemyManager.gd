extends Node2D

@export var enemy : Resource = null
@export var player : Node2D = null

@onready var path = $SpawnPath
@onready var timer = $Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func spawn():
	var en = enemy.instantiate()
	var loc = $SpawnPath/SpawnLocation
	loc.progress_ratio = randf()
	en.position = loc.position
	en.target = player
	add_child(en)


func _on_timer_timeout():
	spawn()
