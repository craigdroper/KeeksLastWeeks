
DateWHostWelcomeState = Class{__includes = BaseState}

function DateWHostWelcomeState:init(params)
    self.player = gGlobalObjs['player']
    self.lobby = params.lobby
end

function DateWHostWelcomeState:enter()
    gStateStack:push(DialogueState('Keeks: Good evening...or afternoon? I\'m not really sure...'..
        'Anyway, I\'m meeting my fiance here for a date, I may be a few minutes '..
        'or hours late but...\n'..
        'Host: Ah yes good evening monsieur Keeks. Your date has already arrived, '..
        'and believe it or not, hasn\'t left after all this time waiting. She is '..
        'at your usual table, you know the way, yes?\n'..
        'Keeks: You sure you won\'t show me the way, I\'d prefer some protection, '..
        'or at least witnesses when I join her at the table\n'..
        'Host: I took an uppercut for you last time monsieur, I\'m sure you can '..
        'handle yourself alone this time. Enjoy your dinner!\n'..
        'Keeks: *Shit, here goes nothing.*',
            function()
                self:tweenEnter()
            end))
end

function DateWHostWelcomeState:tweenEnter()
    gSounds['footsteps']:play()
    local walkPixels = self.player.x - self.player:getWidth()
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = -self.player:getWidth()}
    }):finish(
        function()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the HostWelcome state off
            gStateStack:pop()
            gStateStack:push(DateWEnterRestState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end)

end

function DateWHostWelcomeState:update(dt)
    self.player:update(dt)
end

function DateWHostWelcomeState:render()
    self.lobby:render()
    self.player:render()
end
