
CasGDispResState = Class{__includes = BaseState}

function CasGDispResState:init(params)
    self.result = params.result
    self.font = gFonts['huge']
    if self.result == 'WIN' then
        self.rgb = {r=0, g=255, b=0}
    else
        self.rgb = {r=255, g=0, b=0}
    end
    local textW = self.font:getWidth(self.result)
    local textH = self.font:getHeight()
    self.x = (VIRTUAL_WIDTH - textW)/2
    self.y = (VIRTUAL_HEIGHT - textH)/2
    self.opacity = 0
    self.tweenFinished = false
end

function CasGDispResState:enter()
    self:tweenDisplay()
end

function CasGDispResState:tweenDisplay()
    Timer.tween(2, {
        [self] = {opacity = 255}
    }):finish(
        function()
            self.tweenFinished = true
        end)
end

function CasGDispResState:update(dt)
    if self.tweenFinished then
        -- Pop this display result state
        gStateStack:pop()
    end
end

function CasGDispResState:render()
    love.graphics.setFont(self.font)
    love.graphics.setColor(self.rgb.r, self.rgb.g, self.rgb.b, self.opacity)
    love.graphics.print(self.result, self.x, self.y)
    love.graphics.setColor(255, 255, 255, 255)
end
