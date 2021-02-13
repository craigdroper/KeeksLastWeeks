--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

DialogueState = Class{__includes = BaseState}

function DialogueState:init(
        text,
        callback,
        textX, textY, textWidth, textHeight,
        updateFunc, renderFunc )

    local text_x = TEXT_X
    if textX then
        text_x = textX
    end
    local text_y = TEXT_Y
    if textY then
        text_y = textY
    end
    local text_width = TEXT_WIDTH
    if textWidth then
        text_width = textWidth
    end
    local text_height = TEXT_HEIGHT
    if textHeight then
        text_height = textHeight
    end

    self.textbox = Textbox(text_x, text_y, text_width, text_height,
        text, gFonts['medium'])
    self.callback = callback or function() end
    self.updateFunc = updateFunc
    self.renderFunc = renderFunc
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

    if self.updateFunc then
        self.updateFunc(dt)
    end
end

function DialogueState:render()
    self.textbox:render()
end
