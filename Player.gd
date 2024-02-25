extends RigidBody2D


@export var base_speed = 3
@export var max_speed = 100
@export var max_velocity = 400
@export var control_linear_damp = 4
@export var control_angular_damp = 4
@export var dash_thrust = 200
@export var gravity_resist = 8
@export var dash_duration = 0.5
@export var dash_cooldown = 2.0

#@export var control_steady = 0.15

const TILT_VELOCITY = 1.0
const TILT_ANGLE_DEGREES = 30

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var in_control = true
var equipped = false
#var pickup_available = false
var pickup_item
var dash_ready = true
var dashing = false
var mouse_delta : Vector2
var current_speed = 0

signal speed(speed)
signal dash()
signal vector(pos, velocity, addvelocity)
signal debug(info)
signal weapon_move(pos)

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_linear_damp(control_linear_damp)
	set_angular_damp(control_angular_damp)

#func _process(_delta):
#	emit_signal("debug", transform)

func _integrate_forces(_state):
	var add_velocity = Vector2.ZERO
	var add_angular_velocity = 0
	if in_control == true:
		# make linear velocity more like the requested velocity
#		var requested_velocity = (mouse_delta * base_speed)
#		var add_velocity = (requested_velocity - get_linear_velocity()).limit_length(max_speed)
		add_velocity = (mouse_delta * base_speed).limit_length(max_speed)
		current_speed = add_velocity.length()
		if current_speed == max_speed:
			if dash_ready == true:
				dash_ready = false
				dashing = true
				$DashTimer.start(dash_duration)
			if dashing:
				add_velocity = add_velocity.normalized() * dash_thrust
		if dashing:
			emit_signal("dash")
		else:
			emit_signal("speed", current_speed)
#		if linear_velocity.dot(add_velocity) <= 0 or current_speed == 0:
#			linear_velocity *= (1 - control_steady)
		add_velocity.y -= gravity_resist
		
		#var tilt_degrees = (add_velocity.x / max_speed) * TILT_ANGLE_DEGREES
		var tilt = get_angle_to(to_global(add_velocity)) + PI/2
		add_angular_velocity = angle_difference(rotation, tilt) * TILT_VELOCITY
		
	var jet_vector = Vector2()
	jet_vector.x = (transform.x*add_velocity).x + (transform.x*add_velocity).y
	jet_vector.y = (transform.y*add_velocity).x + (transform.y*add_velocity).y
	
	emit_signal("vector", position, linear_velocity, jet_vector)
	
	linear_velocity += add_velocity
	angular_velocity += add_angular_velocity
	
	#emit_signal("debug", str(jet_vector.x) + "\n" + str(jet_vector.y))
		
	#control jet effects
	var t = Transform2D()
	if jet_vector.y > 0:
		t.x *= 0
		t.y *= 0
	else:
		t.x *= -jet_vector.y * 0.0025
		t.y *= -jet_vector.y * 0.0025
	t.origin = $MainJet.transform.origin
	$MainJet.transform = t
	
	t = Transform2D()
	if jet_vector.y < 0:
		t.x *= 0
		t.y *= 0
	else:
		t.x *= jet_vector.y * 0.001
		t.y *= -jet_vector.y * 0.001
	t.origin = $TopLeftJet.transform.origin
	$TopLeftJet.transform = t
	t.origin = $TopRightJet.transform.origin
	$TopRightJet.transform = t
	
	t = Transform2D()
	if jet_vector.x < 0 and add_angular_velocity > 0:
		t.x.x = cos(PI/2) * add_angular_velocity * 0.01
		t.x.y = sin(PI/2) * add_angular_velocity * 0.01
		t.y.x = -sin(PI/2) * add_angular_velocity * 0.01
		t.y.y = cos(PI/2) * add_angular_velocity * 0.01
	elif jet_vector.x < 0:
		t.x *= 0
		t.y *= 0
	else:
		t.x.x = cos(PI/2) * (jet_vector.x * 0.001 + add_angular_velocity * 0.01)
		t.x.y = sin(PI/2) * (jet_vector.x * 0.001 + add_angular_velocity * 0.01)
		t.y.x = -sin(PI/2) * (jet_vector.x * 0.001 + add_angular_velocity * 0.01)
		t.y.y = cos(PI/2) * (jet_vector.x * 0.001 + add_angular_velocity * 0.01)
	t.origin = $UpperLeftJet.transform.origin
	$UpperLeftJet.transform = t
	
	t = Transform2D()
	if jet_vector.x < 0 and add_angular_velocity < 0:
		t.x.x = cos(PI/2) * -add_angular_velocity * 0.01
		t.x.y = sin(PI/2) * -add_angular_velocity * 0.01
		t.y.x = -sin(PI/2) * -add_angular_velocity * 0.01
		t.y.y = cos(PI/2) * -add_angular_velocity * 0.01
	elif jet_vector.x < 0:
		t.x *= 0
		t.y *= 0
	else:
		t.x.x = cos(PI/2) * (jet_vector.x * 0.001 - add_angular_velocity * 0.01)
		t.x.y = sin(PI/2) * (jet_vector.x * 0.001 - add_angular_velocity * 0.01)
		t.y.x = -sin(PI/2) * (jet_vector.x * 0.001 - add_angular_velocity * 0.01)
		t.y.y = cos(PI/2) * (jet_vector.x * 0.001 - add_angular_velocity * 0.01)
	t.origin = $LowerLeftJet.transform.origin
	$LowerLeftJet.transform = t
	
	t = Transform2D()
	if jet_vector.x > 0 and add_angular_velocity < 0:
		t.x.x = cos(-PI/2) * -add_angular_velocity * 0.01
		t.x.y = sin(-PI/2) * -add_angular_velocity * 0.01
		t.y.x = -sin(-PI/2) * -add_angular_velocity * 0.01
		t.y.y = cos(-PI/2) * -add_angular_velocity * 0.01
	elif jet_vector.x > 0:
		t.x *= 0
		t.y *= 0
	else:
		t.x.x = cos(-PI/2) * (-jet_vector.x * 0.001 - add_angular_velocity * 0.01)
		t.x.y = sin(-PI/2) * (-jet_vector.x * 0.001 - add_angular_velocity * 0.01)
		t.y.x = -sin(-PI/2) * (-jet_vector.x * 0.001 - add_angular_velocity * 0.01)
		t.y.y = cos(-PI/2) * (-jet_vector.x * 0.001 - add_angular_velocity * 0.01)
	t.origin = $UpperRightJet.transform.origin
	$UpperRightJet.transform = t
	
	t = Transform2D()
	if jet_vector.x > 0 and add_angular_velocity > 0:
		t.x.x = cos(-PI/2) * add_angular_velocity * 0.01
		t.x.y = sin(-PI/2) * add_angular_velocity * 0.01
		t.y.x = -sin(-PI/2) * add_angular_velocity * 0.01
		t.y.y = cos(-PI/2) * add_angular_velocity * 0.01
	elif jet_vector.x > 0:
		t.x *= 0
		t.y *= 0
	else:
		t.x.x = cos(-PI/2) * (-jet_vector.x * 0.001 + add_angular_velocity * 0.01)
		t.x.y = sin(-PI/2) * (-jet_vector.x * 0.001 + add_angular_velocity * 0.01)
		t.y.x = -sin(-PI/2) * (-jet_vector.x * 0.001 + add_angular_velocity * 0.01)
		t.y.y = cos(-PI/2) * (-jet_vector.x * 0.001 + add_angular_velocity * 0.01)
	t.origin = $LowerRightJet.transform.origin
	$LowerRightJet.transform = t
	
	mouse_delta = Vector2()
	
	if pickup_item != null and equipped == false:
				var newjoint = load("res://WeaponJoint.tscn").instantiate()
				emit_signal("weapon_move", self)
				newjoint.node_a = NodePath("..")
				newjoint.node_b = NodePath("../../" + pickup_item.name)
				add_child(newjoint)
				equipped = true

func _input(event):
	if event is InputEventMouseMotion:
		mouse_delta = event.relative
	
	if event.is_action_pressed("freefall"):
		if in_control == true:
			in_control = false
			set_linear_damp(0)
			set_angular_damp(0)
		else:
			in_control = true
			set_linear_damp(control_linear_damp)
			set_angular_damp(control_angular_damp)
	
	if event.is_action_pressed("drop"):
		if in_control and equipped:
			$WeaponJoint.queue_free()
			equipped = false
			pickup_item = null
	
	if event.is_action_pressed("pickup"):
		if in_control and not equipped and $PickupArea.has_overlapping_bodies():
			for item in $PickupArea.get_overlapping_bodies():
				if item.name == "Hammer" or item.name == "Sword":
					pickup_item = item
					break
			
			
	if event.is_action_pressed("exit"):
		get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)
		get_tree().quit()


func _on_DashTimer_timeout():
	if dashing == true:
		dashing = false
		$DashTimer.start(dash_cooldown)
	else:
		dash_ready = true
