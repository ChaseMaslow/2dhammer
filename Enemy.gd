extends Damageable


@export var gravity_resist = 10
@export var base_speed = 3
@export var target : Node = null

var in_control = true

var TILT_VELOCITY = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _integrate_forces(state):
	on_integrate_forces(state)
	var add_velocity = Vector2.ZERO
	var add_angular_velocity = 0
	if in_control == true:
		add_velocity = (Vector2.ZERO - linear_velocity).normalized()
		if target != null:
			add_velocity = (target.position - position).normalized()
		add_velocity = add_velocity.normalized() * base_speed
		add_velocity.y -= gravity_resist
		
		var tilt = get_angle_to(to_global(add_velocity)) + PI/2
		add_angular_velocity = angle_difference(rotation, tilt) * TILT_VELOCITY
		add_velocity.x = 0
		add_velocity = add_velocity.rotated(rotation)
	
	linear_velocity += add_velocity
	angular_velocity += add_angular_velocity

func _on_body_entered(body):
	on_body_entered(body)
	if dead:
		in_control = false
		$AnimatedSprite2D.set_speed_scale(0)
