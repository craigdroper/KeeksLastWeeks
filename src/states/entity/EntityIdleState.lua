--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

EntityIdleState = Class{__includes = BaseState}

function EntityIdleState:init(entity)
    self.entity = entity

    self.entity:changeAnimation('idle-' .. self.entity.direction)

    -- used for AI waiting
    self.waitDuration = 0
    self.waitTimer = 0
end

function EntityIdleState:processAI(params, dt)
    if self.waitDuration == 0 then
        self.waitDuration = math.random(5)
    else
        self.waitTimer = self.waitTimer + dt

        if self.waitTimer > self.waitDuration then
            self.entity:changeState('walk')
        end
    end
end

function EntityIdleState:render()
    local anim = self.entity.currentAnimation
    love.graphics.setColor(255, 255, 255, self.entity.opacity)

    local animTexture = gTextures[anim.texture]
    local animFrame = gFrames[anim.texture][anim:getCurrentFrame()]
    if self.entity.subQuadXShift then
        local origFrameX, origFrameY, origFrameW, origFrameH = animFrame:getViewport()
        animFrame = love.graphics.newQuad(
            origFrameX + self.entity.subQuadXShift,
            origFrameY + self.entity.subQuadYShift,
            origFrameW + self.entity.subQuadWShift,
            origFrameH + self.entity.subQuadHShift,
            animTexture:getDimensions())
    end

    love.graphics.filterDrawQ(
        animTexture,
        animFrame,
        math.floor(self.entity.x - self.entity.offsetX * self.entity.scaleX),
        math.floor(self.entity.y - self.entity.offsetY * self.entity.scaleY),
        self.entity.orientation,
        self.entity.scaleX,
        self.entity.scaleY)
    love.graphics.setColor(255, 255, 255, 255)

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.entity.x, self.entity.y, self.entity.width, self.entity.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
