extends Node3D

@onready var static_body_3d: StaticBody3D = $StaticBody3D
@onready var mesh: Node3D = $mesh
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_sfx: AudioStreamPlayer3D = $HitSFX
@onready var health_manager: Node3D = $HealthManager

@export var loot_data : LootData

func _ready() -> void:
	add_user_signal("ObjectDeleted")
	mesh.rotation.y = randf_range(0, TAU)

func hit():
	animation_player.play("hit")
	hit_sfx.pitch_scale = randf_range(0.8,1.2)
	hit_sfx.play()
	
func die():
	Autoload.drop_loot(loot_data, global_position + Vector3(0,1,0))
	emit_signal("ObjectDeleted")
	health_manager.queue_free()
	static_body_3d.queue_free()
	animation_player.queue_free()
	mesh.queue_free()
	await hit_sfx.finished
	queue_free()
