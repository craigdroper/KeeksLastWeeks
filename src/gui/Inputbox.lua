
Inputbox = Class{}

function Inputbox:init(x, y, width, height, font, prefix, invalidRegex)
    self.panel = Panel(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.closed = false

    self.font = font or gFonts['small']
    self.prefix = prefix and prefix or ''
    self.invalidRegex = invalidRegex and invalidRegex or nil
    self.textH = self.font:getHeight()
    love.keyboard.clearCurrentText()
    self.text = love.keyboard.getCurrentText()
    self.isValidText = true

    self.cursorW = 5
    self.printCursor = true
    Timer.every(0.5, function() self.printCursor = not self.printCursor end)
end

function Inputbox:update(dt)
    self.text = love.keyboard.getCurrentText()

    if self.invalidRegex then
        if self.text:match(self.invalidRegex) then
            self.isValidText = false
        else
            self.isValidText = true
        end
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        if not self.isValidText then
            gSounds['hurt']:play()
        else
            self.closed = true
        end
    end
end

function Inputbox:isClosed()
    return self.closed
end

function Inputbox:getText()
    return self.text
end

function Inputbox:render()
    self.panel:render()

    love.graphics.setFont(self.font)
    local fullText = self.prefix .. self.text
    local textW = self.font:getWidth(fullText)
    -- Print the currently input text
    local textX = self.x + (self.width - textW)/2
    local textY = self.y + (self.height - self.textH)/2
    if self.isValidText then
        love.graphics.setColor(255, 255, 255, 255)
    else
        love.graphics.setColor(255, 0, 0, 255)
    end
    love.graphics.print(fullText, textX, textY)
    -- Print a blinking cursor
    if self.printCursor then
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.rectangle('fill', textX + textW,
            textY, self.cursorW, self.textH)
    end
    love.graphics.setColor(255, 255, 255, 255)

end
