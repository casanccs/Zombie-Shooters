extends CharacterBody3D

var speed = 6
var accel = 10
var hp = 5

@onready var nav = $NavigationAgent3D
@onready var player = $"/root/main/Player"

func _ready():
	position.y = 0.25

func _physics_process(delta):
	position.y = 0.25
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
		if collision.get_collider().is_in_group("Player"):
			collision.get_collider().getHit(1)

func hit(damage):
	hp -= damage
	if hp <= 0:
		queue_free()
		return 'small'
	return 'none'

