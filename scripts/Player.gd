extends KinematicBody2D


var hook_target = null
var velocity = Vector2.ZERO
var direction = Vector2.ZERO
var hook_acceleration = 670
var hook_speed = 100

onready var raycast = $RayCast2D
onready var arrow = $Arrow

var draw_hint = false
var guide_point = null

func _ready():
	pass
#	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func _draw():
	pass
	if hook_target:
		draw_line(Vector2.ZERO, hook_target - global_position, Color.red)
	elif guide_point:
		draw_line(Vector2.ZERO, guide_point, Color.white)
		draw_circle(guide_point, 5, Color.white)

func _process(delta):
	raycast.rotation = (global_position -  get_global_mouse_position()).angle() + PI/2	
	arrow.rotation = (global_position - get_global_mouse_position()).angle() - PI/2
	
	if raycast.is_colliding():
		arrow.modulate = Color.red
		
		guide_point = raycast.get_collision_point() - global_position
	else:
		arrow.modulate = Color.white
		guide_point = null
	update()

func _physics_process(delta):
	if hook_target and global_position.distance_to(hook_target) > 32:
		velocity += direction * hook_acceleration
		var collision = move_and_collide(velocity * delta) 
		if collision:
			hook_target = null
			update()
	else:
		velocity = Vector2.ZERO
		hook_target = null
#		global_position = lerp(global_position, hook_target, 0.05)

	
	
func _input(event):
	if Input.is_action_just_pressed("hook") and raycast.is_colliding():
		var point = raycast.get_collision_point()
		if not hook_target:
			hook_target = raycast.get_collision_point()
			direction = (hook_target - global_position).normalized()
			velocity =  direction * hook_speed
			update()
			
			print("hook_target => ", hook_target)
			print("glob_pos => ", global_position)
			print("ht - gp => ", hook_target - global_position)
			print("direction => ", direction)
			print("")

