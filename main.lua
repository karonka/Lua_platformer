debug = true
require 'globals'
require 'loader'
require 'collider'
require 'physics'
require 'player'
require 'enemy'
require 'weapon'
require 'platform'
require 'camera'
require 'objects'

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
end



function love.draw()
  love.graphics.draw(Images["background"]["normal"],0,0,0,2)
  love.graphics.push()
  love.graphics.translate(Camera.tX,Camera.tY)
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
end

function createLevel()
  
  Layer = {}
  Layer.background = {}
  Layer.platforms = {}
  Layer.enemies = {}
  Layer.player = {}
  
  Layer.player[0] = Player:new(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 72, 97, 1500, 3, 1.4, 1800, 1400)
  Layer.player[0].children[1] = Weapon:new(Layer.player[0].x, Layer.player[0].y + 10, 22, 64, 'sword', 'normal', Weapon.hit(0.5,1.8,0.1))
  --Layer.player[0].children[1] = Weapon:new(Layer.player[0].x, Layer.player[0].y + 10, 40, 26, 'gun', 'normal', Weapon.hit(0.5,1.8,0.1))
  Camera.target = Layer.player[0]
	Layer.enemies[0] = Snail.new(200, 200)
  for i = 1, 5 do
    Layer.platforms[i] = {}
    for j = 0, TILE_COUNT_X - 1 do
      Layer.platforms[i][j] = Platform:new(TILE_WIDTH*j + TILE_WIDTH/2, 300+300*i, 70, 70,"grass", "mid")
    end
    local hole = love.math.random(0,46)
    if i == 5 then
      break
    end
    for k = hole, hole+4 do
      Layer.platforms[i][k] = nil
    end
    if Layer.platforms[i][hole-1] then
    	Layer.platforms[i][hole-1].state = "right"
    end
    if Layer.platforms[i][hole+5] then
    	Layer.platforms[i][hole+5].state = "left"
    end
  end
end


