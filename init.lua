----------------------------
    -- Primitive Meshes
----------------------------
local current_folder = (...):gsub('%.[^%.]+$', '') .. "."
local generator = require(current_folder .. "generator")
local mesh = {}

-- Set Defaults ----------------------------------------------------------------------------
function mesh.texture_default(texture)
    mesh.default_texture = texture
end

----------------------------
    -- Constructors
----------------------------
-- Cuboid constructor ----------------------------------------------------------------------
function mesh.cuboid_new(pos, max, uv_map, texture)
    -- Our cuboid object
    local cuboid = {}

    -- Texturing defaults
    local texture = texture or mesh.default_texture
    local uv_map  = uv_map or {}
    
    -- Default minimum vertex position to 0
    local min = cpml.vec3()

    -- Vertex coordinates
	local vertices = {
        -- Top
        min.x, min.y, max.z, max.x, min.y, max.z,
        max.x, max.y, max.z, min.x, max.y, max.z,
        
        -- Bottom
        max.x, min.y, min.z, min.x, min.y, min.z,
        min.x, max.y, min.z, max.x, max.y, min.z,
        
        -- Front
        min.x, min.y, min.z, max.x, min.y, min.z,
        max.x, min.y, max.z, min.x, min.y, max.z,
        
        -- Back
        max.x, max.y, min.z, min.x, max.y, min.z,
        min.x, max.y, max.z, max.x, max.y, max.z,
        
        -- Right
        max.x, min.y, min.z, max.x, max.y, min.z,
        max.x, max.y, max.z, max.x, min.y, max.z,
        
        -- Left
        min.x, max.y, min.z, min.x, min.y, min.z,
        min.x, min.y, max.z, min.x, max.y, max.z
	}

    -- Create UVs and indices
    local uvs       = generator.create_quad_uvs(texture, uv_map, #vertices)
    local indices   = generator.create_quad_index(#vertices)
    
    -- Merge tables for mesh creation
    vertices = generator.uv_merge(vertices, uvs)
    
    -- Create the mesh
	local layout = { 
        { "VertexPosition", "float", 3 },
        { "VertexTexCoord", "float", 2 }
    }
	cuboid.mesh = love.graphics.newMesh(layout, vertices, "triangles", "static")
    
    -- Assignments
	cuboid.mesh:setVertexMap(indices)
    cuboid.mesh:setTexture(texture)
    
    cuboid.type        = "cuboid"
    cuboid.position    = pos
    cuboid.orientation = cpml.quat(0, 0, 0, 1)

    return cuboid
end

-- Quad constructor ------------------------------------------------------------------------
function mesh.quad_new(pos, max, uv_map, texture)
    -- Our quad object
    local quad = {}

    -- Texturing defaults
    local texture = texture or mesh.default_texture
    local uv_map  = uv_map or {}

    -- Default minimum vertex position to 0
    local min = cpml.vec3()

    -- Vertex coordinates
	local vertices = {
        min.x, min.y, max.z, max.x, min.y, max.z,
        max.x, max.y, max.z, min.x, max.y, max.z,
	}

    -- Create UVs and indices
    local uvs       = generator.create_uvs(texture, uv_map, #vertices)
    local indices   = generator.create_index(#vertices)
    
    -- Merge tables for mesh creation
    vertices = generator.uv_merge(vertices, uvs)
    
    -- Create the mesh
	local layout = { 
        { "VertexPosition", "float", 3 },
        { "VertexTexCoord", "float", 2 }
    }
	quad.mesh = love.graphics.newMesh(layout, vertices, "triangles", "static")
    
    -- Assignments
	quad.mesh:setVertexMap(indices)
    quad.mesh:setTexture(texture)
    
    quad.type        = "quad"
    quad.position    = pos
    quad.orientation = cpml.quat(0, 0, 0, 1)

    return quad
end

-- Sphere constructor ----------------------------------------------------------------------
function mesh.sphere_new(pos, max, loops, uv_map, texture)
    -- Our sphere object
    local sphere = {}
    
    -- Texturing defaults
    local texture = texture or mesh.default_texture
    local uv_map  = uv_map or {}
    
    -- Default minimum vertex position to 0
    local min = cpml.vec3()
    
    -- Round values if needed
    loops.x = math.floor(loops.x)
    loops.z = math.floor(loops.z) + 3
    
    assert(loops.x > 2 and loops.z > 2, "Not enough loops to create sphere")
    
    -- Expansion midpoint
    local vertical_midpoint = loops.z/2
    
    -- Create vertex table and add first vertex
    local vertices = {
        max.x/2, max.y/2, min.z 
    }
    
    local add_x = math.pi*2/loops.x
    
    -- Stack horizontal loops
    for z = 1, loops.z - 3 do
        -- Solve vertex height
        local new_z = z*loops.z/(loops.z - 2)
    
        local mid_expand = -math.cos((new_z - vertical_midpoint)/loops.z*math.pi)
        local mult_z = -math.cos(new_z/loops.z*math.pi)/2+0.5
        
        local vertex_z = max.z*mult_z
        
        -- Create horizontal loop
        for x = 0, math.pi*2 - (add_x - cpml.constants.FLT_EPSILON), add_x do
            local vertex_x = math.cos(x)*(max.x*mid_expand)/2 + max.x/2
            local vertex_y = math.sin(x)*(max.y*mid_expand)/2 + max.y/2

            table.insert(vertices, vertex_x)
            table.insert(vertices, vertex_y)
            table.insert(vertices, vertex_z)
        end
    end
    
    -- Add final vertex
    table.insert(vertices, max.x/2)
    table.insert(vertices, max.y/2)
    table.insert(vertices, max.z)
    
    -- Create UVs and indices
    local uvs     = generator.create_loop_uvs(texture, uv_map, loops)
    local indices = generator.create_loop_index(loops)
    
    -- Merge tables for mesh creation
    vertices = generator.uv_merge(vertices, uvs)

    -- Create the mesh
	local layout = { 
        { "VertexPosition", "float", 3 },
        { "VertexTexCoord", "float", 2 }
    }
	sphere.mesh = love.graphics.newMesh(layout, vertices, "triangles", "static")
    
    -- Assignments
	sphere.mesh:setVertexMap(indices)
    sphere.mesh:setTexture(texture)
    
    sphere.type        = "sphere"
    sphere.position    = pos
    sphere.orientation = cpml.quat(0, 0, 0, 1)

    return sphere
end

----------------------------
    -- Drawing
----------------------------
function mesh.draw(object)
    local projection = cpml.mat4()
        :translate(object.position)
        :rotate(object.orientation)
        
    love.graphics.getShader():send("u_model", projection:to_vec4s())

    -- draw the mesh
    love.graphics.draw(object.mesh)
end

return mesh
