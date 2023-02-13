extends Node2D

var bodyPart = preload("res://bodyPart.tscn")
onready var head = get_node("headPart")
var direction = Vector2(0, 1);
var segments = [];


# Called when the node enters the scene tree for the first time.
func _ready():
	global_position = Vector2(288, 160)
	
	segments.append(head);
	
	for i in 3:
		var new_part = bodyPart.instance();
		segments.append(new_part);
		add_child(new_part);


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		direction = Vector2(0, 1);
	if Input.is_action_just_pressed("ui_up"):
		direction = Vector2(0, -1);
	if Input.is_action_just_pressed("ui_right"):
		direction = Vector2(1, 0);
	if Input.is_action_just_pressed("ui_left"):
		direction = Vector2(-1, 0);
		
	if Input.is_action_just_pressed("ui_accept"):
		add_segment()

func update_positions():
	for x in range(segments.size() - 1, -1, -1):
		if x == 0:
			segments[x].global_position += direction * 32;
		else:
			segments[x].global_position = segments[x - 1].global_position;

func get_head_position():
	return segments[0].global_position;
	
func check_bounds():
	var head_pos = get_head_position()
	var cell_size = Globals.cell_size;
	var grid_size = Globals.grid_size;
	
	if head_pos.x >= grid_size.x * cell_size:
		segments[0].global_position.x = 0;
	if head_pos.x < 0:
		segments[0].global_position.x = (grid_size.x - 1) * cell_size;
	if head_pos.x >= grid_size.y * cell_size:
		segments[0].global_position.y = 0;
	if head_pos.y < 0:
		segments[0].global_position.y = (grid_size.y - 1) * cell_size;

func check_game_over():
	for i in range(1, segments.size(), 1):
		if segments[i].global_position == get_head_position():
				print("Game Over");
				Globals.game_over();

func add_segment():
	var new_part = bodyPart.instance();
	
	segments.append(new_part);
	add_child(new_part);
	new_part.global_position = Vector2(-64, -64);

func _on_Timer_timeout():
	pass # Replace with function body.
	update_positions()
	check_bounds()
	check_game_over()
