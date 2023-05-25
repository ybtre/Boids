package main

import fmt "core:fmt"
import rl "vendor:raylib"

//@InProgress: start fps ~21
// -- ~27fps after removing for loops in ruleset
MAX_BOIDS :: 1000

dop_ish : bool = true 
// dop_ish : bool = false 
// oop_ish : bool = true 
oop_ish : bool = false

timer 	: f32 = 0
step 	: f32 = .0

flock_pow : f32 = .0003
align_pow : f32 = .03
avoid_pow : f32 = .006

neighbors : [dynamic]Boid