
AptWStationaryState = Class{__includes = BaseState}

function AptWStationaryState:init(params)
    self.player = gGlobalObjs['player']
    self.apartment = params.apartment
end

function AptWStationaryState:enter()
    -- Explicitly set the player's X & Y coordinates to be sitting on the couch
    local horzCouchWidth = gFramesInfo['apartment'][gAPT_HORZ_COUCH_NAME]['width']
    local horzCouchHeight = gFramesInfo['apartment'][gAPT_HORZ_COUCH_NAME]['height']
    local horzCouchX = self.apartment.furniture['horizontal-couch'][3]
    local horzCouchY = self.apartment.furniture['horizontal-couch'][4]
    local ARMREST_OFFSET = 7
    self.player.x = (horzCouchX + horzCouchWidth/2) - self.player.width/2 - ARMREST_OFFSET
    self.player.y = horzCouchY
    self.player:changeAnimation('idle-down')

    gStateStack:push(DialogueState(
        'Welcome home\n\nWhat would you like to do next?',
        function()
            gStateStack:push(AptWInitialMenuState({apartment = self.apartment}))
    end))
end

function AptWStationaryState:update(dt)
    self.player:update(dt)
end

function AptWStationaryState:render()
    self.apartment:render()
    if self.player then
        self.player:render()
    end
end
