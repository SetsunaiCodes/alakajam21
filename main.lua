
function love.load()
    wf = require 'libraries/windfield'
    sti = require 'libraries/sti'
    anim8 = require 'libraries/anim8'
    camera = require 'libraries/camera'
    Player = require 'player'
    Enemy = require 'enemy'
    GravitySwitch = require 'gravitySwitch'

 
    scaler = 2
    tileSize = 16

    
    cam = camera()

    world = wf.newWorld(0, 500)

    world:addCollisionClass("Ground")
    world:addCollisionClass("Enemy")
    world:addCollisionClass("Player")
    world:addCollisionClass("Switch")



    gameMap = sti('assets/maps/testing.lua')


    -- Player als Objekt erzeugen
    player = Player:new(world, 350, 100, tileSize * scaler, tileSize * scaler)


    -- Testing Enemy erzeugen
    -- enemy = Enemy:new(world, 400, 100, 20, 20)

    -- Testing Switch erzeugen
    local gravityLayer = gameMap.layers["Switch"]
    if gravityLayer and gravityLayer.objects then
        for i, obj in ipairs(gravityLayer.objects) do
            gravitySwitch = GravitySwitch:new(world, (obj.x - tileSize) * scaler, (obj.y - tileSize) * scaler, tileSize * scaler, tileSize * scaler)

        end
    end

    -- Load Collisions
    local collisionLayer = gameMap.layers["Collisions"]
    if collisionLayer and collisionLayer.objects then
        for i, obj in ipairs(collisionLayer.objects) do
            ground = world:newRectangleCollider(obj.x * scaler, obj.y * scaler, obj.width * scaler, obj.height * scaler)
            ground:setType('static')
            ground:setCollisionClass("Ground")
        end
    else
        print("Kein Collisions-Layer oder keine Objekte gefunden!")
    end



end


function love.update(dt)

    local playerX, playerY = player:getPosition() 

    world:update(dt)
    player:update(dt)
    gravitySwitch:update(player)   


    
    


    cam:lookAt(playerX, playerY)
end


function love.draw()
    cam:attach()
        love.graphics.push()
        love.graphics.scale(scaler,scaler)

        -- HIER MUSS JEDER LAYER EINZELN GEDRAWED WERDEN (Natürlich ohne Collisions)
        gameMap:drawLayer(gameMap.layers["Tiles"],0,0)

        love.graphics.pop()


        -- Physics World Linien
        -- world:draw()


        -- Player drawen
        player:draw()
        -- Draw GravitySwitch
        gravitySwitch:draw()

        

        --  DIE ISSUES MIT DEM SCALER UND DEN PHYSICS ANGEHEN

    cam:detach()

end
