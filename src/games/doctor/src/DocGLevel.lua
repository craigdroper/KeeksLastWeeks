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
    self.isGameOver = false

    self.launchRem = 2

    self.totalAliens = 20 - self.player.health / 5
    if( self.totalAliens < 1 ) then
        self.totalAliens = 1
    end
    self.destroyedAliens = 0
    -- bodies we will destroy after the world update cycle; destroying these in the
    -- actual collision callbacks can cause stack overflow and other errors
    self.destroyedBodies = {}

    self.obsVelocity = 200
    self.virusVelocity = 400

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

                if sumVel > self.obsVelocity then
                    table.insert(self.destroyedBodies, a:getBody())
                end
            else
                local velX, velY = a:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > self.obsVelocity then
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

                if sumVel > self.virusVelocity then
                    self.destroyedAliens = self.destroyedAliens + 1
                    table.insert(self.destroyedBodies, b:getBody())
                end
            else
                local velX, velY = b:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > self.virusVelocity then
                    self.destroyedAliens = self.destroyedAliens + 1
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

                if sumVel > self.virusVelocity then
                    self.destroyedAliens = self.destroyedAliens + 1
                    table.insert(self.destroyedBodies, b:getBody())
                end
            else
                local velX, velY = b:getBody():getLinearVelocity()
                local sumVel = math.abs(velX) + math.abs(velY)

                if sumVel > self.virusVelocity then
                    self.destroyedAliens = self.destroyedAliens + 1
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
    self.playerIcon = DocGAlien(self.world, 'player', 0, 0, 'Player')
    self.groundHeight = 35
    local levelX = VIRTUAL_WIDTH + self.horzObs.width/2
    self.gridXCoords = {
        [1] = levelX - (self.vertObs.width + 3*self.horzObs.width),
        [2] = levelX - (self.vertObs.width + 2*self.horzObs.width),
        [3] = levelX - (self.vertObs.width + 1*self.horzObs.width),
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
    local numAliens = self.totalAliens
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
            -- secY + self.horzObs.height + self.vertObs.height - self.alien.height,
            secY + self.horzObs.height + self.vertObs.height - self.alien.height/2,
            'Alien' ) )
        table.insert(self.aliens, DocGAlien(self.world, 'square',
            secX + self.vertObs.width/2 + self.horzObs.width/2 + self.alien.width/2,
            -- secY + self.horzObs.height + self.vertObs.height - self.alien.height,
            secY + self.horzObs.height + self.vertObs.height - self.alien.height/2,
            'Alien' ) )
    end
    if( numAliens % 2 == 1 ) then
        table.insert(self.aliens, DocGAlien(self.world, 'square',
            secX + self.vertObs.width/2 + self.horzObs.width/2,
            -- secY + self.horzObs.height + self.vertObs.height - self.alien.height*2,
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
            self.launchRem = self.launchRem - 1

            --[[
            if( self.launchRem < 0 ) then
                local gameStats = {numDestroyed = self.destroyedAliens}
                gStateStack:push(FadeInState({r = 255, g = 255, b = 255}, 1,
                    function()
                        -- Pop the Game state off
                        gStateStack:pop()
                        gStateStack:push(WorkWExitMeetingState({gameStats = gameStats}))
                        gStateStack:push(FadeOutState({r = 255, g = 255, b = 255}, 1,
                            function()
                            end))
                    end))
            end
            --]]

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
        -- love.graphics.draw(gTextures['tiles'], gFrames['tiles'][12], x, VIRTUAL_HEIGHT - 35)
    end

    self.launchMarker:render()

    -- Draw the launches remaining in the top left corner
    local padX = 5
    local padY = 5
    for i = 1, self.launchRem do
        love.graphics.filterDrawD(self.playerIcon.image,
            (i-1)*(self.playerIcon.width + padX),
            padY,
            0,
            self.playerIcon.scaleX,
            self.playerIcon.scaleY )
    end

    for k, alien in pairs(self.aliens) do
        alien:render()
    end

    for k, obstacle in pairs(self.obstacles) do
        obstacle:render()
    end

    -- render instruction text if we haven't launched bird
    if not self.launchMarker.launched and not self.isGameOver then
        love.graphics.setFont(gFonts['medium'])
        love.graphics.setColor(255, 50, 50, 255)
        love.graphics.printf('Click and drag medicine to shoot!',
            0, 64, VIRTUAL_WIDTH, 'center')
        love.graphics.setColor(255, 255, 255, 255)
    end

    -- game over all aliens are dead
    --[[
    if #self.aliens == 0 then
        gStateStack:pop()
        gStateStack:push(DocGGameOverState({level = self.level}))
    end
    --]]
end
