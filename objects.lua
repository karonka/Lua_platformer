Snail = {}
Fly = {}

Snail.new = function (x,y)
	return Enemy:new(x, y, 54, 30, 60, 'snail', 'walk', {normalMovement,dieOnPlayerCollision})
end
Fly.new = function (x,y,dist)
	return Enemy:new(x, y, 54, 30, 60, 'snail', 'walk', {flyBetweenPoints(dist,x)})
end

