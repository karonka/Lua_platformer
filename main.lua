debug = true
require 'loader'
require 'collider'
require 'player'
require 'platform'

function love.load()
  defineGlobals()
  --love.graphics.setBackgroundColor(0,60,180)
  mediaLoader()
  createLevel()
end


function love.update(dt)
  for k, v in pairs(Layer) do 
    for k2, v2 in pairs(v) do
      if v == Layer.platforms then
        for k3, v3 in pairs(v2) do
          v3:update(dt)
          --v3:draw()
        end
      else     
        v2:update(dt)
        --v2:draw()
      end
    end
  end
end



function love.draw()
  love.graphics.draw(Images["background"]["normal"],0,0,0,2)
  love.graphics.push()
  love.graphics.translate(tX,tY)
  for k, v in pairs(Layer) do 
    for k2, v2 in pairs(v) do
      if v == Layer.platforms then
        for k3, v3 in pairs(v2) do
          --v3:update(dt)
          v3:draw()
        end
      else     
        --v2:update(dt)
        v2:draw()
      end
    end
  end
  
  for i = 1, 5 do
    for j = 0, 50 do
      if(Layer.platforms[i][j]) then
        --love.graphics.draw(Platform.img, Layer.platforms[i][j].x, Layer.platforms[i][j].y)
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
  
  Layer.player[0] = Player:new( SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 72, 97, 500)
  
  for i = 1, 5 do
    Layer.platforms[i] = {}
    for j = 0, 50 do
      Layer.platforms[i][j] = Platform:new(tileWidth*j + tileWidth/2, 300+300*i, 70, 70,"grass", "mid")
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

function defineGlobals()
  
 -- print(love.window.getDesktopDimensions())
  SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions()
  PERCENT_OF_SCREEN_FILLED = 0.85
  SCREEN_HEIGHT = SCREEN_HEIGHT * PERCENT_OF_SCREEN_FILLED
  SCREEN_WIDTH = SCREEN_WIDTH * PERCENT_OF_SCREEN_FILLED
  love.window.setMode( SCREEN_WIDTH, SCREEN_HEIGHT , {fullscreen = false, borderless = false})
  
  tileWidth = 70
  tileHeight = 70
  tY = 0
  tX = 0
end

function lerp(a,b,t) 
    return a+(b-a)*t 
end

function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end
