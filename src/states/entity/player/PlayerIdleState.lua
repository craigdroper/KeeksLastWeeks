--[[
    GD50
    Pokemon

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerIdleState = Class{__includes = EntityIdleState}

function PlayerIdleState:init(player)
    EntityIdleState.init(self, player)
end

function PlayerIdleState:enter(params)
end

function PlayerIdleState:update(dt)
end

function PlayerIdleState:update(dt)
    -- In general, there is not a concept of a walk state in most of this game
    -- so we don't want to take any user input and try and transition to an
    -- invalid state
    if self.entity.isStateUpdatable then
        if love.keyboard.isDown('left') then
            self.entity.direction = 'left'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown('right') then
            self.entity.direction = 'right'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown('up') then
            self.entity.direction = 'up'
            self.entity:changeState('walk')
        elseif love.keyboard.isDown('down') then
            self.entity.direction = 'down'
            self.entity:changeState('walk')
        end
    end
end

function PlayerIdleState:render()
    EntityBaseState.render(self)
end
