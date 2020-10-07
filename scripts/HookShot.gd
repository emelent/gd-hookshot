extends KinematicBody2D


var hook_target = null

onready var raycast = $RayCast2D
onready var tween = $Tween


func _ready():
	tween.connect("tween_completed", self, "__tween_complete")
	
func _process(delta):
	raycast.rotation = (global_position -  get_global_mouse_position()).angle() + PI/2	
	if raycast.is_colliding():
		modulate = Color.red
	else:
		modulate = Color.white

	
	
func _input(event):
	if Input.is_action_just_pressed("hook") and raycast.is_colliding():
		if not hook_target:
			hook_target = raycast.get_collision_point()
			tween.interpolate_property(self, "global_position",
				global_position, hook_target, 1,
				Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
			tween.start()


func __tween_complete():
	hook_target = null
