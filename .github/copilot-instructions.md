# Screams Into The Void — Copilot instructions for AI coding agents

This file gives focused, actionable guidance for an AI code assistant to be productive in this repository.

High-level facts

- Engine: Godot (GDScript). Project targets Godot 4.5+ (see `README.md`).
- Task runner: `mise` is required. Run `mise install` once to install tools, then use `mise` for common tasks (see `README.md`).
- Git Hook manager: `hk` is required. It is also used for linting and formatting. It is configured via `hk.pkl`. See: <https://github.com/jdx/hk>
- Tests: uses `addons/gdUnit4` for unit tests. Run tests via `mise test`.

Quick start (what to run locally)

- Install prerequisites: `mise install` (from repo root).
- Open editor: `mise godot` (or `mise game` to run the game task). Use the Godot editor for scene wiring and quick playtests.
- Run tests: `mise test` (invokes gdUnit4 test harness configured in the repo).
- Export builds: `mise export-all` / `mise export-web` (see `README.md` tasks list).
- Lint code: `hk check`
- Fix code style and formatting: `hk fix`

Big-picture architecture (what to read first)

- `main/` — application entry points and input mapping. See `main/main.gd` (initialises `Global`, spawns `AsteroidLauncher`), and `main/input_manager.gd` (centralised input mapping via GUIDE contexts).
- `global.gd` and `global.tscn` — project global state (singletons). Many systems read/write via `Global.*`.
- `game_save.gd` & `game_save.tscn` — save / settings surface (exported properties, signals such as `use_symbols_changed`, and versioned save intent described in the project brief).
- Domain folders (examples): `Asteroid/`, `Absorber/`, `player/` — scenes and GDScript per gameplay entity.
- `addons/gdUnit4/` — tests; use this to add small, fast unit tests for logic (e.g., MatterBag, Molecule composition).

Common patterns and repository conventions

- Scene-first, small-node scripts: each entity typically lives in its own folder (scene + script). Prefer editing scenes in Godot to wire nodes.
- Global singleton pattern: `global.gd` is used for shared state (e.g., `Global.play_field`, `Global.player_node`, `Global.rng`). Modify carefully — prefer clear getters/setters where possible.
- Input system: custom mapping via `GUIDE` types shown in `main/input_manager.gd` (`GUIDEMappingContext`, `GUIDEAction`). Use mapping contexts rather than raw Input.is_action_pressed in gameplay code.
- Exported properties & signals: many options use `@export` and emit signals on change (see `game_save.gd`). When changing an exported API, update any inspector-expected names and tests.
- Save system: the project aims for versioned, multi-file saves (see `memory-bank/projectbrief.md`); changes to save structures should include migration strategies and tests.
- RNG: randomization is initialised centrally (`Global.rng.randomize()` in `main/main.gd`). Use `Global.rng` for deterministic behavior in tests where helpful.

Integration points & external tools

- mise — primary developer task runner & installer (listed in `README.md`). All CI tasks use it.
- Godot — edit scenes and run the project. Use the editor to inspect exported properties and node paths before changing code that expects a certain scene layout.
- gdUnit4 — unit test framework located in `addons/gdUnit4`.

Example reference snippets to follow (do not change without local testing)

- Starting behaviour: `main/main.gd` creates `AsteroidLauncher` and calls `start()` after process frame. Prefer this pattern for systems that must attach at runtime.
- Input wiring: `main/input_manager.gd` connects `action_pause_or_back.triggered` to `current_window.pause_or_back`. Use `triggered.connect(...)` rather than ad-hoc polling for those actions.
- Settings pattern: `game_save.gd` exposes `@export var use_symbols: bool` and emits `use_symbols_changed` in the setter — mirror this approach when creating new settings.

What an AI agent should do when proposing edits

- Small, focused changes only. If editing scene files (.tscn) or exported property names, also update tests and mention needed scene wiring in the PR description.
- Run `mise test` and prefer changes that keep tests green. If a proposed change requires a Godot editor update (scene wiring), include precise steps and which scene node(s) must be changed.
- When changing save formats: include a migration routine and unit tests demonstrating both old and new format handling.

Where to look for more context

- Game design & rationale: `memory-bank/projectbrief.md` (core loop, prestige design, save philosophy).
- Tasks & automation: `README.md` (mise tasks list).
- Entry points & global state: `main/main.gd`, `global.gd`, `game_save.gd`.

If something is unclear

- Ask for the intended runtime (editor vs exported build), the target platform (desktop vs web), and whether scene wiring changes are acceptable.
- For high-risk changes (save format, global state layout, or major architecture shifts), request a short design note and a test plan before implementing.

Request feedback

- If any section is unclear or you want specific examples added (e.g., a short test showing MatterBag behavior), tell me which area to expand and I'll iterate.

---
Generated from quick repo scan on behalf of the maintainer (see `README.md` and `memory-bank/projectbrief.md`).
