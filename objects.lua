Snail = {}
Snail.new = function (x,y)
	return Enemy:new(x, y, 54, 30, 60, 'snail', 'walk', {Enemy.dieOnPlayerCollision})
end
