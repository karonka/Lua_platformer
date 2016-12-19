function updateVelocity(self, x, y, dt)
	self.velocityX = (self.velocityX + x) * (1-self.frictionX*dt)
	self.velocityY = (self.velocityY + y) * (1-self.frictionY*dt)
end

function setVelocity(self,x,y)
	self.velocityX = x
	self.velocityY = y
end

function applyGravity(self,dt)
	self.velocityY = self.velocityY + self.gravity*dt
end

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
	  if ( self.velocityY > 0) then
	  	self.velocityY = 0
      	self.jumping = false
      end
    end
  end
end
