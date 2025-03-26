local Canvas = require 'canvas'
local CanvasEntity = require 'canvas-entity'
local Shapes = require 'shapes'
local Circle, Line = Shapes.Circle, Shapes.Line

local registerMouseInput
local registerKeyboardInput

local canvas
local previousPoint
local historyLocked = false

function love.load()
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

registerMouseInput = function ()
    if love.mouse.isDown(1) then
        local shape
        if previousPoint == nil then
            shape = Circle(3)
            canvas:registerHistoryPoint()
        else
            shape = Line(
                3,
                previousPoint[1] - love.mouse.getX(),
                previousPoint[2] - love.mouse.getY()
            )
        end

        previousPoint = {love.mouse.getX(), love.mouse.getY()}

        canvas:addEntity(CanvasEntity(
            love.mouse.getX(), love.mouse.getY(),{1, 1, 1}, shape
        ))
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
