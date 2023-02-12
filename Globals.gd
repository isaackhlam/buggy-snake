extends Node

var food_scene = preload("res://Food.tscn");
var snake_scene = preload("res://Snake.tscn");

var gameOver_scene = preload("res://GameOverOverlay.tscn")

onready var main = get_node("/root/main");
onready var snake = get_node("/root/main/Snake")
onready var highscore_label = get_node("/root/main/Label")

var grid_size = Vector2(20, 15)
var cell_size = 32;
var highscore = 0;

func eat_food():
	snake.add_segment();
	snake.get_node("EatFoodSound").play()
	highscore += 1;
	highscore_label.text = str(highscore).pad_zeros(2);
	place_food();

func place_food():
	var food = food_scene.instance();
	food.global_position = get_random_grid_pos();
	main.add_child(food);
	
func get_random_grid_pos():
	var possible_positions = [];
	for x in grid_size.x:
		for y in grid_size.y:
			possible_positions.append(Vector2(x * cell_size, y * cell_size))
			
	for segment in snake.segments:
		possible_positions.erase(segment.global_position);
	
	randomize();
	possible_positions.shuffle();
	var ramdon_pos = possible_positions[0];
	return ramdon_pos;

func reset_game():
	snake = snake_scene.instance()
	main.add_child(snake)
	reset_highscore();

func reset_highscore():
	highscore = 0;
	highscore_label.text = "00";

func game_over():
	snake.queue_free()
	var overlay = gameOver_scene.instance();
	main.add_child(overlay);

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
