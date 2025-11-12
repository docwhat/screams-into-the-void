# Rules for working with Godot and GDScript

## Type Checking

You MUST always use types when declaring variables and functions.

## Code Structure

- Code MUST follow the
[GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).
- Use composition over inheritance for flexibility. This approach allows for greater
modularity and reusability of components, making it easier to combine different
functionalities without complex inheritance hierarchies.

## hk Usage

The `hk` command is for managing git hooks and running fixes and checks on code.

- To check a few specific files, you can pass the filenames into `hk check`.
Example: `hk check events.gd global.gd`
- To check all modified files, you can use `hk check` with no other arguments.
- To check all files in the repository, use `hk check --all`

`hk` also has a fix subcommand that can fix some things. For example, it can
ensure GDScript is formatted correctly according to the
[GDScript style guide](https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/gdscript_styleguide.html).

- To fix a few specific files, you can pass the filenames into `hk fix`.
Example: `hk fix events.gd global.gd`
- To fix all modified files, you can use `hk fix` with no other arguments.
- To fix all files in the repository, use `hk fix --all`
