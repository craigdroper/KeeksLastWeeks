UserInputState = Class{__includes = BaseState}

function UserInputState:init(prefix, invalidRegex, callback, nPrevState)
    self.inputbox = Inputbox(TEXT_X, TEXT_Y, TEXT_WIDTH, TEXT_HEIGHT, gFonts['medium'],
        prefix, invalidRegex)
    self.callback = callback or function() end
    self.nPrevState = nPrevState and nPrevState or 1
end

function UserInputState:update(dt)
    self.inputbox:update(dt)

    if self.inputbox:isClosed() then
        -- In order to pass back information, we will set the userInput
        -- attribute on the state before this
        prevState = gStateStack:getNPrevState(self.nPrevState)
        prevState.userInput = self.inputbox:getText()
        gStateStack:pop()
        -- Want to callback after we've popped the current dialogue state
        -- in case the callback is intending to push other new states onto
        -- the stack
        self.callback()
    end
end

function UserInputState:render()
    self.inputbox:render()
end
