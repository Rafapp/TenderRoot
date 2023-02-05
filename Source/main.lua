import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

PoolLocs = {}
RockLocs = {}
BattLocs = {}

GlobalObjLocs = {}

-- Rock dimensions
local rockWidth = 0
local rockHeight = 0

-- Pool dimensions
local poolWidth = 0
local poolHeight = 0

-- Root drawing variables
local moveSpeed = 1
local rootThickness = 2 -- Even number pls
local rootY = 0
local rootX = 0
local branchSize = 10 -- Even number pls
local branchNumber = 0
local branchLocs = {}
local branchLocsLocalScale = {}

local original_draw_mode = gfx.getImageDrawMode()
local color = gfx.getColor()
local rootLength = 1000
local rootBranches = 1
local waterTablePosY = 0

local playTimer = nil
local playTime = 30 * 1000 --30secs in milisec
local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

-- Place rock at x, y
local poolCount = 0
function PoolGen(x, y)
	tempPool = {x = x, y = y, isUsed = false}
	drawPool(tempPool.x, tempPool.y)
	PoolLocs[poolCount] = tempPool
	poolCount += 1
end

-- ROCK GEN: Place rock at x, y
local rockCount = 0
function RockGen(x,y)
	tempRock = {x = x, y = y}
	drawRock(tempRock.x, tempRock.y)
	RockLocs[rockCount] = tempRock
	rockCount += 1
end

function drawPool(x,y)
	local poolImage = gfx.image.new("images/water_pocket")
	local poolSprite = gfx.sprite.new(poolImage)
	poolSprite:moveTo(x,y)
	poolSprite:add()

	if poolWidth == 0 then
		poolWidth = poolSprite.width
	end
	if poolHeight == 0 then
		poolHeight = poolSprite.height
	end
end

function drawRock(x,y)
	local rockImage = gfx.image.new("images/rock_small")
	local rockSprite = gfx.sprite.new(rockImage)
	rockSprite:moveTo(x,y)
	rockSprite:add()
	
	if rockWidth == 0 then
		rockWidth = rockSprite.width
		print(rockWidth)
	end
	if rockHeight == 0 then
		rockHeight = rockSprite.height
		print(rockHeight)
	end
end

function initialize()
	PoolGen(200,80)
	PoolGen(200,100)
	RockGen(250,80)
	RockGen(300,120)

	local seedImage = gfx.image.new("images/seed")
	local seedSprite = gfx.sprite.new(seedImage)
	seedSprite:moveTo(200,32)
	seedSprite:add()

	local backgroundImage = gfx.image.new("images/background")
	gfx.sprite.setBackgroundDrawingCallback(
		function(x, y, width, height)
			gfx.setClipRect(x, y, width, height)
			backgroundImage:draw(0, 0)
			gfx.clearClipRect()
		end
	)

	local waterTableImg = gfx.image.new("images/water_table")
	local waterTableSpr = gfx.sprite.new(waterTableImg)
	waterTableSpr:moveTo(200,120)
	waterTableSpr:add()
	waterTablePosY = 220

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
		drawBranch()
	end

	-- B button press
	if playdate.buttonJustPressed(playdate.kButtonB) then
		if(branchNumber > 0) then
			alternateBranch()
		end
	end

	--D-PAD button press
	if playdate.buttonIsPressed(playdate.kButtonUp) and (rootY > 0) and (rootY <= 97) then
		drawRoot(0,-1)
	end
	if playdate.buttonIsPressed(playdate.kButtonRight) and (rootX < 100) and (rootX >= -100) then
		drawRoot(1,0)
	end
	if playdate.buttonIsPressed(playdate.kButtonDown) and (rootY >= 0) and (rootY < 97)  then
		drawRoot(0,1)
	end
	if playdate.buttonIsPressed(playdate.kButtonLeft) and (rootX <= 100) and (rootX > -100) then
		drawRoot(-1,0)
	end
	-- Snake control
	--print ("rootX: " ..rootX)
	--print ("rootY: " ..rootY)
	drawUI()
	--drawPool()
end


-- x can be -1 (left), 0 (center) and 1 (right)
-- FIX ME: CHECK ROCK COLLISSIONS HERE!
function drawRoot(x, y)
	--print(rootX, rootY)
	if CheckRockCollision((200 - rootThickness/2) + (rootThickness*(rootX+x)), 48 - rootThickness/2 + (rootThickness*(rootY+y))) then
		return
	end

	if(rootLength > 0) then
		gfx.setColor(gfx.kColorBlack)
		gfx.fillRect((200 - rootThickness/2) + (rootThickness*rootX), 48 - rootThickness/2 + (rootThickness*rootY), rootThickness, rootThickness)
		--print((200 - rootThickness/2) + (rootThickness*rootX), 48 - rootThickness/2 + (rootThickness*rootY))
		CheckPoolCollision((200 - rootThickness/2) + (rootThickness*(rootX+x)), 48 - rootThickness/2 + (rootThickness*(rootY+y)))
		rootX += x
		rootY += y
		rootLength -= 1
	end
	WaterTableCollision(48 - rootThickness/2 + (rootThickness*rootY))
end

function drawBranch()
	if rootBranches > 0 then
		drawX = (200 - branchSize/2) + (rootThickness*rootX)
		drawY = (48 - branchSize/2) + (rootThickness*rootY)

		gfx.drawRect(drawX,drawY,branchSize, branchSize)

		branchLocs[branchNumber] = {}
		branchLocs[branchNumber][drawX] = drawY

		branchLocsLocalScale[branchNumber] = {}
		branchLocsLocalScale[branchNumber][rootX] = rootY

		branchNumber += 1;
		rootBranches -= 1
	end
end

local buttonPressCount = 0 -- Number of times B is pressed.
function alternateBranch()
	-- Mod loop through branches
	local branchSelected = buttonPressCount % branchNumber
	buttonPressCount += 1

	-- Get local X and Y coordinates of current branch
	local tempX = 0
	local tempY = 0
	for k, v in pairs(branchLocsLocalScale) do
		for x, y in pairs(v) do
			if(k == branchSelected) then
				tempX = x
				tempY = y
			end
		end
	end

	-- Visually loop through branches
	for k, v in pairs(branchLocs) do
        for x, y in pairs(v) do
			if(k == branchSelected) then
				gfx.fillRect(x+1,y+1,branchSize-2,branchSize-2)
				rootX = tempX
				rootY = tempY
			else
				gfx.setColor(gfx.kColorWhite)
                gfx.fillRect(x+1,y+1,branchSize-2,branchSize-2)
                gfx.setColor(gfx.kColorBlack)
			end
		end
	end
end

function updateRootLength(num)
	rootLength = num
end

function drawUI()
	gfx.fillRect(10,0,140,20)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Root Length: " .. rootLength, 20, 0)
	gfx.setImageDrawMode(original_draw_mode)

	gfx.fillRect(280,0,130,20)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Branches: " .. rootBranches, 290, 0)
	gfx.setImageDrawMode(original_draw_mode)
end

-- this f(x) will return a boolean value for whether the position collides with a rock location or not
function CheckRockCollision(x, y)
	--print(x,y)
	for k, v in pairs(RockLocs) do
		local rockX = v.x
		local rockY = v.y
		
		local lowX = rockX - rockWidth/2
		local highX = rockX + rockWidth/2
		
		--Y low and high range
		local lowY = rockY - rockHeight/2
		local highY = rockY + rockHeight/2

		if (x > lowX and x < highX) and (y > lowY and y < highY) then
			--will be inside rock
			print("colliding")
			return true
		end
	end

	return false
end


function CheckPoolCollision(x, y)
	for k, v in pairs(PoolLocs) do
		local poolX = v.x
		local poolY = v.y

		--X low and high range
		local lowX = poolX - poolWidth/2
		local highX = poolX + poolWidth/2
		
		--Y low and high range
		local lowY = poolY - poolHeight/2
		local highY = poolY + poolHeight/2

		if (x > lowX and x < highX) and (y > lowY and y < highY) and not (v.isUsed) then
			rootLength += 20
			rootBranches += 1
			v.isUsed = true
		end
	end
end

function WaterTableCollision(y)
	if y >= waterTablePosY then
		--print("win")
		gfx.fillRect(0,115,400,30)
		gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		gfx.drawTextAligned("Win!", 200, 120, kTextAlignment.center)
		gfx.setImageDrawMode(original_draw_mode)

		-- gfx.fillRect(0,150,400,30)
		-- gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
		-- gfx.drawTextAligned("Press A button to Restart", 200, 155, kTextAlignment.center)
		-- gfx.setImageDrawMode(original_draw_mode)

		playdate.stop()
	end
end

--not in use
function ResetVariables()
	rootLength = 24
	rootBranches = 1
	initialize()

	rootX = 0
	rootY = 0
	branchLocs = {}
	branchLocsLocalScale = {}

	PoolLocs = {};
	RockLocs = {};
	BattLocs = {};
	GlobalObjLocs = {};
end
