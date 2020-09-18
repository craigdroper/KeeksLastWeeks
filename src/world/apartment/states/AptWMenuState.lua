--[[
    AptWMenuState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The AptWMenuState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

AptWMenuState = Class{__includes = BaseState}

function AptWMenuState:init()
    -- The apartment is a static enough object this can all be initialized
    -- at the beginning
    self.apartment = Apartment()
    self.player = gGlobalEnts['player'] 
end

function AptWMenuState:enter()
end

function AptWMenuState:update(dt)
    self.player:update(dt)
    -- TODO implement scrolling through menu and waiting for selection here
end

function AptWMenuState:render()
    self.apartment:render()
    if self.player then
        self.player:render()
    end
end
