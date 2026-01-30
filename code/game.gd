extends Node

var Player: CharacterBody3D
var Camera: Node3D
var Area: AreaNode
var hidden:= false

func game_over():
	OS.alert("You got caught!!!")
	Player.position = Vector3.ZERO
