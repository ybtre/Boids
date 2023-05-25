package main

import fmt "core:fmt"
import rl "vendor:raylib"

render_boids :: proc()
{
	using rl


	if oop_ish
	{	
		for _, i in boids
		{
			DrawRectangleLinesEx(rl.Rectangle{boids[i].position.x, boids[i].position.y, 2, 2}, 2, boids[i].color)
			// DrawRectangleRec(rl.Rectangle{boids[i].position.x, boids[i].position.y, 10, 10}, boids[i].color)	
			// 1-2 less fps with circles compared to rects
			// DrawCircle(i32(boids[i].position.x), i32(boids[i].position.y), 5, boids[i].color)
		}
	}

	if dop_ish
	{
		for i in 0..<MAX_BOIDS
		{
			DrawRectangleLinesEx(Rectangle{boid_positions[i].x, boid_positions[i].y, 2, 2}, 2, boid_color)	
		}
	}
}
