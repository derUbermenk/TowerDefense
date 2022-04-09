extends Node2D
class_name Turret

var type
var enemy_array = []
var built = false
var enemy

func _ready():
	if built:
		get_node("Range/CollisionShape2D").get_shape().radius = 0.5 * GameData.tower_data[type]["range"]


func _physics_process(delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn() 
	else:
		enemy = null

func turn():
	get_node("Turret").look_at(enemy.position)

func select_enemy(): 
	var enemy_progress_array = [] # collection of the offsets of the enemies inside range
	for i in enemy_array:
		enemy_progress_array.append(i.offset)
	
	var max_offset = enemy_progress_array.max() 						# find the max offset in the enemy_progress_array
	var enemy_index = enemy_progress_array.find(max_offset) # get the index of the max offset
	enemy = enemy_array[enemy_index]  											# enemy index and enemy max offset index is same

func _on_Range_body_entered(body):
	# body is the kinematic body of the tank
	# need to track the pathfollow 2d which is the parent node
	# 	representing a tank
	enemy_array.append(body.get_parent())

func	_on_Range_body_exited(body):
	enemy_array.erase(body.get_parent())
