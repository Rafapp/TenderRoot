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
Pool_dist = 8;
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

--[[ SHAHBAZ CODE BLOCK B STARTS--]]

-- Function to generate number of waters at a radial distance from root/split origin
function PoolGen()
	for i = 0, NumWaters, 1 do

		local rand_num = math.random(math.pi())
		local temp_x = math.cos(rand_num) * Pool_dist
		local temp_y = math.sin(rand_num) * Pool_dist
		local temp_Pool = {} -- we could later on refactor this into a JSON object repping the water pool
		temp_Pool['x_coord'] = temp_x
		temp_Pool['y_coord'] = temp_y
		GlobalObjLocs[temp_x] = table.insert(GlobalObjLocs[temp_x], temp_y) -- TEST: if everything is right, this should chain y coords at each x val
		PoolLocs[i] = temp_Pool;
	end
end

-- Function to generate number of rocks at a radial distance from root/split origin

function RockGen()
	for i = 0, NumRocks, 1 do

		local rand_num = math.random(math.pi())
		local temp_x = math.cos(rand_num) * (Pool_dist - 2)
		local temp_y = math.sin(rand_num) * (Pool_dist - 2)
		local temp_Rock = {} -- we could later on refactor this into a JSON object repping the water pool
		temp_Rock['x_coord'] = temp_x
		temp_Rock['y_coord'] = temp_y
		if not (Is_PlaceOcc(temp_x, temp_y)) then -- TO DO: for checking if any other object is already on that place
			PoolLocs[i] = temp_Rock;
			GlobalObjLocs[temp_x] = table.insert(GlobalObjLocs[temp_x], temp_y) -- TEST: if everything is right, this should chain y coords at each x val
		else
			i = i - 1;
		end
	end
end

-- Function to generate number of rocks at a radial distance from root/split origin

function BattGen()
	for i = 0, NumBatteries, 1 do

		local rand_num = math.random(math.pi())
		local temp_x = math.cos(rand_num) * (Pool_dist - 2)
		local temp_y = math.sin(rand_num) * (Pool_dist - 2)
		local temp_Batt = {} -- we could later on refactor this into a JSON object repping the water pool
		temp_Batt['x_coord'] = temp_x
		temp_Batt['y_coord'] = temp_y
		if not (Is_PlaceOcc(temp_x, temp_y)) then -- TO DO: for checking if any other object is already on that place
			PoolLocs[i] = temp_Batt;
			GlobalObjLocs[temp_x] = table.insert(GlobalObjLocs[temp_x], temp_y) -- TEST: if everything is right, this should chain y coords at each x val
		else
			i = i - 1;
		end

	end
end

-- TEST: Checks if there is an object already placed at a coordinate (priority given to water/pool objects!)
function Is_PlaceOcc(x, y)
	for i = 1, #GlobalObjLocs[x] do
		if (GlobalObjLocs[x][i] == y) then
			return true
		end
	end
	return false
end

--[[ SHAHBAZ CODE BLOCK B ENDS--]]
