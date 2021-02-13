
IntroGIntroState = Class{__includes = BaseState}

function IntroGIntroState:init()
    self.opac = 0
    self.isFirstTitle = true
    self.startFirstFade = 12
    self.firstTitleTime = 12
    self.startSecFade = 31
    self.secTitleTime = 6
end

function IntroGIntroState:enter()
    gIntroSounds['odyssey']:play()
    local introDuration = gIntroSounds['odyssey']:getDuration()

    Timer.after(self.startFirstFade,
        function()
            Timer.tween(self.firstTitleTime/2, {
                [self] = {opac = 255}
            }):finish(
                function()
            Timer.tween(self.firstTitleTime/2, {
                [self] = {opac = 0}
            })
                end)
        end)
    Timer.after(self.startSecFade,
        function()
            self.isFirstTitle = false
            Timer.tween(self.secTitleTime, {
                [self] = {opac = 255}
            })
        end
    )

    Timer.after(introDuration,
        function()
            gStateStack:pop()
            gStateStack:push(IntroGMainMenuState())
        end)
end

function IntroGIntroState:update(dt)
end

function IntroGIntroState:render()
    love.graphics.setColor(255, 255, 255, self.opac)
    if self.isFirstTitle then
        love.graphics.setFont(gFonts['huge'])
        love.graphics.printf('Dirty Bit Studios', 0, VIRTUAL_HEIGHT/2-32, VIRTUAL_WIDTH, 'center')
    else
        love.graphics.setFont(gFonts['large'])
        love.graphics.printf('Proudly Presents', 0, VIRTUAL_HEIGHT/2-8, VIRTUAL_WIDTH, 'center')
    end
    love.graphics.setColor(255, 255, 255, 255)
end
