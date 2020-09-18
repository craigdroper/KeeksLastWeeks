--[[
    AptWSitState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The AptWSitState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

AptWSitState = Class{__includes = BaseState}

function AptWSitState:init()
    -- The apartment is a static enough object this can all be initialized
    -- at the beginning
    self.apartment = Apartment()
    self.player = gGlobalEnts['player']
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
end

function AptWSitState:update(dt)
    self.player:update(dt)
    -- TODO implement scrolling through menu and waiting for selection here
end

function AptWSitState:render()
    self.apartment:render()
    if self.player then
        self.player:render()
    end
end
