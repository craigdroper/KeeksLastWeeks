--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGBattleState = Class{__includes = BaseState}

function WeedGBattleState:init(player)
    self.player = player
    self.bottomPanel = Panel(0, VIRTUAL_HEIGHT - 64, VIRTUAL_WIDTH, 64)

    -- flag for when the battle can take input, set in the first update call
    self.battleStarted = false

    self.opponent = WeedGOpponent {
        party = WeedGParty {
            pokemon = {
                WeedGPokemon(WeedGPokemon.getRandomDef(), math.random(2, 6))
            }
        }
    }

    self.playerSprite = WeedGBattleSprite(nil, -64, VIRTUAL_HEIGHT - 128, true)
    self.opponentSprite = WeedGBattleSprite(self.opponent.party.pokemon[1].battleSpriteFront,
        VIRTUAL_WIDTH, 8, false)

    -- health bars for pokemon
    self.playerHealthBar = ProgressBar {
        x = VIRTUAL_WIDTH - 160,
        y = VIRTUAL_HEIGHT - 80,
        width = 152,
        height = 6,
        color = {r = 189, g = 32, b = 32},
        value = self.player.weedGPokemon.currentHP,
        max = self.player.weedGPokemon.HP
    }

    self.opponentHealthBar = ProgressBar {
        x = 8,
        y = 8,
        width = 152,
        height = 6,
        color = {r = 189, g = 32, b = 32},
        value = self.opponent.party.pokemon[1].currentHP,
        max = self.opponent.party.pokemon[1].HP
    }

    -- exp bar for player
    self.playerExpBar = ProgressBar {
        x = VIRTUAL_WIDTH - 160,
        y = VIRTUAL_HEIGHT - 73,
        width = 152,
        height = 6,
        color = {r = 32, g = 32, b = 189},
        value = self.player.weedGPokemon.currentExp,
        max = self.player.weedGPokemon.expToLevel
    }

    -- flag for rendering health (and exp) bars, shown after pokemon slide in
    self.renderHealthBars = false

    -- circles underneath pokemon that will slide from sides at start
    self.playerCircleX = -68
    self.opponentCircleX = VIRTUAL_WIDTH + 32

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
    love.graphics.ellipse('fill', self.opponentCircleX, 60, 72, 24)
    love.graphics.ellipse('fill', self.playerCircleX, VIRTUAL_HEIGHT - 64, 72, 24)

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
    Timer.tween(1, {
        [self.playerSprite] = {x = 32},
        [self.opponentSprite] = {x = VIRTUAL_WIDTH - 96},
        [self] = {playerCircleX = 66, opponentCircleX = VIRTUAL_WIDTH - 70}
    })
    :finish(function()
        self:triggerStartingDialogue()
        self.renderHealthBars = true
    end)
end

function WeedGBattleState:triggerStartingDialogue()

    -- display a dialogue first for the pokemon that appeared, then the one being sent out
    gStateStack:push(WeedGBattleMessageState('A wild ' .. tostring(self.opponent.party.pokemon[1].name ..
        ' appeared!'),

    -- callback for when the battle message is closed
    function()
        gStateStack:push(WeedGBattleMessageState('Go, Keeks!',

        -- push a battle menu onto the stack that has access to the battle state
        function()
            gStateStack:push(WeedGBattleMenuState(self))
        end))
    end))
end
