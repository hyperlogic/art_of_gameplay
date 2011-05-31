local gfx = love.graphics
local joy = love.joystick
local aud = love.audio
local insert = table.insert

module("mario", package.seeall)

tune = {air_steer = false,
        variable_jump = false,
        air_steer_accel = 10,
        jump_vy = -15,
        ground_speed = 5,
        gravity = 50}

local function make_block(x, y)
    return {x = x, y = y}
end

function enter()
    quad = gfx.newQuad(0,0,1,1,1,1)
    tile_ground = gfx.newImage("tile_ground.png")
    mario_idle = gfx.newImage("mario_idle.png")

    ground_blocks = {}

    ground_y = 10

    -- fill up blocks
    for i = -20, 20 do
        insert(ground_blocks, make_block(i, ground_y + 1))
        insert(ground_blocks, make_block(i, ground_y + 2))
    end

    mario = {x = 3, y = 3, vx = 0, vy = 0, state = "air", right = true}

    -- HACK:  use slide title to flip tuning flags
    local slide = slides.slide_table[slides.current_slide()]
    if slide[1].text == "Jump with Air Control" then
        tune.air_steer = true
    elseif slide[1].text == "Variable Jump with Air Control" then
        tune.air_steer = true
        tune.variable_jump = true
    end
        
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
    if mario.state == "ground" then

        stick_vx = stick_x * tune.ground_speed

        -- check for jump button
        if joy.isDown(0, 11) then
            aud.play(mario_jump)

            mario.vx = stick_x * tune.ground_speed

            if tune.variable_jump then
                mario.vy = tune.jump_vy
            else
                -- give a bit of a boost to compensate for the lack of variable jump
                mario.vy = tune.jump_vy * 1.7
            end

            mario.state = "air"
            mario.air_phase = 1
        end
    elseif mario.air_phase == 1 and mario.state == "air" then
        -- check for jump release
        if not joy.isDown(0, 11) then
            mario.air_phase = 2
        end
    end

    -- when on ground, stick drives velocity
    if mario.state == "ground" then
        mario.vx = stick_vx
    end

    -- horizontal acceleration
    local a_x = 0
    if mario.state == "air" and tune.air_steer then
        a_x = stick_x * tune.air_steer_accel
    end

    -- vertical accelration
    local a_y = tune.gravity
    if tune.variable_jump and mario.state == "air" and mario.air_phase == 1 then
        a_y = a_y / 3
    end

    -- update position
    mario.x = mario.x + mario.vx * dt + 0.5 * a_x * dt * dt
    mario.y = mario.y + mario.vy * dt + 0.5 * a_y * dt * dt

    -- update velocity
    mario.vx = mario.vx + a_x * dt
    mario.vy = mario.vy + a_y * dt

    -- clamp horizontal velocity
    if mario.vx > tune.ground_speed then
        mario.vx = tune.ground_speed
    end
    if mario.vx < -tune.ground_speed then
        mario.vx = -tune.ground_speed
    end

    -- collision detection against ground plane
    if mario.vy > 0 and mario.y > ground_y then
        mario.state = "ground"
        mario.y = ground_y
        mario.vy = 0
    end

    if mario.state == "air" and mario.vy > 0 then
        mario.air_phase = 3
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