Snail = {}
Fly = {}
Bomb = {}
Spider = {}

Snail.new = function (x,y)
	return Enemy:new(x, y, 54, 30, 60, 'snail', 'walk', 1/2, 100, takeDamage, {normalMovement, dieOnPlayerCollision, restore(3.2, 'state', 'dead', {['state'] = 'walk', ['velocityX'] = 60,['direction']= -1, ['hp'] = 100})})
end
Fly.new = function (x,y,dist)
	return Enemy:new(x, y, 72, 33, 50, 'fly', 'fly', 1/4, 25, takeDamage, {flyBetweenPoints(dist,x),dieOnPlayerCollision})
end
Spider.new = function (x,y,dist)
	return Enemy:new(x, y, 70, 45, 70, 'spider', 'walk', 1/6, 200, takeDamage, {normalMovement, restore(3.2, 'state', 'dead', {['state'] = 'walk', ['velocityX'] = 70,['direction']= -1, ['hp'] = 200})})
end

Bomb.new = function(x, y)
	local bomb = Item:new( x, y, 30, 30, 'bomb', 'normal', {collect, onPlayerInteraction(useBomb)})
	bomb.damage = 30
	return bomb
end

