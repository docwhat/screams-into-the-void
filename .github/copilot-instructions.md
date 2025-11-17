# Screams Into The Void — Copilot instructions for AI coding agents

This file gives focused, actionable guidance for an AI code assistant to be productive in this repository.

## High-level facts

- **Engine**: Godot 4.5+ using GDScript.
- **Task runner**: `mise` is required (used in CI and all major workflows).
- **Linting/formatting**: `trunk` (git hook manager, linter, and formatter) handles all linting and code style. It is configured via `.trunk/trunk.yaml` and excludes `addons/**`.
- **Testing**: `addons/gdUnit4` provides unit tests; run via `mise test`.
- **License**: CC-by-nc-nd 4.0 (restrictive — read LICENSE before proposing major changes).

## Quick start (what to run locally)

- Install prerequisites: `mise install` (from repo root).
- Open editor: `mise godot` to launch Godot editor (or `mise game` to run the game task).
- Run tests: `mise test` — invokes gdUnit4 test harness.
- Lint code: `trunk check` — validates all files (gdscript, markdown, toml, pkl, yaml) and offers to fix some problems automatically.
- Fix code style: `trunk fmt` — auto-fixes linting/formatting issues (runs on pre-commit by default).
- Export builds: `mise export-all` or `mise export-web` (see `README.md` for platform-specific tasks).

## Big-picture architecture (what to read first)

### Core systems

- **`main/main.gd`** — Entry point. Initializes `Global` singleton, disables 3D rendering, spawns `AsteroidLauncher` on first process frame.
- **`global.gd` & `global.tscn`** — Project global state. Contains `play_field`, `player_node`, `viewport`, `rng`, and gameplay configuration (asteroid spawn rates, colors, debug flags). Access via `Global.*`.
- **`game_save.gd`** — Persistent settings and save data (not loaded at startup, but holds exportable properties like `use_symbols`, number formatting). Emits signals on changes (e.g., `use_symbols_changed`).
- **Domain folders** (`Asteroid/`, `Absorber/`, `player/`) — Gameplay entities; each has scene + GDScript files. Example: `Asteroid/asteroid.gd` has dissolve logic, matter bags, and noise-based visuals.

### Data layer

- **`MatterBag`** — Resource class managing Matter composition (a typed dictionary `Dictionary[Matter, int]`). Emits `matter_changed` signal on updates. Used for resource inventory and asteroid composition.
- **`Matter`** — Enum-like class defining element types (Carbon, Water, etc.) with `by_name` lookup and `all_matter` list for iteration.
- **`Molecule`** — Represents compound matter (combinations of elements, not yet heavily used in core loop).

## Common patterns and repository conventions

### Naming conventions

- **Directories**: Use lowercase `snake_case` for new directories (e.g., `asteroid_kinds/`, `game_states/`). Note: existing directories use PascalCase (`Asteroid/`, `Absorber/`) but this will be migrated over time.
- **Files**: Use lowercase with underscores for GDScript files (e.g., `asteroid_launcher.gd`, `game_save.gd`).
- **Classes**: Use PascalCase (e.g., `AsteroidLauncher`, `MatterBag`).
- **Functions/Variables**: Use snake_case (e.g., `decrement_asteroid_count()`, `player_node`).

### Scene-first, small-node scripts

Each entity lives in its own folder with a `.tscn` (scene) and `.gd` (script). **Prefer editing scenes in Godot** to wire nodes — use `@onready %NodeName` to reference uniquely-named nodes.

**Example**: `Asteroid/asteroid.tscn` contains `Polygon2D` (shape), `Line2D` (outline), `CollisionPolygon2D`; `Asteroid/asteroid.gd` accesses them via `@onready var shape: Polygon2D = %Shape`.

### Global singleton pattern

`global.gd` holds shared state (gameplay config, RNG seed, node references). **Modify carefully**:

- Prefer getters/setters over direct assignment.
- Reference via `Global.*` (e.g., `Global.player_node`, `Global.asteroid_max`).
- Debug flags in `@export_group` are inspectable in Godot editor.

**Example**: `Global.rng` is initialized and seeded in `main/main.gd`; use `Global.rng.randi_range()` for deterministic randomness in tests.

### Input system (GUIDE addon)

Centralized input via `main/input_manager.gd` using `GUIDEMappingContext` and `GUIDEAction` (from `addons/guide/`). **Do not use raw `Input.is_action_pressed`** in gameplay code.

**Example**: `action_pause_or_back.triggered.connect(current_window.pause_or_back)` connects signals rather than polling.

### Exported properties & signals

Settings use `@export` with setters that emit signals for reactivity.

**Example** (from `game_save.gd`):

```gdscript
signal use_symbols_changed
@export var use_symbols: bool = false:
 set(value):
  use_symbols = value
  use_symbols_changed.emit()
```

Mirror this pattern when adding new settings. Tests should verify signal emission.

### Save system

Project aims for versioned, multi-file saves (see `memory-bank/projectbrief.md`). **Changes to save structures require**:

1. Migration routine (old → new format).
2. Unit tests covering both formats.
3. Documentation in the PR description.

## Integration points & external tools

- **mise** — primary developer task runner & installer (listed in `README.md`). All CI tasks use it. Tasks are defined in `mise.toml`.
- **trunk** — hook manager for linting/formatting, configured in `.trunk/trunk.yaml`. Excludes `addons/**` automatically. Runs on pre-commit (with `fix = true`).
- **Godot** — edit scenes and run the project. Use the editor to inspect exported properties and node paths before changing code that expects a certain scene layout.
- **gdUnit4** — unit test framework located in `addons/gdUnit4`. Tests extend `GdUnitTestSuite`; use `before_test()` / `after_test()` for setup/teardown.

## Example reference snippets to follow (do not change without local testing)

- **Starting behaviour**: `main/main.gd` creates `AsteroidLauncher` and calls `start()` after process frame. Prefer this pattern for systems that must attach at runtime.
- **Input wiring**: `main/input_manager.gd` connects `action_pause_or_back.triggered` to `current_window.pause_or_back`. Use `triggered.connect(...)` rather than ad-hoc polling for those actions.
- **Settings pattern**: `game_save.gd` exposes `@export var use_symbols: bool` and emits `use_symbols_changed` in the setter — mirror this approach when creating new settings.
- **Resource signals**: `MatterBag.matter_changed` signal is emitted whenever contents change. Connect to this signal for reactive updates instead of polling.
- **Testing pattern** (from `test/test_matter_bag.gd`):

    ```gdscript
    extends GdUnitTestSuite
    var bag: MatterBag
    func before_test():
        bag = MatterBag.new()
    func after_test():
        auto_free(bag)
    func test_constructor_with_dictionary():
        var dict = { Matter.carbon: 2, Matter.water: 3 }
        bag = MatterBag.new(dict)
        assert_int(bag.get_by_matter(Matter.carbon)).is_equal(2)
    ```

## What an AI agent should do when proposing edits

- Small, focused changes only. If editing scene files (.tscn) or exported property names, also update tests and mention needed scene wiring in the PR description.
- Run `mise test` and prefer changes that keep tests green. If a proposed change requires a Godot editor update (scene wiring), include precise steps and which scene node(s) must be changed.
- When changing save formats: include a migration routine and unit tests demonstrating both old and new format handling.

## Where to look for more context

- **Game design & rationale**: `memory-bank/projectbrief.md` (core loop, prestige design, save philosophy, narrative tone).
- **Tasks & automation**: `README.md` and `mise.toml` (mise tasks list and definitions).
- **Entry points & global state**: `main/main.gd`, `global.gd`, `game_save.gd`.
- **Data structures**: `matter.gd`, `matter_bag.gd`, `molecule.gd` for resource composition logic.

If something is unclear

- Ask for the intended runtime (editor vs exported build), the target platform (desktop vs web), and whether scene wiring changes are acceptable.
- For high-risk changes (save format, global state layout, or major architecture shifts), request a short design note and a test plan before implementing.

Request feedback

- If any section is unclear or you want specific examples added (e.g., a short test showing MatterBag behavior), tell me which area to expand and I'll iterate.

---

Generated from quick repo scan on behalf of the maintainer (see `README.md` and `memory-bank/projectbrief.md`).
