
--- PHYSICS ---

function updateVelocity(self, x, y)
	local dt = love.timer.getDelta()
	self.velocityX = (self.velocityX + x) * (1-self.frictionX*dt)
	self.velocityY = (self.velocityY + y) * (1-self.frictionY*dt)
end

function setVelocity(self,x,y)
	self.velocityX = x
	self.velocityY = y
end

function applyGravity(self)
	local dt = love.timer.getDelta()
	self.velocityY = self.velocityY + self.gravity*dt
end


--- MOVEMENT LOGIC ---

function moveLinear(self)
	local dt = love.timer.getDelta()
	self.x = self.x + self.velocityX*dt
	self.y = self.y + self.velocityY*dt
end

function normalMovement(self)
	local dt = love.timer.getDelta()
	local prevX, prevY = self.x, self.y
	applyGravity(self, dt)
	self.y = self.y + self.velocityY*dt
	if self.x + self.velocityX*dt - self.width/2 < 0 or self.x + self.velocityX*dt + self.width/2 > WORLD_WIDTH then
		self.velocityX = -1*self.velocityX
	end 
	self.x = self.x + self.velocityX*dt	
	self.y = self.y + self.velocityY*dt
	self.y = clamp(0 + self.height/2, self.y , WORLD_HEIGHT - self.height/2)
	local dx,dy = self.x - prevX, self.y - prevY
	collisionWithStatic(self,dx,dy)
end

function runFromPlayer(self)
end

function goToAim(self)
end

function flyBetweenPoints (maxDist, startX )
	local x1 = math.max(0, startX - maxDist)
	local x2 = math.min(WORLD_WIDTH, startX + maxDist)
	return function (self) 
		local dt = love.timer.getDelta()
		if self.x + self.velocityX*dt - self.width/2 < x1 or self.x + self.velocityX*dt + self.width/2 > x2 then
			self.velocityX = -1*self.velocityX
		end 
		self.x = self.x + self.velocityX*dt
	end
end

--- COLLISION ---

function collisionWithStatic(self,dx,dy)
  self.collider:update(dx,dy)
  
  local both = false
  local collX = false
  local collY = false
  local overlapX = 0
  local overlapY = 0
 	for _, row in pairs(Layer.platforms) do
 		for _,platform in pairs(row) do 
			bothT, collXT, collYT, overlapXT, overlapYT  = self.collider:checkCollision(platform.collider, dx, dy)
		--      print(bothT, collXT, collYT)
			both = both or bothT
			collX = collX or collXT
			collY = collY or collYT
			overlapX = (math.abs(overlapX) > math.abs(overlapXT)) and overlapX or overlapXT
			overlapY = (math.abs(overlapY) > math.abs(overlapYT)) and overlapY or overlapYT
		end
	end
  
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
      	if self.jumping and self.velocityY > 0 then 
	  		self.jumping = false
	  	end	
  		self.velocityY = 0
    end
  end
end

function dieOnPlayerCollision(self)
	local obj = Layer.player[0]
	if self.collider:checkCollision(obj.collider,0,0) then
		self.velocityX = 0
		self.state = "dead"
	end
end

function checkPlayerCollision(self)
	return self.collider:checkCollision(Layer.player[0].collider,0,0)
end
