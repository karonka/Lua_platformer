Player = {}

-- Constructor
function Player:new( xc, yc, w, h, acc, frictX, frictY, grav, jmpSpeed, _funcs)
  -- define our parameters here
  local object = {
    x = xc,
    y = yc,
    width = w,
    height = h,
    direction = 1,
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
    state = "front",
    recentlyDamaged = false,
    hp = 5000,
    coins = 0,
    behaviors = _funcs,
    collider = Collider:new(xc, yc, w, h, 0.7, 0.9),
    children = {},
    inventory = {},
  }
  --Images["player"] = Images["alienPink"]
  setmetatable(object, { __index = Player })
  return object
end

function Player:draw()
	self.timePassed = self.timePassed + love.timer.getDelta()
	if self.timePassed > self.timePerFrame then  
		self.frame = self.frame + 1
		if self.frame > #Images["player"]["walk"] then
			self.frame = self.frame - (#Images["player"]["walk"])
		end
		self.timePassed = self.timePassed - self.timePerFrame
	end
	self.direction = self.direction and self.velocityX*self.direction < 0 and -self.direction or self.direction or 1
	local _,_,w,h = (Images["player"][self.state][self.frame] or Images["player"][self.state]):getViewport()
  	love.graphics.draw(Images["player"]["sprite"],Images["player"][self.state][self.frame] or Images["player"][self.state], 
  	self.x - (w/2)*self.direction, self.y - h/2, 0, self.direction , 1)
  	for i = 1,#self.children do
  		self.children[i]:draw()
  	end
end

function Player:update(dt)
    if self.hp < 1 then
    	--self.state = 'dead'
    	GAME_OVER = true
    	return
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
		forceX = forceX/2
	end
	
	  	
  	for k,v in pairs(self.behaviors) do
		v(self)
	end	

	local prevX, prevY = self.x, self.y
	--self.y = self.y + 5
	--applyGravity(self, dt)
	forceY = self.gravity*dt
	updateVelocity(self, forceX, forceY, dt)
	self.velocityX = self.velocityX >= 0 and math.floor(self.velocityX) or math.ceil(self.velocityX)
	self.x = self.x + self.velocityX*dt
	self.y = self.y + self.velocityY*dt
    -- For Debugging, to move down and test the level faster
    if love.keyboard.isDown("]") then 
        self.y = self.y + 200
    end
	self.x = clamp(0 + self.width/2, self.x , WORLD_WIDTH - self.width/2)
	self.y = clamp(0 + self.height/2, self.y , WORLD_HEIGHT - self.height/2)

	local dx,dy = self.x - prevX, self.y - prevY
	collisionWithStatic(self,dx,dy) 
	
	if self.recentlyDamaged then
		self.state = 'hurt'
	elseif math.abs(self.velocityX) < 20 and not self.jumping then
		self.state = 'front'
	elseif math.abs(self.velocityX) > 20 and not self.jumping then
		self.state = 'walk'
	elseif self.jumping then
		self.state = 'jump'
	end
	
  	dx,dy = self.x - prevX, self.y - prevY
  	
    for i = 1,#self.children do
  		self.children[i]:update(dt,dx,dy,self.direction)
  	end
end

function love.keypressed( key, scancode, isrepeat)
	if isrepeat then return end
	if love.keyboard.isDown('i') then
		for i = 1,#PLAYER.inventory do
			if love.keyboard.isDown(i) then
				drop(PLAYER.inventory[i], i, PLAYER.x + 100*PLAYER.direction, PLAYER.y)
			end
		end
	end
    -- switch weapon logic, move that into a function
    if key == 'q' then
        if Layer.player[0].children[1].active then
            Layer.player[0].children[1].active = false
            Layer.player[0].children[2].active = true
        else 
            Layer.player[0].children[1].active = true
            Layer.player[0].children[2].active = false
        end
    end
end

function Player:deactivateAllWeapons() 
    for i = 1, #Layer.player[0].children do
        Layer.player[0].children[i].active = false
    end
end
