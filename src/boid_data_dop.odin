package main

import fmt "core:fmt"
import rl "vendor:raylib"


boid_positions 		: [MAX_BOIDS]rl.Vector2
boid_velocities  	: [MAX_BOIDS]rl.Vector2
boid_rotation 		: f32 		: 0
boid_color			: rl.Color 	: C_GREEN

init_boids_dop :: proc()
{
	using rl
	
	for i in 0..<MAX_BOIDS
	{
		boid_positions[i].x = f32(GetRandomValue(0, i32(SCREEN.x)))
		boid_positions[i].y = f32(GetRandomValue(0, i32(SCREEN.y)))

		boid_velocities[i].x = f32(GetRandomValue(-5, 5)) - .5
		boid_velocities[i].y = f32(GetRandomValue(-5, 5)) - .5
	}
}