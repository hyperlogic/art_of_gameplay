# 
# The Art of Gameplay
# Programming
---
# What is Gameplay?
---
# What is Gameplay?
* NOT Graphics
* NOT Optimization
* NOT Tools
* NOT Exporters
* NOT Physics
---
# 
# Then What Is It?
## Let's look at a few
## examples
---
#
# The Anatomy of a Jump
* User presses jump
* Calculate initial velocity
* Follow parabolic path
---
# Initial Velocity
! v0.png
! v0_add.png
## Tuned by designers
---
# Parabolic Graph
! parabola.png
@ parabola
---
# 
# How do we translate
# this into something
# we can use?
---
#
# Game Loop
* Get Input
* Update Simulation
* Draw Frame
---
! parabola.png
! parabola_v.png
* x0 is x(t) from last frame
* v0 is v(t) from last frame
* t is the time elapsed
---
#
#
# How does it feel?
---
### Jump
@ mario
---
#
# How does it feel?
* Hard to make short jumps
* Easy to overshoot target
* Hit head on ceiling
---
#
# Air Control
* Limited stick control
* Add small acceleration
* Clamp v_h
---
### Jump with Air Control
@ mario
---
# Variable Jump
* Holding button = higher jump
* Three phases
* Phase 1: light gravity
* Phase 2: normal gravity
* Phase 3: after apex
---
### Variable Jump with Air Control
@ mario
---
# 
# Jump Tuning
* v_v, v_h, a_g
* Hard to tune
* Values not orthogonal
---
## Programmers: 
* v_v - vertical velocity
* v_h - horizontal velocity
* a_g - acceleration due to gravity
## Designers:
* x_j - max distance for jump
* y_j - max height of jump
* t_h - total time in air
---
# How to Convert?
! vx.png
! vy.png
! ag.png
### Not taking variable jump or
### air steering into account
---
#
# Gameplay Mechanics
* Direct player control
* Highly tuned
* Instant feedback
---
#
## Examples
* Vehicle steering
* Balance beam
* Melee combat
---
#
# Weapons
* FPS or TPS
* Create
* Experiment
* Tune
---
#
# Typical Weapons
* Rail Gun
* Shot Gun
* Plasma Gun
* Chain Gun
---
# Tune Values
* Rate of fire
* Clip Size
* Reload Time
* Spin up, Spin Down
* Overheat
---
#
# Implementation
* Big ball of ifs
* Coroutines
* State Machines
---
#
# State Machine
* Finite # of states
* Finite # of transitions
* Process
* Enter / Exit
---
# Example
! sm01.png
---
# More States
! sm02.png
---
# Full State Machine
! sm03.png
---
#
# Benefits of SM
* Easy to extend
* Locality
* Easy to debug
---
#
# Gameplay Systems
* Breakables
* Armor
* Skill Tree
* Drop Tables
---
#
# Level Scripting
* One off
* Add suspense
* Streamline play-through
* Puzzle setups
---
#
# Gameplay Programming
* Mechanics
* Systems
* Level Scripting
---
#
# Law of the Loop
* iterate
* iterate
* iterate
---
#
# Source Code
## ajt@hyperlogic.org
## www.github.com/art_of_gameplay
## www.love2d.org
---
