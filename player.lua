local Player = {}
Player.__index = Player

function Player:new(world, x, y, width, height)
    local self = setmetatable({}, Player)
    self.speed = 200 -- Player Speed
    self.jumpForce = -300 --JumpHeight
    self.isGrounded = false

    self.spriteSheet = love.graphics.newImage('assets/spritesheets/player.png')
    self.grid = anim8.newGrid(tileSize, tileSize, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())

    self.animations = {}
    self.animations.idle = anim8.newAnimation(self.grid('1-2', 1), 0.5 ) -- Update 0.5 for faster animations
    self.animations.walk = anim8.newAnimation(self.grid('1-4', 2), 0.5 ) -- Update 0.5 for faster animations
    self.animations.jump = anim8.newAnimation(self.grid('1-3', 3), 0.5 ) -- Update 0.5 for faster animations

    self.anim = self.animations.walk


    self.collider = world:newRectangleCollider(x, y, width, height)
    self.collider:setFixedRotation(true) -- verhindert, dass der Player fällt
    self.collider:setRestitution(0) -- kein Bouncen

    return self
end

function Player:getPosition()
    return self.collider:getX(), self.collider:getY()
end

function Player:update(dt)
    local vx, vy = self.collider:getLinearVelocity() --Aktuelle Geschwindigkeit des Players

    -- Movement
    if love.keyboard.isDown("a") then
        vx = -self.speed
        self.anim = self.animations.walk

    elseif love.keyboard.isDown("d") then
        vx = self.speed 
        self.anim = self.animations.walk
    else
        vx = 0 -- Stoppt den Player hardcut, wenn gerade nichts gedrückt, dann rutscht der nicht mehr

    end


    -- Check, ob der Player gerade auf dem Boden ist, oder nicht
    self.isGrounded = self.collider:enter("Ground") or self.collider:stay("Ground") 

    -- Springen, wenn der Player gerade nicht in der Luft ist
    if love.keyboard.isDown("w") and self.isGrounded then
        vy = self.jumpForce
        self.anim = self.animations.jump

    end


    if not love.keyboard.isDown("w") and not love.keyboard.isDown("a") and not love.keyboard.isDown("d") then
        self.anim = self.animations.idle
    end


    self.anim:update(dt)

    -- Geschwindigkeit platzieren
    self.collider:setLinearVelocity(vx, vy)
end

function Player:draw()
    -- Falls du spezielle Zeichnungen für den Player möchtest, hier einfügen
    self.anim:draw(self.spriteSheet, self.collider:getX()-tileSize, self.collider:getY()-tileSize, nil, scaler, scaler)
end

return Player
