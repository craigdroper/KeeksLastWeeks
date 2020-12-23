--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

DocGLevel = Class{}

function DocGLevel:init()
    -- create a new "world" (where physics take place), with no x gravity
    -- and 30 units of Y gravity (for downward force)
    self.world = love.physics.newWorld(0, 300)
    self.player = gGlobalObjs['player']

    -- bodies we will destroy after the world update cycle; destroying these in the
    -- actual collision callbacks can cause stack overflow and other errors
    self.destroyedBodies = {}

    -- define collision callbacks for our world; the World object expects four,
    -- one for different stages of any given collision
    function beginContact(a, b, coll)
        local types = {}
        types[a:getUserData()] = true
        types[b:getUserData()] = true

        -- if we collided between both an alien and an obstacle...
        if types['Obstacle'] and types['Player'] then
            -- Update AlienLaunchMarker state to let it know a player
            -- has made a collision with an object
            self.launchMarker.isAlienContact = true

            -- destroy the obstacle if player's combined velocity is high enough
            if a:getUserData() == 'Obstacle' then
                local velX, velY = b:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, a:getBody())
                end
            else
                local velX, velY = a:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, b:getBody())
                end
            end
        end

        -- if we collided between an obstacle and an alien, as by debris falling...
        if types['Obstacle'] and types['Alien'] then

            -- destroy the alien if falling debris is falling fast enough
            if a:getUserData() == 'Obstacle' then
                local velX, velY = a:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, b:getBody())
                end
            else
                local velX, velY = b:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, a:getBody())
                end
            end
        end

        -- if we collided between the player and the alien...
        if types['Player'] and types['Alien'] then
            -- Update AlienLaunchMarker state to let it know a player
            -- has made a collision with a target alien
            self.launchMarker.isAlienContact = true

            -- destroy the alien if player is traveling fast enough
            if a:getUserData() == 'Player' then
                local velX, velY = a:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, b:getBody())
                end
            else
                local velX, velY = b:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > 20 then
                    table.insert(self.destroyedBodies, a:getBody())
                end
            end
        end

        -- if we hit the ground, play a bounce sound
        if types['Player'] and types['Ground'] then
            -- Update AlienLaunchMarker state to let it know a player
            -- has made a collision with the ground
            self.launchMarker.isAlienContact = true
            gDocGSounds['bounce']:stop()
            gDocGSounds['bounce']:play()
        end
    end

    -- the remaining three functions here are sample definitions, but we are not
    -- implementing any functionality with them in this demo; use-case specific
    function endContact(a, b, coll)

    end

    function preSolve(a, b, coll)

    end

    function postSolve(a, b, coll, normalImpulse, tangentImpulse)

    end

    self.vertObs = DocGObstacle(self.world, 'vertical', 0, 0)
    self.horzObs = DocGObstacle(self.world, 'horizontal', 0, 0)
    self.alien = DocGAlien(self.world, 'square', 0, 0, 'Alien')
    self.groundHeight = 35
    self.gridXCoords = {
        [1] = VIRTUAL_WIDTH - (self.vertObs.width + 3*self.horzObs.width),
        [2] = VIRTUAL_WIDTH - (self.vertObs.width + 2*self.horzObs.width),
        [3] = VIRTUAL_WIDTH - (self.vertObs.width + 1*self.horzObs.width),
    }
    self.gridYCoords = {
        [1] = VIRTUAL_HEIGHT - self.groundHeight - 1*(self.vertObs.height + self.horzObs.height),
        [2] = VIRTUAL_HEIGHT - self.groundHeight - 2*(self.vertObs.height + self.horzObs.height),
        [3] = VIRTUAL_HEIGHT - self.groundHeight - 3*(self.vertObs.height + self.horzObs.height),
    }

    -- register just-defined functions as collision callbacks for world
    self.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

    -- shows alien before being launched and its trajectory arrow
    self.launchMarker = DocGAlienLaunchMarker(self.world)

    -- aliens in our scene
    self.aliens = {}

    -- obstacles guarding aliens that we can destroy
    self.obstacles = {}

    -- simple edge shape to represent collision for ground
    self.edgeShape = love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH * 3, 0)

    self:createLevel()

    -- ground data
    self.groundBody = love.physics.newBody(self.world, -VIRTUAL_WIDTH, VIRTUAL_HEIGHT - self.groundHeight, 'static')
    self.groundFixture = love.physics.newFixture(self.groundBody, self.edgeShape)
    self.groundFixture:setFriction(0.5)
    self.groundFixture:setUserData('Ground')

    -- background graphics
    self.background = DocGBackground()
end

-- Expecting a 3x3 boolean grid
function DocGLevel:createLevel()
    local numAliens = 20 - self.player.health / 5
    local numAliens = 20
    if( numAliens < 1 ) then
        numAliens = 1
    end
    self.grid = {
        [1] = {[1] = {build = false, numaliens = 0},
               [2] = {build = false, numaliens = 0},
               [3] = {build = false, numaliens = 0},
           },
        [2] = {[1] = {build = false, numaliens = 0},
               [2] = {build = false, numaliens = 0},
               [3] = {build = false, numaliens = 0},
           },
        [3] = {[1] = {build = false, numaliens = 0},
               [2] = {build = false, numaliens = 0},
               [3] = {build = false, numaliens = 0},
           },
    }
    if( numAliens > 0 ) then
        self.grid[2][1].build = true
    end
    if( numAliens > 2 ) then
        self.grid[1][1].build = true
        self.grid[3][1].build = true
    end
    if( numAliens > 7 ) then
        self.grid[2][2].build = true
    end
    if( numAliens > 12 ) then
        self.grid[1][2].build = true
        self.grid[3][2].build = true
    end
    if( numAliens > 15 ) then
        self.grid[1][3].build = true
        self.grid[2][3].build = true
        self.grid[3][3].build = true
    end
    -- Always place one on the ground in the lowest row and middle
    -- column section, just in case there isn't a section of wood there
    self.grid[2][1].numaliens = 1
    numAliens = numAliens - 1
    while( numAliens > 0 ) do
        local x = math.random(3)
        local y = math.random(3)
        if( self.grid[x][y].build and self.grid[x][y].numaliens < 3 ) then
            self.grid[x][y].numaliens = self.grid[x][y].numaliens + 1
            numAliens = numAliens - 1
        end
    end
    for col, colTable in pairs(self.grid) do
        for row, secInfo in pairs(colTable) do
            if( secInfo.build ) then
                self:createSection(
                    self.gridXCoords[col],
                    self.gridYCoords[row],
                    (col == 1 or not self.grid[col-1][row].build),
                    secInfo.numaliens )
            end
        end
    end
end

function DocGLevel:createSection(secX, secY, createLeftPillar, numAliens)
    -- remember these are oriented from their center points
    -- left vertical obstacle
    if createLeftPillar then
        table.insert(self.obstacles, DocGObstacle(self.world, 'vertical',
            secX + self.vertObs.width/2,
            secY + self.horzObs.height + self.vertObs.height/2) )
    end
    -- right vertical obstacle
    table.insert(self.obstacles, DocGObstacle(self.world, 'vertical',
        secX + self.vertObs.width/2 + self.horzObs.width,
        secY + self.horzObs.height + self.vertObs.height/2) )
    -- horizontal obstacle
    table.insert(self.obstacles, DocGObstacle(self.world, 'horizontal',
        secX + self.vertObs.width/2 + self.horzObs.width/2,
        secY + self.horzObs.height/2) )

    -- spawn an alien to try and destroy
    if( numAliens >= 2 ) then
        table.insert(self.aliens, DocGAlien(self.world, 'square',
            secX + self.vertObs.width/2 + self.horzObs.width/2 - self.alien.width/2,
            secY + self.horzObs.height + self.vertObs.height - self.alien.height/2,
            'Alien' ) )
        table.insert(self.aliens, DocGAlien(self.world, 'square',
            secX + self.vertObs.width/2 + self.horzObs.width/2 + self.alien.width/2,
            secY + self.horzObs.height + self.vertObs.height - self.alien.height/2,
            'Alien' ) )
    end
    if( numAliens % 2 == 1 ) then
        table.insert(self.aliens, DocGAlien(self.world, 'square',
            secX + self.vertObs.width/2 + self.horzObs.width/2,
            secY + self.horzObs.height + self.vertObs.height - self.alien.height*3/2,
            'Alien' ) )
    end
end

function DocGLevel:update(dt)
    -- update launch marker, which shows trajectory
    self.launchMarker:update(dt)

    -- Box2D world update code; resolves collisions and processes callbacks
    self.world:update(dt)

    -- destroy all bodies we calculated to destroy during the update call
    for k, body in pairs(self.destroyedBodies) do
        if not body:isDestroyed() then
            body:destroy()
        end
    end

    -- reset destroyed bodies to empty table for next update phase
    self.destroyedBodies = {}

    -- remove all destroyed obstacles from level
    for i = #self.obstacles, 1, -1 do
        if self.obstacles[i].body:isDestroyed() then
            table.remove(self.obstacles, i)

            -- play random wood sound effect
            local soundNum = math.random(5)
            gDocGSounds['break' .. tostring(soundNum)]:stop()
            gDocGSounds['break' .. tostring(soundNum)]:play()
        end
    end

    -- remove all destroyed aliens from level
    for i = #self.aliens, 1, -1 do
        if self.aliens[i].body:isDestroyed() then
            table.remove(self.aliens, i)
            gDocGSounds['kill']:stop()
            gDocGSounds['kill']:play()
        end
    end

    -- replace launch marker if original alien stopped moving
    if self.launchMarker.launched then
        local destroyAlienCount = 0
        for i=#self.launchMarker.aliens, 1, -1 do
            local xPos, yPos = self.launchMarker.aliens[i].body:getPosition()
            local xVel, yVel = self.launchMarker.aliens[i].body:getLinearVelocity()
            if xPos < 0 or xPos > VIRTUAL_WIDTH or (math.abs(xVel) + math.abs(yVel) < 1.5) then
                destroyAlienCount = destroyAlienCount + 1
            end
        end
        if destroyAlienCount == #self.launchMarker.aliens then
            for i=#self.launchMarker.aliens, 1, -1 do
                self.launchMarker.aliens[i].body:destroy()
                table.remove(self.launchMarker.aliens, i)
            end
            self.launchMarker = DocGAlienLaunchMarker(self.world)

            -- re-initialize level if we have no more aliens
            if #self.aliens == 0 then
                gStateMachine:change('start')
            end
        end

        --[[
        -- if we fired our alien to the left or it's almost done rolling, respawn
        if xPos < 0 or (math.abs(xVel) + math.abs(yVel) < 1.5) then
            self.launchMarker.alien.body:destroy()
            self.launchMarker = AlienLaunchMarker(self.world)

            -- re-initialize level if we have no more aliens
            if #self.aliens == 0 then
                gStateMachine:change('start')
            end
        end
        ]]
    end
end

function DocGLevel:render()
    -- render ground tiles across full scrollable width of the screen
    for x = -VIRTUAL_WIDTH, VIRTUAL_WIDTH * 2, 35 do
        love.graphics.draw(gTextures['tiles'], gFrames['tiles'][12], x, VIRTUAL_HEIGHT - 35)
    end

    self.launchMarker:render()

    for k, alien in pairs(self.aliens) do
        alien:render()
    end

    for k, obstacle in pairs(self.obstacles) do
        obstacle:render()
    end

    -- render instruction text if we haven't launched bird
    if not self.launchMarker.launched then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf('Click and drag circular alien to shoot!',
            0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
    end

    -- render victory text if all aliens are dead
    if #self.aliens == 0 then
        love.graphics.setFont(gFonts['huge'])
        love.graphics.setColor(0, 0, 0, 255)
        love.graphics.printf('VICTORY', 0, VIRTUAL_HEIGHT / 2 - 32, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
    end
end
