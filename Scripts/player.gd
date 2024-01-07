extends CharacterBody3D

signal hit

@export var SPEED = 6
@export var MOUSE_SENS = 0.003
@export var GRAVITY = 9.81
@export var STAMINA = 100
@export var toSPRINT = true

@onready var camera = $"Camera3D"
@onready var ray = $"Camera3D/RayCast3D"
@onready var HP = $"Camera3D/HP"
@onready var STAm = $"Camera3D/STAMINA"
@onready var ShootCoolDown = $"ShootCoolDown"
@onready var CurrentWeapon = $Camera3D/CurrentWeapon
@onready var GunAmmoLabel = $Camera3D/GunAmmo
@onready var AmmoLabel = $Camera3D/Ammo
@onready var Money = $"Camera3D/Money"
@onready var HitEffect = $"Camera3D/ColorRect"
@onready var BuyMenu = $"Camera3D/Control"
#@onready var ray_end = $"Camera3D/RayEnd"
#@onready var bullet_scene = load("res://bullet.tscn")
#@onready var trail_scene = load("res://trail.tscn")
var tilt = 0
var paused = false
var score = 0
var money = 1000
var hp = 5

var gun_id = 1
var toShoot = true # if you can shoot or not

var gunCapacity= [12, 50, 32, 5]
var gunAmmo = [12, 50, 32, 5]
var ammo = [24, 100, 64, 10]
var ownWeapons = [1,0,0,0]

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	HP.value = hp
	STAm.value = STAMINA
	position.y = 10
	CurrentWeapon.text = "Pistol"
	GunAmmoLabel.text = "12"
	AmmoLabel.text = "24"
	
func _input(event):
	if not paused:
		if event is InputEventMouseMotion:
			rotate(Vector3.UP, -event.relative.x*MOUSE_SENS)
			if -PI*180 < tilt - event.relative.y and tilt - event.relative.y < PI*180:
				camera.rotate_object_local(Vector3.RIGHT, -event.relative.y*MOUSE_SENS)
				tilt -= event.relative.y
		

func _physics_process(delta):
	STAm.value = STAMINA
	HP.value = hp
	Money.text = "$" + str(money)
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	if is_on_floor():
		velocity.y = 0
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = 8
		
	if Input.is_action_pressed("Sprint") and toSPRINT:
		SPEED = 16
		STAMINA -= 0.5
		if STAMINA <= 0:
			toSPRINT = false
	else:
		SPEED = 3
		if STAMINA < 100:
				STAMINA += 0.5
		if STAMINA > 50:
			toSPRINT = true
			
	if not is_on_floor():
		velocity.y -= GRAVITY * delta
#	var collision = move_and_collide(Vector3(velocity.x, velocity.y, velocity.z))

	move_and_slide()
	
	if Input.is_action_just_pressed("BuyMenu"):
		BuyMenu.visible = !BuyMenu.visible
	if BuyMenu.visible == false:
		if Input.is_action_just_pressed("1") and ownWeapons[0]:
			gun_id = 1
			CurrentWeapon.text = "Pistol"
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_just_pressed("2")  and ownWeapons[1]:
			gun_id = 2
			CurrentWeapon.text = "SMG"
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_just_pressed("3")  and ownWeapons[2]:
			gun_id = 3
			CurrentWeapon.text = "AR"
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_just_pressed("4")  and ownWeapons[3]:
			gun_id = 4
			CurrentWeapon.text = "Sniper"
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_just_pressed("5"):
			gun_id = 5
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_just_pressed("6"):
			gun_id = 6
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
	else:	
		if Input.is_action_just_pressed("1") and money >= 300:
			
			ammo[0] += 24
			AmmoLabel.text = str(ammo[0])
			
			money -= 300
			
		if Input.is_action_just_pressed("2") and money >= 450:
			if ownWeapons[1]:
				ammo[1] += 100
				AmmoLabel.text = str(ammo[2])
				
				money -= 450
			elif money >= 1500:
				money -= 1500
				ownWeapons[1] = 1	
				$Camera3D/Control/SMG.text = "SMG Ammo: $450(2)"
				
		if Input.is_action_just_pressed("3") and money >= 750:
			if ownWeapons[2]:
				ammo[2] += 64
				AmmoLabel.text = str(ammo[2])
				
				money -= 750
			elif money >= 2500:
				money -= 2500
				ownWeapons[2] = 1	
				$Camera3D/Control/AR.text = "AR Ammo: $750(3)"
		if Input.is_action_just_pressed("4") and money >= 900:
			if ownWeapons[3]:
				ammo[3] += 10
				AmmoLabel.text = str(ammo[3])
				
				money -= 900
			elif money >= 3000:
				money -= 3000
				ownWeapons[3] = 1	
				$Camera3D/Control/AR.text = "Sniper Ammo: $900(4)"
		if Input.is_action_just_pressed("5"):
			gun_id = 5
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_just_pressed("6"):
			gun_id = 6
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
#############################################################################
# __Shooting Logic __
	# Recoil values:
	'''
		- Pistol: 0.1
		- SMG: 0.04
		- AR: 0.075
		- Sniper: 1
	'''
	if gun_id == 1: # Pistol
		ShootCoolDown.wait_time = 0.3
		if Input.is_action_just_pressed("reload") and ammo[gun_id - 1] >= gunCapacity[gun_id - 1]:
			gunAmmo[gun_id - 1] = gunCapacity[gun_id -1]
			ammo[gun_id - 1] -= gunCapacity[gun_id -1]
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_just_pressed("shoot") and toShoot and gunAmmo[gun_id - 1] > 0:
			print("Shot Pistol")
			gunAmmo[gun_id - 1] -= 1
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			toShoot = false
			ShootCoolDown.start()
			camera.rotate_object_local(Vector3.RIGHT, 0.1)
			tilt += 0.1/MOUSE_SENS
			if ray.is_colliding() and ray.get_collider().is_in_group("Enemies"):
				var killed = ray.get_collider().hit(5)
				if killed == "normal":
					incrementMoney(100)
				elif killed == "big":
					incrementMoney(300)
				elif killed == "small":
					incrementMoney(150)
				score += 1
				hit.emit()
	#			gui_score.text = "Score: " + str(score)
	if gun_id == 2: # Automatic SMG shoots faster than an AR, but deals less damage
		ShootCoolDown.wait_time = 0.05
		if Input.is_action_just_pressed("reload") and ammo[gun_id - 1] >= gunCapacity[gun_id - 1]:
			gunAmmo[gun_id - 1] = gunCapacity[gun_id -1]
			ammo[gun_id - 1] -= gunCapacity[gun_id -1]
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_pressed("shoot") and toShoot and gunAmmo[gun_id - 1] > 0:
			print("Shot SMG")
			gunAmmo[gun_id - 1] -= 1
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			toShoot = false
			ShootCoolDown.start()
			camera.rotate_object_local(Vector3.RIGHT, 0.04)
			tilt += 0.04/MOUSE_SENS
			if ray.is_colliding() and ray.get_collider().is_in_group("Enemies"):
				var killed = ray.get_collider().hit(1.5)
				if killed == "normal":
					incrementMoney(100)
				elif killed == "big":
					incrementMoney(300)
				elif killed == "small":
					incrementMoney(150)
				score += 1
				hit.emit()
	if gun_id == 3: # AR
		ShootCoolDown.wait_time = 0.1
		if Input.is_action_just_pressed("reload") and ammo[gun_id - 1] >= gunCapacity[gun_id - 1]:
			gunAmmo[gun_id - 1] = gunCapacity[gun_id -1]
			ammo[gun_id - 1] -= gunCapacity[gun_id -1]
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_pressed("shoot") and toShoot and gunAmmo[gun_id - 1] > 0:
			print("Shot AR")
			gunAmmo[gun_id - 1] -= 1
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			toShoot = false
			ShootCoolDown.start()
			camera.rotate_object_local(Vector3.RIGHT, 0.075)
			tilt += 0.075/MOUSE_SENS
			if ray.is_colliding() and ray.get_collider().is_in_group("Enemies"):
				var killed = ray.get_collider().hit(3.3)
				if killed == "normal":
					incrementMoney(100)
				elif killed == "big":
					incrementMoney(300)
				elif killed == "small":
					incrementMoney(150)
				score += 1
				hit.emit()
	#			gui_score.text = "Score: " + str(score)
	if gun_id == 4: # Sniper
		ShootCoolDown.wait_time = 3
		if Input.is_action_just_pressed("reload") and ammo[gun_id - 1] >= gunCapacity[gun_id - 1]:
			gunAmmo[gun_id - 1] = gunCapacity[gun_id -1]
			ammo[gun_id - 1] -= gunCapacity[gun_id -1]
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
		if Input.is_action_just_pressed("shoot") and toShoot and gunAmmo[gun_id - 1] > 0:
			print("Shot Sniper")
			gunAmmo[gun_id - 1] -= 1
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			toShoot = false
			ShootCoolDown.start()
			camera.rotate_object_local(Vector3.RIGHT, 1)
			tilt += 1/MOUSE_SENS
			if ray.is_colliding() and ray.get_collider().is_in_group("Enemies"):
				var killed = ray.get_collider().hit(20)
				if killed == "normal":
					incrementMoney(100)
				elif killed == "big":
					incrementMoney(300)
				elif killed == "small":
					incrementMoney(150)
				score += 1
				hit.emit()
#############################################################################
	
			
		
func getHit(damage):
	hp -= damage
	print('hp:', hp)
	if hp <= 0:
		get_tree().quit()
	HitEffect.visible = true
	$HitTimer.start()	
	


func _on_shoot_cool_down_timeout():
	toShoot = true
func incrementMoney(amount):
	money += amount


func _on_hit_timer_timeout():
	HitEffect.visible = false# Replace with function body.
