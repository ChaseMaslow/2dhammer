class_name Weapon extends RigidBody2D

@export var sharp = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_weapon_move(pos):
	position = pos.position

func _on_weapon_flip():
	for x in get_children():
		x.transform.x *= -1

func _on_area_area_entered(area):
	if area.name == "PickupArea":
		area.get_parent().connect("weapon_move", _on_weapon_move)
		area.get_parent().connect("weapon_flip", _on_weapon_flip)


func _on_area_area_exited(area):
	if area.name == "PickupArea":
		area.get_parent().disconnect("weapon_move", _on_weapon_move)
		area.get_parent().disconnect("weapon_flip", _on_weapon_flip)
