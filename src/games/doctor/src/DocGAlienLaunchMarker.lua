--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

DocGAlienLaunchMarker = Class{}

function DocGAlienLaunchMarker:init(world)
    self.world = world

    -- starting coordinates for launcher used to calculate launch vector
    self.baseX = 90
    self.baseY = VIRTUAL_HEIGHT - 100

    -- shifted coordinates when clicking and dragging launch alien
    self.shiftedX = self.baseX
    self.shiftedY = self.baseY

    -- rotation for the trajectory arrow
    self.rotation = 0

    -- whether our arrow is showing where we're aiming
    self.aiming = false

    -- whether we launched the alien and should stop rendering the preview
    self.launched = false

    -- our alien we will eventually spawn
    self.aliens = {}
    self.isSplitAlien = false
    self.isAlienContact = false
    -- XXX DEMO
    self.spaceTextTimer = 100
end

function DocGAlienLaunchMarker:createPlayerAlien(shiftedX, shiftedY, linVelX, linVelY)
    local alien = DocGAlien(self.world, 'round', shiftedX, shiftedY, 'Player')

    -- apply the difference between current X,Y and base X,Y as launch vector impulse
    alien.body:setLinearVelocity(linVelX, linVelY)

    -- make the alien pretty bouncy
    alien.fixture:setRestitution(0.4)
    alien.body:setAngularDamping(1)
    table.insert(self.aliens, alien)
end

function DocGAlienLaunchMarker:update(dt)

    -- XXX DEMO
    self.spaceTextTimer = self.spaceTextTimer + dt

    -- perform everything here as long as we haven't launched yet
    if not self.launched then

        -- grab mouse coordinates
        local x, y = push:toGame(love.mouse.getPosition())
        -- Hack with issue where the mouse drops off a retrievable y axis
        if( y == nil ) then
            y = VIRTUAL_HEIGHT
        end

        -- if we click the mouse and haven't launched, show arrow preview
        if love.mouse.wasPressed(1) and not self.launched then
            self.aiming = true

        -- if we release the mouse, launch an Alien
        elseif love.mouse.wasReleased(1) and self.aiming then
            self.aliens = {}
            self.launched = true

            self:createPlayerAlien(self.shiftedX, self.shiftedY,
                (self.baseX - self.shiftedX) * 15,
                (self.baseY - self.shiftedY) * 15)

            -- we're no longer aiming
            self.aiming = false

        -- re-render trajectory
        elseif self.aiming then
            self.rotation = self.baseY - self.shiftedY * 0.9
            self.shiftedX = math.min(self.baseX + 30, math.max(x, self.baseX - 30))
            self.shiftedY = math.min(self.baseY + 30, math.max(y, self.baseY - 30))
        end
    else
        -- XXX DEMO with space bar timer
        if love.keyboard.wasPressed('space') then
            self.spaceTextTimer = 0
        end
        -- we have launched
        if love.keyboard.wasPressed('space') and
                not self.isSplitAlien and
                not self.isAlienContact then
            self.isSplitAlien = true
            local alien = self.aliens[1]
            local alienX, alienY = alien.body:getX(), alien.body:getY()
            local linVelX, linVelY = alien.body:getLinearVelocity()
            -- Create a new alien which will look as if it were launched on
            -- a slightly more upward trajectory than the original alien
            self:createPlayerAlien(alienX, alienY, linVelX, linVelY + 100)
            -- Create a new alien which will look as if it were launched on
            -- a slightly more downward trajectory than the original alien
            self:createPlayerAlien(alienX, alienY, linVelX, linVelY - 100)
        end
    end
end

function DocGAlienLaunchMarker:render()
    if not self.launched then

        -- render base alien, non physics based
        love.graphics.draw(gDocGTextures['aliens'], gDocGFrames['aliens'][9],
            self.shiftedX - 17.5, self.shiftedY - 17.5)

        if self.aiming then

            -- render arrow if we're aiming, with transparency based on slingshot distance
            local impulseX = (self.baseX - self.shiftedX) * 15
            local impulseY = (self.baseY - self.shiftedY) * 15

            -- draw 6 circles simulating trajectory of estimated impulse
            local trajX, trajY = self.shiftedX, self.shiftedY
            local gravX, gravY = self.world:getGravity()

            -- http://www.iforce2d.net/b2dtut/projected-trajectory
            for i = 1, 90 do

                -- magenta color that starts off slightly transparent
                love.graphics.setColor(255, 80, 255, (255 / 12) * i)

                -- trajectory X and Y for this iteration of the simulation
                trajX = self.shiftedX + i * 1/60 * impulseX
                trajY = self.shiftedY + i * 1/60 * impulseY + 0.5 * (i * i + i) * gravY * 1/60 * 1/60

                -- render every fifth calculation as a circle
                if i % 5 == 0 and i <= 15  then
                    love.graphics.circle('fill', trajX, trajY, 3)
                end
            end
        end

        love.graphics.setColor(255, 255, 255, 255)
    else
        for _, alien in pairs(self.aliens) do
            alien:render()
        end
    end
    --[[
    -- XXX DEMO
    -- if self.spaceTextTimer ~= nil then
        local timerFadeTime = 0.5
        love.graphics.setColor(255, 127, 0,
            math.max(0, math.min(255, ((timerFadeTime - self.spaceTextTimer) / timerFadeTime) * 255)))
        love.graphics.setFont(gFonts['huge'])
        love.graphics.printf('SPACE', 0, VIRTUAL_HEIGHT / 2 - 40, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
        -- if self.spaceTextTimer > timerFadeTime then
            -- self.spaceTextTimer = nil
        -- end
    -- end
    -- --]]
end
