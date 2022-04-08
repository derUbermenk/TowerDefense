# alternatively we could do:
# extends res://Scenes/Turrets/Turrets.gd
# but defining a class name makes the turret script global
extends Turret 

# this means that the GunT1 scene has access to the functions defined
# in the Turret class 
