extends Node3D


@onready var mesh: Node3D = $mesh
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var hit_sfx: AudioStreamPlayer3D = $HitSFX
@export var loot_data : LootData
@onready var player_damager: PlayerDamager = $PlayerDamager
@onready var double_hit_prevent: Timer = $DoubleHitPrevent

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
	$mesh/StaticBody3D.queue_free()
	animation_player.queue_free()
	$mesh/PlayerHurterBox.monitoring = false
	mesh.queue_free()
	await hit_sfx.finished
	queue_free()


func _on_player_hurter_box_body_entered(body: Node3D) -> void:
	if double_hit_prevent.is_stopped():
		player_damager.hit()
		double_hit_prevent.start()
