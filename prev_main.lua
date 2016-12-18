--[[g = love.graphics
key = love.keyboard

local max_speed_x = 400
local speed_y = 0
local gravity = 900
--local max_speed_y
--local speed = 0
--local acc 
local jump_speed = 600
local dir = 0
local x = 0
local y = 500
local jumping = false

function love.load()
	g.setColor(0,0,0,255)
	g.setBackgroundColor(153,204,255)
end

function love.keyreleased(k)
	if k == "escape" then
		love.event.quit()
	end
	if k == "left" or k == "right" then
		if not (key.isDown("left") or key.isDown("right")) then 
			--speed = 0
			dir = 0
		end
	end
end

function love.update(dt)
	if key.isDown("right") then
		--speed = math.min(acc*dt + speed, max_speed)
		dir = 1
	end
	if key.isDown("left") then
		--speed = math.min(acc*dt + speed, max_speed)
		dir = -1
	end
	
	if key.isDown("up") then
		if not jumping then
			speed_y = jump_speed
			jumping = true
		end
	end
	
	x = x + dir*(max_speed_x*dt) -- - (1/2)*acc*dt*dt)
	if  x > win_width - 40 then
		x = win_width - 40
	end
	if  x < 0 then
		x = 0
	end
	
	y = y - speed_y*dt
	speed_y = speed_y - gravity*dt

	if y >= 500 then
		y = 500
		jumping = false
		speed_y = 0
	end
end



function love.draw()
	g.rectangle("fill",x,y,40,70)
end
]]
