package main

import fmt "core:fmt"
import rl "vendor:raylib"

render_boids :: proc()
{
	using rl
	
	for _, i in boids
	{
		DrawRectangleLinesEx(rl.Rectangle{boids[i].position.x, boids[i].position.y, 2, 2}, 2, boids[i].color)
		// DrawRectangleRec(rl.Rectangle{boids[i].position.x, boids[i].position.y, 10, 10}, boids[i].color)	
		// 1-2 less fps with circles compared to rects
		// DrawCircle(i32(boids[i].position.x), i32(boids[i].position.y), 5, boids[i].color)
	}
}
