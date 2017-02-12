Snail = {}
Fly = {}

Snail.new = function (x,y)
	return Enemy:new(x, y, 54, 30, 60, 'snail', 'walk', 1/2, 100, takeDamage, {normalMovement, dieOnPlayerCollision, restore(3.2, 'state', 'dead', {['state'] = 'walk', ['velocityX'] = 60,['direction']= -1})})
end
Fly.new = function (x,y,dist)
	return Enemy:new(x, y, 72, 33, 50, 'fly', 'fly', 1/4, 100, takeDamage, {flyBetweenPoints(dist,x),dieOnPlayerCollision, })
end

