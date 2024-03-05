class_name Damageable extends RigidBody2D

@export var HP: float = 100
@export var mortal: bool = true
@export var SplashObj: Resource
#@export var splash_obj_path: String = "res://SplashText.tscn"

var collision_pos
var collision_force
var last_velocity = Vector2.ZERO
var sharp = false
var dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _integrate_forces(state):
	on_integrate_forces(state)

func on_integrate_forces(state):
	if (state.get_contact_count() > 0):
		collision_pos = state.get_contact_local_position(0)
		collision_force = ceilf(((state.get_linear_velocity() - last_velocity) / state.get_inverse_mass() / state.get_step()).length() / 1000)
		#collision_force = state.get_contact_impulse(0).length()
		var obj = state.get_contact_collider_object(0)
		if obj is Weapon and obj.sharp:
			var norm = state.get_contact_local_normal(0).orthogonal()
			var slice_force = ceilf((absf(state.get_contact_collider_object(0).linear_velocity.dot(norm) - last_velocity.dot(norm)) / state.get_inverse_mass() / state.get_step()) / 2800)
			if (slice_force > collision_force):
				sharp = true
			collision_force = max(collision_force, slice_force)
		else:
			sharp = false
	last_velocity = linear_velocity

func _on_body_entered(body):
	on_body_entered(body)

func on_body_entered(body):
	#collision_pos = to_global(collision_pos)
	#collision_pos.x -= 100
	if (collision_force < 20) or dead:
		pass
	else:
		hurt(collision_force-19, sharp)

func _on_area_entered(area):
	if area.name == "HurtArea":
		area.hurt.connect(hurt)

func _on_area_exited(area):
	if area.name == "HurtArea":
		area.hurt.disconnect(hurt)

func hurt(damage, is_sharp):
	var splash = load("res://SplashText.tscn").instantiate()
	splash.set_text(str(damage))
	if mortal:
		HP -= damage
		if HP <= 0:
			dead = true
	splash.set_pos(collision_pos)
	#splash.set_transparency(collision_force / 100)
	splash.set_color(Color(float(damage/100), 0, 0, float(damage/100)))
	if is_sharp:
		splash.set_color(Color(0, 0, float(damage/100), float(damage/100)))
	splash.set_time(1.0)
	add_child(splash)
