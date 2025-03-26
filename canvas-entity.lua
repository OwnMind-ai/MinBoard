local Object = require 'classic'

--@class CanvasEntity
local CanvasEntity = Object:extend()

function CanvasEntity:new(x, y, color, shape)
    self.x = x
    self.y = y
    self.color = color
    self.shape = shape
end

function CanvasEntity:draw(canvas)
    if type(self.color) == "table" then
        love.graphics.setColor(unpack(self.color))
    else
        love.graphics.setColor(unpack(canvas.background))
    end

    self.shape:draw(
        self.x * canvas.scale + canvas.dx,
        self.y * canvas.scale + canvas.dy,
        canvas.scale
    )
end

return CanvasEntity
