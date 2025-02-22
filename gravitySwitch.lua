local GravitySwitch = {}
GravitySwitch.__index = GravitySwitch

function GravitySwitch:new(world, x, y, width, height)
    local self = setmetatable({}, GravitySwitch)
    love.graphics.setDefaultFilter("nearest", "nearest")
    self.spriteSheet = love.graphics.newImage('assets/spritesheets/Switch.png')
    self.grid = anim8.newGrid(tileSize, tileSize, self.spriteSheet:getWidth(), self.spriteSheet:getHeight())
    self.animations = {}
    self.animations.off = anim8.newAnimation(self.grid('1-1',1), 0.1)
    self.animations.on = anim8.newAnimation(self.grid('2-2',1), 0.1)

    self.anim = self.animations.off

    self.collider = world:newRectangleCollider(x, y, width, height)
    -- self.collider:setType('static')
    self.collider:setFixedRotation(true) -- verhindert, dass der Player fällt
    self.collider:setCollisionClass('Switch')  -- Spezielle Kollisionklasse für den Switch
    self.collider:setType('kinematic')


    return self

end

-- Methode zur Zuweisung des Players
function GravitySwitch:setPlayer(player)
    self.player = player
end


function GravitySwitch:update(player)
    if not player or not player.collider then
        print("Fehler: Player oder Collider ist nil!")
        return
    end

    -- Überprüfen, ob der Player den Switch-Bereich betritt oder sich weiterhin darin befindet
    if self.collider:enter("Player") or self.collider:stay("Player") then

        -- Wenn die "E"-Taste gedrückt wird, dann den Switch umschalten
        if love.keyboard.isDown("e") then
            self.anim = self.animations.on

            -- Hier muss jetzt die Gravitation geändert werden
            
        end
    end

end


function GravitySwitch:draw()
    love.graphics.rectangle("fill", self.collider:getX(), self.collider:getY() - tileSize, tileSize *scaler, tileSize * scaler)
    self.anim:draw(self.spriteSheet,self.collider:getX(), self.collider:getY() - tileSize, nil, scaler, scaler)

end 

return GravitySwitch