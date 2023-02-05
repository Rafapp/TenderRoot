import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics
local original_draw_mode = gfx.getImageDrawMode()
local rootLength = 10

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
	resetTimer()
end

initialize()

--runs 30fps, can be somehow changed
function playdate.update()
	-- A button press
	if playdate.buttonJustPressed(playdate.kButtonA) then
		
	end

	-- B button press
	if playdate.buttonJustPressed(playdate.kButtonB) then
		
	end
	
	--D-PAD button press
	if playdate.buttonIsPressed(playdate.kButtonUp) then
		
	end
	if playdate.buttonIsPressed(playdate.kButtonRight) then
		
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) then
		
	end
	if playdate.buttonIsPressed(playdate.kButtonLeft) then
		
	end

	playdate.timer.updateTimers() --always update all timers at the end of update loop, even if you dont use timer related variables
	gfx.sprite.update() --tells system to update every sprite on the draw list

	--UI elements
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Root Length: " .. rootLength, 10, 0)
	gfx.setImageDrawMode(original_draw_mode)
end