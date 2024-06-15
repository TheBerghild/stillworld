extends CharacterBody3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sfx: AudioStreamPlayer = $SFX
@onready var death: AudioStreamPlayer = $Death
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var detection_area: Area3D = $DetectionArea
@onready var player_damager: PlayerDamager = $PlayerDamager
@onready var cooldown: Timer = $Cooldown
@onready var player_hurt_area: Area3D = $PlayerHurtArea

var can_follow_player : bool = false

func _ready() -> void:
	add_user_signal("ObjectDeleted")
	detection_area.body_entered.connect(on_player_detection)
	detection_area.body_exited.connect(on_player_lost)
	animation_tree.set("parameters/Transition/transition_request","idle")
	
func hit():
	animation_tree.set("parameters/Hit/request", 1)
	sfx.pitch_scale = randf_range(0.6,1)
	sfx.play()
	
func die():
	death.play()
	animation_tree.active = false
	animation_player.play("Death")
	emit_signal("ObjectDeleted")
	await animation_player.animation_finished
	queue_free()

func _physics_process(delta: float) -> void:
	if not can_follow_player: return
	animation_tree.set("parameters/Transition/transition_request","walk")
	var new_velocity = global_position.direction_to(Autoload.player_pos)
	new_velocity.y = 0
	look_at(Autoload.player_pos)
	velocity = new_velocity.normalized() * 2
	move_and_slide()
	
func on_player_detection(_body):
	can_follow_player = true
	animation_tree.set("parameters/Transition/transition_request","walk")

func on_player_lost(_body):
	can_follow_player = false
	animation_tree.set("parameters/Transition/transition_request","idle")

func _on_player_hurt_area_body_entered(_body: Node3D) -> void:
	attempt_attack()

func attempt_attack():
	if not cooldown.is_stopped(): return
	if player_hurt_area.has_overlapping_bodies():
		can_follow_player = false
		animation_tree.set("parameters/Transition/transition_request","idle")
		await get_tree().create_timer(0.6).timeout
		cooldown.start()
		animation_tree.set("parameters/Attack/request", 1)
		
func _on_cooldown_timeout() -> void:
	attempt_attack()


func _on_player_hurt_area_body_exited(body: Node3D) -> void:
	can_follow_player = true
