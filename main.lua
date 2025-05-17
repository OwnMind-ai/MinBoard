local Canvas = require 'canvas'
local CanvasEntity = require 'canvas-entity'
local Shapes = require 'shapes'
local Circle, Line = Shapes.Circle, Shapes.Line

local registerMouseInput
local registerKeyboardInput

SCALE_RATE = 0.05
COLORS = {
    ['1'] = {1, 1, 1},
    ['2'] = {1, 0, 0},
    ['3'] = {0, 0, 1},
    ['4'] = {0, 1, 0},
    ['5'] = {1, 1, 0},
    ['6'] = {1, 0, 1},
    ['7'] = {0, 1, 1},
    ['8'] = {1, 0.5, 0},
    ['9'] = {0.5, 0, 1},
    ['0'] = {0, 0, 0},
    ['e'] = 'eraser'
}

local canvas
local previousPoint
local historyLocked = false
local pointStarted = false
local drawLocked = false

function love.load()
    love.window.setMode( 800, 600, {
        resizable = true,
        borderless = true,
        centered = true
    })
    canvas = Canvas()

    love.graphics.setBackgroundColor(unpack(canvas.background))
end

function love.update()
    registerMouseInput()
    registerKeyboardInput()
end

function love.draw()
    canvas:drawEntities()
end

function love.wheelmoved(_, direction)
    canvas.scale = canvas.scale * (1 + direction * SCALE_RATE)

    canvas.dx = canvas.dx - (love.mouse.getX() - canvas.dx) * direction * SCALE_RATE
    canvas.dy = canvas.dy - (love.mouse.getY() - canvas.dy) * direction * SCALE_RATE
end

function love.keypressed(key)
    if key == 'c' then
        canvas.dx = 0
        canvas.dy = 0
    elseif key == 'r' then
        canvas = Canvas()
    elseif key == '=' or key == '+' then
        canvas.brushSize = canvas.brushSize + 1
    elseif key == '-' or key == '_' then
        canvas.brushSize = math.max(canvas.brushSize - 1, 1)
    elseif COLORS[key] ~= nil then
        canvas.color = COLORS[key]
    end
end

registerMouseInput = function ()
    local mx = (love.mouse.getX() - canvas.dx) / canvas.scale
    local my = (love.mouse.getY() - canvas.dy) / canvas.scale

    if not drawLocked and love.mouse.isDown(1) then
        local shape

        if previousPoint == nil then
            pointStarted = true
            canvas:registerHistoryPoint()
        else
            if previousPoint[1] - mx ~= 0 or previousPoint[2] - my ~= 0 then
                pointStarted = false
                shape = Line(
                    canvas.brushSize,
                    previousPoint[1] - mx,
                    previousPoint[2] - my
                )

                canvas:addEntity(CanvasEntity( mx, my, canvas.color, shape))
            end
        end

        previousPoint = {mx, my}
    elseif love.mouse.isDown(3) then
        mx = love.mouse.getX()
        my = love.mouse.getY()

        if previousPoint ~= nil then
            canvas:displace(
                mx - previousPoint[1],
                my - previousPoint[2]
            )
        end

        drawLocked = true
        previousPoint = {mx, my}
    else
        if pointStarted then
            canvas:addEntity(CanvasEntity( mx, my, canvas.color, Circle(canvas.brushSize)))
            pointStarted = false
        end

        if previousPoint ~= nil and not drawLocked then
            canvas:poligonizeLast()
        end
        previousPoint = nil
        drawLocked = false
    end
end

registerKeyboardInput = function ()
    if love.keyboard.isDown('lctrl') and love.keyboard.isDown('z') then
        if not historyLocked then
            canvas:goBackToLastPoint()
        end
        historyLocked = true
    else
        historyLocked = false
    end
end
