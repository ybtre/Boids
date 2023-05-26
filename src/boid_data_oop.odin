package main

import fmt "core:fmt"
import rl "vendor:raylib"

Boid :: struct
{
	position 	: rl.Vector2,
	velocity 	: rl.Vector2,
	rotation 	: f32,
	color 		: rl.Color,
}

//@InProgress: start fps ~21
// -- ~27fps after removing for loops in ruleset
boids : [MAX_BOIDS]Boid

wrap : bool = true
bounce : bool = false
should_flock : bool = true
should_align : bool = true
should_avoid : bool = true

flock_X : f32
flock_Y : f32

align_X : f32
align_Y : f32

closeX : f32
closeY : f32
init_boids_oop :: proc()
{
	using rl
	
	for _, i in boids
	{
		boids[i].position.x = f32(GetRandomValue(0 , i32(SCREEN.x)))
		boids[i].position.y = f32(GetRandomValue(0, i32(SCREEN.y)))

		boids[i].velocity.x = f32(GetRandomValue(-5, 5)) - .5
		boids[i].velocity.y = f32(GetRandomValue(-5, 5)) - .5
		boids[i].rotation = 0

		// boids[i].color = C_GREEN
		boids[i].color = Color { u8(GetRandomValue(100, 255)), u8(GetRandomValue(100, 255)), u8(GetRandomValue(100,255)), 255}		
	}
}