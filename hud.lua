HUD = {
['lives'] = 5,
['full'] = 5,
['half'] = 0,
['coins'] = 0,
['offsetX'] = 20,
['offsetY'] = 20,
['dist1'] = 20,
['dist2'] = 4,
}


HUD.update = function(self)
	self.coins = PLAYER.coins
	self.half = PLAYER.hp < PLAYER.startHp/2 and 1 or 0
	self.full = PLAYER.lives - self.half
	self.empty = 5 - self.full - self.half
end

HUD.draw = function(self)
	local x, y  = self.offsetX, self.offsetY
	local _,_,w,h = (Images['hud']['coins']):getViewport()
  	love.graphics.draw(Images['hud']["sprite"],Images['hud']['coins'],x, y, 0, 1/2)
  	x = x + w/2 + self.dist2
  	local t = self:getDigits()
  	for i = #t,1,-1 do
  		_,_,w,h = (Images['hud'][t[i]]):getViewport()
  		love.graphics.draw(Images['hud']["sprite"],Images['hud'][t[i]],x, y, 0, 1/2)
  		x = x + w/2 + self.dist2
  	end
  	x = x - self.dist2 + self.dist1
  	_,_,w,h = (Images['hud']['heartFull']):getViewport()
  	for i = 1,self.full do
  		love.graphics.draw(Images['hud']['sprite'],Images['hud']['heartFull'],x, y, 0, 1/2)
  		x = x + w/2 + self.dist2
  	end
  	if self.half > 0 then
  		love.graphics.draw(Images['hud']['sprite'],Images['hud']['heartHalf'],x, y, 0, 1/2)
  		x = x + w/2 + self.dist2
  	end
  	for i = 1,self.empty do
  		love.graphics.draw(Images['hud']['sprite'],Images['hud']['heartEmpty'],x, y, 0, 1/2)
  		x = x + w/2 + self.dist2
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
