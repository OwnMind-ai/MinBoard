local Object = require 'classic'

local Circle = Object:extend()

function Circle:new(radius)
    self.radius = radius
end

function Circle:draw(x, y)
    love.graphics.circle("fill", x, y, self.radius, 5)
end

local Line = Object:extend()

function Line:new(width, vx, vy)
    self.width = width
    self.vx = vx
    self.vy = vy
end

function Line:draw(x, y)
    love.graphics.setLineWidth(self.width)
    love.graphics.line(x + self.vx, y + self.vy, x, y)
end

return {Circle = Circle, Line = Line}
