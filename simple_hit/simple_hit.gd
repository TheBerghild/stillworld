extends Node3D


@onready var gpu_particles_3d = $GPUParticles3D
@onready var gpu_particles_3d_2 = $GPUParticles3D2


func _ready():
	gpu_particles_3d.emitting = true
	gpu_particles_3d_2.emitting = true
	gpu_particles_3d.finished.connect(queue_free) 
