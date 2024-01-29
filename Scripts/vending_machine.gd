extends StaticBody3D

@export var Juggernog = false
@export var Staminaup = false
@export var quickHands = false
@export var speedCola = false
@export var packapunch = false
@onready var player = get_parent().get_node("Player")
@onready var vendyMenu = player.get_node("Camera3D/vendyMenu")
var dis = 0
#@onready var mat = $MeshInstance3D.mesh.surface_get_material(0)
func _ready():
	if Juggernog:
		$MeshInstance3D.mesh.surface_get_material(0).albedo_color = Color(1,0,0)
	if Staminaup:
		$MeshInstance3D.mesh.surface_get_material(0).albedo_color = Color(0,1,0)
	if packapunch:
		$MeshInstance3D.mesh.surface_get_material(0).albedo_color = Color(0,0,1)

func _process(delta):
	dis = player.global_transform.origin.distance_to(self.global_transform.origin)
	if dis <= 3:
		if Juggernog:
			vendyMenu.text = "Juggernog: 1000"
		if Staminaup:
			vendyMenu.text = "Staminaup: 1000"
		if quickHands:
			vendyMenu.text = "quickHands: 1000"
		if speedCola:
			vendyMenu.text = "speedCola: 1000"
		if packapunch:
			vendyMenu.text = "packapunch: 3000"
		player.showvendy()
		
	
	
	if Input.is_action_just_pressed("Interact") and dis <= 3:
		
		if Juggernog:
			player.vendy(1)
		if Staminaup:
			player.vendy(2)
		if quickHands:
			player.vendy(3)
		if speedCola:
			player.vendy(4)
		if packapunch:
			player.vendy(5)	
						
