--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

DialogueState = Class{__includes = BaseState}

-- function DialogueState:init(x, y, width, height, text, font, callback)
function DialogueState:init(text, callback)
    local tbwidth = VIRTUAL_WIDTH / 2
    local tbheight = 64
    local tbx = (VIRTUAL_WIDTH - tbwidth) / 2
    local boxYPad = 6
    local tby = (VIRTUAL_HEIGHT - tbheight - boxYPad)
    self.textbox = Textbox(tbx, tby, tbwidth, tbheight, text, gFonts['medium'])
    -- self.textbox = Textbox(x, y, width, height, text, font)
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
