--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGBattleState = Class{__includes = BaseState}

function WeedGBattleState:init(player)
    self.player = player
    -- Refresh full HP
    self.player.weedGPokemon.currentHP = self.player.weedGPokemon.HP
    self.panelH = 64
    self.bottomPanel = Panel(0, VIRTUAL_HEIGHT - self.panelH, VIRTUAL_WIDTH, self.panelH)

    -- flag for when the battle can take input, set in the first update call
    self.battleStarted = false

    local playLevel = self.player.weedGPokemon.level
    local oppLevel = 0
    if playLevel < 2 then
        oppLevel = playLevel
    elseif playLevel < 6 then
        oppLevel = math.min(math.max(playLevel + math.random(1), 1),10)
    else
        oppLevel = math.min(math.max(playLevel + math.random(2), 1),10)
    end

    self.opponent = WeedGOpponent {
        party = WeedGParty {
            pokemon = {
                WeedGPokemon(WeedGPokemon.getRandomDef(), oppLevel, false)
            }
        }
    }

    self.playerSprite = WeedGBattleSprite(nil, -self.player:getWidth() - 100, true)
    self.opponentSprite = WeedGBattleSprite(self.opponent.party.pokemon[1].battleSpriteFront,
        VIRTUAL_WIDTH + 100, false)

    -- health bars for pokemon
    self.playerHealthBar = ProgressBar {
        x = 8,
        y = 8,
        width = 152,
        height = 6,
        color = {r = 189, g = 32, b = 32},
        value = self.player.weedGPokemon.currentHP,
        max = self.player.weedGPokemon.HP
    }

    self.opponentHealthBar = ProgressBar {
        x = VIRTUAL_WIDTH - 160,
        y = VIRTUAL_HEIGHT - 80,
        width = 152,
        height = 6,
        color = {r = 189, g = 32, b = 32},
        value = self.opponent.party.pokemon[1].currentHP,
        max = self.opponent.party.pokemon[1].HP
    }

    -- exp bar for player
    self.playerExpBar = ProgressBar {
        x = 8,
        y = 15,
        width = 152,
        height = 6,
        color = {r = 32, g = 32, b = 189},
        value = self.player.weedGPokemon.currentExp,
        max = self.player.weedGPokemon.expToLevel
    }

    -- flag for rendering health (and exp) bars, shown after pokemon slide in
    self.renderHealthBars = false

    -- circles underneath pokemon that will slide from sides at start
    self.playerCircleX = self.playerSprite.x + self.playerSprite.width/2
    self.opponentCircleX = self.opponentSprite.x + self.opponentSprite.width/2

    -- references to active pokemon
    self.playerPokemon = self.player.weedGPokemon
    self.opponentPokemon = self.opponent.party.pokemon[1]
end

function WeedGBattleState:enter(params)

end

function WeedGBattleState:exit()
    gWeedGSounds['battle-music']:stop()
    -- gWeedGSounds['field-music']:play()
end

function WeedGBattleState:update(dt)
    -- this will trigger the first time this state is actively updating on the stack
    if not self.battleStarted then
        self:triggerSlideIn()
    end
end

function WeedGBattleState:render()
    love.graphics.clear(214, 214, 214, 255)

    love.graphics.setColor(45, 184, 45, 124)
    local circlePad = 0
    self.circleW = 100
    self.circleH = 36
    love.graphics.ellipse('fill',
        self.opponentCircleX, self.opponentSprite.y + self.opponentSprite.height + circlePad,
        self.circleW, self.circleH)
    love.graphics.ellipse('fill',
        self.playerCircleX, self.playerSprite.y + self.playerSprite.height + circlePad,
        self.circleW, self.circleH)

    love.graphics.setColor(255, 255, 255, 255)
    self.opponentSprite:render()
    self.playerSprite:render()

    if self.renderHealthBars then
        self.playerHealthBar:render()
        self.opponentHealthBar:render()
        self.playerExpBar:render()

        -- render level text
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.setFont(gFonts['small'])
        love.graphics.print('LV ' .. tostring(self.playerPokemon.level),
            self.playerHealthBar.x, self.playerHealthBar.y - 10)
        love.graphics.print('LV ' .. tostring(self.opponentPokemon.level),
            self.opponentHealthBar.x, self.opponentHealthBar.y + 8)
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(255, 255, 255, 255)
    end

    self.bottomPanel:render()
end

function WeedGBattleState:triggerSlideIn()
    self.battleStarted = true

    -- slide the sprites and circles in from the edges, then trigger first dialogue boxes
    local playerX = 96
    local oppX = VIRTUAL_WIDTH - 250
    Timer.tween(1, {
        [self.playerSprite] = {x = playerX},
        [self.opponentSprite] = {x = oppX},
        [self] = {
        playerCircleX = playerX + self.playerSprite.width/2,
        opponentCircleX = oppX + self.opponentSprite.width/2}
    })
    :finish(function()
        self:triggerStartingDialogue()
        self.renderHealthBars = true
    end)
end

function WeedGBattleState:triggerStartingDialogue()

    -- display a dialogue first for the pokemon that appeared, then the one being sent out
    gStateStack:push(WeedGBattleMessageState('A wild ' .. tostring(self.opponent.party.pokemon[1].name ..
        ' appeared, time to blaze up!'),

    -- callback for when the battle message is closed
    function()
    gStateStack:push(WeedGBattleMessageState('Remember, your more advanced smoking techniques will do more damage, but also have a higher chance of missing',
    function()
        gStateStack:push(WeedGBattleMessageState('Go, Keeks!',
        -- push a battle menu onto the stack that has access to the battle state
        function()
            gStateStack:push(WeedGBattleMenuState(self))
        end))
    end))
    end))
end
