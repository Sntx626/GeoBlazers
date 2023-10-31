extends Node

func requestHTTP(URL):
	# Create an HTTP request node and connect its completion signal.
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	var response = http_request.request(URL)
	
	return response

func _http_request_completed(result, response_code, headers, body):
	#On completion, make image into label compatible format
	if result != HTTPRequest.RESULT_SUCCESS:
		print('g')
		push_error("Image couldn't be downloaded. Try a different image.")

	var image = Image.new()
	#Only jpg or png
	var error = image.load_jpg_from_buffer(body)
	if error != OK:
		error = image.load_png_from_buffer(body)

	#Sizing
	var viewport_size = get_viewport().size
	var new_width = 500 * viewport_size.x * 0.00099  #For responsiveness
	var new_height = 300 * viewport_size.y * 0.00099  
	image.resize(new_width, new_height)
	var texture = ImageTexture.create_from_image(image)
	
	var script1 = load("res://src/ui.tscn").instantiate()
	var script2 = get_node("../main-ui/info-view/poi-info-panel/MarginContainer/MarginContainer/ScrollContainer/poi-label")
	
	#Reset image without deleting text
	var text = script2.text
	script2.clear()
	var split_index = text.find("[left][b]")
	var first_part = text.substr(0, split_index)
	var second_part = text.substr(split_index + 0, text.length() - split_index - 14)
	script2.append_text(first_part)
	script2.append_text('[center]')
	script2.add_image(texture)
	script2.append_text(second_part)
	script2.add_text("\n\n\n")
