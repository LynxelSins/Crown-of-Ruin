extends CharacterBody3D

@export var speed_for = 14
@export var speed_back = 12
@export var jump_impulse = 20
@export var fall_acceleration = 75
@export var maxHP = 800
@export var ATK = 200
var ATKskill = ATK * 2

@onready var lucien = $Lucien
@onready var animation = $Lucien/AnimationPlayer
