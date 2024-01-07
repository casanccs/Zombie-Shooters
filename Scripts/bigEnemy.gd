extends CharacterBody3D

var speed = 2
var accel = 10
var hp = 25
var nphit = false

@onready var nav = $NavigationAgent3D
@onready var player = $"/root/main/Player"

func _ready():
	position.y = 0.75

func _physics_process(delta):
	position.y = 0.75
	var direction = Vector3()
	nav.target_position = player.global_position
	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	
	if !nphit:
		move_and_slide()
	
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		# If the collision is with ground
		if collision.get_collider() == null:
			continue
		# If the collider is with a mob
		if collision.get_collider().is_in_group("Player") and !nphit:
			collision.get_collider().getHit(4)
			nphit = true
			$Timer.start()

func hit(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
		return 'big'
	return 'none'


func _on_timer_timeout():
	nphit = false # Replace with function body.
