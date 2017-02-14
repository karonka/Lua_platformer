function mediaLoader()	-- ? to be read from file ?
  spriteParser('GameAssets/Sprites/Actors/p3_spritesheet.txt','GameAssets/Sprites/Actors/p3_spritesheet.png')
  spriteParser('GameAssets/Sprites/Tiles/tiles_spritesheet.xml','GameAssets/Sprites/Tiles/tiles_spritesheet.png')
  spriteParser('GameAssets/Sprites/Tiles/items_spritesheet.xml','GameAssets/Sprites/Tiles/items_spritesheet.png')
  spriteParser('GameAssets/Sprites/Actors/enemies_spritesheet.txt','GameAssets/Sprites/Actors/enemies_spritesheet.png')
  spriteParser('GameAssets/Sprites/Actors/enemies.xml','GameAssets/Sprites/Actors/enemies.png')
  spriteParser('GameAssets/Sprites/Tiles/sheet.txt','GameAssets/Sprites/Tiles/sheet.png')
  spriteParser('GameAssets/Sprites/HUD/hud_spritesheet.xml','GameAssets/Sprites/HUD/hud_spritesheet.png')
  bgsLoader("normal", "GameAssets/Sprites/Backgrounds/bg_grasslands.png")
  menuLoader("gameover", "GameAssets/Sprites/HUD/gameover.png")
end


function spriteParser(file, sprite)
	if (string.match(file,"%w+.txt")) then
		txtParser(file, sprite)
	end
	if (string.match(file,"%w+.xml")) then
		xmlParser(file, sprite)
	end
	
end

function txtParser(file, sprite)
	local img = love.graphics.newImage(sprite)
	
	local fileLines = {}
	for line in love.filesystem.lines(file) do
	  fileLines[#fileLines+1] = line
	end
	local currLine = 1
	
	local pattern = "(%a+)%s+(%a+)%s+(%d+)%s*"
	local pattern2 = "%w+%s+=%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s*"
	
	local obj, state, count
	while currLine <= #fileLines do
    	local t = fileLines[currLine]
    	obj,state,count = string.match(t,pattern)
    	if count then
    		for i = 1,count do
    			currLine = currLine + 1
    			local k = fileLines[currLine]
				local x,y,w,h = string.match(k,pattern2)
				quadsLoader(obj, state, img, x, y, w, h)
			end
    	end
    	currLine = currLine+1
    end
end

function xmlParser(file, sprite)
	local img = love.graphics.newImage(sprite)
	
	local fileLines = {}
	for line in love.filesystem.lines(file) do
	  fileLines[#fileLines+1] = line
	end
	local pattern = "%s*<SubTexture name=\"(%a+%d*)%p(%a*)(%d*)%.png\" x=\"(%d+)\" y=\"(%d+)\" width=\"(%d+)\" height=\"(%d+)\"/>%s*"
	local obj, state, state2, x, y, w, h
	for i = 1,#fileLines do
    	local t = fileLines[i]
    	obj, state, state2, x, y, w, h = string.match(t,pattern)
    	if h then
			quadsLoader(obj, state ~= "" and state or state2, img, x, y, w, h)
    	end
    end
end


function quadsLoader(obj, state, img, x, y, w, h)
--	print(obj.."    "..state)
	if not Images then
		Images = {}
	end
	if not Images[obj] then
		Images[obj] = {}
	end
   	-- adding whole sprite to the object // for drawing
    Images[obj]["sprite"] = img
	
	if Images[obj][state] and type(Images[obj][state]) ~= "table" then 
		local im = Images[obj][state]
		Images[obj][state] = {}
		Images[obj][state][1] = im
		Images[obj][state][#Images[obj][state] + 1] = love.graphics.newQuad(x,y,w,h, img:getDimensions())
	elseif not Images[obj][state] then
		Images[obj][state] = love.graphics.newQuad(x,y,w,h, img:getDimensions())
	else
		Images[obj][state][#Images[obj][state] + 1] = love.graphics.newQuad(x,y,w,h, img:getDimensions())
	end
end

function bgsLoader(bg_state, file) --bg_state = {ice, forest, dungeon, space....}
	if not Images then
		Images = {}
	end
	if not Images["background"] then
		Images["background"] = {}
	end
		Images["background"][bg_state] = love.graphics.newImage(file)
end

function menuLoader(state, file)
	if not Images then
		Images = {}
	end
	if not Images["menu"] then
		Images["menu"] = {}
	end
		Images["menu"][state] = love.graphics.newImage(file)
end
