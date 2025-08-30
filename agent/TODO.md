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
- [ ] Modify spawning to favor top-to-bottom movement (bulk of asteroids)
- [ ] Add small percentage of asteroids with different trajectories
- [ ] Implement tunable variable for player interception targeting
- [ ] Improve spawn positioning to ensure off-screen spawning
- [ ] Test and tune parameters

## Implementation Plan
1. Analyze current asteroid spawning logic
2. Modify main.gd to implement directional spawning preferences
3. Add Global variable for player interception percentage
4. Update spawning logic to target player when needed
5. Test and refine the system
