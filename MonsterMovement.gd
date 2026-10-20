extends CharacterBody3D

@export var speed: float = 4.0
@export var sight: int = 5

#Refers to the player tree
@onready var player: Node3D = get_tree().get_first_node_in_group("Player")

func _physics_process(delta: float) -> void:
	if not player:
		return
		
		
		#if the player is more then 5 units aka 5 meters
	if global_position.distance_to(player.global_position) > sight:
		return
		
		
		
		#calculates the direction towards the player (part of chase)
	var direction: Vector3 = global_position.direction_to(player.global_position)
	
	if direction.length() > 2:
		return
	
	
		#Makes sure the monster doesn't fly towards the player by setting the y to 0. (can be deleted in case of multible floors)
	direction.y = 0
	direction = direction.normalized()
		
		#set teh velocity to move the monster in the direction of the player
	
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
		
		# in case of the monster floating fx: when spawned above y= 0 moves it down to the floor
	if not is_on_floor():
		velocity.y -= 9.8 * delta

	move_and_slide()
		
		#makes the monster look at the player
	if direction.length() > 0:
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
