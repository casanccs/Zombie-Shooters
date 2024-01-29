extends CharacterBody3D

signal hit

@export var SPEED = 6
@export var INITSPEED = 6
@export var MOUSE_SENS = 0.003
@export var GRAVITY = 9.81
@export var STAMINA = 100
@export var maxSTAMINA = 100
@export var toSPRINT = true
@export var reloadMulti = 1
@export var damageMulti = 1
@export var ammoMulti = 1
@export var fireRateMulti = 1

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
@onready var HitMarker =  $"Camera3D/HitMarker"
@onready var MarkerTimer = $"MarkerTimer"
@onready var ReloadingText = $"Camera3D/Reloading"
@onready var ReloadTimer = $"ReloadTimer"
@onready var vendyMenu = $"Camera3D/vendyMenu"
#@onready var ray_end = $"Camera3D/RayEnd"
#@onready var bullet_scene = load("res://bullet.tscn")
#@onready var trail_scene = load("res://trail.tscn")
var tilt = 0
var paused = false
var score = 0
var money = 100000
var hp = 5

var gun_id = 1
var toShoot = true # if you can shoot or not

var gunCapacity= [12, 50, 32, 5]
var gunAmmo = [12, 50, 32, 5]
var ammo = [24, 100, 64, 10]
var ownWeapons = [1,1,1,1]
var reloadTimes = [1.5,2,3,4]

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
	#### 
	vendyMenu.visible = false
	####
	
	$"Camera3D/Wave".text = "Wave: " + str(get_parent().curWave + 1)
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
		SPEED = INITSPEED * 2
		STAMINA -= 0.5
		if STAMINA <= 0:
			toSPRINT = false
	else:
		SPEED = INITSPEED
		if STAMINA < maxSTAMINA:
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
			stopReloading()
		if Input.is_action_just_pressed("2")  and ownWeapons[1]:
			gun_id = 2
			CurrentWeapon.text = "SMG"
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
			stopReloading()
		if Input.is_action_just_pressed("3")  and ownWeapons[2]:
			gun_id = 3
			CurrentWeapon.text = "AR"
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
			stopReloading()
		if Input.is_action_just_pressed("4")  and ownWeapons[3]:
			gun_id = 4
			CurrentWeapon.text = "Sniper"
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
			stopReloading()
		if Input.is_action_just_pressed("5"):
			gun_id = 5
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
			stopReloading()
		if Input.is_action_just_pressed("6"):
			gun_id = 6
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			AmmoLabel.text = str(ammo[gun_id-1])
			stopReloading()
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
		ShootCoolDown.wait_time = 0.3/fireRateMulti
		
		if Input.is_action_just_pressed("reload") and ammo[gun_id - 1] >= gunCapacity[gun_id - 1]:
			startReloading()
		if Input.is_action_just_pressed("shoot") and toShoot and gunAmmo[gun_id - 1] > 0:
			print("Shot Pistol")
			gunAmmo[gun_id - 1] -= 1
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			toShoot = false
			ShootCoolDown.start()
			camera.rotate_object_local(Vector3.RIGHT, 0.1)
			tilt += 0.1/MOUSE_SENS
			if ray.is_colliding() and ray.get_collider().is_in_group("Enemies"):
				var killed = ray.get_collider().hit(5*damageMulti)
				if killed == "normal":
					incrementMoney(100)
				elif killed == "big":
					incrementMoney(300)
				elif killed == "small":
					incrementMoney(150)
				score += 1
				hit.emit()
				HitMarker.visible = true
				MarkerTimer.start()
	#			gui_score.text = "Score: " + str(score)
	if gun_id == 2: # Automatic SMG shoots faster than an AR, but deals less damage
		ShootCoolDown.wait_time = float(0.05/fireRateMulti)
		if Input.is_action_just_pressed("reload") and ammo[gun_id - 1] >= gunCapacity[gun_id - 1]:
			startReloading()
		if Input.is_action_pressed("shoot") and toShoot and gunAmmo[gun_id - 1] > 0:
			print("Shot SMG")
			gunAmmo[gun_id - 1] -= 1
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			toShoot = false
			ShootCoolDown.start()
			camera.rotate_object_local(Vector3.RIGHT, 0.04)
			tilt += 0.04/MOUSE_SENS
			if ray.is_colliding() and ray.get_collider().is_in_group("Enemies"):
				var killed = ray.get_collider().hit(1.5 * damageMulti)
				if killed == "normal":
					incrementMoney(100)
				elif killed == "big":
					incrementMoney(300)
				elif killed == "small":
					incrementMoney(150)
				score += 1
				hit.emit()
				HitMarker.visible = true
				MarkerTimer.start()
	if gun_id == 3: # AR
		ShootCoolDown.wait_time = 0.1/fireRateMulti
		if Input.is_action_just_pressed("reload") and ammo[gun_id - 1] >= gunCapacity[gun_id - 1]:
			startReloading()
		if Input.is_action_pressed("shoot") and toShoot and gunAmmo[gun_id - 1] > 0:
			print("Shot AR")
			gunAmmo[gun_id - 1] -= 1
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			toShoot = false
			ShootCoolDown.start()
			camera.rotate_object_local(Vector3.RIGHT, 0.075)
			tilt += 0.075/MOUSE_SENS
			if ray.is_colliding() and ray.get_collider().is_in_group("Enemies"):
				var killed = ray.get_collider().hit(3.3*damageMulti)
				if killed == "normal":
					incrementMoney(100)
				elif killed == "big":
					incrementMoney(300)
				elif killed == "small":
					incrementMoney(150)
				score += 1
				hit.emit()
				HitMarker.visible = true
				MarkerTimer.start()
	#			gui_score.text = "Score: " + str(score)
	if gun_id == 4: # Sniper
		ShootCoolDown.wait_time = 3/fireRateMulti
		if Input.is_action_just_pressed("reload") and ammo[gun_id - 1] >= gunCapacity[gun_id - 1]:
			startReloading()
		if Input.is_action_just_pressed("shoot") and toShoot and gunAmmo[gun_id - 1] > 0:
			print("Shot Sniper")
			gunAmmo[gun_id - 1] -= 1
			GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
			toShoot = false
			ShootCoolDown.start()
			camera.rotate_object_local(Vector3.RIGHT, 1)
			tilt += 1/MOUSE_SENS
			if ray.is_colliding() and ray.get_collider().is_in_group("Enemies"):
				var killed = ray.get_collider().hit(20*damageMulti)
				if killed == "normal":
					incrementMoney(100)
				elif killed == "big":
					incrementMoney(300)
				elif killed == "small":
					incrementMoney(150)
				score += 1
				hit.emit()
				HitMarker.visible = true
				MarkerTimer.start()
#############################################################################
	
func showvendy():
	vendyMenu.visible = true
	
func getHit(damage):
	hp -= damage
	print('hp:', hp)
	if hp <= 0:
		get_tree().quit()
	HitEffect.visible = true
	$HitTimer.start()	
	$HRegenTimer.start()


func _on_shoot_cool_down_timeout():
	toShoot = true
func incrementMoney(amount):
	money += amount


func _on_hit_timer_timeout():
	HitEffect.visible = false# Replace with function body.


func _on_marker_timer_timeout():
	HitMarker.visible = false

var maxHP = 5
var incHP = 1
func _on_h_regen_timer_timeout():
	hp += incHP
	if hp > maxHP:
		hp = maxHP


func _on_reload_timer_timeout():
	stopReloading()
	gunAmmo[gun_id - 1] = gunCapacity[gun_id -1] 
	ammo[gun_id - 1] -= gunCapacity[gun_id -1] 
	GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
	AmmoLabel.text = str(ammo[gun_id-1])
	
func startReloading():
	ReloadTimer.wait_time = reloadTimes[gun_id - 1] * reloadMulti 
	ReloadTimer.start()
	ReloadingText.visible = true
	
func stopReloading():
	ReloadTimer.stop()
	ReloadingText.visible = false
var op = [false,false,false,false,false]	
func vendy(type):
	if type == 1 and op[0] == false and money >= 1000:
		op[0] = true
		maxHP = 9	
		hp = 9 
		money -= 1000	
	if type == 2 and op[1] == false and money >= 1000:
		op[1] = true
		maxSTAMINA = 200
		money -= 1000
	if type == 3 and op[2] == false and money >= 1000:
		op[2] = true
		reloadMulti = 0.5
		money -= 1000	
	if type == 4 and op[3] == false and money >= 1000:
		op[3] = true
		
		money -= 1000
		INITSPEED += 15	
	if type == 5 and op[4] == false and money >= 1000:
		op[4] = true
		damageMulti = 4
		ammoMulti = 2
		fireRateMulti = 3
		money -= 1000
		for i in range(len(gunCapacity)):
			gunCapacity[i] *= ammoMulti
			ammo[i] *= ammoMulti
			gunAmmo[i] = gunCapacity[i]
		GunAmmoLabel.text = str(gunAmmo[gun_id - 1])
		AmmoLabel.text = str(ammo[gun_id-1])	
			
		
		
