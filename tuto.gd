extends Control

var capture = false

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quick_save"):
		self.visible = false
	if Input.is_action_just_pressed("ui_cancel"):
		self.visible = !self.visible
		capture = !self.visible
		
		
func _unhandled_input(event):
	if event is InputEventMouseMotion && capture:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
