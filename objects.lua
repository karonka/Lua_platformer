Snail = {}
Fly = {}
Bomb = {}
Spider = {}
Coin = {}
Spikes = {}
Barnacle = {}

Snail.new = function (x,y)
	return Enemy:new(x, y, 54, 30, 60, 'snail', 'walk', 1/2, 100, nil, takeNoDamage, {normalMovement, damagePlayer(0), dieOnPlayerCollision, restore(3.2, 'state', 'dead', {['state'] = 'walk', ['velocityX'] = 60,['direction']= -1, ['hp'] = 100})})
end
Fly.new = function (x,y,dist)
	return Enemy:new(x, y, 72, 33, 50, 'fly', 'fly', 1/4, 25, nil, takeDamage, {flyBetweenPoints(dist,x), damagePlayer(100)})
end
Spider.new = function (x,y)
	return Enemy:new(x, y, 70, 45, 70, 'spider', 'walk', 1/6, 200, nil, takeDamage, {normalMovement, damagePlayer(300), restore(20, 'state', 'dead', {['state'] = 'walk', ['velocityX'] = 70,['direction']= -1, ['hp'] = 200})})
end
Barnacle.new = function(x, y)
	return Enemy:new(x, y, 51, 55, 0, 'barnacle', 'normal', 1/4, 100, nil, takeDamage, {normalMovement, damagePlayer(500), restore(10, 'state', 'dead', {['state'] = 'normal', ['velocityX'] = 0,['direction']= -1, ['hp'] = 100})})
end

Bomb.new = function(x, y)
	return Item:new( x, y, 30, 30, 'bomb', 'normal', nil, {collect, onPlayerInteraction(function (self)
																							for k, v in pairs(Layer.enemies) do
																								v:getHit(30) -- 30 damage
																							end
																							self.isVisible = false
																							end)})
end

Coin.new = function(x, y)
	return Item:new(x, y, 20, 20, 'coin', 'gold', nil, {function (self)
														if self.isVisible and checkPlayerCollision(self) then
															PLAYER.coins = PLAYER.coins + 1 
															self.isVisible = false
														end
													end})
end

Spikes.new = function(x,y)
	return Item:new(x, y, 70, 70, 'spikes', 'normal', Collider:new(x, y + 17, 70, 35, 0.7, 0.7), {damagePlayer(1000)})
end
