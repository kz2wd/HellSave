extends Control



var current_percent: int
var rng = RandomNumberGenerator.new()

@export var world_spawn: Node3D
@export var player: Player

var respawn_position: Vector3

func reset_menu() -> void:
	current_percent = 0
	respawn_position = world_spawn.position
	
func _ready() -> void:
	reset_menu()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handle_save()
	handle_respawn()
	
	
func wait(seconds: float) -> void:
	await get_tree().create_timer(seconds).timeout
	

func handle_save() -> void:
	if not Input.is_action_just_pressed("quick_save"): return
	try_save()
	

func respawn()	 -> void:
	player.position = respawn_position
	#player.acceleration = Vector3.ZERO

func handle_respawn() -> void:
	if not Input.is_action_just_pressed("respawn"): return
	respawn()
	
func update_luck_label() -> void:
	$Saving_luck.text = "Need : " + str(current_percent) + "%"

func update_hit_label(pull: int) -> void:
	$Saving_hit.text = "Pulled : " + str(pull) + "%"

func try_save() -> void:
	self.visible = true
	$Saving_state.text = "SAVING"
	$Saving_hit.text = "pulling..."
	update_luck_label()
	await wait(2)
	var pull = rng.randi_range(0, 100)
	update_hit_label(pull)
	# If fail
	if pull < current_percent:
		$Saving_state.text = "SAVING FAILED"
		reset_menu()
		await wait(1)
		respawn()
		
	else:
		$Saving_state.text = "SAVED !"
		current_percent += 5
		update_luck_label()
		respawn_position = player.position
		await wait(1)
	
	self.visible = false
		
	
	
