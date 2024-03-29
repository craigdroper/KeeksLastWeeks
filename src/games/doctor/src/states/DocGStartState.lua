--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

DocGStartState = Class{__includes = BaseState}

function DocGStartState:init()
    self.background = DocGBackground()
    self.world = love.physics.newWorld(0, 300)

    -- ground
    self.groundBody = love.physics.newBody(self.world, 0, VIRTUAL_HEIGHT, 'static')
    self.groundShape = love.physics.newEdgeShape(0, 0, VIRTUAL_WIDTH, 0)
    self.groundFixture = love.physics.newFixture(self.groundBody, self.groundShape)

    -- walls
    self.leftWallBody = love.physics.newBody(self.world, 0, 0, 'static')
    self.rightWallBody = love.physics.newBody(self.world, VIRTUAL_WIDTH, 0, 'static')
    self.wallShape = love.physics.newEdgeShape(0, 0, 0, VIRTUAL_HEIGHT)
    self.leftWallFixture = love.physics.newFixture(self.leftWallBody, self.wallShape)
    self.rightWallFixture = love.physics.newFixture(self.rightWallBody, self.wallShape)

    -- lots of aliens
    self.aliens = {}

    for i = 1, 100 do
        table.insert(self.aliens, DocGAlien(self.world))
    end
end

function DocGStartState:enter()
    self.startMenu = Menu {
        items = {
            {
                text = 'Play',
                onSelect =
                    function()
                        -- Pop off BarGStartState
                        gStateStack:pop()
                        gStateStack:push(DocGPlayState())
                    end
            },
            {
                text = 'Instructions',
                onSelect =
                    function()
                        gStateStack:push(DocGInstructionsState())
                    end
            },
        }
    }
end

function DocGStartState:update(dt)
    self.world:update(dt)
    self.startMenu:update(dt)
end

function DocGStartState:render()
    self.background:render()

    for k, alien in pairs(self.aliens) do
        alien:render()
    end

    -- title text
    love.graphics.setColor(64, 64, 64, 200)
    love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 194, VIRTUAL_HEIGHT / 2 - 160,
        388, 80, 3)

    love.graphics.setColor(255, 50, 50, 255)
    love.graphics.setFont(gFonts['huge'])
    love.graphics.printf('Angry Pills', 0, VIRTUAL_HEIGHT / 2 - 160, VIRTUAL_WIDTH, 'center')

    -- instruction text
    -- love.graphics.setColor(64, 64, 64, 200)
    -- love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 164, VIRTUAL_HEIGHT / 2 + 56,
    --     328, 64, 3)

    --love.graphics.setColor(255, 50, 50, 255)
    --love.graphics.setFont(gFonts['medium'])
    --love.graphics.printf('Press Enter to start!', 0, VIRTUAL_HEIGHT / 2 + 40, VIRTUAL_WIDTH, 'center')

    self.startMenu:render()
end
