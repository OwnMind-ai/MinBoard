local Object = require 'classic'

local Circle = Object:extend()

function Circle:new(radius)
    self.radius = radius
end

function Circle:draw(x, y, scale)
    love.graphics.circle("fill", x, y, self.radius * scale, 20)
end

local Line = Object:extend()

function Line:new(width, vx, vy)
    self.width = width
    self.vx = vx
    self.vy = vy
end

function Line:draw(x, y, scale)
    love.graphics.setLineWidth(self.width * scale)
    love.graphics.line(x + self.vx * scale, y + self.vy * scale, x, y)
end

return {Circle = Circle, Line = Line}
