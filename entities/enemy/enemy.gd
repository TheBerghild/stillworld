extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sfx: AudioStreamPlayer = $SFX
@onready var death: AudioStreamPlayer = $Death
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var detection_area: Area3D = $DetectionArea
@onready var player_damager: PlayerDamager = $PlayerDamager
@onready var cooldown: Timer = $Cooldown
@onready var player_hurt_area: Area3D = $PlayerHurtArea

@export var max_speed : float

var can_follow_player : bool = false
var can_move : bool = true
var knockback := Vector3.ZERO

func _ready() -> void:
	add_user_signal("ObjectDeleted")
	detection_area.body_entered.connect(on_player_detection)
	detection_area.body_exited.connect(on_player_lost)
	animation_tree.set("parameters/Transition/transition_request","idle")
	
func hit():
	animation_tree.set("parameters/Hit/request", 1)
	sfx.pitch_scale = randf_range(0.6,1)
	sfx.play()
	knockback = Autoload.player_pos.direction_to(global_position) * 4

func die():
	death.play()
	animation_tree.active = false
	animation_player.play("Death")
	emit_signal("ObjectDeleted")
	await animation_player.animation_finished
	queue_free()

func _physics_process(delta: float) -> void:
	if can_move and can_follow_player:
		animation_tree.set("parameters/Transition/transition_request","walk")
		var player_dir = global_position.direction_to(Autoload.player_pos)
		var new_velocity = player_dir + velocity
		rotation.y = lerp_angle(rotation.y, player_dir.angle_to(global_position),delta*8)
		velocity = new_velocity.normalized() * 4
		move_and_slide()
	else:
		velocity.move_toward(Vector3.ZERO, delta)

func on_player_detection(_body):
	can_follow_player = true
	animation_tree.set("parameters/Transition/transition_request","walk")

func on_player_lost(_body):
	#can_follow_player = false
	animation_tree.set("parameters/Transition/transition_request","idle")
	can_follow_player = false

func _on_player_hurt_area_body_entered(_body: Node3D) -> void:
	attempt_attack()

func attempt_attack():
	if not cooldown.is_stopped(): return
	if animation_tree.get("parameters/Hit/active"): return
	if player_hurt_area.has_overlapping_bodies():
		can_move = false
		animation_tree.set("parameters/Transition/transition_request","idle")
		await get_tree().create_timer(0.6).timeout
		cooldown.start()
		animation_tree.set("parameters/Attack/request", 1)
		await animation_tree.animation_finished
		can_move = true
		
func _on_cooldown_timeout() -> void:
	attempt_attack()

