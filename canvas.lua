local Object = require "classic"
local CanvasEntity = require 'canvas-entity'
local Shapes = require 'shapes'
local PolyLine = Shapes.PolyLine

--@class Canvas
local Canvas = Object:extend()

function Canvas:new()
    self.entities = {}
    self.dx = 0
    self.dy = 0
    self.scale = 1
    self.brushSize = 3
    self.color = {1, 1, 1}
    self.background = {32 / 255, 33 / 255, 36 / 255}
    -- Array of entities contains them in the order they have been drew.
    -- Thus, historyPoints array can store the indexes from which last 'line' started (no redo tho)
    self.historyPoints = {}
end

-- Transforms lines from the last history point to a single polygon line
function Canvas:poligonizeLast()
    local point = self.historyPoints[#self.historyPoints]
    if point == nil then
        point = 0
    end

    local startCords = {}
    local firstX = self.entities[#self.entities].x
    local firstY = self.entities[#self.entities].y

    for i = #self.entities, point + 1, -1 do
        local entity = self.entities[i]
        if entity.shape.radius ~= nil then
            return
        end
        table.remove(self.entities, i)

        table.insert(startCords, {entity.shape.vx, entity.shape.vy})
    end

    local poly = PolyLine(self.brushSize, startCords)
    table.insert(self.entities, CanvasEntity(firstX, firstY, self.color, poly))
end

function Canvas:registerHistoryPoint()
    table.insert(self.historyPoints, #self.entities)
end

function Canvas:goBackToLastPoint()
    if #self.historyPoints <= 0 then
        return
    end

    -- TODO just remove one, since polylines are one entity
    -- You even can do redo with floating history point and deletion of future on insert
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
