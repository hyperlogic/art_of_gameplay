local printf = function (...) print(string.format(...)) end
local insert = table.insert
local gfx = love.graphics

module("slides", package.seeall)

local slide_table = {}
local fonts = {}
local slide_index = 1

function load(filename)

    slide_index = 1

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

    fonts = {h1 = gfx.newFont("FreeSansBold.otf", h1_metrics.y_size),
             h2 = gfx.newFont("FreeSansBold.otf", h2_metrics.y_size),
             bullet = gfx.newFont("FreeSansBold.otf", bullet_metrics.y_size),}

    local slide = {}
    local y = top_y_offset

    -- crappy markdown-ish parser
    for line in io.lines(filename) do
        if line:sub(1,2) == "##" then
            -- h2
            local text = line:sub(3)
            insert(slide, {font = fonts.h2,
                           text = text,
                           x = h2_metrics.x_offset,
                           y = y,
                           align = h2_metrics.align})
            y = y + h2_metrics.y_size + h2_metrics.y_offset
        elseif line:sub(1,1) == "#" then
            -- h1
            local text = line:sub(3)
            insert(slide, {font = fonts.h1,
                           text = text,
                           x = h1_metrics.x_offset,
                           y = y,
                           align = h1_metrics.align})
            y = y + h1_metrics.y_size + h1_metrics.y_offset
        elseif line:sub(1,2) == "* " then
            -- bullet point!
            local text = line:sub(3)
            insert(slide, {font = fonts.bullet,
                           text = "* "..text,
                           x = bullet_metrics.x_offset,
                           y = y,
                           align = bullet_metrics.align})
            y = y + bullet_metrics.y_size + bullet_metrics.y_offset
        elseif line:sub(1,3) == "---" then
            -- end of slide
            insert(slide_table, slide)
            y = top_y_offset
            slide = {}
        end
    end
end

function draw()

    local white = {255, 255, 255, 255}
    local black = {0, 0, 0, 192}
    local drop_offset_x = 3
    local drop_offset_y = 4

    local slide = slide_table[slide_index]
    assert(slide)
    for i, v in ipairs(slide) do
        gfx.setFont(v.font)
        gfx.setColor(black)
        gfx.printf(v.text, v.x + drop_offset_x, v.y + drop_offset_y, gfx.getWidth(), v.align)

        gfx.setColor(white)
        gfx.printf(v.text, v.x, v.y, gfx.getWidth(), v.align)
    end
end

function num_slides()
    return #slide_table
end

function current_slide()
    return slide_index
end

function next()
    slide_index = slide_index + 1
    if slide_index > slides.num_slides() then
        slide_index = slides.num_slides()
    end
end

function prev()
    slide_index = slide_index - 1
    if slide_index < 1 then
        slide_index = 1
    end
end
