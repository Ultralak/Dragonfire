class_name GameInputEvents
extends Node

static func movement_input() -> float:
	var direction : float  =  Input.get_axis("move_left", "move_right"	)
	return direction

static func jump_input() -> bool:
	var jump_ : bool = Input.is_action_just_pressed("jump")
	return jump_
	
static func shoot_input() -> bool:
	var shoot_ : bool = Input.is_action_pressed("shoot")
	return shoot_
	
static func shoot_up_input() -> bool:
	var shoot_ : bool = Input.is_action_just_pressed("shoot")
	var up_input :  bool = Input.is_action_pressed("look_up")
	return shoot_ and up_input

static func crouch_input() -> bool:
	var crouch_ : bool = Input.is_action_just_pressed("crouch")
	return crouch_

static func slash_input() -> bool:
	var slash : bool = Input.is_action_just_pressed("slash")
	return slash
	
static func fall_input() -> bool:
	var fall_ : bool = Input.is_action_just_pressed("force_fall")
	return fall_
	
static func wall_cling_input() -> bool:
	var wall_cling_ : bool = Input.is_action_pressed("wall_cling")
	return wall_cling_
static func dash_input() -> bool:
	var dash_pressed : bool = Input.is_action_just_pressed("dash")
	return dash_pressed	
		
