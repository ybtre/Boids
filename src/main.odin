package main

import fmt "core:fmt"
import "core:math"
import la "core:math/linalg"
import "core:strconv"
import rl "vendor:raylib"
import "core:strings"

main :: proc() {
	using rl
	
	SetRandomSeed(42)

	InitWindow(i32(SCREEN.x), i32(SCREEN.y), strings.clone_to_cstring(project_name))
	// SetTargetFPS(60)
	is_running: bool = true;

	if oop_ish
	{
		init_boids_oop()
	}

	if dop_ish
	{
		init_boids_dop()
	}
	flock := Rectangle{200, 20, 50, 50}
	align := Rectangle{300, 20, 50, 50}
	avoid := Rectangle{400, 20, 50, 50}
	for is_running && !WindowShouldClose()
	{
		{// UPDATE

			update_boids()

			if CheckCollisionPointRec(GetMousePosition(), flock)
			{
				if IsMouseButtonDown(MouseButton.LEFT)
				{
					flock_pow += 0.0001
				}
				if IsMouseButtonDown(MouseButton.RIGHT)
				{
					flock_pow -= 0.0001
				}
			}
			if CheckCollisionPointRec(GetMousePosition(), align)
			{
				if IsMouseButtonDown(MouseButton.LEFT)
				{
					align_pow += 0.01
				}
				if IsMouseButtonDown(MouseButton.RIGHT)
				{
					align_pow -= 0.01
				}
			}
			if CheckCollisionPointRec(GetMousePosition(), avoid)
			{
				if IsMouseButtonDown(MouseButton.LEFT)
				{
					avoid_pow += 0.001
				}
				if IsMouseButtonDown(MouseButton.RIGHT)
				{
					avoid_pow -= 0.001
				}
			}
		}

		{// RENDER
			BeginDrawing()
			ClearBackground(C_DARK_BLUE)

				DrawText(strings.clone_to_cstring(fmt.tprintf("%.3f", GetFrameTime())), 10, 40, 40, C_LIGHT_BLUE)
				DrawText(strings.clone_to_cstring(fmt.tprintf("%d", GetFPS())), 10, 80, 40, C_LIGHT_BLUE)
				DrawText(strings.clone_to_cstring(fmt.tprintf("%.4f", flock_pow)), 10, 120, 40, C_LIGHT_BLUE)
				DrawText(strings.clone_to_cstring(fmt.tprintf("%.2f", align_pow)), 10, 160, 40, C_LIGHT_BLUE)
				DrawText(strings.clone_to_cstring(fmt.tprintf("%.3f", avoid_pow)), 10, 200, 40, C_LIGHT_BLUE)

				{//Objects Render

					render_boids()
					DrawRectangleLinesEx(Rectangle{
					PLAY_AREA, PLAY_AREA,
					SCREEN.x - PLAY_AREA*2, SCREEN.y - PLAY_AREA*2}, 
					3,
					C_MID_BLUE)

					DrawCircle(i32(SCREEN.x - PLAY_AREA), i32(SCREEN.y - PLAY_AREA), 15, C_MID_BLUE)

					DrawRectangleRec(flock, C_GREEN)
					DrawRectangleRec(align, C_GREEN)
					DrawRectangleRec(avoid, C_GREEN)
				}
			EndDrawing()
		}
	}
}