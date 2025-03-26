local Object = require 'classic'

--@class CanvasEntity
local CanvasEntity = Object:extend()

function CanvasEntity:new(x, y, color, shape)
    self.x = x
    self.y = y
    self.color = color
    self.shape = shape
end

function CanvasEntity:draw()
    -- local width, height = love.window.getDimensions( )
    love.graphics.setColor(unpack(self.color))
    self.shape:draw(self.x, self.y)
end

return CanvasEntity
