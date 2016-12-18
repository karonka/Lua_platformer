Enemy = {}
-- Constructor
function Enemy:new( xc, yc, w, h, in_speed, enemyTp, st)
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
    enemyType = enemyTp,
    state = st,
    collider = Collider:new(xc, yc, w, h, 0.7, 0.9),
  }
  setmetatable(object, { __index = Enemy })
  return object
end

function Enemy:draw()
end

function Enemy:update(dt)
	--move()
	--checkCollisions()
 	--updateChilds() -- childs = weapons
end
