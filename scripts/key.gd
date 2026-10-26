
#this script is for the key 
extends Area3D

# this functions checks if somethings enters the key area 
func _on_body_entered(body: Node3D) -> void:
	#here checks if it is the objects  type characterbody3D (player).
	 #if so it removes the key
	if body is CharacterBody3D:
	 # writing a message
		print ("key collected")
		#removes the key
		queue_free()
