local Canvas = require 'canvas'
local CanvasEntity = require 'canvas-entity'
local Shapes = require 'shapes'
local Circle, Line = Shapes.Circle, Shapes.Line

local registerMouseInput
local registerKeyboardInput

SCALE_RATE = 0.05

local canvas
local previousPoint
local historyLocked = false

function love.load()
    love.window.setMode( 800, 600, {
        resizable = true,
        borderless = true,
        centered = true
    })
    canvas = Canvas()

    love.graphics.setBackgroundColor(32 / 255, 33 / 255, 36 / 255)
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
    elseif key == 'w' then
        canvas.entities = {}
        canvas.historyPoints = {}
    end
end

registerMouseInput = function ()
    if love.mouse.isDown(1) then
        local shape
        local mx = (love.mouse.getX() - canvas.dx) / canvas.scale
        local my = (love.mouse.getY() - canvas.dy) / canvas.scale

        if previousPoint == nil then
            shape = Circle(3)

            canvas:registerHistoryPoint()
        else
            shape = Line(
                3,
                previousPoint[1] - mx,
                previousPoint[2] - my
            )
        end

        previousPoint = {mx, my}

        canvas:addEntity(CanvasEntity( mx, my, {1, 1, 1}, shape))
    elseif love.mouse.isDown(3) then
        local mx = love.mouse.getX() / canvas.scale
        local my = love.mouse.getY() / canvas.scale

        if previousPoint ~= nil then
            canvas:displace(
                mx - previousPoint[1],
                my - previousPoint[2]
            )
        end

        previousPoint = {mx, my}
    else
        previousPoint = nil
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
