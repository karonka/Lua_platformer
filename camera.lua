Camera = {
  target = nil,
  tX = 0,
  tY = 0,
  scaleX = SCREEN_WIDTH /(1920 * PERCENT_OF_SCREEN_FILLED),
  scaleY = SCREEN_HEIGHT / (1080 * PERCENT_OF_SCREEN_FILLED) 
}


function Camera:setTarget(_target)
   self.target = _target
   self.tX = _target.x - SCREEN_WIDTH/2 * self.scaleX
   self.tY = _target.y - SCREEN_HEIGHT/2 * self.scaleY
end

function Camera.update(dt)
    Camera.tX = lerp(Camera.tX,SCREEN_WIDTH/2 - Camera.target.x * Camera.scaleX, math.min(1, 3*dt)) 
    Camera.tY = lerp(Camera.tY,SCREEN_HEIGHT/2 - Camera.target.y * Camera.scaleY, math.min(1, 3*dt))
    Camera.tX = clamp(-WORLD_WIDTH * Camera.scaleX + SCREEN_WIDTH, Camera.tX, 0)
    Camera.tY = clamp(-WORLD_HEIGHT * Camera.scaleY + SCREEN_HEIGHT, Camera.tY, 0)
    Camera.tX = math.floor(Camera.tX)
    Camera.tY = math.floor(Camera.tY)
    print(Camera.target.x)
    love.graphics.translate(Camera.tX,Camera.tY)
end
