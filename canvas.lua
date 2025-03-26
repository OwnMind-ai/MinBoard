local Object = require "classic"

--@class Canvas
local Canvas = Object:extend()

function Canvas:new()
    self.entities = {}
    self.dx = 0
    self.dy = 0
    -- Array of entities contains them in the order they have been drew.
    -- Thus, historyPoints array can store the indexes from which last 'line' started
    self.historyPoints = {}
end

function Canvas:registerHistoryPoint()
    table.insert(self.historyPoints, #self.entities)
end

function Canvas:goBackToLastPoint()
    if #self.historyPoints <= 0 then
        return
    end

    local point = self.historyPoints[#self.historyPoints]
    table.remove(self.historyPoints, #self.historyPoints)

    for i = #self.entities, point + 1, -1 do
        table.remove(self.entities, i)
    end
end

function Canvas:displace(dx, dy)
    self.dx = self.dx + dx
    self.dy = self.dy + dy
end

function Canvas:addEntity(entity)
    table.insert(self.entities, entity)
end

function Canvas:drawEntities()
    for _, entity in pairs(self.entities) do
        entity:draw(self)
    end
end

return Canvas
