extends Area2D

@export var gridSize : int = 32

var mouseOver = false
var held = false
var pickupPoint : Vector2
var areasBelow : Array[Area2D]


func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	print(areasBelow)
	if held:
		var target = get_global_mouse_position() + pickupPoint
		if target:
			global_position = lerp(global_position, snapped(target, Vector2(gridSize, gridSize)), 10 * delta )


func _on_mouse_entered() -> void:
	mouseOver = true


func _on_mouse_exited() -> void:
	mouseOver = false


func _input_event(viewport: Viewport, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("MouseLeft"):
		if mouseOver:
			held = true
			pickupPoint = global_position - get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if event.is_action_released("MouseLeft"):
		held = false
	if event.is_action_pressed("RotateTetro"):
		if held:
			print('spin')
			rotation = rotation + deg_to_rad(90)


func _on_area_entered(area: Area2D) -> void:
	areasBelow.append(area)


func _on_area_exited(area: Area2D) -> void:
	areasBelow.erase(area)
