#this scripts controls the cabinet
extends Node3D
# Get the Animationsplayer that controls the doors
@onready var animation_player=$AnimationPlayer

#checks if the cabinet is open or closed. ##Start point is true the cabinet dooes is closed. 

var is_open = false 

#check if the player is close enough to the cabinet.  Startpoint is false since the player is far way from the cabinet. 

var player_near = false

# Function that allows the player to open the cabinets doors. 
func open_cabinet():
	# Play the  animation to open the doors. 
	animation_player.play("open")
	# Update the cabinet state to open
	is_open = true 
	
	# another function this one to close the cabinets doors 
func close_cabinet():
	#play the same animation backwards to close the cabinets doors. 
	animation_player.play_backwards("open")
	# update the cabintes stat to closed
	is_open= false

#check if the player presses the interactions key.
func _input(event):
	if event.is_action_pressed("interact "):
		print("E key works")
	
	#check if the interact button (E) is pressed and the player is near the cabinets area. 
	if event.is_action_pressed("interact ") and player_near:
		print ("E pressed near cabinet")
		
		#if the cabinet is ospen, close it. 
		if is_open:
			close_cabinet()
			#if the cabinet is closed, open it. 
		else:
			open_cabinet() 


#function that check if something enter the area around the cabinet 
func _on_area_3d_body_entered(body: Node3D) -> void:
	#check if the player entering the area is type CharacterBody3D
	if body is CharacterBody3D: 
		#  The player is now close to the cbinet area.  
		player_near= true
		print ("Player is near the cabinet")


# function that check if something leaves the area around the cabinet
func _on_area_3d_body_exited(body: Node3D) -> void:
	#check if the aboject leaving the area is the player.  
	if body is CharacterBody3D: 
		#the player is no longer close to the cabinets area. 
		player_near= false  
