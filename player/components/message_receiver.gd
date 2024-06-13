extends Node3D

@onready var animation_player: AnimationPlayer = $SubViewport/AnimationPlayer
@onready var label: Label = $SubViewport/Label
@onready var animation_tree: AnimationTree = $"../../Animation/AnimationTree"
@onready var audio_stream_player_3d: AudioStreamPlayer3D = $AudioStreamPlayer3D

const VOICE_01 = preload("res://player/voice/voice-01.ogg")
const VOICE_02 = preload("res://player/voice/voice-02.ogg")
const VOICE_03 = preload("res://player/voice/voice-03.ogg")
const VOICE_04 = preload("res://player/voice/voice-04.ogg")

var voices = [VOICE_01,VOICE_02,VOICE_03,VOICE_04]

func _ready() -> void:
	Autoload.SendMessage.connect(send_message)

func send_message(message : StringName):
	if animation_player.is_playing(): return
	audio_stream_player_3d.stream = voices.pick_random()
	audio_stream_player_3d.pitch_scale = randf_range(0.8,1.2)
	audio_stream_player_3d.play()
	animation_player.stop()
	animation_player.play("RESET")
	label.text = tr("MSG_%s" %message)
	animation_player.play("message")
	animation_tree.set("parameters/Message/request", 1)
