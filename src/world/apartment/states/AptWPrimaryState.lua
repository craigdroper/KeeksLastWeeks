
AptWPrimaryState = Class{__includes = BaseState}

function AptWPrimaryState:init()
    self.apartment = gGlobalObjs['apartment']
    self.player = gGlobalObjs['player']
end

function AptWPrimaryState:enter()
    -- Explicitly set the player's X & Y coordinates to be sitting on the couch
    local horzCouchWidth = gFramesInfo['apartment'][gAPT_HORZ_COUCH_NAME]['width']
    local horzCouchHeight = gFramesInfo['apartment'][gAPT_HORZ_COUCH_NAME]['height']
    local horzCouchX = self.apartment.furniture['horizontal-couch'][3]
    local horzCouchY = self.apartment.furniture['horizontal-couch'][4]
    local ARMREST_OFFSET = 7
    self.player.x = (horzCouchX + horzCouchWidth/2) - self.player.width/2 - ARMREST_OFFSET
    self.player.y = horzCouchY
    self.player:changeAnimation('idle-down')
end

function AptWPrimaryState:update(dt)
    self.player:update(dt)
end

function AptWPrimaryState:render()
    self.apartment:render()
    if self.player then
        self.player:render()
    end
end
