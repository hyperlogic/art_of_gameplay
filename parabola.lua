local gfx = love.graphics
local joy = love.joystick

module("parabola", package.seeall)

local function graph(func, time, width, height)
    
    -- draw x-axis
    gfx.setColor(black)
    gfx.line(0, 0, width, 0)

    -- draw y-axis
    gfx.setColor(black)
    gfx.line(0, 0, 0, height)

    gfx.setColor(green)
    local dt = 0.1
    local prev_x, prev_y = func(0)
    for t = 0.1, time, 0.1 do
        local x, y = func(t)
        gfx.line(prev_x, prev_y, x, y)
        prev_x, prev_y = x, y
    end
end

function enter()
    v0_x = 70
    v0_y = 100
end

function exit()

end

function update(dt)
    local x, y = joy.getAxes(0)

    -- dead spot
    local dead_spot = 0.3
    if math.abs(x) < dead_spot then
        x = 0
    end
    if math.abs(y) < dead_spot then
        y = 0
    end

    -- stick vel
    local sv_x, sv_y = 30, -30

    v0_x = v0_x + sv_x * x * dt
    v0_y = v0_y + sv_y * y * dt
end

function draw()
    gfx.push()
    
    -- set things up with the origin at 0, 0
    gfx.translate(0, gfx.getHeight())
    gfx.scale(1, -1)
    gfx.translate(100, 100)

    gfx.setLine(5, "smooth")

    -- joypad control over this!

    local a = -50
    local function f(t)
        local x = v0_x * t
        local y = v0_y * t + 0.5 * a * t * t
        return x, y
    end

    graph(f, 20, 800, 400)

    gfx.setColor(red)
    gfx.line(0,0, v0_x, v0_y)

    gfx.pop()
end

