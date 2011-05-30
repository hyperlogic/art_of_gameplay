local gfx = love.graphics
local joy = love.joystick
local insert = table.insert

module("mario", package.seeall)

local function make_block(x, y)
    return {x = x, y = y}
end

function enter()
    quad = gfx.newQuad(0,0,1,1,1,1)
    tile_ground = gfx.newImage("tile_ground.png")
    mario_idle = gfx.newImage("mario_idle.png")

    ground_blocks = {}

    ground_y = 10
    gravity = 10

    -- fill up blocks
    for i = -20, 20 do
        insert(ground_blocks, make_block(i, ground_y + 1))
        insert(ground_blocks, make_block(i, ground_y + 2))
    end

    mario = {x = 3, y = 3, vx = 0, vy = 0, on_ground = false, right = true}
end

function exit()
    
end

function update(dt)

    local stick_x, stick_y = joy.getAxes(0)

    -- dead spot
    local dead_spot = 0.3
    if math.abs(stick_x) < dead_spot then
        stick_x = 0
    end
    if math.abs(stick_y) < dead_spot then
        stick_y = 0
    end

    local stick_vx = 0
    if mario.on_ground then

        stick_vx = stick_x * 5

        -- jump
        if joy.isDown(0, 11) then
            print("jump!")
            mario.vx = stick_x * 5
            mario.vy = -10
            mario.on_ground = false
        end
    end

    if mario.on_ground then
        mario.vx = stick_vx
    end

    mario.x = mario.x + mario.vx * dt
    mario.y = mario.y + mario.vy * dt + 0.5 * gravity * dt * dt

    mario.vx = mario.vx
    mario.vy = mario.vy + gravity * dt

    if mario.vy > 0 and mario.y > ground_y then
        mario.on_ground = true
        mario.y = ground_y
        mario.vy = 0
    else
        mario.on_ground = false
    end
end

function draw()
    gfx.push()
    
    gfx.scale(50, 50)

    for i, v in ipairs(ground_blocks) do
        gfx.drawq(tile_ground, quad, v.x, v.y, 0, 1, 1)
    end

    -- draw mario
    if mario.vx > 0 then
        mario.right = true
    elseif mario.vx < 0 then
        mario.right = false
    end

    if mario.right then
        gfx.drawq(mario_idle, quad, mario.x, mario.y, 0, 1, 1)
    else
        gfx.drawq(mario_idle, quad, mario.x + 1, mario.y, 0, -1, 1)
    end

    gfx.pop()
end