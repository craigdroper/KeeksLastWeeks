--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

PlayerThrowState = Class{__includes = BaseState}

function PlayerThrowState:init(player, dungeon)
    self.player = player
    self.dungeon = dungeon

    -- render offset for spaced character sprite
    self.player.offsetY = 5
    self.player.offsetX = 0

    -- create hitbox based on where the player is and facing
    local direction = self.player.direction

    self.player:changeAnimation('throw-' .. self.player.direction)
end

function PlayerThrowState:enter(params)
    gSounds['throw']:stop()
    gSounds['throw']:play()

    self.pot = params.pot

   -- create a hitbox for the pot that's aligned with the players current
   -- direction. Visually this hitbox and the path of the pot wont
   -- be exactly the same depending on the direction (mainly right and left
   -- wont match up)
   local destX, destY = self.player.x + self.player.offsetX, self.player.y + self.player.offsetY
   if self.player.direction == 'right' then
       destX = self.player.x + self.player.width + TILE_SIZE * 4
       self.pot.hitbox = Hitbox(self.player.x + self.player.width,
                                self.player.y,
                                self.pot.width,
                                self.pot.height)
   elseif self.player.direction == 'left' then
       destX = self.player.x - TILE_SIZE * 4
       self.pot.hitbox = Hitbox(self.player.x - self.pot.width,
                                self.player.y,
                                self.pot.width,
                                self.pot.height)
   elseif self.player.direction == 'down' then
       destY = self.player.y + self.player.height + TILE_SIZE * 4
       self.pot.hitbox = Hitbox(self.player.x,
                                self.player.y + self.player.height,
                                self.pot.width,
                                self.pot.height)
   elseif self.player.direction == 'up' then
       destY = self.player.y - TILE_SIZE * 4
       self.pot.hitbox = Hitbox(self.player.x,
                                self.player.y - self.pot.height,
                                self.pot.width,
                                self.pot.height)
   end
   -- Tween the box and its hitbox to move to the furthest possible
   -- tile, deleting the object if it travels is maximum distance and
   -- doesn't hit anything. Update will check if any collisions occur
        Timer.tween(1, {
                [self.pot] = {x = destX, y = destY},
                [self.pot.hitbox] = {x = destX, y = destY},
            }):finish(function()
                        self:breakPot()
                        self.player:changeState('idle')
                     end)
end

function PlayerThrowState:breakPot()
    local objects = self.dungeon.currentRoom.objects
    for idx, object in pairs(objects) do
        if object == self.pot then
            table.remove(objects, idx)
            gSounds['breakpot']:play()
            break
        end
    end
end

function PlayerThrowState:update(dt)
    local objects = self.dungeon.currentRoom.objects
    local entities = self.dungeon.currentRoom.entities
    local breakPot = false

    -- check for collisions with entities
    for k, entity in pairs(self.dungeon.currentRoom.entities) do
        if entity:collides(self.pot.hitbox) then
            entity:damage(1)
            gSounds['hit-enemy']:play()
            breakPot = true
        end
    end

    -- Check if the pot has hit the wall
    local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE)
        + MAP_RENDER_OFFSET_Y - TILE_SIZE
    if self.pot.hitbox.x <= MAP_RENDER_OFFSET_X + TILE_SIZE or
       self.pot.hitbox.x + self.pot.hitbox.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 or
       self.pot.hitbox.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.pot.height/2 or
       self.pot.hitbox.y + self.pot.hitbox.height >= bottomEdge then
        breakPot = true
    end


    if breakPot then
        self:breakPot()
    end

    if self.player.currentAnimation.timesPlayed > 0 then
        -- freeze the animation in the last frame until throw is complete
        self.player.currentAnimation.currentFrame =
            #self.player.currentAnimation.frames
    end
end

function PlayerThrowState:render()
    local anim = self.player.currentAnimation
    love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
        math.floor(self.player.x - self.player.offsetX), math.floor(self.player.y - self.player.offsetY))

    -- debug for player and hurtbox collision rects
    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.player.x, self.player.y, self.player.width, self.player.height)
    -- love.graphics.rectangle('line', self.swordHurtbox.x, self.swordHurtbox.y,
    --     self.swordHurtbox.width, self.swordHurtbox.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
