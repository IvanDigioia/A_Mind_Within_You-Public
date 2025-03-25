extends StaticBody2D

var state = false #chiusa/aperta
var location = false #se il player si trova nell'area 2D a sinistra premere F aprirà la porta, se si trova a destra chiuderà la porta

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D
@onready var aperturaS : Label = $Node2D/Label
@onready var chiusuraD : Label = $Node2D/Label2
@onready var aperturaD : Label = $Node2D/Label3
@onready var chiusuraS : Label = $Node2D/Label4
@onready var open : CollisionShape2D = $CollisionShape2D

#il primo if funziona il secondo no
func _on_area_2d_body_entered(body):
	if(body is Player) and state == false: #la porta è chiusa e si cerca di aprire a sinsitra
		aperturaS.visible = true
		location = true
	elif (body is Player) and state == true: #la porta è aperta e si cerca di chiudere a sinistra
		chiusuraS.visible = true
		location = true
	else:
		chiusuraS.visible = false
		aperturaS.visible = false
		location = false

func _on_area_2d_body_exited(body):
	aperturaS.visible = false
	chiusuraS.visible = false

func _input(event):
	if event.is_action_pressed("Interagisci") and location == true and state == false and aperturaS.visible == true: #apertura a sinistra
		sprite.stop()
		sprite.play("Aperta")
		open.disabled = true
		state = true
	elif event.is_action_pressed("Interagisci") and location == true and state == true and chiusuraD.visible == true: #chiusura a destra
		sprite.stop()
		sprite.play("Chiusa")
		open.disabled = false
		state = false
	elif event.is_action_pressed("Interagisci") and location == true and state == false and aperturaD.visible == true: #apertura a destra
		sprite.stop()
		sprite.play("Aperta")
		open.disabled = true
		state = true
	elif event.is_action_pressed("Interagisci") and location == true and state == true and chiusuraS.visible == true: #chiusura a sinistra
		sprite.stop()
		sprite.play("Chiusa")
		open.disabled = false
		state = false
	else:
		pass


func _on_area_2d_2_body_entered(body):
	if (body is Player) and state == true: #la porta è aperta e la si cerca di chiudere da destra
		chiusuraD.visible = true
		location = true
	elif (body is Player) and state == false: #la porta è chiusa e la si cerca di aprire a destra
		aperturaD.visible = true
		location = true
	else:
		chiusuraD.visible = false
		aperturaD.visible = false
		location = false
	

func _on_area_2d_2_body_exited(body):
	chiusuraD.visible = false
	aperturaD.visible = false
