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
	if not GAME_OVER then
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
	end
  	Camera.update(dt)
  	HUD:update()
  	if love.keyboard.isDown('l') then GAME_OVER = true end
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
  HUD:draw()
  drawInventory()
  if GAME_OVER then
  	drawGameOverScreen()
  end
end

function createLevel()
  
    Layer = {}
    Layer.background = {}
    Layer.platforms = {}
    Layer.enemies = {}
    Layer.player = {}
    Layer.items = {}
  
    Layer.player[0] = Player:new(SCREEN_WIDTH/2, SCREEN_HEIGHT/2, 72, 97, 1500, 3, 1.4, 1800, 1400, {restore(2, 'recentlyDamaged', true, {['recentlyDamaged'] = false})})
    --Layer.player[0].children[1] = Weapon:new(Layer.player[0].x, Layer.player[0].y, 22, 64,   9, 59, 28, 25,   60, 10, 60, 60, 'sword', 'normal', 100, Weapon.swordHit(0.5,1.8,0.15))
    Layer.player[0].children[1] =   Weapon:new(Layer.player[0].x, Layer.player[0].y, 22, 64,   10, 20, 28, 25,   0, 0, 0, 0, 'gun', 'normal', 25, Weapon.gunHit(0.2,600,20,50,-5))
    PLAYER = Layer.player[0]
    --Layer.player[0].children[2] = Projectile:new(1000,300, 12, 12, 250, 1,'projectile', 'laser',0, 300, {moveLinear})
    Camera.target = Layer.player[0]

	Layer.enemies[0] = Snail.new(200, 200)
	Layer.enemies[1] = Fly.new(200, 400, 500)
	Layer.enemies[2] = Spider.new(0, 400, 500)
	Layer.items[0] = Item:new(200, 500, 20, 20, 'buttonBlue', nil, nil, {activateOnPlayerEnter})
	Layer.items[1] = Item:new(300, 500, 20, 20, 'buttonGreen', nil, nil, {activateOnPlayerEnter,deactivateOnPlayerLeave})
	Layer.items[2] = Item:new(400, 500, 20, 20, 'buttonYellow')
	Layer.items[3] = Coin.new(500,500)
	Layer.items[4] = Item:new(900, 500, 20, 20, 'key', 'yellow', nil, {activateSthOnPlayerEnter(Layer.items[2]), hideOnPlayerEnter})
	Layer.items[5] = Item:new(700, 500, 20, 20, 'flagRed', nil, nil, {activateOnPlayerEnter})
	Layer.items[6] = Bomb.new(100, 500)
	Layer.items[7] = Spikes.new(1000, 500)
    for i = 1, TILE_COUNT_Y do
        Layer.platforms[i] = {}
        if i % 10 == 0 then
            for j = 0, TILE_COUNT_X - 1 do
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
                Layer.enemies[#Layer.enemies +1] = Enemy:new(TILE_COUNT_X*j + TILE_WIDTH/2, (300-TILE_COUNT_Y) + 30*i, 54, 30, 60, 'barnacle', 'normal', 1/2, 100, nil, takeDamage, {normalMovement, dieOnPlayerCollision, restore(3.2, 'state', 'dead', {['state'] = 'normal', ['velocityX'] = 60,['direction']= -1, ['hp'] = 100})})
            end
            Layer.platforms[i][j] = Platform:new(TILE_WIDTH*j + TILE_WIDTH/2, 300+30*i, 70, 70, "grass", "mid")
            end
            local hole = love.math.random(0,46)
            if i == TILE_COUNT_Y then
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
end


