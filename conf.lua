-- Configuration

function love.conf(t)
	t.title = "OrangePlazma" -- The title of the window the game is in (string)
	--t.version = "0.9.1"         -- The LÖVE version this game was made for (string)
  
	t.window.width = 1000
	t.window.height = t.window.width / 1.77
	-- For Windows debugging
	t.console = true
end
