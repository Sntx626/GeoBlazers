extends MarginContainer

var delay = 0.1
var timer = Timer.new()

class Building:
	var name: String
	var desc: String
	var image_url: String
	var hours_of_operation: String
	var address: String
	
	func _init(pname:String, pdesc:Array, pimage: String, phours: String, paddress: String):
		name = pname
		desc = funfacts_to_desc(pdesc)
		image_url = pimage
		hours_of_operation = phours
		address = paddress
	
	func funfacts_to_desc(facts: Array) -> String:
		var result = ""
		for item in facts:
			result += item + "\n\n"
		return result

func update_search_bar():
	if Input.is_action_pressed("backspace") and timer.is_stopped():
		var t = $"main-ui/top-bar/search-bar".text
		$"main-ui/top-bar/search-bar".text = t.substr(0, len(t)-1)
		timer.start()
	if Input.is_action_just_pressed("C-backspace"):
		$"main-ui/top-bar/search-bar".text = ""

	if Input.is_action_just_pressed("Enter"):
		_on_searchbar_text_submitted($"main-ui/top-bar/search-bar".text)

	if Input.is_action_just_pressed("a"):
		$"main-ui/top-bar/search-bar".text += "a"
	if Input.is_action_just_pressed("b"):
		$"main-ui/top-bar/search-bar".text += "b"
	if Input.is_action_just_pressed("c"):
		$"main-ui/top-bar/search-bar".text += "c"
	if Input.is_action_just_pressed("d"):
		$"main-ui/top-bar/search-bar".text += "d"
	if Input.is_action_just_pressed("e"):
		$"main-ui/top-bar/search-bar".text += "e"
	if Input.is_action_just_pressed("f"):
		$"main-ui/top-bar/search-bar".text += "f"
	if Input.is_action_just_pressed("g"):
		$"main-ui/top-bar/search-bar".text += "g"
	if Input.is_action_just_pressed("h"):
		$"main-ui/top-bar/search-bar".text += "h"
	if Input.is_action_just_pressed("i"):
		$"main-ui/top-bar/search-bar".text += "i"
	if Input.is_action_just_pressed("j"):
		$"main-ui/top-bar/search-bar".text += "j"
	if Input.is_action_just_pressed("k"):
		$"main-ui/top-bar/search-bar".text += "k"
	if Input.is_action_just_pressed("l"):
		$"main-ui/top-bar/search-bar".text += "l"
	if Input.is_action_just_pressed("m"):
		$"main-ui/top-bar/search-bar".text += "m"
	if Input.is_action_just_pressed("n"):
		$"main-ui/top-bar/search-bar".text += "n"
	if Input.is_action_just_pressed("o"):
		$"main-ui/top-bar/search-bar".text += "o"
	if Input.is_action_just_pressed("p"):
		$"main-ui/top-bar/search-bar".text += "p"
	if Input.is_action_just_pressed("q"):
		$"main-ui/top-bar/search-bar".text += "q"
	if Input.is_action_just_pressed("r"):
		$"main-ui/top-bar/search-bar".text += "r"
	if Input.is_action_just_pressed("s"):
		$"main-ui/top-bar/search-bar".text += "s"
	if Input.is_action_just_pressed("t"):
		$"main-ui/top-bar/search-bar".text += "t"
	if Input.is_action_just_pressed("u"):
		$"main-ui/top-bar/search-bar".text += "u"
	if Input.is_action_just_pressed("v"):
		$"main-ui/top-bar/search-bar".text += "v"
	if Input.is_action_just_pressed("w"):
		$"main-ui/top-bar/search-bar".text += "w"
	if Input.is_action_just_pressed("x"):
		$"main-ui/top-bar/search-bar".text += "x"
	if Input.is_action_just_pressed("y"):
		$"main-ui/top-bar/search-bar".text += "y"
	if Input.is_action_just_pressed("z"):
		$"main-ui/top-bar/search-bar".text += "z"

func _process(delta):
	var isMenuVisible = false
	if Input.is_action_just_pressed("menu_button_pressed"):
		if tutorial_open:
			_on_close_tutorial_button_pressed()
		else:
			_on_menubutton_pressed()
	
	update_search_bar()
	
	var info_view = $"main-ui/info-view"
	if timer.is_stopped(): #If its been atleast 0.09 seconds
		if info_view.is_visible(): #if the menu is visible
			if Input.is_action_pressed("ui_up"):
				var selectedIndex = $"main-ui/info-view/poi-list-panel/MarginContainer/poi-list".get_selected_items()[0]
				if(selectedIndex > 0):
					update_building_selection(selectedIndex-1)
					timer.start()
				
			if Input.is_action_pressed("ui_down"):
				var selectedIndex = $"main-ui/info-view/poi-list-panel/MarginContainer/poi-list".get_selected_items()[0]
				var itemCount = $"main-ui/info-view/poi-list-panel/MarginContainer/poi-list".item_count
				if(selectedIndex < itemCount-1):
					update_building_selection(selectedIndex+1)
					timer.start()

var buildings = []
var selected_building = 0

func load_buildings() -> Array:
	var buildings_str = ""
	var buildings_file = FileAccess.open("res://rsc/buildings/buildings.json", FileAccess.READ)
	while buildings_file.get_position() < buildings_file.get_length():
		buildings_str += buildings_file.get_line()
	
	var json = JSON.new()
	var error = json.parse(buildings_str)
	
	var json_error = json.get_error_message()
	var json_line = json.get_error_line()
	
	if error == OK:
		var output = []
		for building_dict in json.data["Results"]:
			output.append(Building.new(
				String(building_dict.name),
				building_dict.funfacts,
				building_dict.image_url,
				building_dict.hours_of_operation,
				building_dict.address
			))
		output.sort_custom(func(a, b): return a.name.nocasecmp_to(b.name) < 0)
		return output
	else:
		print("JSON Parse Error: ", json.get_error_message(), " in ", buildings_str, " at line ", json.get_error_line())
		return []

# Called when the node enters the scene tree for the first time.
func _ready():
	buildings = load_buildings()
	add_child(timer)
	timer.wait_time = delay
	timer.one_shot = true
	
	# add buildings to poi-list in the menu
	for building in buildings:
		$"main-ui/info-view/poi-list-panel/MarginContainer/poi-list".add_item(building.name)
	
	# select first building
	update_building_selection(0)

func update_building_selection(index: int):
	selected_building = index
	$"main-ui/info-view/poi-list-panel/MarginContainer/poi-list".select(index)
	$"main-ui/info-view/poi-info-panel/MarginContainer/MarginContainer/ScrollContainer/poi-label".clear()
	label_driver(index)
	$"main-ui/info-view/poi-list-panel/MarginContainer/poi-list".ensure_current_is_visible()


func label_driver(index: int):

	var script = load("res://src/ImageHTTPRequest.gd")
	# Creating an instance to call a non-static method
	var instance = script.new()
	self.add_child(instance)
	
	var picture = instance.requestHTTP(buildings[index].image_url)#"https://via.placeholder.com/512"
	$"main-ui/info-view/poi-info-panel/MarginContainer/MarginContainer/ScrollContainer/poi-label".clear()
	$"main-ui/info-view/poi-info-panel/MarginContainer/MarginContainer/ScrollContainer/poi-label".bbcode_text = ("[center][b]" + buildings[index].name + "\n" + "[/b][/center]" +
	"[center]" + buildings[index].address + "[/center]" + "\n" + "[center] Usual hours of opperation: " + buildings[index].hours_of_operation + "[/center]" +"\n\n\n"+ "[left][b]" + "Fun facts about "+ buildings[index].name + ":" + "[/b]" + "\n" + buildings[index].desc + "[/left]")
	
func find_building(name: String	) -> int:
	for i in range(len(buildings)):
		var building_name_to_lower = buildings[i].name.to_lower()
		if building_name_to_lower.contains(name.to_lower()):
			return i
	return -1

func goto_building():
	$"../character".goto_building(buildings[selected_building].name)
	
	# reset ui state
	$"main-ui/top-bar/search-bar".clear()
	$"main-ui/info-view".visible = false

func _on_menubutton_pressed():
	if tutorial_open:
		return
	var info_view = $"main-ui/info-view"
	info_view.visible = !info_view.visible

func _on_poilist_item_selected(index):
	update_building_selection(index)

func _on_searchbar_text_changed(new_text):
	var building_id = find_building(new_text)
	if building_id != -1:
		update_building_selection(building_id)

func _on_searchbar_text_submitted(new_text):
	var building_id = find_building(new_text)
	if building_id != -1:
		selected_building = building_id
		goto_building()

func _on_gotopoibutton_pressed():
	goto_building()

var tutorial_open = true
func _on_close_tutorial_button_pressed():
	$"tutorial".visible = false
	tutorial_open = false
