import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local rootLength = 0 

-- Root drawing variables
local moveSpeed = 1
local rootThickness = 2 -- Even number pls
local rootY = 0
local rootX = 0

local playTimer = nil
local playTime = 30*1000 --30secs in milisec
local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

function initialize()
	local seedImage = gfx.image.new("images/seed")
	local seedSprite = gfx.sprite.new(seedImage)
	seedSprite:moveTo(200,32)
	seedSprite:add()
	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function (x,y,width,height)
			gfx.setClipRect(x,y,width,height)
			backgroundImage:draw(0,0)
			gfx.clearClipRect()
		end
	)
	gfx.sprite.update() --tells system to update every sprite on the draw list
	resetTimer()
end

initialize()

--runs 30fps, can be somehow changed
function playdate.update()
	-- Sprite manipulation runs before sprite update
	playdate.timer.updateTimers() --always update all timers at the end of update loop, even if you dont use timer related variables
	
	
	-- Any drawing runs after sprite update

	-- A button press
	if playdate.buttonJustPressed(playdate.kButtonA) then
		
	end

	-- B button press
	if playdate.buttonJustPressed(playdate.kButtonB) then
		
	end
	
	--D-PAD button press
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		drawRoot(0,-1)
	end
	if playdate.buttonIsPressed(playdate.kButtonRight) then
		drawRoot(1,0)
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) then
		drawRoot(0,1)
	end
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		drawRoot(-1,0)
	end
	-- Snake control


	--UI elements
	gfx.drawText("Root Length: " .. rootLength, 10, 10)
end


-- x can be -1 (left), 0 (center) and 1 (right)
function drawRoot(x,y)
	gfx.fillRect((200 - rootThickness/2) + (rootThickness*rootX),48 - rootThickness/2 + (rootThickness*rootY),rootThickness, rootThickness)
	rootY += y
	rootX += x
end
