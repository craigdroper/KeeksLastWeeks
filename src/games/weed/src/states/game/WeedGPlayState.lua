--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGPlayState = Class{__includes = BaseState}

function WeedGPlayState:init()
    self.level = Level()

    --gWeedGSounds['field-music']:setLooping(true)
    --gWeedGSounds['field-music']:play()

    self.dialogueOpened = false
end

function WeedGPlayState:update(dt)
    if not self.dialogueOpened and love.keyboard.wasPressed('p') then

        -- heal player pokemon
        gWeedGSounds['heal']:play()
        self.level.player.party.pokemon[1].currentHP = self.level.player.party.pokemon[1].HP

        -- show a dialogue for it, allowing us to do so again when closed
        gStateStack:push(DialogueState('Your Pokemon has been healed!',

        function()
            self.dialogueOpened = false
        end))
    end

    self.level:update(dt)
end

function WeedGPlayState:render()
    self.level:render()
end
