extends CanvasLayer

@onready var timer_node = $Timer
@onready var text_node = $Text

var text_msg: String = "Splash"
var time_to_live: float = 1.0
var text_pos: Vector2 = Vector2.ZERO
#var text_transparency: float = 0.5
var text_color: Color = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready():
	text_node.text = text_msg
	set_offset(text_pos)
	#text_node.label_settings.font_color[3] = text_transparency
	#text_node.label_settings.shadow_color[3] = text_transparency
	text_node.label_settings.font_color = text_color
	#text_node.label_settings.shadow_color[3] = text_color[3]
	timer_node.start(time_to_live)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_text(text: String):
	text_msg = text

func set_time(time: float):
	time_to_live = time

func set_pos(pos: Vector2):
	text_pos = pos
	
#func set_transparency(val: float):
#	text_transparency = val

func set_color(col: Color):
	text_color = col

func _on_timer_timeout():
	queue_free()
