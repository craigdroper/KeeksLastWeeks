--[[
    CokeGBird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The CokeGBird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

CokeGBird = Class{}

local GRAVITY = 20

function CokeGBird:init()
    self.image = gCokeGImages['nose']
    self.width, self.height = self.image:getDimensions()
    self.x = (VIRTUAL_WIDTH - self.width)/ 2
    self.y = (VIRTUAL_HEIGHT - self.height)/ 2

    self.collOffX = 2
    self.collOffY= 4

    self.dy = 0
    self.jumpYAcc = -4

    -- When the bird sneezes it is no longer in play and should
    -- no longer be updated
    self.isInPlay = true
    self.isWin = false
    self.isStartGravity = true

    -- particle system belonging to the bird, emitted on sneeze
    self.psystem = love.graphics.newParticleSystem(gBGTextures['particle'], 128)
    -- lasts 1 second
    self.psystem:setParticleLifetime(1.5, 2)
    -- give it an acceleration of anywhere between X1,Y1 and X2,Y2 (0, 0) and (0, 80) here
    -- gives generally outward and downward
    self.psystem:setLinearAcceleration(-10, 0, 50, 200)
    -- spread of particles; normal looks more natural than uniform
    self.psystem:setAreaSpread('normal', 10, 10)
    -- Want the sneeze to be all white
   self.psystem:setColors(
        255, 255, 255, 200,
        255, 255, 255, 0
    )
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]
function CokeGBird:collides(pipe)
    -- the 2's are left and top offsets
    -- the 4's are right and bottom offsets
    -- both offsets are used to shrink the bounding box to give the player
    -- a little bit of leeway with the collision

    if (self.x + self.collOffX) + (self.width - self.collOffY) >= pipe.x and
        self.x + self.collOffX <= pipe.x + COKEG_PIPE_WIDTH then
        if (self.y + self.collOffX) + (self.height - self.collOffY) >= pipe.y and
            self.y + self.collOffY <= pipe.y + COKEG_PIPE_HEIGHT then
            return true
        end
    end

    return false
end

function CokeGBird:win()
    gCokeSounds['wow']:play()
    self.isWin = true
    self.upTimer = 0.2
end

function CokeGBird:sneeze()
    gCokeSounds['sneeze']:play()
    self.psystem:emit(128)
    self.isInPlay = false
end

function CokeGBird:update(dt)
    self.psystem:update(dt)

    if not self.isInPlay then
        -- Update only the particle emiter, but not its position
        -- or velocity
        self.dy = 0
        return
    end

    if not self.isWin then
        if self.isStartGravity then
            self.dy = self.dy + (GRAVITY/8) * dt
        else
            self.dy = self.dy + GRAVITY * dt
        end
    end

    if self.isWin then
        self.upTimer = self.upTimer - dt
        if self.upTimer < 0 then
            self.upTimer = 0.1
            self.dy = self.jumpYAcc
        end
    else
        -- burst of anti-gravity when space or left mouse are pressed
        if love.keyboard.wasPressed('space') or love.mouse.wasPressed(1) then
            self.isStartGravity = false
            self.dy = self.jumpYAcc
            gCokeSounds['sniff']:stop()
            gCokeSounds['sniff']:play()
        end
    end

    self.y = self.y + self.dy
end

function CokeGBird:render()
    -- The Nose png need to be flipped across the y axis
    love.graphics.filterDrawD(self.image, self.x, self.y, 0, -1, 1)
    love.graphics.filterDrawD(self.psystem, self.x + self.width / 2, self.y + self.height)
end
