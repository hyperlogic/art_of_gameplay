
local slides = require "slides"
local gfx = love.graphics
local aud = love.audio
local images = {}
local quads = {}

function love.load()
    slides.load("slides.markdown")

    -- load sky background
    images.sky = gfx.newImage("sky.png")
    quads.sky = gfx.newQuad(0,0,1,1,1,1)
end

function love.update(dt)
end

function love.draw()
    -- draw sky
    gfx.drawq(images.sky, quads.sky, 0, 0, 0, gfx.getWidth(), gfx.getHeight())

    -- draw slides
    slides.draw(slide_index)
end

function love.keypressed (key, unicode)

    if key == "right" then
        slides.next()
    elseif key == "left" then
        slides.prev()
    end
end

function love.keyreleased (key, unicode)
end

function love.joystickpressed (joystick, button)
    -- x button
    if button == 11 then
        slides.next()
    end

    -- b button
    if button == 12 then
        slides.prev()
    end
end

