# Project Brief: "Screams Into the Void" (working title)

## One-line Summary

Active incremental game in Godot: The main character (MC) is a sentient swarm of
nanobots that gathers materials, upgrades itself, and periodically prestiges
back to a barely-sentient origin while retaining ephemeral memory fragments.

## High-level goal

Design a compact, engaging incremental loop that feels alive: players feed a
growing, learning creature composed of nanobots through active interaction and
strategic upgrades, then either intentionally or through a disaster reset
(prestige) to unlock deeper long‑term progression and narrative glimpses.

## Core experience

- Genre: Active incremental, Clicker, Sci-Fi, Number-go-up.
- Perspective: Top-down, floating in space collecting asteroids and space debris.
- Immediate tactile satisfaction from active gathering and micro-interactions.
- Clear, addictive sense of growth as the MC accumulates materials and
capabilities.
- Emotional resonance via the MC’s emergent voice: curious, lonely, fragmented
memories after each prestige.
- Loop: Gather → Improve → Automate → Overwhelm → Prestige → Memory fragments
add meta-progression.

## Core loop & systems

- Primary resource:
  - Raw matter in the form of atomic elements (e.g., Carbon, Iron, Silicon).
- Secondary resources:
  - Molecules (combinations of elements, possibly with different processing
  requirements).
  - Energy (generated passively or actively, required for certain upgrades).
  - Recipes for molecules (unlocked via upgrades, found (plot driven), or memory
  fragments).
  - Blueprints for nanobot swarms and MC enhancements.
  - Cognitive Fragments (rare plot drivers)
- Active mechanics:
  - manual swarm commands:
    - dissamble/reassemble resources
    - probe planets and planetoids
    - analyze anomalies
    - protect against threats (e.g., radiation bursts)
  - targeted harvesting. They depend on upgrade paths:
    - direct click-to-collect
    - mark for collection by the MC bumping into resources
    - mark for collection by automated nanobot swarms
    - area-of-effect commands
    - puzzle like collection. To be determined.
  - special abilities on cooldown.
- Passive mechanics:
  - resources bumping into the MC and being collected automatically.
  - automated nanobot swarms
  - energy gathering
  - energy generation
- Upgrade paths:
  - MC upgrades:
    - processing abilities
    - storage capacity
    - automation abilities
    - cognitive functions.
  - fabrication upgrades: new nanobot types, better nanobots.
  - nanobot swarm upgrades: automation, gathering radius, types of user
  interaction for collecting.
- Soft caps and diminishing returns to encourage prestige decisions.

## Prestige mechanics (signature)

- "Reboot" resets resources, many upgrades and available nanobots, returns
player to "barely sentient" state.
- Persisting meta: Cognitive Fragments convert into Memory Nodes—small permanent
bonuses (starting efficiency, unlocks, lore shards).
- 💡 Idea: each prestige compresses the MC’s experience into poetic memory
fragments displayed as short logs/narration.
  - Alternative: Use pictures instead of text.
- Player can use prestige to try different strategies and upgrade paths.
- Prestige pacing tuned so each loop feels meaningfully different and faster
(but not necessarily taking any less time).

## Narrative / tone

- Minimalist, emergent narrative told through memory fragments and MC's evolving
voice.
- The MC's voice: young female, terse, curious, worried, slightly uncanny;
evolves with upgrades and prestiges.
- Lore revealed nonlinearly: fragments of origin, description of how the MC came
to be, hints at larger universe.

## Technical stack & constraints

- Engine: Godot using GDScript.
- Scenes: modular nodes for MC, resources, upgrades, UI.
- Save system:
  - Must be flexible enough to handle changes in code gracefully.
  - Use versioned save data with migration paths.
  - Use multi-file saves to seprarate quickly changing data from more stable data.
- Settings system: separate from save data, since settings are specific to each device.
- Performance:
  - swarm visualizations via GPUParticles, shaders, or multi-mesh instances.
  - efficient resource spawning and culling.
  - scale gracefully to mobile/desktop
- Graphics:
  - simple 2D style, similar in style to retro pixel art but without actually
  being pixelized.
  - Particle effects for the nanobot swarms and explosions.
  - Disolve effects for absorption of resources.

## UX / UI priorities

- Clear minimal resource readouts.
- Concise upgrade affordances.
- Fast feedback for active input (sound, micro-explosions, UI pop).
- 💡 Idea: Maybe use an accessible tutorial: first loop teaches gathering,
upgrades, and prestige in 5–10 minutes.
  - Alternative: let the play discover some systems organically, with clear
  descriptions of upgrades.

## Art & audio

Note that art and audio are basic placeholders for MVP; polish can come later.

- Visual: abstract micro‑tech aesthetic — glowing particles, simple geometry.
- Audio:
  - click/collect sfx
  - evolving ambient hum
  - 🎯 Stretch Goal: Get actual voice actor for MC's voice. Maybe other actors
  for memory fragments?
- Keep assets simple and modular for iteration speed.

## Metrics of success (MVP)

- Satisfying active collection feel (polish to input and feedback).
- Functional prestige system with at least one persistent meta.
- Meaningful short-term upgrades and automated progression.
- Basic memory fragment narrative implemented.
- Unit tests for core logical systems.
- GdUnit4 tests for key gameplay loops.

## High-level roadmap

1. Prototyping parts of the game to understand what I don't know yet:
    - Active gathering gameplays (multiple methods of resource collection)
    - Resource spawning and distribution in space
    - Add upgrade tree
    - basic automation
    - UI
    - Implement prestige
    - Prestige upgrade tree
    - Persistent Memory Nodes
2. Write basic narrative fragments and incorporate them into the game. Use
localization ready text processing.
3. Create first MVP build for playtesting.
4. Playtesting.
5. Iterate based on feedback.
6. Add art and audio.
7. Balancing and polish.
8. Optimization
9. Final testing and bug fixing.
10. Release!

## Risks & mitigation

- Risk: Loop becomes shallow/boring
    — Mitigation: early playtests
  - Mitigation: varied upgrade synergies
- Risk: Performance with many agents
    — Mitigation: with LOD, pooled nodes, visual aggregation, and if needed GDNative.
- Risk: Narrative feels tacked on
    — Mitigation: Integrate memory fragments as rewards for mechanical milestones.

## Success criteria (release)

- Players engage in multiple prestige cycles voluntarily.
- Each loop feels faster and more expressive.
- Memory fragments provide meta-goals and emotional hooks.
- Positive feedback.

---  
Contact: @docwhat for iteration notes and demo builds.
