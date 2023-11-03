extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity") * 1.4

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	
	var listVisible = get_node("../ui/main-ui/info-view")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if !listVisible.visible:
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
			if is_on_floor():
				velocity.y = JUMP_VELOCITY * 0.5
			
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
	else:
		velocity.x = 0
		velocity.z = 0

	move_and_slide()

func goto_building(building: String):
	var fall_mod = Vector3(0, 4, 0)
	if building in buildings.keys():
		print("Going to ", building)
		position = buildings[building] + fall_mod
	else:
		print("Building not mapped! Going to ASU instead...")
		position = Vector3(3.439, 0, -3.196) + fall_mod

var buildings = {
	# Acadia Athletics Complex
	# Acadia Divinity College
	"Acadia Divinity College": Vector3(6.663, 0, 3.539),

	# Alumni Hall
	# Bancroft House
	"Bancroft House": Vector3(4.882, 0, -8.101),

	# Beveridge Arts Centre
	"Beveridge Arts Centre": Vector3(4.792, 0, -14.432),

	# Biology Building
	# Carnegie Hall
	"Carnegie Hall": Vector3(-6.921, 0, -5.017),

	# Central Heating Plant & Tank Farm
	# Centre for Organizational Research & Development
	"Centre for Organizational Research & Development": Vector3(7.747, 0, -8.303),

	# Chase Court
	"Chase Court": Vector3(-1.848, 0, 8.283),

	# Chipman House
	"Chipman House": Vector3(-6.089, 0, 2.607),

	# Christofer Hall
	"Christofer Hall": Vector3(-7.283, 0, 6.07),

	# Clark Commons
	"Clark Commons": Vector3(-6.751, 0, 4.363),

	# Crowell Tower
	"Crowell Tower": Vector3(1.389, 0, 17.319),

	# Cutten House
	"Cutten House": Vector3(-6.749, 0, 13.563),

	# Dennis House
	"Dennis House": Vector3(1.096, 0, 4.242),

	# DeWolfe Building
	"DeWolfe Building": Vector3(-5.767, 0, 1.014),

	# DeWolfe House
	# Eaton House
	"Eaton House": Vector3(-5.831, 0, 7.81),

	# Elliott Hall
	# Emmerson Hall
	"Emmerson Hall": Vector3(-4.839, 0, -3.857),

	# Festival Theatre
	# Fountain Commons
	"Fountain Commons": Vector3(-2.305, 0, -1.178),

	# Godfrey House
	"Godfrey House": Vector3(4.703, 0, -10.778),

	# Harvey Denton Hall
	"Harvey Denton Hall": Vector3(0.723, 0, -5.681),

	# Hayward House
	"Hayward House": Vector3(5.983, 0, -10.424),

	# Horton Hall
	# Huggins Science Hall
	# Irving Support Centre
	# K.C. Irving Centre
	# Manning Memorial Chapel
	"Manning Memorial Chapel": Vector3(1.597, 0, -10.989),

	# Patterson Hall
	# Raymond House
	"Raymond House": Vector3(-0.765, 0, 1.478),

	# Rhodes Hall
	"Rhodes Hall": Vector3(-8.085, 0, -7.77),

	# Robbie Roscoe Services Building (Physical Plant)
	"Robbie Roscoe Services Building (Physical Plant)": Vector3(-5.663, 0, 19.032),

	# Roy Jodrey Hall
	"Roy Jodrey Hall": Vector3(-4.442, 0, 5.624),

	# Seminary House
	# Service Building Garage
	"Service Building Garage": Vector3(-6.644, 0, 23.383),

	# SRMK Outdoor Activity Centre
	# Students’ Centre (Old and New SUB)
	"Students’ Centre (Old and New SUB)": Vector3(3.33, 0, -1.821),

	# University Faculty Club
	# University Hall
	"University Hall": Vector3(-5.045, 0, -11.753),

	# Vaughan Memorial Library
	# War Memorial House
	# Wheelock Dining Hall/Campus Bookstore
	"Wheelock Dining Hall/Campus Bookstore": Vector3(4.173, 0, 8.347),

	# Whitman House
	"Whitman House": Vector3(2.195, 0, -0.457),

	# Willett House
	"Willett House": Vector3(-7.068, 0, -1.459),

	# Wong International Centre
	"Wong International Centre": Vector3(7.72, 0, -9.943),
}
