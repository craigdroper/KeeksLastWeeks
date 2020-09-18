--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

DialogueState = Class{__includes = BaseState}

-- function DialogueState:init(x, y, width, height, text, font, callback)
function DialogueState:init(text, callback)
    self.textbox = Textbox(TEXT_X, TEXT_Y, TEXT_WIDTH, TEXT_HEIGHT,
        text, gFonts['medium'])
    self.callback = callback or function() end
end

function DialogueState:update(dt)
    self.textbox:update(dt)

    if self.textbox:isClosed() then
        self.callback()
        gStateStack:pop()
    end
end

function DialogueState:render()
    self.textbox:render()
end