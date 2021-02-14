
GameOverGTitleState = Class{__includes = BaseState}

function GameOverGTitleState:init(params)
    self.background = GameOverGBackground()
    self.player = gGlobalObjs['player']
    self.player.displayStats = false
    self.emptyStat = params.emptyStat
    self.opac = 0
    self.startFade = 6
    self.fadeTime = 5
    self.displayDialogue = 13
end

function GameOverGTitleState:enter()
    gGameOverSounds['wedding']:setLooping(true)
    gGameOverSounds['wedding']:play()

    Timer.after(self.startFade,
        function()
            Timer.tween(self.fadeTime, {
                [self] = {opac = 255}
            })
        end
    )

    Timer.after(self.displayDialogue,
        function()
            gStateStack:push(GameOverGDialogueState({emptyStat = self.emptyStat}))
        end
    )

end

function GameOverGTitleState:update(dt)
end

function GameOverGTitleState:render()
    self.background:render()

    love.graphics.setColor(0, 0, 0, self.opac)
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('GAME OVER', 0, VIRTUAL_HEIGHT/2-32, VIRTUAL_WIDTH, 'center')
    love.graphics.setColor(255, 255, 255, 255)
end
