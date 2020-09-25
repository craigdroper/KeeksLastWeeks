--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, {
        animations = ENTITY_DEFS['keeks'].animations,
        walkSpeed = ENTITY_DEFS['keeks'].walkSpeed,
        width = 36,
        height = 58,
        x = (VIRTUAL_WIDTH - 77) / 2,
        y = (VIRTUAL_HEIGHT - 77) / 2
    })

    self.time = 100
    self.health = 100
    self.money = 1000
    self.fun = 0
end

function Player:update(dt)
    Entity.update(self, dt)
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2

    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end

function Player:adjustSolidCollision(object, dt)
    -- according to the current direction of the player entity, adjust its
    -- position outside the bounds of the object
    -- reset position with a little extra padding (2 pixels) to prevent
    -- buggy repositioning of character
    if self.direction == 'up' then
        self.y = self.y + PLAYER_WALK_SPEED * dt
    elseif self.direction == 'down' then
        self.y = self.y - PLAYER_WALK_SPEED * dt
    elseif self.direction == 'right' then
        self.x = self.x - PLAYER_WALK_SPEED * dt
    elseif self.direction == 'left' then
        self.x = self.x + PLAYER_WALK_SPEED * dt
    end
end

-- Called in main.lua since we always want this to be displayed
function Player:renderStats()
    local font = gFonts['large']
    love.graphics.setFont(font)

    local strTime = string.format('%s', self.time)
    local timeText = string.format('T:%4s', strTime)
    local textH = font:getHeight()
    local textW = font:getWidth(timeText)
    love.graphics.setColor(0, 0, 255, 255)
    love.graphics.print(timeText, VIRTUAL_WIDTH - textW, 0)

    local strHealth = string.format('%s', self.health)
    local healthText = string.format('H:%4s', strHealth)
    local textW = font:getWidth(healthText)
    love.graphics.setColor(255, 0, 0, 255)
    love.graphics.print(healthText, VIRTUAL_WIDTH - textW, textH)

    local strMoney = string.format('%s', self.money)
    local moneyText = string.format('M:%4s', strMoney)
    local textW = font:getWidth(moneyText)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print(moneyText, VIRTUAL_WIDTH - textW, 2*textH)

    local strFun = string.format('%s', self.fun)
    local funText = string.format('F:%4s', strFun)
    local textW = font:getWidth(funText)
    love.graphics.setColor(255, 255, 0, 255)
    love.graphics.print(funText, VIRTUAL_WIDTH - textW, 3*textH)

    love.graphics.setColor(255, 255, 255, 255)
end

function Player:render()
    Entity.render(self)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
