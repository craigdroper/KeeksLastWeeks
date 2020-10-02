
DateWEnterRestState = Class{__includes = BaseState}

function DateWEnterRestState:init()
    self.player = gGlobalObjs['player']
    self.rest = DateWRestaurant()
end

function DateWEnterRestState:enter()
    -- Set the player entity's scale factors to the correct values
    -- for this room's tile sizes
    self.player.scaleX = 1.75
    self.player.scaleY = 1.75
    self.player.opacity = 255
    self.player.walkSpeed = 40
    -- Explicitly set the player's X & Y coordinates to be below frame
    -- and just a bit to the right of the left edge
    self.player.x = 30
    self.player.y = VIRTUAL_HEIGHT + 10
    -- Setup tween entrance
    self:tweenEnter()
end

function DateWEnterRestState:tweenEnter()
    local APRX_MID_TABLE_Y = VIRTUAL_HEIGHT / 2 - 10
    local APRX_MID_TABLE_X = VIRTUAL_WIDTH / 3 + 55
    local X_SHIFT = APRX_MID_TABLE_X + 60
    local APRX_DEST_TABLE_Y = APRX_MID_TABLE_Y - 25
    local APRX_DEST_TABLE_X = X_SHIFT + 24

    -- Come just inside and subtract the door fee
    local walkPixels = self.player.y - APRX_MID_TABLE_Y
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = APRX_MID_TABLE_X, y = APRX_MID_TABLE_Y,
                         scaleX = 1, scaleY = 1}
    }):finish(
        function()
    local walkPixels = X_SHIFT - self.player.x
    self.player:changeAnimation('walk-right')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = X_SHIFT}
    }):finish(
        function()
    local walkPixels = self.player.y - APRX_DEST_TABLE_Y
    self.player.walkSpeed = 10
    self.player:changeAnimation('walk-up')
    Timer.tween(self.player:getPixelWalkTime(walkPixels), {
        [self.player] = {x = APRX_DEST_TABLE_X, y = APRX_DEST_TABLE_Y,
                         scaleX = 0.6, scaleY = 0.6}
    }):finish(
        function()
        -- Pop the date Enter State off, and Push Stationary state on
        gStateStack:pop()
        gStateStack:push(DateWStationaryState({rest = self.rest}))
        end)
        end)
        end)
end

function DateWEnterRestState:update(dt)
    self.player:update(dt)
end

function DateWEnterRestState:render()
    self.rest:render()
    self.player:render()
end
