
function love.load()
    wf = require 'libraries/windfield'
    sti = require 'libraries/sti'
    camera = require 'libraries/camera'


    scaler = 2
    tileSize = 16

    
    cam = camera()

    world = wf.newWorld(0, 500)
    gameMap = sti('assets/maps/testing.lua')


    player = world:newRectangleCollider(350, 100, tileSize * scaler, tileSize * scaler)


    -- Load Collisions
    local collisionLayer = gameMap.layers["Collisions"]
    if collisionLayer and collisionLayer.objects then
        for i, obj in ipairs(collisionLayer.objects) do
            ground = world:newRectangleCollider(obj.x * scaler, obj.y * scaler, obj.width * scaler, obj.height * scaler)
            ground:setType('static')
        end
    else
        print("Kein Collisions-Layer oder keine Objekte gefunden!")
    end
end


function love.update(dt)

    local playerX, playerY = player:getX(), player:getY() 

    world:update(dt)



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
        world:draw()

        --  DIE ISSUES MIT DEM SCALER UND DEN PHYSICS ANGEHEN

    cam:detach()

end
