Projectile = {}
-- Constructor
function Projectile:new( xc, yc, w, h, speed, dir, tp, st, funcs)
  -- define our parameters here
  local object = {
    x = xc,
    y = yc,
    velocityX = speed,
    width = w,
    height = h,
    frame = 1,
    timePassed = 0,
    timePerFrame = 1/18,
    direction = dir,
    projectileType = tp,
    state = st,
    collider = Collider:new(xc, yc, w, h, 0.9, 0.9),
    behaviors = funcs,
--  update/ move logic = nil,
  }
  setmetatable(object, { __index = Projectile })
  return object
end

function Projectile:draw()
end

function Projectile:update(dt)
	for k,v in ipairs(self.behaviors) do
		v(self)
	end
end
