# Asteroid System Implementation TODO

## Analysis Complete ✅
- [x] Explored existing codebase structure
- [x] Found existing asteroid spawning system in main.gd
- [x] Identified player movement and positioning system
- [x] Located asteroid assets in Planets/Asteroids/

## Current Status
The game already has a basic asteroid spawning system that:
- Spawns asteroids using a Timer (0.5s interval)
- Uses Path2D for spawn locations
- Creates asteroids from Planets/Asteroids/Asteroid.tscn
- Gives random velocity and direction

## Required Improvements
- [x] Modify spawning to favor top-to-bottom movement (bulk of asteroids)
- [x] Add small percentage of asteroids with different trajectories
- [x] Implement tunable variable for player interception targeting
- [x] Improve spawn positioning to ensure off-screen spawning
- [ ] Test and tune parameters (ready for manual testing)

## Implementation Completed ✅
1. ✅ Analyzed current asteroid spawning logic
2. ✅ Modified main.gd to implement directional spawning preferences
3. ✅ Added Global variables for player interception percentage and top-down bias
4. ✅ Updated spawning logic to target player when needed
5. ⏳ System ready for testing and refinement

## New System Features
- **Top-down bias**: 70% of asteroids spawn from top (configurable via `Global.asteroid_top_down_bias`)
- **Player targeting**: 30% of asteroids target player position (configurable via `Global.asteroid_player_intercept_chance`)
- **Multi-directional spawning**: Remaining asteroids spawn from left, right, or bottom edges
- **Off-screen spawning**: All asteroids spawn 100 pixels outside visible area
- **Smart targeting**: Intercepting asteroids calculate direct path to player position
