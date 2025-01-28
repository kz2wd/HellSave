extends CharacterBody3D
class_name Player

@export var mouse_sensitivity = 0.0015

@export var speed = 8.0
@export var acceleration = 10.0
@export var jump_speed = 5.0

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $Camera3D



func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):
	velocity.y += -gravity * delta
	get_move_input(delta)

	move_and_slide()
	
func _process(delta) -> void:
	update_height()
	add_time(delta)
		
func get_move_input(delta):
	var vy = velocity.y
	velocity.y = 0
	var input = Input.get_vector("left", "right", "forward", "backward")
	var dir = Vector3(input.x, 0, input.y).rotated(Vector3.UP, camera.rotation.y)
	velocity = lerp(velocity, dir * speed, acceleration * delta)
	velocity.y = vy
	if is_on_floor() and Input.is_action_pressed("jump"):
		velocity.y = jump_speed

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		camera.rotation.x -= event.relative.y * mouse_sensitivity
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90.0, 90.0)
		camera.rotation.y -= event.relative.x * mouse_sensitivity
		
			


var time: float = 0

func reset_time():
	time = 0
	update_time()
	
func add_time(delta):
	time += delta
	update_time()
		
func update_time():
	$Time.text = "Time: " + str(int(time)) + "s"
	
func update_height():
	$Height.text = "Height: " + str(int(position.y)) + "m"


func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	
func _on_area_3d_body_entered(body: Node3D) -> void:
	if body != self: return
	$VictoryMessage.text = "GG! Reached top in " + str(int(time)) + " seconds!"
	$VictoryMessage.visible = true

func _on_area_3d_body_exited(body: Node3D) -> void:
	if body != self: return
	$VictoryMessage.visible = false
