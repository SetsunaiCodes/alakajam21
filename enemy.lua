local Enemy = {}
Enemy.__index = Enemy

function Enemy:new(world, x, y, width, height)
    local self = setmetatable({}, Enemy)
    self.speed = 100
    self.jumpForce = -250
    self.isGrounded = false
    self.direction = 1  -- Startet mit Bewegung nach rechts
    self.detectionRadius = 150  -- Radius, in dem der Gegner den Spieler sieht
    self.jumpCooldown = 2  -- Sekunden zwischen Sprüngen
    self.timeSinceLastJump = 0
    self.turnCooldown = 0  -- Cooldown für Umdrehen

    self.collider = world:newRectangleCollider(x, y, width, height)
    self.collider:setFixedRotation(true)
    self.collider:setRestitution(0)
    self.collider:setCollisionClass("Enemy")

    return self
end

function Enemy:update(dt, player)
    local vx, vy = self.collider:getLinearVelocity()
    local ex, ey = self.collider:getX(), self.collider:getY()
    local px, py = player:getPosition()

    -- Prüfen, ob Gegner auf dem Boden ist
    self.isGrounded = self.collider:enter("Ground") or self.collider:stay("Ground")

    -- **1. Spieler erkennen und angreifen**
    local distanceToPlayer = math.abs(px - ex)
    if distanceToPlayer < self.detectionRadius then
        if self.isGrounded and self.timeSinceLastJump >= self.jumpCooldown then
            local jumpDirection = (px > ex) and 1 or -1  -- Springt in Richtung des Spielers
            vx = jumpDirection * (self.speed * 1.5)  -- Sprunggeschwindigkeit
            vy = self.jumpForce  -- Nach oben springen
            self.timeSinceLastJump = 0  -- Timer zurücksetzen
        end
    else
        -- **2. Prüfen, ob vor dem Gegner noch Boden ist**
        if self.turnCooldown <= 0 then
            local checkX = ex + (self.direction * 16)  -- Ein Tile vor dem Gegner
            local checkY = ey + 18  -- Direkt unter dem Tile vor dem Gegner
            local groundAhead = world:queryRectangleArea(checkX, checkY, 10, 5, {"Ground"})

            -- Wenn kein Boden mehr da ist, umdrehen
            if #groundAhead == 0 then
                self.direction = self.direction * -1  -- Richtung wechseln
                self.turnCooldown = 0.3  -- Cooldown für Umdrehen, damit er nicht zappelt
            end
        else
            self.turnCooldown = self.turnCooldown - dt  -- Cooldown verringern
        end

        -- **3. Patrouillieren**
        vx = self.speed * self.direction
    end

    -- Cooldown Timer für das Springen aktualisieren
    self.timeSinceLastJump = self.timeSinceLastJump + dt

    -- Geschwindigkeit setzen
    self.collider:setLinearVelocity(vx, vy)
end

function Enemy:draw()
    love.graphics.setColor(1, 0, 0)  -- Rot
    local x, y = self.collider:getX(), self.collider:getY()
    love.graphics.rectangle("fill", x - 10, y - 10, 20, 20)  -- Zeichnet den Enemy als Quadrat
    love.graphics.setColor(1, 1, 1)  -- Reset auf weiß
end

return Enemy
