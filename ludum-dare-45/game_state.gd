extends Node

# Constants 
var HOUSE_COST = 10
var LAUNCH_COST = 100

var TRANSIT_TIME = 10
var HOUSE_CAP = 10
var MINE_RATE = 3
var MINE_SPEED = 3
var LAUNCH_RATE = 0.5
var MAX_LAUNCH_TIME = 10
var DEATH_RATE = 1

var PAYLOAD = LAUNCH_COST - 50
var CONV = 0.2

var resources
var population
var num_engineer
var num_worker
var num_scientist
var num_civilian

var earth_resources

var num_houses
var num_rockets

var request_engineer
var request_worker
var request_scientist

var civ_load

var has_played = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()

func reset():
	resources = 0
	population	= 0
	num_engineer = 0
	num_worker = 0
	num_scientist = 0
	num_civilian = 0
	
	earth_resources = 100
	
	num_houses = 1
	num_rockets = 0
	
	request_engineer = 0
	request_worker = 0
	request_scientist = 0
	
	civ_load = 2

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
