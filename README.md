# LÖVE3D-Mesh
Generates primitive mesh objects for LÖVE3D

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

-- Assign default to mesh objects
mesh.texture_default(default_texture)

skybox = mesh.cuboid_new(
    cpml.vec3(-500, -500, -500),
    cpml.vec3(1000, 1000, 1000),
    {
        {x = 0, y = 0, w = 512, h = 512},
    },
    skybox_texture
)

sphere = mesh.sphere_new(
    cpml.vec3(0, 0, 0),
    cpml.vec3(1, 1, 1),
    {x = 21, z = 21},
    {x = 128, y = 128, radius = 32}
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
