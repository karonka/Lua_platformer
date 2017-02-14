Projectile = {}
-- Constructor
function Projectile:new( xc, yc, w, h, speed, dir, tp, st, _targetX, _targetY, _damage, funcs)
  -- define our parameters here
  local object = {
    x = xc,
    y = yc,
    velocityX = speed*dir,
    velocityY = 0,
    width = w,
    height = h,
    frame = 1,
    timePassed = 0,
    timePerFrame = 1/18,
    direction = dir,
    damage = _damage,
    projectileType = tp,
    state = st,
    active = true,
    collider = Collider:new(xc, yc, w, h, 0.8, 0.8),
    behaviors = funcs,
--  update/ move logic = nil,
  }
  if (_targetX >= 0 and _targetY >= 0) then 
  	local xDif = math.abs(_targetX-xc)
  	local yDif = math.abs(_targetY-yc)
  	local dirX = _targetX > xc and 1 or -1
  	local dirY = _targetY > yc and 1 or -1
  	object.velocityX = xDif > 0 and dirX*math.sqrt((speed*speed)/(1+(yDif/xDif))) or 0
  	object.velocityY = yDif > 0 and dirY*math.sqrt((speed*speed) - object.velocityX*object.velocityX) or 0
  end
  setmetatable(object, { __index = Projectile })
  return object
end

function Projectile:draw()
	if not self.active then return end
	local _,_,w,h = (Images[self.projectileType][self.state][self.frame] or Images[self.projectileType][self.state]):getViewport()
  	love.graphics.draw(Images[self.projectileType]["sprite"],Images[self.projectileType][self.state][self.frame] or Images[self.projectileType][self.state], 
  	self.x - (w/2)*self.direction, self.y - h/2, 0, self.direction , 1)
end

function Projectile:update(dt)
	if not self.active then return end
	for k,v in ipairs(self.behaviors) do
		v(self,dt)
	end
    for k, v in pairs(Layer.enemies) do 
        if self.collider:checkCollisionBasic(v.collider)  and v.state ~= 'dead' then
            v:getHit(self.damage)
            self.active = false
            return
        end
    end
end
