
BarWBouncerState = Class{__includes = BaseState}

function BarWBouncerState:init(params)
    self.player = gGlobalObjs['player']
    self.exterior = params.exterior
end

function BarWBouncerState:enter()
    gStateStack:push(DialogueState('Bouncer: ID please.\n\n'..
        'Keeks: ID? Can\'t you see I\'m old enough?\n\n'..
        'Bouncer: Well sure, physically you look like you\'ve seen better days...'..
        'like back in the 50\'s when you were a kid. Still, something '..
        'about you still screams "I have the music tastes of a teenage girl", so I\'m '..
        'going to have to see some ID just to be sure.\n\n'..
        'Keeks: Ok ok, here you go.\n\n'..
        'Bouncer: Whoah! You\'re three years younger than me?! I can\'t believe that. '..
        'Well enjoy yourself Mr. Keeks.',
            function()
                self:tweenEnter()
            end))
end

function BarWBouncerState:tweenEnter()
    gSounds['footsteps']:play()
    local walkPixels = 50
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = self.player.x - walkPixels}
    }):finish(
        function()
    self.player:changeAnimation('walk-left')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = self.player.x - walkPixels, opacity=0}
    }):finish(
        function()
    gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
        function()
            -- Pop the Bouncer state off
            gStateStack:pop()
            gBarWSounds['exterior']:stop()
            gStateStack:push(BarWEnterState())
            gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                function()
                end))
        end))
        end)
        end)

end

function BarWBouncerState:update(dt)
    self.player:update(dt)
end

function BarWBouncerState:render()
    self.exterior:render()
    self.player:render()
end
