HUD = {
	['full'] = 5,
	['half'] = 0,
	['coins'] = 0,
	['offsetX'] = 20,
	['offsetY'] = 20,
	['dist1'] = 20,
	['dist2'] = 4,
	['scale'] = SCREEN_WIDTH/2500,
}

HUD['font'] = love.graphics.newFont( 12 )
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
	local x,y = 400,20
	local size = SCREEN_WIDTH/24
	local scale = 1
	for i = 1,2 do
		local weapon = PLAYER.children[i]
		if weapon.active then
			love.graphics.setColor(153,0,102)
			love.graphics.rectangle( 'line', x, y, size, size, 3, 3)
		else
			love.graphics.rectangle( 'line', x, y, size, size, 3, 3)
			love.graphics.print( {{0,0,0,120},'q'}, x + 0.8*size, y + 0.8*size)
		end
		love.graphics.setColor(255,255,255,255)
		local quad = Images[weapon.weaponType][weapon.state][1] or Images[weapon.weaponType][weapon.state]-- or Images[item.itemType]['normal']
		_,_,w,h = quad:getViewport()
		scale = size*0.8/(w > h and w or h)
		love.graphics.draw(Images[weapon.weaponType]["sprite"], quad, x + 3 + size/2 - w*scale/2, y + 3 + size/2 - h*scale/2, 0, scale)
		x = x + size + 3
	end
	x = x + size/3
	for i = 1,9 do
		love.graphics.rectangle( 'line', x, y, size, size, 3, 3)
		love.graphics.print( {{0,0,0,120},tostring(i)}, x + 0.8*size, y + 0.8*size)
		if PLAYER.inventory[i] then
			local item = PLAYER.inventory[i]
			local quad = Images[item.itemType][item.state][1] or Images[item.itemType][item.state]-- or Images[item.itemType]['normal']
			_,_,w,h = quad:getViewport()
			scale = size*0.8/(w > h and w or h)
			love.graphics.draw(Images[item.itemType]["sprite"], quad, x + 3, y + 3, 0, scale)
		end
		x = x + size + 3
	end
end


