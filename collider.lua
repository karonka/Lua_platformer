Collider = {}

-- Constructor

function Collider:new(objX, objY, objW, objH, scaleW, scaleH)
  -- define our parameters here
  scaleW = scaleW or 1
  scaleH = scaleH or 1
  local o = {
    x1 = objX - objW*scaleW/2,
    x2 = objX + objW*scaleW/2,
    y1 = objY - objH*scaleH/2,
    y2 = objY + objH*scaleH/2,
    w = objW * scaleW,
    h = objH * scaleH,
  } 
  setmetatable(o, { __index = Collider })  
  return o
end

function Collider:checkCollisionBasic(o)
    if(self.x1 < o.x2 and self.x2 > o.x1  and self.y1 < o.y2 and self.y2 > o.y1) then
        return true
    end
    return false
end

function Collider:checkCollision(o, dx, dy)
    dx = dx or 0
    dy = dy or 0
	--print(self.x1.." "..self.x2.." "..self.y1.." "..self.y2 )
    local both, x, y, distX, distY = false, false, false, 0, 0
	if(self.x1 < o.x2 and self.x2 > o.x1  and self.y1 < o.y2 and self.y2 > o.y1) then
        both = true
        
        if(self.x1 < o.x2 and self.x2 > o.x1  and self.y1-dy < o.y2 and self.y2-dy > o.y1) then
          x = true  
          if(self.x1 - dx < o.x1) then
            distX = self.x2 - o.x1
          else
            distX = self.x1 - o.x2
          end
        end
        
        if(self.x1-dx < o.x2 and self.x2-dx > o.x1  and self.y1 < o.y2 and self.y2 > o.y1) then
          y = true
          if(self.y1 - dy < o.y1) then
            distY = self.y2 - o.y1
          else
            distY = self.y1 - o.y2
          end
        end
        
        if(not x and not y) then
          if(self.y1 - dy < o.y1) then
            distY = self.y2 - o.y1
          else
            distY = self.y1 - o.y2
          end
        end
    end  
  return both, x, y, distX, distY
end

function Collider:update(dx,dy)
	self.x1 = self.x1 + dx
	self.x2 = self.x2 + dx
	self.y1 = self.y1 + dy
	self.y2 = self.y2 + dy
end
