extends CharacterBody2D

const SPEED = 30
const FRICTION = 500

@onready var ray_cast_2d: RayCast2D = $RayCast2D
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var playback = animation_tree.get("parameters/StateMachine/playback") as AnimationNodeStateMachinePlayback
@export var chase_range: = 64
@onready var hurtbox: Hurtbox = $Hurtbox



func _ready() -> void:
	hurtbox.hurt.connect(func(other_hitbox: Hitbox):
			velocity = other_hitbox.knockback_direction * 100
			playback.start("HitState")
			print("changed to the hit state")
	)
	

func _physics_process(delta: float) -> void:
	var state = playback.get_current_node()
	match state:
		"IdleState": pass
		"ChaseState": 
			var player = get_player()
			if player is Player:
				velocity = global_position.direction_to(player.global_position) * SPEED
				sprite_2d.scale.x = sign(velocity.x)
			else:
				velocity = Vector2.ZERO
				
			move_and_slide()
		"HitState":
			move_and_slide()
			velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
func get_player() -> Player:
	return get_tree().get_first_node_in_group("player")
	
	# below is the Seralyn way, above is the Gabi way
	#var player: Player
	#player = get_tree().get_first_node_in_group("player")
	#return player

func is_player_in_range() -> bool: 
	var result = false
	var player: = get_player()
	if player is Player:  #this line basically checks if the player is alive
		var distance_to_player=global_position.distance_to(player.global_position)
		if distance_to_player < chase_range:
			result = true
	return result

func can_see_player() -> bool:
	if not is_player_in_range(): return false
	var player: = get_player()
	#if player is not player: return false
	#technically not needed (line above) but it feels safer as a safety check
	ray_cast_2d.target_position = player.global_position - global_position
	ray_cast_2d.force_raycast_update()
	# clear line of sight = the ray hits nothing, or the first thing it hits is the player
	var has_los_to_player: bool = not ray_cast_2d.is_colliding() or ray_cast_2d.get_collider() == player
	return has_los_to_player
	
