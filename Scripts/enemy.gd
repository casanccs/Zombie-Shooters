extends CharacterBody3D

var speed = 3
var accel = 10
var hp = 15
var nphit = false

@onready var nav = $NavigationAgent3D
@onready var player = $"/root/main/Player"
@onready var timer = $Timer

func _ready():
	position.y = 0.75

func _physics_process(delta):
	var direction = Vector3()
	nav.target_position = player.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	move_and_slide()
	
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		# If the collision is with ground
		if collision.get_collider() == null:
			continue
		# If the collider is with a mob
		
		if collision.get_collider().is_in_group("Player") and !nphit:
			collision.get_collider().getHit(1)
			nphit = true
			timer.start()
			
			

func hit(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
		return 'normal'
	return 'none'


func _on_timer_timeout():
	nphit = false# Replace with function body.
