Enemy = {}
-- Constructor
function Enemy:new( xc, yc, w, h, velocity, enemyTp, st, onPlayerCollideFunc)
  -- define our parameters here
  local object = {
    x = xc,
    y = yc,
    velocityX = velocity,
    velocityY = 0,
    gravity = 500,
    width = w,
    height = h,
    frame = 1,
    timePassed = 0,
    timePerFrame = 1/2,
    direction = -1,
    enemyType = enemyTp,
    state = st,
    collider = Collider:new(xc, yc, w, h, 1, 1),
    onCollideWithPlayer = onPlayerCollideFunc,
--  update/ move logic = nil,
  }
  setmetatable(object, { __index = Enemy })
  return object
end

function Enemy:draw()
	--self.direction = self.direction and self.velocityX*self.direction < 0 and -self.direction or self.direction or 1
	local _,_,w,h = (Images[self.enemyType][self.state][self.frame] or Images[self.enemyType][self.state]):getViewport()
  	love.graphics.draw(Images[self.enemyType]["sprite"],Images[self.enemyType][self.state][self.frame] or Images[self.enemyType][self.state], 
  	self.x - (w/2)*self.direction, self.y - h/2, 0, self.direction , 1)
end

function Enemy:update(dt)
	local prevX, prevY = self.x, self.y
	self.timePassed = self.timePassed + dt
	if self.timePassed > self.timePerFrame then  
		self.frame = self.frame + 1
		if type(Images[self.enemyType][self.state]) == "table" and self.frame > #Images[self.enemyType][self.state] then
			self.frame = self.frame - (#Images[self.enemyType][self.state])
		end
		self.timePassed = self.timePassed - self.timePerFrame
	end
	
	applyGravity(self, dt)
	self.x = self.x + self.velocityX*dt
	self.y = self.y + self.velocityY*dt
	self.x = clamp(0 + self.width/2, self.x , WORLD_WIDTH - self.width/2)
	self.y = clamp(0 + self.height/2, self.y , WORLD_HEIGHT - self.height/2)

	local dx,dy = self.x - prevX, self.y - prevY
	collisionWithStatic(self,dx,dy) 
	self:checkPlayerCollision()
	--move()
	--checkCollisions()
 	--updateChilds() -- childs = weapons
end

function Enemy:checkPlayerCollision()
	local obj = Layer.player[0]
	if self.collider:checkCollision(obj.collider,0,0) then
		self:onCollideWithPlayer()
	end
end

function Enemy:die()
	self.velocityX = 0
	self.state = "dead"
end

function Enemy:runFromPlayer()
end

function goToAim()
end
