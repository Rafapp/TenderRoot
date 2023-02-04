import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

function initialize()

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