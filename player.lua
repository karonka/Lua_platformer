Player = {}

-- Constructor
function Player:new( xc, yc, w, h, in_speed)
  -- define our parameters here
  local object = {
    x = xc,
    y = yc,
    speed = in_speed,
    width = w,
    height = h,
    frame = 1,
    timePassed = 0,
    timePerFrame = 1/18,
    direction = 1,
    state = "walk",
    collider = Collider:new(xc, yc, w, h, 0.7, 0.9),
  }
  --Images["player"] = Images["alienPink"]
  setmetatable(object, { __index = Player })
  return object
end

function Player:draw()
	-- scale factors to be dependant on resolution/ screen dims
  	love.graphics.draw(Images["player"]["sprite"],Images["player"][self.state][self.frame], self.x - self.width/2, self.y - self.height/2, 0, 1 , 1)
end

function Player:update(dt)
  --print(self.x, self.y)
  local prevX, prevY = self.x, self.y
  self.timePassed = self.timePassed + dt
  if self.timePassed > self.timePerFrame then  
  	self.frame = self.frame + 1
  	if self.frame > #Images["player"]["walk"] then
  		self.frame = self.frame - (#Images["player"]["walk"])
  	end
  	self.timePassed = self.timePassed - self.timePerFrame
  end
  
  if love.keyboard.isDown("f") then
    self.speed = 3000
  end
  
  if love.keyboard.isDown("down") then
    self.y = self.y + dt*self.speed
  end
  if love.keyboard.isDown("up") then
    self.y = self.y - dt*self.speed
  end
  if love.keyboard.isDown("left") then
    self.x = self.x - dt*self.speed
    self.direction = -1
  end
  if love.keyboard.isDown("right") then
    self.x = self.x + dt*self.speed
    self.direction = 1
  end
  --self.y = self.y + 5
  
  
  
  self.x = clamp(0 + self.width/2, self.x , 3670)
  self.y = clamp(0 + self.height/2, self.y , 1000+SCREEN_HEIGHT-91)
 -- CheckCollisionPlatforms()

  self.speed = 500
  
  
  
  -- moveNormal()
  
  local dx,dy = self.x - prevX, self.y - prevY
  self.collider:update(dx,dy)
  both = false
  collX = false
  collY = false
  overlapX = 0
  overlapY = 0
  for i = 1, 5 do
    for j = 0, 60 do
      if Layer.platforms[i][j] then
        bothT, collXT, collYT, overlapXT, overlapYT  = self.collider:checkCollision(Layer.platforms[i][j].collider, dx, dy)
  --      print(bothT, collXT, collYT)
        both = both or bothT
        collX = collX or collXT
        collY = collY or collYT
        overlapX = (math.abs(overlapX) > math.abs(overlapXT)) and overlapX or overlapXT
        overlapY = (math.abs(overlapY) > math.abs(overlapYT)) and overlapY or overlapYT
      end
    end
  end
  print(overlapX, overlapY)
  
  
  
  if (both) then
    if(collX == collY) then
      self.x = self.x - overlapX
      self.y = self.y - overlapY
      self.collider:update(-overlapX,-overlapY)
    elseif (collX)then
      self.x = self.x - overlapX
      self.collider:update(-overlapX, 0)
    elseif (collY) then
      self.y = self.y - overlapY
      self.collider:update(0,-overlapY)
    end
  end
end

function CheckCollisionPlatforms()
  for k1, v1 in pairs(Layer.platforms) do
    for k2, v2 in pairs(v1) do
      --CheckRectCollision(self.collider, v2.collider)
    end
  end
end
