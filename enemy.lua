Enemy = {}
-- Constructor
function Enemy:new( xc, yc, w, h, velocity, enemyTp, st, timePerFr, _hp, _collider, _onHitFunction, funcs)
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
    timePerFrame = timePerFr,
    direction = -1,
    enemyType = enemyTp,
    state = st,
    collider = _collider or Collider:new(xc, yc, w, h, 0.6, 0.9),
    hp = _hp,
    recentlyDamaged = false,
    getHit = _onHitFunction,
    behaviors = funcs,
--  update/ move logic = nil,
  }
  setmetatable(object, { __index = Enemy })
  return object
end

function Enemy:draw()
	self.timePassed = self.timePassed + love.timer.getDelta()
	if self.timePassed > self.timePerFrame then  
		self.frame = self.frame + 1
		if type(Images[self.enemyType][self.state]) == "table" and self.frame > #Images[self.enemyType][self.state] then
			self.frame = self.frame - (#Images[self.enemyType][self.state])
		elseif type(Images[self.enemyType][self.state]) ~= "table" then
			self.frame = 1
		end
		self.timePassed = self.timePassed - self.timePerFrame
	end

    if self.recentlyDamaged == true and self.state ~= 'dead' then
        love.graphics.setColor(150,0,0)
    end
	--self.direction = self.direction and self.velocityX*self.direction < 0 and -self.direction or self.direction or 1
	local _,_,w,h = (Images[self.enemyType][self.state][self.frame] or Images[self.enemyType][self.state]):getViewport()
  	love.graphics.draw(Images[self.enemyType]["sprite"],Images[self.enemyType][self.state][self.frame] or Images[self.enemyType][self.state], 
  	self.x - (w/2)*self.direction, self.y - h/2, 0, self.direction , 1)
    --drawCollider(self)
    if self.recentlyDamaged == true then
        love.graphics.setColor(255,255,255)
        self.recentlyDamaged = false
    end
end
   
function Enemy:update(dt)
	local prevX, prevY = self.x, self.y
	
	for k,v in pairs(self.behaviors) do
		v(self)
	end	
	--move()
	--checkCollisions()
 	--updateChildren() -- = weapons
end
