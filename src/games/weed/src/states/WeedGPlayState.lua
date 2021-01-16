--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

WeedGPlayState = Class{__includes = BaseState}

function WeedGPlayState:init()
    self.level = WeedGLevel()

    --gWeedGSounds['field-music']:setLooping(true)
    --gWeedGSounds['field-music']:play()

    self.dialogueOpened = false
end

function WeedGPlayState:update(dt)
    self.level:update(dt)
end

function WeedGPlayState:render()
    self.level:render()
end
