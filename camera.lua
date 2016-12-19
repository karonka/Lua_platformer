Camera = {
  target = nil,
  tX = 0,
  tY = 0
}

function Camera.update(dt)
  Camera.tX = lerp(Camera.tX,SCREEN_WIDTH/2 - Camera.target.x,math.min(1, 3*dt)) 
  Camera.tY = lerp(Camera.tY,SCREEN_HEIGHT/2  - Camera.target.y,math.min(1, 3*dt))
  Camera.tX = clamp(-WORLD_WIDTH + SCREEN_WIDTH, Camera.tX, 0)
  Camera.tY = clamp(-WORLD_HEIGHT + SCREEN_HEIGHT, Camera.tY, 0)
  Camera.tX = math.floor(Camera.tX)
  Camera.tY = math.floor(Camera.tY)
  love.graphics.translate(Camera.tX,Camera.tY)
end
