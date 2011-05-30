local printf = function (...) print(string.format(...)) end
local insert = table.insert
local gfx = love.graphics

module("slides", package.seeall)

local slide_table = {}
local fonts = {}
local slide_index = 1

function load(filename)

    -- warp
    slide_index = 11

    local top_y_offset = 50

    local h1_metrics = {y_size = 70,
                        y_offset = 60,
                        x_offset = 0,
                        align = "center"}

    local h2_metrics = {y_size = 60,
                        y_offset = 50,
                        x_offset = 0,
                        align = "center"}

    local bullet_metrics = {y_size = 50,
                            y_offset = 20,
                            x_offset = 150,
                            align = "left"}

    local image_metrics = {y_offset = 50,
                           x_offset = 100}

    fonts = {h1 = gfx.newFont("FreeSansBold.otf", h1_metrics.y_size),
             h2 = gfx.newFont("FreeSansBold.otf", h2_metrics.y_size),
             bullet = gfx.newFont("FreeSansBold.otf", bullet_metrics.y_size),}

    local slide = {}
    local y = top_y_offset

    -- crappy parser for a markdown like slideshow format
    -- # This is h1 text
    -- ## This is h2 text
    -- * This is a bullet point
    -- * This is another
    -- ! image.png
    -- @ custom_table
    -- ---
    for line in io.lines(filename) do
        if line:sub(1,2) == "##" then
            -- h2
            local text = line:sub(3)
            insert(slide, {type = "text",
                           font = fonts.h2,
                           text = text,
                           x = h2_metrics.x_offset,
                           y = y,
                           align = h2_metrics.align})
            y = y + h2_metrics.y_size + h2_metrics.y_offset
        elseif line:sub(1,1) == "#" then
            -- h1
            local text = line:sub(3)
            insert(slide, {type = "text",
                           font = fonts.h1,
                           text = text,
                           x = h1_metrics.x_offset,
                           y = y,
                           align = h1_metrics.align})
            y = y + h1_metrics.y_size + h1_metrics.y_offset
        elseif line:sub(1,2) == "* " then
            -- bullet point!
            local text = line:sub(3)
            insert(slide, {type = "text",
                           font = fonts.bullet,
                           text = "* "..text,
                           x = bullet_metrics.x_offset,
                           y = y,
                           align = bullet_metrics.align})
            y = y + bullet_metrics.y_size + bullet_metrics.y_offset
        elseif line:sub(1,2) == "! " then
            -- image!
            local filename = line:sub(3)
            local image = gfx.newImage(filename)
            assert(image)
            local quad = gfx.newQuad(0,0,1,1,1,1)

            insert(slide, {type = "image",
                           image = image,
                           quad = quad,
                           x = image_metrics.x_offset,
                           y = y})
            y = y + image:getHeight() + image_metrics.y_offset
        elseif line:sub(1,2) == "@ " then
            -- custom_table property
            local table_name = line:sub(3)
            slide.custom_table = table_name
        elseif line:sub(1,3) == "---" then
            -- end of slide
            insert(slide_table, slide)
            y = top_y_offset
            slide = {}
        end
    end
end

function draw()

    local num_drops = 2

    local slide = slide_table[slide_index]
    assert(slide)

    -- call custom draw
    if slide.custom_table then
        _G[slide.custom_table].draw()
    end

    for i, v in ipairs(slide) do
        if v.type == "text" then
            gfx.setFont(v.font)
            gfx.setColor(black)
            for i = 1, num_drops do
                gfx.printf(v.text, v.x + i, v.y + i, gfx.getWidth(), v.align)
            end
            gfx.setColor(white)
            gfx.printf(v.text, v.x, v.y, gfx.getWidth(), v.align)
        elseif v.type == "image" then
            gfx.setColor(black)
            for i = 1, num_drops do
                gfx.drawq(v.image, v.quad, v.x + i, v.y + i, 0, 
                          v.image:getWidth(), v.image:getHeight())                
            end

            gfx.setColor(white)
            gfx.drawq(v.image, v.quad, v.x, v.y, 0, 
                      v.image:getWidth(), v.image:getHeight())
        end
    end
end

function num_slides()
    return #slide_table
end

function current_slide()
    return slide_index
end

function get_custom_table()
    local slide = slide_table[slide_index]
    assert(slide)
    if slide.custom_table then
        return _G[slide.custom_table]
    end
end    

function next()
    if get_custom_table() then
        get_custom_table().exit()
    end

    slide_index = slide_index + 1
    if slide_index > slides.num_slides() then
        slide_index = slides.num_slides()
    end

    if get_custom_table() then
        get_custom_table().enter()
    end
end

function prev()

    if get_custom_table() then
        get_custom_table().exit()
    end

    slide_index = slide_index - 1
    if slide_index < 1 then
        slide_index = 1
    end

    if get_custom_table() then
        get_custom_table().enter()
    end
end
