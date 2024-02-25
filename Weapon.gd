extends RigidBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_weapon_move(pos):
	position = pos.position


func _on_area_area_entered(area):
	if area.name == "PickupArea":
		area.get_parent().connect("weapon_move", _on_weapon_move)


func _on_area_area_exited(area):
	if area.name == "PickupArea":
		area.get_parent().disconnect("weapon_move", _on_weapon_move)
