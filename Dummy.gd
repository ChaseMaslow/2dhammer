extends RigidBody2D

@export var SplashObj: Resource
#@export var splash_obj_path: String = "res://SplashText.tscn"

var collision_pos
var collision_force

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _integrate_forces(state):
	if (state.get_contact_count() > 0):
		collision_pos = state.get_contact_local_position(0)
		collision_force = ceilf((state.get_linear_velocity() / state.get_inverse_mass() / state.get_step()).length() / 1000)
		#collision_force = state.get_contact_impulse(0).length()

func _on_body_entered(body):
	#collision_pos = to_global(collision_pos)
	#collision_pos.x -= 100
	var splash = load("res://SplashText.tscn").instantiate()
	splash.set_text(str(collision_force))
	splash.set_pos(collision_pos)
	#splash.set_transparency(collision_force / 100)
	splash.set_color(Color(float(collision_force/100), 0, 0, float(collision_force/100)))
	splash.set_time(1.0)
	add_child(splash)
