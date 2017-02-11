Weapon = {}
-- Constructor
function Weapon:new( xc, yc, w, h, _type, _state, _func)
  -- define our parameters here
  local object = {
    x = xc,
    y = yc,
--    speed = in_speed,
    width = w,
    height = h,
    frame = 1,
    timePassed = 0,
    timePerFrame = 1/18,
    direction = 1,
    weaponType = _type,
    state = _state,
    angle = 0,
    func = _func,
--	collider = _collider or Collider:new(xc, yc, w, h, 0.9, 0.9),
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
	if(self.direction == 1) then
		love.graphics.draw(Images[self.weaponType]["sprite"],Images[self.weaponType][self.state][self.frame] or Images[self.weaponType][self.state], 
	  	Layer.player[0].x + 28, --17
	  	Layer.player[0].y + 25, --40
	  	self.angle, -1, 1,
	  	9,59)
  	else
	  	love.graphics.draw(Images[self.weaponType]["sprite"],Images[self.weaponType][self.state][self.frame] or Images[self.weaponType][self.state], 
	  	Layer.player[0].x - 28, --17
	  	Layer.player[0].y + 25, --40
	  	-self.angle, 1, 1,
	  	11,59)
	end
end

function Weapon:update(dt,dx,dy,direction) 
--	local adjust = direction == self.direction and 0 or direction < 0 and -parentWDiff or parentWdiff
	self.x = self.x + dx -- + adjust
	self.y = self.y + dy
--	self.collider:update(dx,dy)
	self.direction = direction or self.direction
	self.angle = self.func(dt,love.keyboard.isDown("e"))
	--print(self.func(dt,love.keyboard.isDown("e")))
	--move()
 	--updateChildren() -- children = projectiles
end

function Weapon.hit(minRot, maxRot, hitDuration)
	local timeSinceHit = 0
	local angle = minRot
	local hitting = false
	return function (dt, hit) -- hit == isKeyDown()
		if hit then
			hitting = true
		end
		if hitting then
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
		end
		return angle	
	end
end
