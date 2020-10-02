--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init()
    Entity.init(self, ENTITY_DEFS['keeks'])

    -- A speed that can be set per scene to better accomodate different
    -- scene pixel sizes
    self.walkSpeed = nil
    -- Purely used for DEV reasons when we want to test something besides
    -- the players walking speed
    self.walkSpeedMult = PLAYER_WALK_SPEED_MULT

    self.time = 100
    self.health = 100
    self.money = 1000
    self.fun = 0
    self.statsFont = gFonts['large']

    -- This is used to indicate that the player is just beginning the
    -- game and is entering his first state
    self.isFirstScene = true

    self.stateMachine = StateMachine {
        -- Initial thought is that the player will only have to be "idle"
        -- since any movement is controlled completely by the program
        -- and there is no need for a "walk" type state where we need
        -- to check if we're interacting with the map
        ['idle'] = function() return PlayerIdleState(player) end,
    }
end

function Player:getPixelWalkTime(numPixels)
    return numPixels / (self.walkSpeed * self.walkSpeedMult)
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
        self.y = self.y + self.walkSpeed * self.walkSpeedMult * dt
    elseif self.direction == 'down' then
        self.y = self.y - self.walkSpeed * self.walkSpeedMult * dt
    elseif self.direction == 'right' then
        self.x = self.x - self.walkSpeed * self.walkSpeedMult * dt
    elseif self.direction == 'left' then
        self.x = self.x + self.walkSpeed * self.walkSpeedMult * dt
    end
end

function Player:genStatsDisp()
    local statsDisp = {}

    local strTime = string.format('%s', self.time)
    local text = string.format('T:%4s', strTime)
    local textH = self.statsFont:getHeight()
    local textW = self.statsFont:getWidth(text)
    statsDisp[TIME_NAME] =
        {text = text, x = VIRTUAL_WIDTH - textW,
         y = 0, height = textH, width = textW}

    local strHealth = string.format('%s', self.health)
    local text = string.format('H:%4s', strHealth)
    local textW = self.statsFont:getWidth(text)
    statsDisp[HEALTH_NAME] =
        {text = text, x = VIRTUAL_WIDTH - textW,
         y = textH, height = textH, width = textW}

    local strMoney = string.format('%s', self.money)
    local text = string.format('M:%4s', strMoney)
    local textW = self.statsFont:getWidth(text)
    statsDisp[MONEY_NAME] =
        {text = text, x = VIRTUAL_WIDTH - textW,
         y = 2*textH, height = textH, width = textW}

    local strFun = string.format('%s', self.fun)
    local text = string.format('F:%4s', strFun)
    local textW = self.statsFont:getWidth(text)
    statsDisp[FUN_NAME] =
        {text = text, x = VIRTUAL_WIDTH - textW,
         y = 3*textH, height = textH, width = textW}

     return statsDisp
end

function Player:getStatMidCoords(statName)
    statsDisp = self:genStatsDisp()
    disp = statsDisp[statName]
    return disp.x + disp.width/2, disp.y + disp.height/2
end

-- Called in main.lua since we always want this to be displayed
function Player:renderStats()
    statsDisp = self:genStatsDisp()
    love.graphics.setFont(self.statsFont)

    disp = statsDisp[TIME_NAME]
    love.graphics.setColor(TIME_RGB.r, TIME_RGB.g, TIME_RGB.b, 255)
    love.graphics.print(disp.text, disp.x, disp.y)

    disp = statsDisp[HEALTH_NAME]
    love.graphics.setColor(HEALTH_RGB.r, HEALTH_RGB.g, HEALTH_RGB.b, 255)
    love.graphics.print(disp.text, disp.x, disp.y)

    disp = statsDisp[MONEY_NAME]
    love.graphics.setColor(MONEY_RGB.r, MONEY_RGB.g, MONEY_RGB.b)
    love.graphics.print(disp.text, disp.x, disp.y)

    disp = statsDisp[FUN_NAME]
    love.graphics.setColor(FUN_RGB.r, FUN_RGB.g, FUN_RGB.b, 255)
    love.graphics.print(disp.text, disp.x, disp.y)

    love.graphics.setColor(255, 255, 255, 255)
end

function Player:render()
    Entity.render(self)
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
