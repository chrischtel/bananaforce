# BananaForce
WIP physics engine in Zig
WIP physics engine in Zig OMG YEA A CONFLICT
# BananaForce

BananaForce aims to be a high-performance physics engine written in Zig. It is designed to handle everything from simple 2D game to complex 3D simulations.


## Why Another Physics Engine?

I got tired of dealing with C++ physics libraries that were either too complex, had weird APIs, or didn't play nice with modern tooling. Zig's safety features and performance characteristics make it perfect for physics simulation where you need both speed and reliability.

## Current Status: Early Development

This is very much a work in progress. Right now I'm building the foundation - math library, basic collision detection, that sort of thing. Don't expect to simulate fluids just yet.

## Features Planned

> *Please note that this is a rough roadmap and things may change as development progresses.*

### Core Math & Utilities
- [x] Project structure
- [ ] Vector math (Vec2, Vec3, Vec4)
- [ ] Matrix operations (Mat3, Mat4)
- [ ] Quaternions for rotations
- [ ] SIMD optimizations

### Collision Detection
- [ ] Basic shapes (sphere, box, capsule)
- [ ] Broad phase (spatial hashing, BVH)
- [ ] Narrow phase (SAT, GJK/EPA)
- [ ] Continuous collision detection

### Rigid Body Dynamics
- [ ] Integration (Verlet, RK4)
- [ ] Constraint solving
- [ ] Joints and springs
- [ ] Sleeping and islands

### Advanced Features
- [ ] Particle systems
- [ ] Soft body simulation
- [ ] Fluid dynamics
- [ ] Multithreading support


## LICENSE
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.