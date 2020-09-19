
BarWStationaryState = Class{__includes = BaseState}

function BarWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.bar = params.bar
end

function BarWStationaryState:enter()
    -- Explicitly set the player's X & Y coordinates to be sitting at the second
    -- seat at the bar
    local stoolWidth = gFramesInfo['bar'][gBAR_LEFT_CHAIR]['width']
    local stoolHeight = gFramesInfo['bar'][gBAR_LEFT_CHAIR]['height']
    local stoolX = self.bar.furniture['barstool-3'][3]
    local stoolY = self.bar.furniture['barstool-3'][4]
    print('Stool 3 X = '..stoolX)
    self.player.x = stoolX
    self.player.y = stoolY
    self.player:changeAnimation('idle-left')

    gStateStack:push(DialogueState(
        'Bartender: Morning Keeks! ' ..
        'We\'ve got your favorite seat saved for you. ' ..
        'What\'ll it be?',
        function()
        end))
end

function BarWStationaryState:update(dt)
    self.player:update(dt)
end

function BarWStationaryState:render()
    self.bar:render()
    if self.player then
        self.player:render()
    end
end
