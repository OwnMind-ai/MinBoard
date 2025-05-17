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

local PolyLine = Object:extend()

function PolyLine:new(width, startCords)
    self.width = width
    self.startCords = startCords
end

-- For polylines the origin x and is the first point of polyline
function PolyLine:draw(x, y, scale)
    local lines = {}
    local vx = x
    local vy = y

    table.insert(lines, x)
    table.insert(lines, y)

    for _, point in pairs(self.startCords) do
        vx = vx + point[1] * scale
        vy = vy + point[2] * scale
        table.insert(lines, vx)
        table.insert(lines, vy)
    end

    love.graphics.setLineWidth(self.width * scale)
    love.graphics.line(lines)
end



return {Circle = Circle, Line = Line, PolyLine = PolyLine}
