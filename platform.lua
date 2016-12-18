Platform = {}

-- Constructor

function Platform:new(xc, yc, w , h, k, s)
  -- define our parameters here
  local o = {
    x = xc,
    y = yc,
   	width = w,
   	height = h,
   	kind = k,
   	state = s,
    collider = Collider:new(xc, yc, w, h),
    children = {},
  }
  setmetatable(o, { __index = Platform })
  return o
end

function Platform:draw()
  love.graphics.draw(Images[self.kind]["sprite"],Images[self.kind][self.state], self.x - self.width/2, self.y - self.height/2)
end

function Platform:update(dt)
  
end
