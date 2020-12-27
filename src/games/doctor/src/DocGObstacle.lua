--[[
    GD50
    Angry Birds

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    An DocGObstacle is any physics-based construction that forms the current level,
    usually shielding the aliens the player is trying to kill; they can form houses,
    boxes, anything the developer wishes. Depending on what kind they are, they are
    typically rectangular or polygonal.
]]

DocGObstacle = Class{}

function DocGObstacle:init(world, shape, x, y)
    self.shape = shape or 'horizontal'

    if self.shape == 'horizontal' then
        self.image = gDoctorImages['horz_obs']
    elseif self.shape == 'vertical' then
        self.image = gDoctorImages['vert_obs']
    end

    self.startX = x
    self.startY = y

    self.world = world

    self.body = love.physics.newBody(self.world,
        self.startX or math.random(VIRTUAL_WIDTH), self.startY or math.random(VIRTUAL_HEIGHT - 35), 'dynamic')

    -- assign width and height based on shape to create physics shape
    if self.shape == 'horizontal' then
        self.width = 110
        self.height = 35
    elseif self.shape == 'vertical' then
        self.width = 35
        self.height = 110
    end
    self.imgW, self.imgH = self.image:getDimensions()
    self.scaleX = self.width/self.imgW
    self.scaleY = self.height/self.imgH

    self.shape = love.physics.newRectangleShape(self.width, self.height)

    self.fixture = love.physics.newFixture(self.body, self.shape)

    self.fixture:setUserData('Obstacle')
end

function DocGObstacle:update(dt)

end

function DocGObstacle:render()
    love.graphics.filterDrawD(
        self.image,
        self.body:getX(),
        self.body:getY(),
        self.body:getAngle(),
        self.scaleX,
        self.scaleY,
        self.width / 2,
        self.height / 2)
end
