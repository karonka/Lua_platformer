Weapon = {}
-- Constructor
function Weapon:new( xc, yc, w, h, _type, _state, _angle, _diffX, _diffY, _collider)
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
    angle = _angle,
    diffX = _diffX,
    diffY = _diffY,
--	collider = _collider or Collider:new(xc, yc, w, h, 0.9, 0.9),
--    children = {} -- children = projectiles
  }
  setmetatable(object, { __index = Weapon })
  return object
end

function Weapon:draw()
  	love.graphics.draw(Images[self.weaponType]["sprite"],Images[self.weaponType][self.state][self.frame] or Images[self.weaponType][self.state], 
  	self.x + self.diffX*math.sin(self.angle)*self.direction, 
  	self.y - self.diffY*math.cos(self.angle),
  	self.angle*self.direction, self.direction, 1)
end

function Weapon:update(dt,dx,dy,direction) 
--	local adjust = direction == self.direction and 0 or direction < 0 and -parentWDiff or parentWdiff
	self.x = self.x + dx -- + adjust
	self.y = self.y + dy
--	self.collider:update(dx,dy)
	self.direction = direction or self.direction
	--move()
 	--updateChildren() -- children = projectiles
end
