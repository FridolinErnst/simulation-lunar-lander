extends Control


var gravity: float = -1.625
var landing_speed: float = 20.0
var fuel: float = 100.0
var thrust: float = 15000.0

signal options_applied()
signal level_changed(level_name: String)
signal game_paused(paused : bool)
