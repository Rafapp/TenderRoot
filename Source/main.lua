import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

function initialize()

	resetTimer()
end

initialize()

--runs 30fps, can be somehow changed
function playdate.update()

	playdate.timer.updateTimers() --always update all timers at the end of update loop, even if you dont use timer related variables
	gfx.sprite.update() --tells system to update every sprite on the draw list
end