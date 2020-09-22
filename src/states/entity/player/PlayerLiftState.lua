--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerLiftState = Class{__includes = BaseState}

function PlayerLiftState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction

    local hitboxX, hitboxY, hitboxWidth, hitboxHeight

    if direction == 'left' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x - hitboxWidth
        hitboxY = self.player.y + 2
    elseif direction == 'right' then
        hitboxWidth = 8
        hitboxHeight = 16
        hitboxX = self.player.x + self.player.width
        hitboxY = self.player.y + 2
    elseif direction == 'up' then
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y - hitboxHeight
    else
        hitboxWidth = 16
        hitboxHeight = 8
        hitboxX = self.player.x
        hitboxY = self.player.y + self.player.height
    end

    self.liftHitbox = Hitbox(hitboxX, hitboxY, hitboxWidth, hitboxHeight)
    self.player:changeAnimation('lift-' .. self.player.direction)
end

function PlayerLiftState:enter(params)
    gSounds['lift']:stop()
    gSounds['lift']:play()

    -- restart lift animation
    self.player.currentAnimation:refresh()
end

function PlayerLiftState:update(dt)
    -- check if hitbox collides with a pot
    for _, obj in pairs(self.dungeon.currentRoom.objects) do
        if obj.type == 'pot' then
            local boxCollide = not (self.liftHitbox.x + self.liftHitbox.width < obj.x or self.liftHitbox.x > obj.x + obj.width or
                self.liftHitbox.y + self.liftHitbox.height < obj.y or self.liftHitbox.y > obj.y + obj.height)
            if boxCollide then
                -- temporarily set this object to not solid until it is thrown
                obj.solid = false
                -- tween the pot on top of the player during the lift animation,
                -- which takes 1 second
                Timer.tween(1, {
                    [obj] = {x = self.player.x, -- - self.player.offsetX,
                             y = self.player.y - obj.height}, -- self.player.offsetY},
                }):finish(function()
                            self.player:changeState('pot-idle', {pot = obj})
                        end)
            end
        end
    end

    if self.player.currentAnimation.timesPlayed > 0 then
        self.player.currentAnimation.timesPlayed = 0
        self.player:changeState('idle')
    end

    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        self.player:changeState('lift')
    end
end

function PlayerLiftState:render()
    local anim = self.player.currentAnimation
    love.graphics.filterDrawQ(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- debug for player and hurtbox collision rects
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
