Projectile = {}
-- Constructor
function Projectile:new( xc, yc, w, h, in_speed, dir, tp, st, aimX, aimY)
  -- define our parameters here
  local object = {
    x = xc,
    y = yc,
    speed = in_speed,
    width = w,
    height = h,
    frame = 1,
    timePassed = 0,
    timePerFrame = 1/18,
    direction = dir,
    projectileType = tp,
    state = st,
    collider = Collider:new(xc, yc, w, h, 0.7, 0.9),
  }
  setmetatable(object, { __index = Projectile })
  return object
end

function Projectile:draw()
end

function Projectile:update(dt)
	--move()
end
