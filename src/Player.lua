--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init()
    Entity.init(self, ENTITY_DEFS['keeks'])

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

    -- Used to locally store a snapshot that can be loaded
    self.snap = nil

    self.stateMachine = StateMachine {
        -- Initial thought is that the player will only have to be "idle"
        -- since any movement is controlled completely by the program
        -- and there is no need for a "walk" type state where we need
        -- to check if we're interacting with the map
        ['idle'] = function() return PlayerIdleState(player) end,
    }
end

function Player:takeSnapshot()
    return {
        x = self.x,
        y = self.y,
        offsetX = self.offsetX,
        offsetY = self.offsetY,
        width = self.width,
        height = self.height,
        scaleX = self.scaleX,
        scaleY = self.scaleY,
        opacity = self.opacity,
        subQuadXShift = self.subQuadXShift,
        subQuadYShift = self.subQuadYShift,
        subQuadWShift = self.subQuadWShift,
        subQuadHShift = self.subQuadHShift,
        walkSpeed = self.walkSpeed,
        curAnimationName = self.curAnimationName
    }
end

function Player:loadSnapshot(snap)
    self.x = snap.x
    self.y = snap.y
    self.offsetX = snap.offsetX
    self.offsetY = snap.offsetY
    self.width = snap.width
    self.height = snap.height
    self.scaleX = snap.scaleX
    self.scaleY = snap.scaleY
    self.opacity = snap.opacity
    self.subQuadXShift = snap.subQuadXShift
    self.subQuadYShift = snap.subQuadYShift
    self.subQuadWShift = snap.subQuadWShift
    self.subQuadHShift = snap.subQuadHShift
    self.walkSpeed = snap.walkSpeed
    self:changeAnimation(snap.curAnimationName)
end

function Player:storeSnapshot()
    self.snap = self:takeSnapshot()
end

function Player:restoreSnapshot()
    self:loadSnapshot(self.snap)
    self.snap = nil
end

function Player:getPixelWalkTime(numPixels)
    return numPixels / (self.walkSpeed * self.walkSpeedMult)
end

function Player:update(dt)
    Entity.update(self, dt)
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
end
