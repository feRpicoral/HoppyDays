extends KinematicBody2D

#WORKFLO
#If player triggers the raycast, ACCELERATE to it
#If hit or not, start going down


#Editor variables
export(int) var fly_speed = 100


#Global variables
var motion = Vector2()
const UP = Vector2(0, -1)
const GRAV = 1000 

#Initialize some variables

func _physics_process(delta):
	move_and_slide(motion, UP)

func _ready():
	pass

func _on_body_entered(body):
	pass 
