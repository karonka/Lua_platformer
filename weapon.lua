Weapon = {}
-- Constructor
function Weapon:new(xc, yc, w, h, _spriteOffsetFromHandX, _spriteOffsetFromHandY, _offsetToHandX, _offsetToHandY, _offsetColliderX, _offsetColliderY, _colliderW, colliderH, _type, _state, _damage, _func)
  -- define our parameters here
  local object = {
    -- center of the player
    x = xc,
    y = yc,
    -- translation 
    spriteOffsetFromHandX = _spriteOffsetFromHandX,
    spriteOffsetFromHandY = _spriteOffsetFromHandY,
    -- offSet from the center of the player to the hand of the player
    offsetX = _offsetToHandX,
    offsetY = _offsetToHandY,
--    speed = in_speed,
    width = w,
    height = h,
    frame = 1,
    timePassed = 0,
    timePerFrame = 1/18,
    direction = 1,
    weaponType = _type,
    damage = _damage,
    state = _state,
    angle = 0,
    func = _func,
    offsetColliderX = _offsetColliderX,
    offsetColliderY = _offsetColliderY,
    collider = _collider or Collider:new(xc + _offsetColliderX, yc + _offsetColliderY, _colliderW, colliderH),
--  children = {} -- children = projectiles
}

  setmetatable(object, { __index = Weapon })
  return object
end

--[[function Weapon:draw()
  	love.graphics.draw(Images[self.weaponType]["sprite"],Images[self.weaponType][self.state][self.frame] or Images[self.weaponType][self.state], 
  	self.x + self.diffX*math.sin(self.angle)*self.direction, 
  	self.y - self.diffY*math.cos(self.angle),
  	self.angle*self.direction, self.direction, 1)
end]]

function Weapon:draw()
    -- Draw the collider for debuging
    drawCollider(self)
	if(self.direction == 1) then
        
		love.graphics.draw(Images[self.weaponType]["sprite"],Images[self.weaponType][self.state][self.frame] or Images[self.weaponType][self.state], 
	  	self.x + self.offsetX, --The hand of the player
	  	self.y + self.offsetY, --The hand of the player
	  	self.angle, 1, 1,
	  	self.spriteOffsetFromHandX, self.spriteOffsetFromHandY) 
  	else
	  	love.graphics.draw(Images[self.weaponType]["sprite"],Images[self.weaponType][self.state][self.frame] or Images[self.weaponType][self.state], 
	  	self.x - self.offsetX, --The hand of the player
	  	self.y + self.offsetY, --The hand of the player
	  	-self.angle, -1, 1,
	  	self.spriteOffsetFromHandX, self.spriteOffsetFromHandY) 
	end
end

function Weapon:update(dt, dx, dy, direction) 
    if(self.direction ~= direction) then
        self.collider:update( (self.offsetColliderX*2) * direction, 0)
    end
--	local adjust = direction == self.direction and 0 or direction < 0 and -parentWDiff or parentWdiff
	self.x = self.x + dx -- + adjust
	self.y = self.y + dy
	self.collider:update(dx,dy)
	self.direction = direction or self.direction
	self:func(dt,love.keyboard.isDown("e"))
	--print(self.func(dt,love.keyboard.isDown("e")))
	--move()
 	--updateChildren() -- children = projectiles
end

function Weapon.hit(minRot, maxRot, hitDuration)
	local timeSinceHit = 0
	local angle = minRot
	local hitting = false
    local enemyHitted = false
	return function (self, dt, hit) -- hit == isKeyDown()
		if hit then
			hitting = true
		end
		if hitting then
            -- change angle of sword
			timeSinceHit = timeSinceHit + dt
			if timeSinceHit < hitDuration then
				angle = minRot + (maxRot - minRot) * (timeSinceHit/hitDuration)
			elseif timeSinceHit >= hitDuration and timeSinceHit < 2*hitDuration then
				angle = maxRot - (maxRot - minRot) * (timeSinceHit/hitDuration - 1)
			else
				angle = minRot
				timeSinceHit = 0
				hitting = false
			end
            if ( not enemyHitted ) then
            -- collisionLogic
            -- WORK IN PROGRESS 
                for k, v in pairs(Layer.enemies) do 
                    if ( self.collider:checkCollisionBasic(v.collider) ) then
                        -- WORKING HERE RIGHT NOW, ALL OF THIS WILL BE CHANGED 
                        v.velocityX = 0
                        v.state = "dead"
                        print(v)
                        enemyHitted = true
                    end
                end
            end
		end
		self.angle =  angle	
	end
end

