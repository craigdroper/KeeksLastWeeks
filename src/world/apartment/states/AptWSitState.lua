
AptWSitState = Class{__includes = BaseState}

function AptWSitState:init()
    self.apartment = gGlobalObjs['apartment']
    self.player = gGlobalObjs['player']
end

function AptWSitState:enter()
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

function AptWSitState:update(dt)
    self.player:update(dt)
end

function AptWSitState:render()
    self.apartment:render()
    if self.player then
        self.player:render()
    end
end
