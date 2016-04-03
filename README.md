# LÖVE3D-Mesh
Generates primitive mesh objects for LÖVE3D

![alt tag](http://i.imgur.com/X8qLr2f.png)

#  Usage
```
mesh = require "mesh"

-- Create Image parameters for mipmapping
image_flags = {
    srgb = select(3, love.window.getMode()).srgb,
    mipmaps = true
}

-- Create textures
-- Default
default_texture = love.graphics.newImage("texture.png", image_flags)
default_texture:setMipmapFilter("linear", 1)

-- Skybox
skybox_texture  = love.graphics.newImage("skybox.png", image_flags)
skybox_texture:setMipmapFilter("linear", 1)

-- Assign defaults to mesh objects
mesh.texture_default(default_texture)

-- Create mesh objects
skybox = mesh.cuboid_new(
    cpml.vec3(-500, -500, -500), -- Position
    cpml.vec3(1000, 1000, 1000), -- Size
    {
        {x = 0, y = 0, w = 512, h = 512}, -- UV map
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

...

love.graphics.setShader(shader_skybox)
mesh.draw(skybox)
love.graphics.setShader()

love.graphics.setShader(shader_3D)
mesh.draw(sphere)
love.graphics.setShader()

```

# Dependencies
  - LÖVE3D
  - CPML
