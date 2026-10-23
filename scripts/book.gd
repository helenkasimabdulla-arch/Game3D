# this scripts control the book extends Area3D
extends Area3D

#checks when something enters the book area
func _on_body_entered(body: Node3D) -> void:
# checks if the object is CharacterBody3D (such as the player). 
	if body is CharacterBody3D:
		#prints a message in the putput panel
		print ("book collected")
		# Removes the book from the game. 
		queue_free()
