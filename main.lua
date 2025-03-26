local Canvas = require 'canvas'
local CanvasEntity = require 'canvas-entity'
local Shapes = require 'shapes'
local Circle, Line = Shapes.Circle, Shapes.Line

local canvas
local previousPoint

function love.load()
    canvas = Canvas()

    love.graphics.setBackgroundColor(32 / 255, 33 / 255, 36 / 255)
end

function love.update()
    if love.mouse.isDown(1) then
        local shape
        if previousPoint == nil then
            shape = Circle(3)
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

function love.draw()
    canvas:drawEntites()
end
