--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

DialogueState = Class{__includes = BaseState}

function DialogueState:init(text, callback)
    self.textbox = Textbox(TEXT_X, TEXT_Y, TEXT_WIDTH, TEXT_HEIGHT,
        text, gFonts['medium'])
    self.callback = callback or function() end
end

function DialogueState:update(dt)
    self.textbox:update(dt)

    if self.textbox:isClosed() then
        -- self.callback()
        gStateStack:pop()
        -- Want to callback after we've popped the current dialogue state
        -- in case the callback is intending to push other new states onto
        -- the stack
        self.callback()
    end
end

function DialogueState:render()
    self.textbox:render()
end
