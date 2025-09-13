# Todo list

## Art Assets

- App Icon.
    Need all resolutions used by mobile, mac, and windows.
- Player's ship.
    The original thought was an oddly shaped bundle of cables, constantly wiggling. Like Dr. Octopus's arms, but move forward as well as wiggling, as if they are going some place.
- I want a Godot icon on the pause screen.

## Gameplay

- Create asteroid kinds.
    The asteroid will provide different amounts of materials, depending on what kind it is.

    I think the asteroid should have randomly have everything, but the player's upgrades determine
    what she can get out of the asteroid. e.g., the asteroid might have 200 carbon, but a new player can only get 2.
- Implement asteroid pooling.
    Instead of creating new asteroids, we can reuse existing ones. We'll need a "re-randomize" function that will recalculate the asteroid's contents and size.
- Prototype the upgrades.
    I'm unsure if I want an upgrade tree, or what.
- Prototype upgrade management.
    I should also prototype how I'll store, edit, and preview the list of upgrades. I've could do it
    by storing the upgrades in a JSON, YAML, or CSV file. Or I could just use GDScript directly.

    I've also seen people writing their own Godot editor app to let them manage game data. I'm not sure how
    hard it would be, but it might be educational to try.

## Misc.

- A license listing
- A credits screen

## Meta/Build

- Add a deploy to itch.io
