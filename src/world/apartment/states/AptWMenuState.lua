--[[
    AptWMenuState Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The AptWMenuState is the starting screen of the game, shown on startup. It should
    display "Press Enter" and also our highest score.
]]

AptWMenuState = Class{__includes = BaseState}

function AptWMenuState:init()
    self.apartment = Apartment()
    -- TODO fetch a reference to the global keeks player
end

function AptWMenuState:update(dt)
    -- TODO implement scrolling through menu and waiting for selection here
end

function AptWMenuState:render()
    self.apartment:render()
end
