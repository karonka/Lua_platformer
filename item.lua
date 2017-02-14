Item = {}
-- Constructor
function Item:new( xc, yc, w, h, _itemTp, _state, _collider, funcs)
  -- define our parameters here
  local object = {
    x = xc,
    y = yc,
    width = w,
    height = h,
    frame = 1,
    timePassed = 0,
    timePerFrame = timePerFr or 1/2,
    direction = 1,
    itemType = _itemTp,
    state = _state or 'normal',
    isActive = false,
    isVisible = true,
    collider = _collider or Collider:new(xc, yc, w, h, 0.9, 0.9),
    behaviors = funcs or {},
--  update/ move logic = nil,
  }
  setmetatable(object, { __index = Item })
  return object
end

function Item:draw()
	self.timePassed = self.timePassed + love.timer.getDelta()
	if self.timePassed > self.timePerFrame then  
		self.frame = self.frame + 1
		if type(Images[self.itemType][self.state]) == "table" and self.frame > #Images[self.itemType][self.state] then
			self.frame = self.frame - (#Images[self.itemType][self.state])
		elseif type(Images[self.itemType][self.state]) ~= "table" then
			self.frame = 1
		end
		self.timePassed = self.timePassed - self.timePerFrame
	end
	if not self.isVisible then return end
	--local drawState = 
	local _,_,w,h = (Images[self.itemType][self.state][self.frame] or Images[self.itemType][self.state]):getViewport()
  	love.graphics.draw(Images[self.itemType]["sprite"],Images[self.itemType][self.state][self.frame] or Images[self.itemType][self.state], 
  	self.x - (w/2)*self.direction, self.y - h/2, 0, self.direction , 1)
end
   
function Item:update(dt)
	if not self.isVisible then return end
	for k,v in pairs(self.behaviors) do
		v(self)
	end
end

function activate(self)
	self.isActive = true
	self.state = 'get'
end

function deactivate(self)
	self.isActive = false
	self.state = 'normal'
end

function hideOnPlayerEnter(self)
	if checkPlayerCollision(self) then
		self.isVisible = false
	end
end

function activateOnPlayerEnter(self)
	if checkPlayerCollision(self) then
		activate(self)
	end
end


function deactivateOnPlayerLeave(self)
	if not checkPlayerCollision(self) then
		deactivate(self)
	end
end

function activateSthOnPlayerEnter(somethingToSwitch)
	return function(self)
		if checkPlayerCollision(self) then
			activate(somethingToSwitch)
		end
	end
end

function killOnEnter(self) -- not only player

end

function collect(self)
	if checkPlayerCollision(self) and #PLAYER.inventory < 9 then
		PLAYER.inventory[#PLAYER.inventory + 1] = self
		self.isVisible = false
	end
end

function drop(self, i, x, y)
	--[[for i = 1,#PLAYER.inventory do
		--print(self.itemType)
		print(PLAYER.inventory[i])
	end]]
	local prevX, prevY = self.x, self.y
	self.isVisible = true
	self.x = clamp(0, x, WORLD_WIDTH)
	self.y = clamp(0, y, WORLD_HEIGHT)
	PLAYER.inventory[i] = PLAYER.inventory[#PLAYER.inventory]
	PLAYER.inventory[#PLAYER.inventory] = nil
	self.collider:update(self.x - prevX, self.y - prevY)
	self.inUse = true
end

function onPlayerInteraction(_func)
	return function(self)
		if self.inUse and love.keyboard.isDown("f") then
			_func(self)
			self.isActive = false
		end
	end
end











