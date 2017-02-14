SCREEN_WIDTH, SCREEN_HEIGHT = love.window.getDesktopDimensions()
PERCENT_OF_SCREEN_FILLED = 0.85
SCREEN_HEIGHT = SCREEN_HEIGHT * PERCENT_OF_SCREEN_FILLED 
SCREEN_WIDTH = SCREEN_WIDTH * PERCENT_OF_SCREEN_FILLED 
love.window.setMode( SCREEN_WIDTH, SCREEN_HEIGHT , {fullscreen = false, borderless = false})

TILE_WIDTH = 70
TILE_HEIGHT = 70
TILE_COUNT_X = 80
TILE_COUNT_Y = 80

MENU = false
GAME_OVER = false
PLAYER = nil

WORLD_WIDTH = TILE_WIDTH*TILE_COUNT_X
WORLD_HEIGHT = TILE_HEIGHT*TILE_COUNT_Y

function lerp(a,b,t) 
    return a+(b-a)*t 
end

function clamp(min, val, max)
    return math.max(min, math.min(val, max));
end
