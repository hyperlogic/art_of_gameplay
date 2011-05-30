
local slides = require "slides"
local gfx = love.graphics
local aud = love.audio
local images = {}
local quads = {}
local sounds = {}

require "parabola"
require "mario"

white = {255, 255, 255, 255}
black = {0, 0, 0, 255}
red = {255, 0, 0, 255}
green = {0, 255, 0, 255}
blue = {0, 0, 255, 255}

local function play_goofy_sound()
    aud.play(sounds[((slides.current_slide() - 1) % #sounds) + 1])
end

function love.load()
    -- load sounds
    for i = 1, 9 do
        table.insert(sounds, aud.newSource("powerup0"..i..".ogg", "static"))
    end
    mario_jump = aud.newSource("mario_jump.ogg", "static")

    slides.load("slides.markdown")

    -- load sky background
    images.sky = gfx.newImage("sky.png")
    quads.sky = gfx.newQuad(0,0,1,1,1,1)

    -- custom_draw 
end

function love.update(dt)
    if slides.get_custom_table() then
        slides.get_custom_table().update(dt)
    end
end

function love.draw()
    -- draw sky
    gfx.setColor(white)
    gfx.drawq(images.sky, quads.sky, 0, 0, 0, gfx.getWidth(), gfx.getHeight())

    -- draw slides
    slides.draw(slide_index)
end

function love.keypressed(key, unicode)

    if key == "right" then
        slides.next()
        play_goofy_sound()
    elseif key == "left" then
        slides.prev()
        play_goofy_sound()
    end
end

function love.keyreleased(key, unicode)
end

function love.joystickpressed(joystick, button)

    -- left bumper
    if button == 8 then
        slides.prev()
        play_goofy_sound()
    end

    -- right bumber
    if button == 9 then
        slides.next()
        play_goofy_sound()
    end
end

