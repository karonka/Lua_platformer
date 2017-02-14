HUD = {
	['full'] = 5,
	['half'] = 0,
	['coins'] = 0,
	['offsetX'] = 20,
	['offsetY'] = 20,
	['dist1'] = 20,
	['dist2'] = 4,
	['scale'] = SCREEN_WIDTH/2500
}

--HUD['font'] = love.graphics.newFont( size )
HUD.update = function(self)
	self.coins = PLAYER.coins
	
	self.half = PLAYER.hp%1000 <= 500 and PLAYER.hp%1000 > 0 and 1 or 0
	self.full = math.floor((PLAYER.hp+999)/1000) - self.half
	self.empty = 5 - self.full - self.half
end

HUD.draw = function(self)
	local x, y  = self.offsetX, self.offsetY
	local _,_,w,h = (Images['hud']['coins']):getViewport()
  	love.graphics.draw(Images['hud']["sprite"],Images['hud']['coins'],x, y, 0, self.scale)
  	x = x + w*self.scale + self.dist2
  	local t = self:getDigits()
  	for i = #t,1,-1 do
  		_,_,w,h = (Images['hud'][t[i]]):getViewport()
  		love.graphics.draw(Images['hud']["sprite"],Images['hud'][t[i]],x, y, 0, self.scale)
  		x = x + w*self.scale + self.dist2
  	end
  	x = x - self.dist2 + self.dist1
  	_,_,w,h = (Images['hud']['heartFull']):getViewport()
  	for i = 1,self.full do
  		love.graphics.draw(Images['hud']['sprite'],Images['hud']['heartFull'],x, y, 0, self.scale)
  		x = x + w*self.scale + self.dist2
  	end
  	if self.half > 0 then
  		love.graphics.draw(Images['hud']['sprite'],Images['hud']['heartHalf'],x, y, 0, self.scale)
  		x = x + w*self.scale + self.dist2
  	end
  	for i = 1,self.empty do
  		love.graphics.draw(Images['hud']['sprite'],Images['hud']['heartEmpty'],x, y, 0, self.scale)
  		x = x + w*self.scale + self.dist2
  	end
end

HUD.getDigits = function(self)
	local n = self.coins
	--print(n)
	if n < 1 then 
		return {'0'}
	end
	local t = {}
	while n > 0 do
		t[#t+1] = tostring(n%10)
		n = math.floor(n/10)		
	end
	return t
end

function drawGameOverScreen()
	local w,h = (Images["menu"]["gameover"]):getDimensions()
	love.graphics.draw(Images["menu"]["gameover"],0,0,0,SCREEN_WIDTH/w, SCREEN_HEIGHT/h)
end

function drawInventory()
	local x,y = 500,20
	for i = 1,9 do
		love.graphics.rectangle( 'line', x, y, 50, 50, 5, 5)
		love.graphics.print( tostring(i), x + 40, y + 37)
		if PLAYER.inventory[i] then
		
		end
	--	_,_,w,h = quad:getViewport()
		--love.graphics.draw(sprite, quad, x, y, 0, self.scale)
		x = x + 53
	end
	
end


