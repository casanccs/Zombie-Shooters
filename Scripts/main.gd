extends Node3D

@onready var enemy_scene = load("res://Scenes/enemy.tscn")
@onready var bigEnemy_scene = load("res://Scenes/bigEnemy.tscn")
@onready var smallEnemy_scene = load("res://Scenes/smallEnemy.tscn")

@onready var spawn1 = $SpawnPoints/Spawn1
@onready var spawn2 = $SpawnPoints/Spawn2
@onready var spawn3 = $SpawnPoints/Spawn3
@onready var spawn4 = $SpawnPoints/Spawn4
@onready var spawn5 = $SpawnPoints/Spawn5
@onready var zspawner = $"ZombieSpawner"

var curWave = 0
var prevWave = 3
var wavePoints = 3
var finish = false

var toSpawn = true
var zrand = 1

func _process(delta):
	if get_tree().get_nodes_in_group("Enemies").is_empty() and wavePoints <= 0 and not finish:
		$"RestTimer".start()
		print("roundFinish")
		finish = true
		curWave += 1
	if toSpawn:
		zrand = randi_range(1,3)
		
		if zrand == 1:
			if wavePoints >= 1:
				wavePoints -= 1
				zspawner.start()
				toSpawn = false


		if zrand == 2:
			if wavePoints >= 4:
				wavePoints -= 4
				zspawner.start()
				toSpawn = false

		if zrand == 3:
			if wavePoints >= 2:
				wavePoints -= 2
				zspawner.start()
				toSpawn = false


func _on_zombie_spawner_timeout():
	var enemy
	if zrand == 1:
		enemy = enemy_scene.instantiate()
	if zrand == 2:
		enemy = bigEnemy_scene.instantiate()
	if zrand == 3:
		enemy = smallEnemy_scene.instantiate()	
		
	var rand = randi_range(1,5)
	if rand == 1:
		enemy.position = spawn1.position
	if rand == 2:
		enemy.position = spawn2.position
	if rand == 3:
		enemy.position = spawn3.position
	if rand == 4:
		enemy.position = spawn4.position
	if rand == 5:
		enemy.position = spawn5.position
	add_child(enemy)
	toSpawn = true


func _on_rest_timer_timeout():
	
	wavePoints = prevWave +  randi_range(1,5)
	prevWave = wavePoints
	
	toSpawn = true
	finish = false
	print(wavePoints)          
