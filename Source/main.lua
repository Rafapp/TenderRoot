import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local playTimer = nil
local playTime = 30*1000 --30secs in milisec
local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

function initialize()
<<<<<<< HEAD
	gfx.drawPixel(0,0)
=======


	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function (x,y,width,height)
			gfx.setClipRect(x,y,width,height)
			backgroundImage:draw(0,0)
			gfx.clearClipRect()
		end
	)
>>>>>>> 7c8d164001e5c77835e0d9f9e66a126c87996f05
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
end