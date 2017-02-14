Snail = {}
Fly = {}
Bomb = {}
Spider = {}
Coin = {}

Snail.new = function (x,y)
	return Enemy:new(x, y, 54, 30, 60, 'snail', 'walk', 1/2, 100, takeNoDamage, {normalMovement, dieOnPlayerCollision, restore(3.2, 'state', 'dead', {['state'] = 'walk', ['velocityX'] = 60,['direction']= -1, ['hp'] = 100})})
end
Fly.new = function (x,y,dist)
	return Enemy:new(x, y, 72, 33, 50, 'fly', 'fly', 1/4, 25, takeDamage, {flyBetweenPoints(dist,x),dieOnPlayerCollision})
end
Spider.new = function (x,y)
	return Enemy:new(x, y, 70, 45, 70, 'spider', 'walk', 1/6, 200, takeDamage, {normalMovement, restore(3.2, 'state', 'dead', {['state'] = 'walk', ['velocityX'] = 70,['direction']= -1, ['hp'] = 200})})
end

Bomb.new = function(x, y)
	return Item:new( x, y, 30, 30, 'bomb', 'normal', {collect, onPlayerInteraction(function (self)
																							for k, v in pairs(Layer.enemies) do
																								v:getHit(30) -- 30 damage
																							end
																							self.isVisible = false
																							end)})
end

Coin.new = function(x, y)
	return Item:new(x, y, 20, 20, 'coin', 'gold', {function (self)
														if self.isVisible and checkPlayerCollision(self) then
															PLAYER.coins = PLAYER.coins + 1 
															print(PLAYER.coins)
															self.isVisible = false
														end
													end})
end
