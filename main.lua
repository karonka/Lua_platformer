debug = true
require 'globals'
require 'loader'
require 'collider'
require 'player'
require 'enemy'
require 'weapon'
require 'platform'
require 'projectile'
require 'item'
require 'hud'
require 'camera'
require 'objects'
require 'functions'

function love.load()
  mediaLoader()
  createLevel()
end


function love.update(dt)
  for k, v in pairs(Layer) do 
    for k2, v2 in pairs(v) do
      if v == Layer.platforms then
        for k3, v3 in pairs(v2) do
          v3:update(dt)
        end
      else     
        v2:update(dt)
      end
    end
  end
  Camera.update(dt)
  HUD:update()
end



function love.draw()
  love.graphics.draw(Images["background"]["normal"],0,0,0,2)
  love.graphics.push()
  love.graphics.translate(Camera.tX,Camera.tY)
  love.graphics.scale(Camera.scaleX,Camera.scaleY)
  --love.graphics.scale(0.6,0.6)
  for k, v in pairs(Layer) do 
    for k2, v2 in pairs(v) do
      if v == Layer.platforms then
        for k3, v3 in pairs(v2) do
          v3:draw()
        end
      else     
        v2:draw()
      end
    end
  end  
  love.graphics.pop() 
  HUD:draw()
end

function createLevel()
  
    Layer = {}
    Layer.background = {}
    Layer.platforms = {}
    Layer.enemies = {}
    Layer.player = {}
    Layer.items = {}
  
    Layer.player[0] = Player:new(SCREEN_WIDTH/2 * (1/Camera.scaleX), SCREEN_HEIGHT/2 * (1/Camera.scaleY), 72, 97, 1500, 3, 1.4, 1800, 1400)
    Layer.player[0].children[1] = Weapon:new(Layer.player[0].x, Layer.player[0].y, 22, 64,   9, 59, 28, 25,   60, 10, 60, 60, 'sword', 'normal', 100, Weapon.swordHit(0.5,1.8,0.15))
    Layer.player[0].children[2] =   Weapon:new(Layer.player[0].x, Layer.player[0].y, 22, 64,   10, 20, 28, 25,   0, 0, 0, 0, 'gun', 'normal', 25, Weapon.gunHit(0.2,600,20,50,-5))
    --Layer.player[0].children[2].active = true
    PLAYER = Layer.player[0]
    --Layer.player[0].children[2] = Projectile:new(1000,300, 12, 12, 250, 1,'projectile', 'laser',0, 300, {moveLinear})
    Camera:setTarget(Layer.player[0])
	--Layer.enemies[0] = Snail.new(200, 200)
	--Layer.enemies[1] = Fly.new(200, 400, 500)
	--Layer.enemies[2] = Spider.new(800, 400)
	Layer.items[0] = Item:new(200, 500, 20, 20, 'buttonBlue', nil, {activateOnPlayerEnter})
	Layer.items[1] = Item:new(300, 500, 20, 20, 'buttonGreen', nil, {activateOnPlayerEnter,deactivateOnPlayerLeave})
	Layer.items[2] = Item:new(400, 500, 20, 20, 'buttonYellow')
	Layer.items[3] = Coin.new(500,500)
	Layer.items[4] = Item:new(900, 500, 20, 20, 'key', 'yellow', {activateSthOnPlayerEnter(Layer.items[2]), hideOnPlayerEnter})
	Layer.items[5] = Item:new(700, 500, 20, 20, 'flagRed', nil, {activateOnPlayerEnter})
	Layer.items[6] = Bomb.new(100, 500)
    for i = 1, TILE_COUNT_Y do
        Layer.platforms[i] = {}
        if i % 10 == 0 then
            for j = 0, TILE_COUNT_X - 1 do
                -- Create enemies and probably objects in the future
                if love.math.random(40) == 1 then
                    Layer.enemies[#Layer.enemies +1] = Spider.new(TILE_COUNT_X*j + TILE_WIDTH/2, (300-TILE_COUNT_Y) + 30*i )
                end
                if math.random(30) == 1 then
                    Layer.enemies[#Layer.enemies +1] = Fly.new(TILE_COUNT_X*j + TILE_WIDTH/2, (300-TILE_COUNT_Y * 2.5) + 30*i, 500 )
                end
                if math.random(30) == 1 then
                    Layer.enemies[#Layer.enemies +1] = Snail.new(TILE_COUNT_X*j + TILE_WIDTH/2, (300-TILE_COUNT_Y) + 30*i)
                end
                if math.random(30) == 1 then
                    Layer.enemies[#Layer.enemies +1] = Enemy:new(TILE_COUNT_X*j + TILE_WIDTH/2, (300-TILE_COUNT_Y) + 30*i, 54, 30, 0, 'barnacle', 'normal', 1/2, 100, takeDamage, {normalMovement, dieOnPlayerCollision, restore(3.2, 'state', 'dead', {['state'] = 'normal', ['velocityX'] = 0,['direction']= -1, ['hp'] = 100})})
                end
                -- Create the platform
               -- if i == 10 or i == 20 then
                    Layer.platforms[i][j] = Platform:new(TILE_WIDTH*j + TILE_WIDTH/2, 300+30*i, 70, 70, "grass", "mid")
                --end
                if i == 30 or i == 40 then
                --    Layer.platforms[i][j] = Platform:new(TILE_WIDTH*j + TILE_WIDTH/2, 300+30*i, 70, 70, "dirt", "mid")
                end
            end
            
            -- Create holes so the player can drop down to the next platform level
            local hole = love.math.random(0,46)
            if i == TILE_COUNT_Y then
                break
            end
            for k = hole, hole+4 do
                Layer.platforms[i][k] = nil
            end
            -- Make the hole look better by changing the tile 
            if Layer.platforms[i][hole-1] then
                Layer.platforms[i][hole-1].state = "right"
            end
            if Layer.platforms[i][hole+5] then
                Layer.platforms[i][hole+5].state = "left"
            end
        end
    end
end


