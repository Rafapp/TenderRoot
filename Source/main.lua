import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"

local gfx <const> = playdate.graphics

--[[ SHAHBAZ CODE BLOCK A STARTS--]]
-- The origin of the root; player start location
ROOT_ORIGIN_X = 200;
ROOT_ORIGIN_Y = 48;
-- The distance a player can travel (root fuel); steps a player can take to water
Player_Fuel = 10;

-- The radial distance a water resource can be from player origin
Pool_dist = 80;
-- number of waters
NumWaters = 3; -- a variable representing the number of pools of water to generate
-- number of stones
NumRocks = 2; -- a variable representing the number of stones to generate
-- number of batteries (BONUS)
NumBatteries = 0; -- a variable representing the number of batteries to generate

-- an array containing the locations of all the water pool objects
PoolLocs = {};
-- an array containing the locations of all the rock objects
RockLocs = {};
-- an array containing the locations of all the battery acid objects
BattLocs = {};
-- a table containing x-y pairs for each object already placed on screen
GlobalObjLocs = {};

--[[ SHAHBAZ CODE BLOCK A ENDS --]]

local poolWidth = 0
local poolHeight = 0;

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
local rootLength = 10
local rootBranches = 0

local playTimer = nil
local playTime = 30 * 1000 --30secs in milisec
local function resetTimer()
	playTimer = playdate.timer.new(playTime, playTime, 0, playdate.easingFunctions.linear)
end

--[[ SHAHBAZ CODE BLOCK B STARTS--]]

-- Function to generate number of waters at a radial distance from root/split origin
function PoolGen()
	for i = 0, NumWaters, 1 do

		local rand_num = math.random(180)
		rand_num = rand_num * 0.0174533
		local temp_x = math.cos(rand_num) * Pool_dist
		local temp_y = math.sin(rand_num) * Pool_dist
		local temp_Pool = {} -- we could later on refactor this into a JSON object repping the water pool
		temp_Pool['x_coord'] = temp_x + 200
		temp_Pool['y_coord'] = temp_y + 48
		if (GlobalObjLocs[temp_x] == nil) then
			GlobalObjLocs[temp_x] = temp_y
		else
			GlobalObjLocs[temp_x] = table.insert(GlobalObjLocs[temp_x], temp_y) -- TEST: if everything is right, this should chain y coords at each x val
		end
		PoolLocs[i] = temp_Pool;
	end

end

-- Function to generate number of rocks at a radial distance from root/split origin

function RockGen()
	for i = 0, NumRocks, 1 do

		local rand_num = math.random(180)
		rand_num = rand_num * 0.0174533
		local temp_x = math.cos(rand_num) * (Pool_dist - 2)
		local temp_y = math.sin(rand_num) * (Pool_dist - 2)
		local temp_Rock = {} -- we could later on refactor this into a JSON object repping the water pool
		temp_Rock['x_coord'] = temp_x
		temp_Rock['y_coord'] = temp_y
		if not (Is_PlaceOcc(temp_x, temp_y)) then -- TO DO: for checking if any other object is already on that place
			PoolLocs[i] = temp_Rock;
			-- GlobalObjLocs[temp_x] = table.insert(GlobalObjLocs[temp_x], temp_y) -- TEST: if everything is right, this should chain y coords at each x val
			if (GlobalObjLocs[temp_x] == nil) then
				GlobalObjLocs[temp_x] = temp_y
			else
				GlobalObjLocs[temp_x] = table.insert(GlobalObjLocs[temp_x], temp_y) -- TEST: if everything is right, this should chain y coords at each x val
			end
		else
			i = i - 1;
		end
	end

end

-- Function to generate number of rocks at a radial distance from root/split origin

function BattGen()
	for i = 0, NumBatteries, 1 do

		local rand_num = math.random(180)
		rand_num = rand_num * 0.0174533
		local temp_x = math.cos(rand_num) * (Pool_dist - 2)
		local temp_y = math.sin(rand_num) * (Pool_dist - 2)
		local temp_Batt = {} -- we could later on refactor this into a JSON object repping the water pool
		temp_Batt['x_coord'] = temp_x
		temp_Batt['y_coord'] = temp_y
		if not (Is_PlaceOcc(temp_x, temp_y)) then -- TO DO: for checking if any other object is already on that place
			PoolLocs[i] = temp_Batt;
			--GlobalObjLocs[temp_x] = table.insert(GlobalObjLocs[temp_x], temp_y) -- TEST: if everything is right, this should chain y coords at each x val
			if (GlobalObjLocs[temp_x] == nil) then
				GlobalObjLocs[temp_x] = temp_y
			else
				GlobalObjLocs[temp_x] = table.insert(GlobalObjLocs[temp_x], temp_y) -- TEST: if everything is right, this should chain y coords at each x val
			end
		else
			i = i - 1;
		end

	end
end

-- TEST: Checks if there is an object already placed at a coordinate (priority given to water/pool objects!)
function Is_PlaceOcc(x, y)
	if (GlobalObjLocs[x] == nil) then
		return false
	else
		for i = 1, #GlobalObjLocs[x] do
			if (GlobalObjLocs[x][i] == y) then
				return true
			end
		end
	end
	return false
end

--[[ SHAHBAZ CODE BLOCK B ENDS--]]

function drawPool()
	for i = 0, #PoolLocs do
		print("hello")
		local poolImage = gfx.image.new("images/water_pocket")
		local poolSprite = gfx.sprite.new(poolImage)
		poolSprite:moveTo(PoolLocs[i]["x_coord"],PoolLocs[i]["y_coord"])
		poolSprite:add()

		if poolWidth == 0 then
			poolWidth = poolSprite.width
		end
		if poolHeight == 0 then
			poolHeight = poolSprite.height
		end
	end
end

function initialize()
	PoolGen()
	RockGen()
	BattGen()
	drawPool()

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
		alternateBranch()
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
		rootBranches+=1
	end

	drawUI()
end


-- x can be -1 (left), 0 (center) and 1 (right)
function drawRoot(x, y)
	gfx.setColor(gfx.kColorBlack)
	gfx.fillRect((200 - rootThickness/2) + (rootThickness*rootX), 48 - rootThickness/2 + (rootThickness*rootY), rootThickness, rootThickness)
	rootX += x
	rootY += y
end

function drawBranch()
	drawX = (200 - branchSize/2) + (rootThickness*rootX)
	drawY = (48 - branchSize/2) + (rootThickness*rootY)
	
	gfx.drawRect(drawX,drawY,branchSize, branchSize)

	branchLocs[branchNumber] = {}
	branchLocs[branchNumber][drawX] = drawY

	branchLocsLocalScale[branchNumber] = {}
	branchLocsLocalScale[branchNumber][rootX] = rootY

	branchNumber += 1;
end

local buttonPressCount = 0
function alternateBranch()
	local selectedBranch = buttonPressCount % branchNumber
	local index = 0
	local index2 = 0
	
	local tempRootX = 0
	local tempRootY = 0
	for a, b in pairs(branchLocsLocalScale) do
		if(selectedBranch == index2) then
			for x2, y2 in pairs(b) do
				tempRootX = x2
				tempRootY = y2
			end
		end
	end

	for k, v in pairs(branchLocs) do
		for x, y in pairs(v) do
			if(selectedBranch == index) then
				gfx.fillRect(x+1,y+1,branchSize-2,branchSize-2)
				rootX = tempRootX
				rootY = tempRootY
			else -- Fill back to white
				gfx.setColor(gfx.kColorWhite)
				gfx.fillRect(x+1,y+1,branchSize-2,branchSize-2)
				gfx.setColor(gfx.kColorBlack)
			end
			index += 1
		end
	end
	buttonPressCount += 1
end

function updateRootLength(num)
	rootLength = num
end

function drawUI()
	gfx.fillRect(10,0,130,20)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Root Length: " .. rootLength, 20, 0)
	gfx.setImageDrawMode(original_draw_mode)

	--[Old method of display Branches]
	--gfx.setColor(gfx.kColorClear)
	--gfx.fillRect(10,40,110,20)
	--gfx.setColor(color)
	--gfx.drawText("Branches: " .. rootBranches, 10, 40)
	
	gfx.fillRect(280,0,130,20)
	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	gfx.drawText("Branches: " .. rootBranches, 290, 0)
	gfx.setImageDrawMode(original_draw_mode)
end

function CheckPoolCollision(x, y)
	for i = 1, #PoolLocs, 1 do
		local pool = PoolLocs[i]
		--X low and high range
		local lowX = pool.x_coord - poolWidth
		local highX = pool.x_coord + poolWidth
		--Y low and high range
		local lowY = pool.y_coord - poolHeight
		local highY = pool.y_coord + poolHeight

		if (x+200 >= lowX and x+200 <= highX) and (y+48 >= lowY and y+48 <= highY) then
			--toggle pool bool (if true then false, vice versa)

			--update root length
			rootLength += 20
			rootBranches += 1
		end
	end
end
