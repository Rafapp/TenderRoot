import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
--will need to look into additional imports for using Crank library

local gfx <const> = playdate.graphics
local playerSprite = nil --null
local playerSpeed = 4

local coinSprite = nil
local score = 0

local playTimer = nil
local playTime = 30*1000 --30secs in milisec

local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

function moveCoin()
	local randX = math.random(40,360)
	local randY = math.random(40,200)
	coinSprite:moveTo(randX, randY)
end

function initialize()
	math.randomseed(playdate.getSecondsSinceEpoch()) --seeds the random function
	local playerImage = gfx.image.new("images/player")
	playerSprite = gfx.sprite.new(playerImage)
	playerSprite:moveTo(200,120) --centers the playerSprite
	--playdate screen resoultion size is 400x240px, with 0,0 being in the top left corner
	playerSprite:setCollideRect(0, 0, playerSprite:getSize()) --will use the size of the sprite for collider at 0,0 
	--use built in collision detection
	playerSprite:add() --adds to display list, so the system knows to draw it

	local coinImage = gfx.image.new("images/coin")
	coinSprite = gfx.sprite.new(coinImage)
	moveCoin()
	coinSprite:setCollideRect(0,0,coinSprite:getSize())
	coinSprite:add()

	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function (x,y,width,height)
			gfx.setClipRect(x,y,width,height)
			--will add to draw list, scale it to screen size, and sets it to lowest z-index
			backgroundImage:draw(0,0)
			gfx.clearClipRect() --remember to clear after drawing image
		end
	)

	resetTimer()
end

initialize()

--runs 30fps, can be somehow changed
function playdate.update()
	if playTimer.value == 0 then
		if playdate.buttonJustPressed(playdate.kButtonA) then
			resetTimer()
			moveCoin()
			score = 0
		end
	else
		if playdate.buttonIsPressed(playdate.kButtonUp) then
			playerSprite:moveBy(0, -playerSpeed) --move up
		end
		if playdate.buttonIsPressed(playdate.kButtonRight) then
			playerSprite:moveBy(playerSpeed, 0) --move right
		end
		if playdate.buttonIsPressed(playdate.kButtonDown) then
			playerSprite:moveBy(0, playerSpeed) --move down
		end
		if playdate.buttonIsPressed(playdate.kButtonLeft) then
			playerSprite:moveBy(-playerSpeed, 0) --move left
		end

		local collisions = coinSprite:overlappingSprites()
		if #collisions >= 1 then --if there is overlap, then the player must have touched it
			moveCoin() --if so then move the coin
			score += 1
		end
	end

	playdate.timer.updateTimers() --always update all timers at the end of update loop, even if you dont use timer related variables
	gfx.sprite.update() --tells system to update every sprite on the draw list

	gfx.drawText("Time: " .. math.ceil(playTimer.value/1000), 5, 5)
	gfx.drawText("Score: " .. score, 320, 5)
end