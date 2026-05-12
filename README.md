# Thorne

A 2D platformer/action prototype in Godot 4.3. Work in progress.

You play as Thorne. The main mechanic is a stretch/grapple arm that fires at walls or enemies. When it hits a wall, it becomes an anchor you can swing from or pull toward. When it hits an enemy, it damages the enemy. The player also has wall climbing, wall jumping, and a slash attack. A set of ability flags gates which moves are available in a given scene.

## Current features

- Custom `CharacterBody2D` movement with coyote time and jump buffering
- Stretch/grapple arm built on raycasts, with separate behavior for wall hits, enemy hits, and moving anchors
- Pendulum-style swinging from a grapple anchor
- Pull movement toward an anchor
- Wall climb and wall jump
- Slash attack with a hitbox
- Ability flags that gate movement states per scene
- Three enemy types: a ground chaser with detection, knockback, and health; a flying enemy that tracks the player and spawns projectiles; a moving hazard that temporarily stops player movement
- Checkpoints, death zones, and respawning
- Buttons that drive doors and moving level pieces
- Autoloaded scene manager for transitions
- Two main level scenes plus a folder of test/prototype scenes

## Player controller

The player controller is split across several scripts rather than one large script. The shared base is `master/state.gd`.

- `characters/thorne/Thorne.gd`: root player node, camera tracking, health, hit reactions, fall state
- `characters/thorne/grounded.gd`: walking, jumping, gravity, coyote time, jump buffering, grapple input, pull movement
- `characters/thorne/arm.gd`: grapple raycast, wall/enemy impact behavior, anchors, retracting, slash attack
- `characters/thorne/swing.gd`: swinging around the current grapple anchor
- `characters/thorne/wall.gd`: wall climbing and wall jumping
- `characters/thorne/shoulder.gd`: small helper script for the player setup

## Ability flags

`master/global.gd` stores ability flags used to gate mechanics during levels. The player does not always start with every ability available.

- `rubber`: stretch/grapple arm
- `radian`: swinging
- `glue`: wall movement
- `hook`: pull toward anchor

The testing scene at `levels/testing/main.tscn` enables all of these flags at startup, which makes it the easiest scene to use when trying the full movement kit.

## Enemies and hazards

- `characters/baddies/grongy/grongy.gd`: ground enemy with detection, chasing, knockback, health, and a death signal
- `characters/baddies/fairy/fairy.gd`: flying enemy that tracks the player and spawns projectiles
- `characters/baddies/fairy/puff.gd`: fairy projectile behavior
- `characters/baddies/monkey/monkey.gd`: moving hazard that temporarily stops player movement
- `master/death zone.gd`: kill zone behavior

## Interactables and level logic

- `interactive/button.gd`: button activation
- `interactive/door.gd`: door movement after activation
- `master/Checkpoint.gd`: respawn point updates
- `master/scene_master.gd`: autoloaded scene transitions
- `levels/1/level1-s.gd`: level 1 events, boss completion, water sections, transition to level 2
- `levels/2/fairy_spawn.gd`: spawns flying enemies inside a zone
- `levels/2/log.gd`: moving level object
- `levels/2/pixies.gd`: level trigger behavior
- `levels/testing/main-s.gd`: enables all player abilities for testing

## Project structure

```text
characters/
  thorne/       Player scene, movement states, grapple/swing scripts
  baddies/      Enemy scenes and enemy scripts
  misc/         Earlier player test scene
interactive/    Buttons and doors
levels/
  1/            First main level
  2/            Second main level
  testing/      Prototype and test scenes, including main.tscn
master/         Shared scripts, state base, checkpoints, scene manager, death zones
paralax/        Parallax visuals and shaders
assets/         Environment art and reusable scene pieces
project.godot
```

## Controls

| Action | Input |
|---|---|
| Move | Arrow keys |
| Jump | Space or controller face button |
| Grapple | X or controller trigger |
| Aim grapple | Controller stick |
| Pull | D or controller trigger |
| Boost | F or controller face button |
| Swing | S or controller button |
| Slash | A or controller face button |
| Teleport (testing) | K |

Grapple aiming currently uses the controller stick. The keyboard can trigger the actions, but anything that involves aiming the arm is best tested with a controller connected.

## How to run

Open `project.godot` in Godot 4.3 or a compatible Godot 4.x version. The current main scene is:

```text
levels/1/level1.tscn
```

For quickly testing the full movement kit, use:

```text
levels/testing/main.tscn
```

That scene starts with the stretch arm, swing, pull, and wall movement abilities enabled.

## Status

In progress. The most developed parts are the player movement, grapple and swing systems, enemies, checkpoints, and level triggers. Art, polish, and level content are not finished. This codebase has been a place to build and test gameplay systems.
