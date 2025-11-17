# Tech Context: "Screams Into the Void" (working title)

## Technologies used

- **Engine**: Godot 4.5.1+ (using GDScript)
- **Build system**: Godot's built-in export system
- **Version control**: Git (with .gitignore for build artifacts)
- **Testing**: GdUnit4 for unit testing core logic
- **Code formatting**: EditorConfig with auto-formatting on save

## Development setup

- Project structure follows Godot best practices with clear separation of concerns:
    - `main/` - Main game logic and state management
    - `player/` - Player character and control systems
    - `Asteroid/` - Asteroid Resource generation and management
    - `ui/` - User interface components
    - `Shaders/` - Custom visual effects
    - `test/` - Unit tests
    - `addons/` - Third-party tools and plugins

- Configuration files:
    - `.editorconfig` - Code style consistency
    - `mise.toml` - Project-specific tool versions
    - `taplo.toml` - TOML file formatting
    - `project.godot` - Godot project settings

## Technical constraints

- Must maintain backward compatibility with save files across versions
- Performance constraints for mobile devices (optimized particle systems)
- Limited by Godot's GDScript performance for complex calculations. This shoulddn't be a problem.
- Memory constraints for long gameplay sessions

## Tool usage patterns

- Use `trunk check` to run linting and static analysis.
- Use `trunk fmt` to auto-correct linting and formatting issues.
- Use `mise test` to run unit tests outside of Godot with GdUnit4.
- Use `mise bump` to increment version numbers.
- Use `mise no-n-a-r-f` to check for forbidden patterns in code.
- Use `godot` command to open projects in Godot Engine.
- Use `code` command to open project in VSCode.
- Use `git` commands for version control and collaboration.
- Use `npm` for any external tooling (if needed)
