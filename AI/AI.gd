extends Control

@onready var input: TextEdit = $Panel/VBoxContainer/TextEdit
@onready var Vbox: VBoxContainer = $Panel2/ScrollContainer/VBoxContainer
@onready var scroll: ScrollContainer = $Panel2/ScrollContainer
@onready var invio: Button = $Panel/VBoxContainer/HBoxContainer/Button
@onready var chiusura: Button = $Panel/VBoxContainer/HBoxContainer/Button2
var url := "http://localhost:5000/send"
var http := HTTPRequest.new()
var last_label: Label = null

func _ready():
	add_child(http)
	http.request_completed.connect(_on_request_completed)
	invio.pressed.connect(_on_button_pressed)  # Collega il pulsante alla funzione
	creaLabel(2, "Fermo tu! identificati e non fare un altro passo altrimenti aprirò il fuoco!")

func _on_button_pressed():
	send_message()
	input.clear()

func send_message():
	var message = input.text.strip_edges()
	
	var headers = ["Content-Type: application/json"]
	var body = JSON.stringify({"message": message})
	var error = http.request(url, headers, HTTPClient.METHOD_POST, body)
	
	if error != OK:
		creaLabel(3, "Errore nell'invio della richiesta!")
	else:
		creaLabel(1, message)
		Feedback()

func _on_request_completed(result, response_code, headers, body):
	var response_text = body.get_string_from_utf8()
	var json = JSON.new()
	var parse_result = json.parse(response_text)
	
	print("Codice risposta HTTP:", response_code)
	print("Corpo della risposta:", body.get_string_from_utf8())
	
	if parse_result == OK:
		var response_data = json.data
		if "status" in response_data and response_data["status"] == "success":
			rimuovi()
			creaLabel(2, response_data["response"])
		else:
			creaLabel(4, "Errore nella risposta dal server!")
	else:
		creaLabel(3, "Errore nel parsing della risposta!")

func _on_button_2_pressed():
	var guardia = get_parent()
	if guardia and guardia.has_method("sblocca"):
		guardia.sblocca()
	
	self.visible = false

func creaLabel(Soggetto, Text):
	var label = Label.new()
	if (Soggetto == 1):
		label.text = "Player: " + Text
	elif  (Soggetto == 2):
		label.text = "NPC: " + Text
	elif (Soggetto == 3):
		label.text = "Interfaccia: " + Text
	elif (Soggetto == 4):
		label.text = "Server:" + Text
	
	label.autowrap_mode = TextServer.AutowrapMode.AUTOWRAP_WORD
	label.size_flags_horizontal = Control.SIZE_EXPAND_FILL  # Occupa tutto lo spazio disponibile
	label.custom_minimum_size.x = 700  # larghezza della label
	
	Vbox.add_child(label)

func Feedback():
	var label = Label.new()
	label.text = "--ATTENDI RISPOSTA--"
	Vbox.add_child(label)
	last_label = label

func rimuovi():
	if last_label:
		Vbox.remove_child(last_label)  # Rimuove l'ultima label
		last_label.queue_free()  # Rimuove definitivamente la label dalla memoria
		last_label = null  # Reset della variabile


