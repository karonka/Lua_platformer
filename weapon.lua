Weapon = {}
-- Constructor
function Weapon:new( xc, yc, w, h, in_speed, tp, st)
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
    direction = 1,
    weaponType = tp,
    state = st,
    collider = Collider:new(xc, yc, w, h, 0.7, 0.9),
    children = {} -- children = projectiles
  }
  setmetatable(object, { __index = Weapon })
  return object
end

function Weapon:draw()
end

function Weapon:update(dt)
	--move()
 	--updateChilds() -- childs = projectiles
end
