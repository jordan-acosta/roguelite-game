# Roguelite Game Sub-Agents

Specialized agents for game development tasks.

## Game Systems

- **balance-analyzer** - Analyze damage formulas, drop rates, difficulty scaling, and stat progression for balance issues
- **dungeon-validator** - Test procedural generation output for playability (dead ends, unreachable areas, difficulty distribution)
- **combat-simulator** - Run theoretical combat scenarios to verify damage/health ratios

## Code Quality

- **game-loop-profiler** - Find performance bottlenecks in update/render cycles
- **state-machine-auditor** - Verify entity state machines for impossible transitions or missing states
- **collision-checker** - Validate hitboxes and collision layer configurations

## Content

- **pixel-art-generator** - Generate and modify pixel art assets for sprites, tiles, and UI elements
- **item-generator** - Help design item stats, effects, and synergies that fit existing systems
- **enemy-designer** - Generate enemy stat blocks and behavior patterns balanced against player progression
- **run-analyzer** - Simulate full runs to check meta-progression pacing

## Level Design

- **dungeon-generator** - Test and improve procedural dungeon generation, validate layouts for playability
- **seed-validator** - Test specific RNG seeds for reproducibility and fairness

## Testing

- **roguelite-tester** - Automated playtesting for common roguelite bugs (softlocks, broken synergies, spawn issues)
