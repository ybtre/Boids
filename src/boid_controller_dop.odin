package main

import fmt "core:fmt"
import rl "vendor:raylib"
import "core:math"

dop_ish_update :: proc()
{
	for i in 0..<MAX_BOIDS
	{
		if should_flock
		{
			// flock(&boids[i], 100, flock_pow)
			flock_dop()
		}
		if should_align
		{
			// align(&boids[i], 40, align_pow)
		}
		if should_avoid
		{
			// avoid(&boids[i], 10, avoid_pow)
		}

		// all_rules(&boids[i])

		move_forward_dop(i)
		if wrap
		{		
			 wrap_boids_dop(i)
		}
	}
}

flock_dop :: proc()
{
	
}

move_forward_dop :: proc(ID : int)
{
	speed := math.sqrt(boid_velocities[ID].x * boid_velocities[ID].y + boid_velocities[ID].x * boid_velocities[ID].y)
	if speed > 3
	{
		// x := boid_velocities[ID].x / speed * 3
		boid_velocities[ID] = boid_velocities[ID].x / speed * 3
		// y := boid_velocities[ID].y / speed * 3
		boid_velocities[ID] = boid_velocities[ID].y / speed * 3
		// boid_velocities[ID] = rl.Vector2{x, y}
	}
	else if speed < 1
	{
		// x := boid_velocities[ID].x / speed * 3
		// y := boid_velocities[ID].y / speed * 3
		// boid_velocities[ID].x = x
		// boid_velocities[ID].y = y
		boid_velocities[ID] = boid_velocities[ID].x / speed * 3
		boid_velocities[ID] = boid_velocities[ID].y / speed * 3
	}
	if boid_velocities[ID].x > 3
	{
		boid_velocities[ID].x = 3
	}
	if boid_velocities[ID].x < -3
	{
		boid_velocities[ID].x = -3
	}
	if boid_velocities[ID].y > 3
	{
		boid_velocities[ID].y = 3
	}
	if boid_velocities[ID].y < -3
	{
		boid_velocities[ID].y = -3
	}
	boid_positions[ID] += boid_velocities[ID] * rl.GetFrameTime() * 10
}

wrap_boids_dop :: proc(ID : int)
{
	if boid_positions[ID].x < (0 + PLAY_AREA)
	{
		boid_positions[ID].x = SCREEN.x - PLAY_AREA
	}
	if boid_positions[ID].x > SCREEN.x - PLAY_AREA
	{
		boid_positions[ID].x = 0 + PLAY_AREA
	}
	if boid_positions[ID].y < (0 + PLAY_AREA)
	{
		boid_positions[ID].y = SCREEN.y - PLAY_AREA
	}
	if boid_positions[ID].y > SCREEN.y - PLAY_AREA
	{
		boid_positions[ID].y = 0 + PLAY_AREA
	}
}
