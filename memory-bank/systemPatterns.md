# System Patterns: "Screams Into the Void" (working title)

## System architecture

- Modular Godot project with distinct scenes for:
  - Main game loop (main/main.tscn)
  - Player character (player/player.tscn)
  - Resource spawning (Asteroid/asteroid.tscn)
  - UI (ui/hud/, ui/options/, ui/pause/)
  - Current Window State management (main/options_state.gd, main/pause_state.gd, main/play_field_state.gd)

- Component-based design using GDScript:
  - Core systems: ResourceManager, UpgradeSystem, PrestigeSystem, SaveSystem
  - Utility modules: NumberTools, ResourceTools, StateMachine
  - Active gameplay: InputManager, Pointer, Player

## Key technical decisions

- Use of Godot's built-in scene system for modularity and reusability.
- Implement versioned save data with migration paths for graceful updates.
- Separate save data into multiple files (savegame.json, memory_nodes.json) for better data management.
- Use of custom shaders (Shaders/) for visual effects like dissolving and particle rendering.
- Use of GdScript drawing for asteroids because it looks cool and is fun. It's also performant and can allow a lot of variety with minimal resources.
- Leverage Godot's built-in signal system for event-driven communication between components.

## Design patterns in use

- Observer pattern for UI updates (resource changes, state changes).
- State pattern for managing game states (play, pause, options).
- Factory pattern for creating different types of asteroids and nanobots.
- Singleton pattern for global systems (Global.gd).

## Critical implementation paths

1. Resource gathering pipeline:
   - Asteroid spawning → Player interaction → Resource collection → Storage → Upgrade consumption

2. Prestige system:
   - Player reaches prestige threshold → Save current state → Convert resources to memory nodes → Reset game state → Apply memory nodes

3. Save/load system:
   - Serialize core data to JSON → Version control → Migration scripts → Load on startup

4. Narrative integration:
   - Memory fragments tied to prestige milestones → Displayed in UI → Converted to permanent bonuses
