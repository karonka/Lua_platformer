Player = {}

-- Constructor
function Player:new( xc, yc, w, h, acc, frictX, frictY, grav, jmpSpeed)
  -- define our parameters here
  local object = {
    x = xc,
    y = yc,
    width = w,
    height = h,
    frame = 1,
    timePassed = 0,
    timePerFrame = 1/18,
    jumping = false,
    velocityX = 0,
    velocityY = 0,
    gravity = grav,
    acceleration = acc,
    jumpSpeed = jmpSpeed,
    frictionX = frictX,
    frictionY = frictY,
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
  
  local forceX, forceY = 0,0
  if love.keyboard.isDown("f") then
    self.speed = 3000
  end
  
  if love.keyboard.isDown("up")  then
	if not self.jumping then
		self.velocityY = - self.jumpSpeed
		self.jumping = true
	end
  end
  if love.keyboard.isDown("left") then
    forceX = forceX - self.acceleration*dt
  end
  if love.keyboard.isDown("right") then
    forceX = forceX + self.acceleration*dt
  end
  
  if (forceX * self.velocityX) < 0 and self.jumping then
  	forceX = forceX/2.5
  end

  --self.y = self.y + 5
  applyGravity(self, dt)
  updateVelocity(self, forceX, forceY, dt)
  self.x = self.x + self.velocityX*dt
  self.y = self.y + self.velocityY*dt
  self.x = clamp(0 + self.width/2, self.x , WORLD_WIDTH - self.width/2)
  self.y = clamp(0 + self.height/2, self.y , WORLD_HEIGHT - self.height/2)

  self.speed = 500
  local dx,dy = self.x - prevX, self.y - prevY
  collisionWithStatic(self,dx,dy) 
 
end


