extends Node2D
@onready var hurtbox: Hurtbox = $Hurtbox

const GRASS_EFFECT = preload("res://effects/grass_effect.tscn")
# the above does the same as the below, somehow
#@export var GRASS_EFFECT: PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hurtbox.hurt.connect(_on_hurt)


func _on_hurt(other_hitbox: Hitbox) -> void:
	var grass_effect_instance = GRASS_EFFECT.instantiate()
	get_tree().current_scene.add_child(grass_effect_instance)
	grass_effect_instance.global_position = global_position
	queue_free()
