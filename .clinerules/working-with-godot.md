# Rules for working with Godot and GDScript

## Type Checking

You MUST always use types when declaring variables and functions.

## Code Structure

- Code MUST follow the
  [GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
- Use composition over inheritance for flexibility. This approach allows for greater
  modularity and reusability of components, making it easier to combine different
  functionalities without complex inheritance hierarchies.

## trunk Usage

The `trunk` command is for managing git hooks and running fixes and checks on code.

- To check a few specific files, you can pass the filenames into `trunk check`.
  Example: `trunk check events.gd global.gd`
- To check all modified files, you can use `trunk check` with no other arguments.
- To check all files in the repository, use `trunk check --all`

`trunk` also has a fmt subcommand that can fix some things. For example, it can
ensure GDScript is formatted correctly according to the
[GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).

- To fix a few specific files, you can pass the filenames into `trunk fmt`.
  Example: `trunk fmt events.gd global.gd`
- To fix all modified files, you can use `trunk fmt` with no other arguments.
- To fix all files in the repository, use `trunk fmt --all`
