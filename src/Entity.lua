--[[
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Repurposed by croper for KLW
]]

Entity = Class{}

function Entity:init(def)

    -- in top-down games, there are four directions instead of two
    self.direction = 'down'

    self.animations = self:createAnimations(def.animations)
    self.curAnimationName = nil

    -- dimensions
    self.x = def.x
    self.y = def.y
    self.width = def.width
    self.height = def.height

    -- drawing offsets for padded sprites
    self.offsetX = def.offsetX or 0
    self.offsetY = def.offsetY or 0

    self.orientation = def.orientation or 0

    -- drawing scale factors for world rooms with differe
    self.scaleX = def.scaleX or 1
    self.scaleY = def.scaleY or 1

    self.opacity = 255

    -- These values can be set to request that only a subsection of
    -- the entity's animation quad is drawn
    self.subQuadXShift = nil
    self.subQuadYShift = nil
    self.subQuadWShift = nil
    self.subQuadHShift = nil

    self.walkSpeed = def.walkSpeed

end

function Entity:getY()
    return self.y
end

function Entity:getX()
    return self.x
end

function Entity:getWidth()
    return self.scaleX * self.width
end

function Entity:getHeight()
    return self.scaleY * self.height
end

function Entity:setSubQuadShifts(xShift, yShift, wShift, hShift)
    self.subQuadXShift = xShift
    self.subQuadYShift = yShift
    self.subQuadWShift = wShift
    self.subQuadHShift = hShift
end

function Entity:clearSubQuad()
    self.subQuadXShift = nil
    self.subQuadYShift = nil
    self.subQuadWShift = nil
    self.subQuadHShift = nil
end

function Entity:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval,
            looping = animationDef.looping
        }
    end

    return animationsReturned
end

--[[
    AABB with some slight shrinkage of the box on the top side for perspective.
]]
function Entity:collides(target)
    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                self.y + self.height < target.y or self.y > target.y + target.height)
end

function Entity:changeState(name, params)
    self.stateMachine:change(name, params)
end

function Entity:changeAnimation(name)
    self.curAnimationName = name
    self.currentAnimation = self.animations[name]
end

function Entity:update(dt)
    self.stateMachine:update(dt)

    if self.currentAnimation then
        self.currentAnimation:update(dt)
    end
end

-- function Entity:render(adjacentOffsetX, adjacentOffsetY)
function Entity:render()
    self.stateMachine:render()
    love.graphics.setColor(255, 255, 255, 255)
end
