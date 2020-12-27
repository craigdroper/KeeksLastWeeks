--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

DocGAlien = Class{}

function DocGAlien:init(world, type, x, y, userData)
    self.rotation = 0

    self.world = world
    self.type = type or 'square'

    self.body = love.physics.newBody(self.world,
        x or math.random(VIRTUAL_WIDTH), y or math.random(VIRTUAL_HEIGHT - 35),
        'dynamic')

    self.width = 35
    self.height = 35
    -- different shape and sprite based on type passed in
    if self.type == 'square' then
        self.image = gDoctorImages['virus']
        self.imageW, self.imageH = self.image:getDimensions()
        self.scaleX = self.width / self.imageW
        self.scaleY = self.height / self.imageH
        self.shape = love.physics.newRectangleShape(self.width, self.height)
        -- self.shape = love.physics.newCircleShape(self.width/2)
    else
        self.image = gDoctorImages['pill']
        self.imageW, self.imageH = self.image:getDimensions()
        self.scaleX = self.width / self.imageW
        self.scaleY = self.height / self.imageH
        self.shape = love.physics.newCircleShape(self.width/2)
    end

    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.fixture:setUserData(userData)

    -- used to keep track of despawning the DocGAlien and flinging it
    self.launched = false
end

function DocGAlien:render()
    love.graphics.filterDrawD(
        self.image,
        math.floor(self.body:getX()),
        math.floor(self.body:getY()),
        self.body:getAngle(),
        self.scaleX,
        self.scaleY,
        self.width/2,
        self.height/2)
end
