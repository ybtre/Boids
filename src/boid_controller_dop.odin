package main

import fmt "core:fmt"
import rl "vendor:raylib"
import "core:math"
import "core:time"

counter := 0

dop_ish_update :: proc()
{
	for i in 0..<MAX_BOIDS
	{
		// find_neighbors_dop();
		
		if should_flock
		{
			// flock(&boids[i], 100, flock_pow)
			flock_dop(i)
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

// find_neighbors_dop :: proc()
// {
// 	clear(&neighbors)
// }

flock_dop :: proc(ID : int)
{	
	using rl

	clear(&neighbors_posistions)
	for i in 0..<MAX_BOIDS
	{
		if boid_positions[ID] == boid_positions[i]
		{
			continue
		}
		d := get_dist_between_dop(ID, i)
		if d < 100
		{
			append(&neighbors_posistions, boid_positions[i])
		}

		if len(neighbors_posistions) > 0
		{
			mean : Vector2
			for p in neighbors_posistions
			{
				mean += p
			}

			mean.x = f32(mean.x / f32(len(neighbors_posistions)))
			mean.y = f32(mean.y / f32(len(neighbors_posistions)))

			dcx := mean.x - boid_positions[ID].x
			dcy := mean.y - boid_positions[ID].y

			boid_velocities[ID].x += dcx * flock_pow
			boid_velocities[ID].y += dcy * flock_pow
		}
	}
}

get_dist_between_dop :: proc(CURR, OTHER : int) -> f32
{
	d := boid_positions[OTHER] - boid_positions[CURR]
	dist := f32(math.sqrt(d.x * d.x + d.y * d.y))

	return dist
}

move_forward_dop :: proc(ID : int)
{
	speed := math.sqrt(boid_velocities[ID].x * boid_velocities[ID].y + boid_velocities[ID].x * boid_velocities[ID].y)
	if speed > 3
	{
		boid_velocities[ID] = boid_velocities[ID].x / speed * 3
		boid_velocities[ID] = boid_velocities[ID].y / speed * 3
	}
	else if speed < 1
	{
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
