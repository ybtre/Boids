package main

import fmt "core:fmt"
import rl "vendor:raylib"
import "core:math"

oop_ish_update :: proc() 
{
	timer += rl.GetFrameTime()

	if timer > step
	{
		for _, i in boids
		{
			// if should_flock
			// {
			// 	flock(&boids[i], 100, flock_pow)
			// }
			// if should_align
			// {
			// 	align(&boids[i], 40, align_pow)
			// }
			// if should_avoid
			// {
			// 	avoid(&boids[i], 10, avoid_pow)
			// }

			all_rules(&boids[i])
	
			move_forward(&boids[i])
			if wrap
			{		
				wrap_boids(&boids[i])
			}
		}
		timer = 0
	}
	
}

all_rules :: proc(BOID : ^Boid)
{
	clear(&neighbors)
	for _, j in boids
	{
		if BOID^ == boids[j]
		{
			continue
		}
		t := get_dist_between(BOID^, boids[j])
		if t < 150
				{
			append(&neighbors, boids[j])	
		}
	}

	if len(neighbors) > 0
	{	
		for n in neighbors
		{
			flock_X += n.position.x
			flock_Y += n.position.y
			
			align_X += n.velocity.x
			align_Y += n.velocity.y
			
			close := 10 - get_dist_between(BOID^, n)
			closeX += (BOID.position.x - n.position.x) * close
			closeY += (BOID.position.y - n.position.y) * close
		}
		// {// flock()
			flock_X = f32(flock_X / f32(len(neighbors)))
			flock_Y = f32(flock_Y / f32(len(neighbors)))

			dflock_x := flock_X - BOID.position.x
			dflock_y := flock_Y - BOID.position.y

			BOID.velocity.x += dflock_x * flock_pow
			BOID.velocity.y += dflock_y * flock_pow
		// }

		// {// align
			align_X = f32(align_X / f32(len(neighbors)))
			align_Y = f32(align_Y / f32(len(neighbors)))

			dalign_x := align_X - BOID.velocity.x
			dalign_y := align_Y - BOID.velocity.y

			BOID.velocity.x += dalign_x * align_pow
			BOID.velocity.y += dalign_y * align_pow
		// }

		// {//aviod
			BOID.velocity.x += closeX * avoid_pow
			BOID.velocity.y += closeY * avoid_pow
		// }
	}
}

flock :: proc(BOID : ^Boid, DIST, POW : f32)
{
	clear(&neighbors)
	for _, j in boids
	{
		if BOID^ == boids[j]
		{
			continue
		}
		t := get_dist_between(BOID^, boids[j])
		if t < DIST
		{
			append(&neighbors, boids[j])	
		}
	}

	if len(neighbors) > 0
	{
		meanX : f32
		meanY : f32
		for n in neighbors
		{
			meanX += n.position.x
			meanY += n.position.y
		}
		meanX = f32(meanX / f32(len(neighbors)))
		meanY = f32(meanY / f32(len(neighbors)))

		dcx := meanX - BOID.position.x
		dcy := meanY - BOID.position.y

		BOID.velocity.x += dcx * POW
		BOID.velocity.y += dcy * POW
	}
}

align :: proc(BOID : ^Boid, DIST, POW : f32)
{
	clear(&neighbors)
	for _, j in boids
	{
		if BOID^ == boids[j]
		{
			continue
		}
		t := get_dist_between(BOID^, boids[j])
		if t < DIST
		{
			append(&neighbors, boids[j])	
		}
	}

	if len(neighbors) > 0
	{
		meanX : f32
		meanY : f32
		for n in neighbors
		{
			meanX += n.velocity.x
			meanY += n.velocity.y
		}
		meanX = f32(meanX / f32(len(neighbors)))
		meanY = f32(meanY / f32(len(neighbors)))

		dcx := meanX - BOID.velocity.x
		dcy := meanY - BOID.velocity.y

		BOID.velocity.x += dcx * POW
		BOID.velocity.y += dcy * POW
	}
}

avoid :: proc(BOID : ^Boid, DIST, POW : f32)
{
	clear(&neighbors)
	for _, j in boids
	{
		if BOID^ == boids[j]
		{
			continue
		}
		t := get_dist_between(BOID^, boids[j])
		if t < DIST
		{
			append(&neighbors, boids[j])	
		}
	}

	if len(neighbors) > 0
	{
		closeX : f32
		closeY : f32
		for n in neighbors
		{
			close := DIST - get_dist_between(BOID^, n)
			closeX += (BOID.position.x - n.position.x) * close
			closeY += (BOID.position.y - n.position.y) * close
		}

		BOID.velocity.x += closeX * POW
		BOID.velocity.y += closeY * POW
	}
}

get_dist_between :: proc(curr, other : Boid) -> f32
{
	dx := other.position.x - curr.position.x
	dy := other.position.y - curr.position.y
	dist := f32(math.sqrt(dx * dx + dy * dy))
	return dist
}

move_forward :: proc(BOID : ^Boid)
{
	speed := math.sqrt(BOID.velocity.x * BOID.velocity.y + BOID.velocity.x * BOID.velocity.y)
	if speed > 3
	{
		x := BOID.velocity.x / speed * 3
		y := BOID.velocity.y / speed * 3
		BOID.velocity = rl.Vector2{x, y}
	}
	else if speed < 1
	{
		x := BOID.velocity.x / speed * 3
		y := BOID.velocity.y / speed * 3
		BOID.velocity.x = x
		BOID.velocity.y = y
	}
	if BOID.velocity.x > 3
	{
		BOID.velocity.x = 3
	}
	if BOID.velocity.x < -3
	{
		BOID.velocity.x = -3
	}
	if BOID.velocity.y > 3
	{
		BOID.velocity.y = 3
	}
	if BOID.velocity.y < -3
	{
		BOID.velocity.y = -3
	}
	BOID.position += BOID.velocity * rl.GetFrameTime() * 10
}

wrap_boids :: proc(BOID : ^Boid)
{
	if BOID.position.x < (0 + PLAY_AREA)
	{
		BOID.position.x = SCREEN.x - PLAY_AREA
	}
	if BOID.position.x > SCREEN.x - PLAY_AREA
	{
		BOID.position.x = 0 + PLAY_AREA
	}
	if BOID.position.y < (0 + PLAY_AREA)
	{
		BOID.position.y = SCREEN.y - PLAY_AREA
	}
	if BOID.position.y > SCREEN.y - PLAY_AREA
	{
		BOID.position.y = 0 + PLAY_AREA
	}
}
