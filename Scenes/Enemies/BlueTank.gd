extends PathFollow2D

signal base_damage(damage)

var speed = 150
var hp = 1000
var base_damage = 21

onready var health_bar = get_node("HealthBar")
onready var impact_area = get_node("Impact") # onready instantiate this var
																						 # this is onready because the node is only ready
																						 # once this node is ready
var projectile_impact = preload("res://Scenes/SupportScenes/ProjectileImpact.tscn")

func _ready():
	health_bar.max_value = hp
	health_bar.value = hp
	
	# disconnect healthbar from parent
	# 	this is to avoid rotation with parent
	health_bar.set_as_toplevel(true)

func _physics_process(delta):
	if unit_offset == 1.0: ## if at the end of the path
		emit_signal("base_damage", base_damage) # emit signal with data base_damage
		queue_free()
	move(delta)

func move(delta):
	set_offset(get_offset() + speed * delta)  # *_offset defines how much pixels in the path has been traveled
																				    # unit offset relative position relative to total number of pixels in path
	health_bar.set_position(position - Vector2(30, 30))
	# disconnecting from parent resets health_bar's
	# position to origin. substracting 30, 30 to the position
	# adds the effect once again of the health bar being offset

func on_hit(damage):
	impact()
	hp -= damage
	health_bar.value = hp
	if hp <= 0:
		on_destroy()

func impact():
	randomize() # randomize the seed of random number generator
							# for each call.
							# not calling randomize makes the random number generator
							# return same numbers for each call

	var x_pos = randi() % 31 # return a number between 0 and 31
	randomize()
	var y_pos = randi() % 31 # return a number between 0 and 31
	var impact_location = Vector2(x_pos, y_pos) 
	var new_impact = projectile_impact.instance()
	new_impact.position = impact_location 

	impact_area.add_child(new_impact) # add impact to the impact_area
																		# this makes the impact area the anchor of new_impact
																		# which in means that the position of impact_area (-15, -15)
																		# is considered as 0,0 by the new_impact
																		# 
																		# from y_pos and x_pos, we know that we are only returning 
																		# numbers from 0, 30. Therefore for extreme cases, new_impact
																		# can only be located at most at 15,15 in the global viewport.
	
func on_destroy():
	get_node("KinematicBody2D").queue_free() # delete the kinematic body first
																					 # this makes turret not point to the kinematic body
																					 # anymore
																					 # but the tank sprite remains in the map
	yield(get_tree().create_timer(0.2), "timeout") # wait for sometime before deleting the tanks sprite
	self.queue_free()
