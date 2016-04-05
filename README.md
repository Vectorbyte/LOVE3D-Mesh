# LÖVE3D-Mesh
Generates primitive mesh objects for LÖVE3D

![alt tag](http://i.imgur.com/X8qLr2f.png)

#  Usage
```lua
mesh = require "Mesh"

-- Do stuff --

-- Set texture default
mesh.texture_default(default_texture)

-- Create mesh objects
skybox = mesh.cuboid_new(
    cpml.vec3(-500, -500, -500), -- Position
    cpml.vec3(1000, 1000, 1000), -- Size
    {
        {x = 0  , y = 0  , w = 512, h = 512}, -- UV map
        {x = 256, y = 256, w = 256, h = 256}, -- You can generate UVs for each face of the cuboid,
        -- If you don't provide more UVs, the next cuboid faces default to the last UVs provided.
    },
    skybox_texture -- Assign skybox_texture as the texture batch for this mesh
)

sphere = mesh.sphere_new(
    cpml.vec3(0, 0, 0), -- Position
    cpml.vec3(1, 1, 1), -- Size
    {x = 21, z = 21},   -- Horizontal/Vertical loops
    {x = 128, y = 128, radius = 32} -- UV map
    -- No texture (defaults)
)

-- Do more stuff --

love.graphics.setShader(shader_skybox)
mesh.draw(skybox)
love.graphics.setShader()

love.graphics.setShader(shader_3D)
mesh.draw(sphere)
love.graphics.setShader()

```

# TODO
  - General cleanup
  - Improve on sphere UVs
  - Add Pyramid-Cone mesh generator
  - Add Cyllinder mesh generator
  - Add Geosphere mesh generator
  - Add Subdivided Quad generator

# Dependencies
  - LÖVE3D
  - CPML
