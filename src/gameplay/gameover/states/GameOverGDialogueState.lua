
GameOverGDialogueState = Class{__includes = BaseState}

function GameOverGDialogueState:init(params)
    self.emptyStat = params.emptyStat
    self.player = gGlobalObjs['player']
    self.message = 'Congratulations on having ' .. self.player.fun .. ' fun!\n'
end

function GameOverGDialogueState:enter()
    if self.emptyStat == HEALTH_NAME then
        self:setHealthMessage()
    elseif self.emptyStat == TIME_NAME then
        self:setTimeMessage()
    elseif self.emptyStat == MONEY_NAME then
        self:setMoneyMessage()
    end

    gStateStack:push(DialogueState(
        self.message,
        function()
            -- Pop off this state and return to the Menu state
            gStateStack:pop()
            -- Push a Game Over Menu state
            gStateStack:push(GameOverGMenuState())
        end
    ))
end

function GameOverGDialogueState:setHealthMessage()
    self.message = self.message .. 'Unfortunately, your health has hit all time lows.\n'..
    'Since you\'re already dead inside, why not have your wedding?\n'..
    'Enjoy married life Keeks!'
end

function GameOverGDialogueState:setTimeMessage()
    self.message = self.message .. 'Unfortunately, your time has run out.\n'..
    'As much as you tried to delay it, its time for your wedding.\n'..
    'Enjoy married life Keeks!'
end

function GameOverGDialogueState:setMoneyMessage()
    self.message = self.message .. 'Unfortunately, you are officially broke.\n'..
    'Seems like a new wife, along with her money, is the only way for you to get back on your feet.\n'..
    'Enjoy married life Keeks!'
end

function GameOverGDialogueState:update(dt)
end

function GameOverGDialogueState:render()
end
