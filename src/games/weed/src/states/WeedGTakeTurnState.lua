--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGTakeTurnState = Class{__includes = BaseState}

function WeedGTakeTurnState:init(battleState, missPercent, multiplier)
    self.battleState = battleState
    self.missPercent = missPercent
    self.multiplier = multiplier
    self.playerPokemon = self.battleState.player.weedGPokemon
    self.opponentPokemon = self.battleState.opponent.party.pokemon[1]

    self.playerSprite = self.battleState.playerSprite
    self.opponentSprite = self.battleState.opponentSprite

    self.firstPokemon = self.playerPokemon
    self.secondPokemon = self.opponentPokemon
    self.firstSprite = self.playerSprite
    self.secondSprite = self.opponentSprite
    self.firstBar = self.battleState.playerHealthBar
    self.secondBar = self.battleState.opponentHealthBar
end

function WeedGTakeTurnState:enter(params)
    self:attack(self.firstPokemon, self.secondPokemon, self.firstSprite, self.secondSprite, self.firstBar, self.secondBar, true,

    function()

        gStateStack:pop()

        -- check to see whether the player or enemy died
        if self:checkDeaths() then
            gStateStack:pop()
            return
        end

        Timer.after(0.5, function()
        self:attack(self.secondPokemon, self.firstPokemon, self.secondSprite, self.firstSprite, self.secondBar, self.firstBar, false,

        function()

            -- remove the message
            gStateStack:pop()

            -- check to see whether the player or enemy died
            if self:checkDeaths() then
                gStateStack:pop()
                return
            end

            -- remove the last attack state from the stack
            gStateStack:pop()
            gStateStack:push(WeedGBattleMenuState(self.battleState))
        end)
    end)
    end)
end

function WeedGTakeTurnState:attack(attacker, defender, attackerSprite, defenderSprite, attackerkBar, defenderBar, isPlayer, onEnd)

    -- first, push a message saying who's attacking, then flash the attacker
    -- this message is not allowed to take input at first, so it stays on the stack
    -- during the animation
    gStateStack:push(WeedGBattleMessageState(attacker.name .. ' attacks ' .. defender.name .. '!',
        function() end, false))

    local attackSuccess = true
    if isPlayer then
        attackSuccess = math.random(100) > self.missPercent
    else
        attackSuccess = math.random(100) > 20
    end
    -- Hack to make hits never miss on level 1 since that can cripple
    -- the player since its usually 2 hits and out
    if attacker.level == 1 then
        attackSuccess = true
    end

    -- pause for half a second, then play attack animation
    Timer.after(0.5, function()
        -- attack sound
        gWeedGSounds['powerup']:stop()
        gWeedGSounds['powerup']:play()
        gWeedGSounds['powerup_smoking']:stop()
        gWeedGSounds['powerup_smoking']:play()

        -- blink the attacker sprite three times (turn on and off blinking 6 times)
        Timer.every(0.1, function()
            attackerSprite.blinking = not attackerSprite.blinking
        end)
        :limit(6)
        :finish(function()

            -- after finishing the blink, play a hit sound and flash the opacity of
            -- the defender a few times
            if attackSuccess then
                gWeedGSounds['hit']:stop()
                gWeedGSounds['hit']:play()
                gWeedGSounds['hit_smoking']:stop()
                gWeedGSounds['hit_smoking']:play()
            else
                gWeedGSounds['miss']:stop()
                gWeedGSounds['miss']:play()
                gWeedGSounds['miss_smoking']:stop()
                gWeedGSounds['miss_smoking']:play()
            end

            Timer.every(0.1, function()
                defenderSprite.opacity = defenderSprite.opacity == 64 and 255 or 64
            end)
            :limit(6)
            :finish(function()

                -- shrink the defender's health bar over half a second, doing at least 1 dmg
                --local dmg = math.max(1, attacker.attack - defender.defense)
                local dmg = math.max(1, attacker.attack + math.random(-2, 2))
                if isPlayer then
                    dmg = dmg * self.multiplier
                end
                if not attackSuccess then
                    dmg = 0
                end

                Timer.tween(0.5, {
                    [defenderBar] = {value = defender.currentHP - dmg}
                })
                :finish(function()
                    defender.currentHP = defender.currentHP - dmg
                    onEnd()
                end)
            end)
        end)
    end)
    return true
end

function WeedGTakeTurnState:checkDeaths()
    if self.playerPokemon.currentHP <= 0 then
        self:faint()
        return true
    elseif self.opponentPokemon.currentHP <= 0 then
        self:victory()
        return true
    end

    return false
end

function WeedGTakeTurnState:faint()

    -- drop player sprite down below the window
    Timer.tween(0.2, {
        [self.playerSprite] = {y = VIRTUAL_HEIGHT}
    })
    :finish(function()

        -- when finished, push a loss message
        gStateStack:push(WeedGBattleMessageState('You fainted!',

        function()
            -- Pop TakeTurn state, push GameOver
            -- Looks like TakeTurn will actually be pushed after this method
            -- was called
            gStateStack:push(WeedGGameOverState({level=self.playerPokemon.level}))
        end))
    end)
end

function WeedGTakeTurnState:victory()

    -- drop enemy sprite down below the window
    Timer.tween(0.2, {
        [self.opponentSprite] = {y = VIRTUAL_HEIGHT}
    })
    :finish(function()
        -- play victory music
        -- gWeedGSounds['battle-music']:stop()

        gWeedGSounds['victory-music']:setLooping(true)
        gWeedGSounds['victory-music']:play()

        -- when finished, push a victory message
        gStateStack:push(WeedGBattleMessageState('Victory!',

        function()

            -- sum all IVs and multiply by level to get exp amount
            local exp = (self.opponentPokemon.HPIV + self.opponentPokemon.attackIV +
                self.opponentPokemon.defenseIV + self.opponentPokemon.speedIV) * self.opponentPokemon.level

            gStateStack:push(WeedGBattleMessageState('You earned ' .. tostring(exp) .. ' experience points!',
                function() end, false))

            Timer.after(1.5, function()
                gWeedGSounds['exp']:play()

                -- animate the exp filling up
                Timer.tween(0.5, {
                    [self.battleState.playerExpBar] = {value = math.min(self.playerPokemon.currentExp + exp, self.playerPokemon.expToLevel)}
                })
                :finish(function()

                    -- pop exp message off
                    gStateStack:pop()

                    self.playerPokemon.currentExp = self.playerPokemon.currentExp + exp

                    -- level up if we've gone over the needed amount
                    if self.playerPokemon.currentExp > self.playerPokemon.expToLevel then

                        gWeedGSounds['levelup']:play()

                        -- set our exp to whatever the overlap is
                        self.playerPokemon.currentExp = self.playerPokemon.currentExp - self.playerPokemon.expToLevel
                        self.playerPokemon:levelUp()

                        local levelUpMsg = 'Congratulations! You leveled Up!'
                        for _, attack in pairs(self.playerPokemon.attacks) do
                            if self.playerPokemon.level == attack.minLevel then
                                levelUpMsg = levelUpMsg .. '\nYou also learned some new skilzz: ' .. attack.text
                            end
                        end

                        gStateStack:push(WeedGBattleMessageState(levelUpMsg,
                        function()
                            if self.playerPokemon.level ~= 10 then
                                self:fadeOutWhite()
                            else
                                -- Pop TakeTurn state, push GameOver
                                -- Looks like TakeTurn will actually be pushed after this method
                                -- was called
                                gStateStack:push(WeedGGameOverState({level=self.playerPokemon.level}))
                            end
                        end))
                    else
                        self:fadeOutWhite()
                    end
                end)
            end)
        end))
    end)
end

function WeedGTakeTurnState:fadeOutWhite()
    -- fade in
    gStateStack:push(FadeInState({
        r = 255, g = 255, b = 255
    }, 1,
    function()

        -- resume field music
        gWeedGSounds['victory-music']:stop()
        --gWeedGSounds['field-music']:play()

        -- pop off the battle state
        gStateStack:pop()
        gStateStack:push(FadeOutState({
            r = 255, g = 255, b = 255
        }, 1, function() end))
    end))
end
