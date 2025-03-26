local Object = require "classic"

--@class Canvas
local Canvas = Object:extend()

function Canvas:new()
    self.entites = {}
end

-- @param entity CanvasEntity
function Canvas:addEntity(entity)
    table.insert(self.entites, entity)
end

function Canvas:drawEntites()
    for _, entity in pairs(self.entites) do
        entity:draw()
    end
end

return Canvas
