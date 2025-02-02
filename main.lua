-----------------------------------------------------------------------------------------
-- Chaos Game WIP (Work In Progress) - empty
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local widget = require("widget")

-- display.setStatusBar( display.HiddenStatusBar )

dW = display.contentWidth
dH = display.contentHeight

frac = {3, 6}

hit = 0.85
leftVal = 0.5

local function createInitialCorners(corners)
	-- -- use the smallest of the dimensions of the device/display
	sideLen = math.min(dW, dH)
	-- -- figure out the top corner/point of the triangle
	local centerX = sideLen * leftVal
	local centerY = sideLen * hit
	local angle = (2*math.pi)/corners
	local radius = 150
	-- -- return 3 points/corners, each being a table
	points = {}
	for i=0,corners-1 do
	    x = centerX + radius * math.sin(i * angle) * -1;
	    y = centerY + radius * math.cos(i * angle) * -1;
	    table.insert(points, {x, y})
	end
	return points
	-- return {topX, topY}, {0, topY + sideLen * math.cos(math.rad(30))}, {sideLen, topY + sideLen * math.cos(math.rad(30))}
end

allPoints = {}


local function plotPoint(p, color, size)
	-- the parameter p (for point) is a table of {x, y}. The parameter color is a table of {red, green, blue}
	local x = p[1]
	local y = p[2]
	-- display a point. Feel free to change its size:
	newPoint = display.newCircle(x, y, size)
	-- the table {r, g, b} needs to be unpacked into a triplet (r, g, b)
	newPoint:setFillColor( unpack(color) )
	table.insert(allPoints, newPoint)
end


-- your functions, as you need them in your main program below, go here:


function createRandomPoint(p, points, n)
    local dice = math.random(n)
    -- print(dice)
    local point = points[dice]
    local x = point[1]
    local y = point[2]
    return {(x-p[1])*(frac[1]/frac[2])+p[1], (y-p[2])*(frac[1]/frac[2])+p[2]}
    -- local x = math.random(p3[1])
    -- local y = math.random(p3[2])
    -- plotPoint({x, y}, {0, 0, 1}, 2)
    -- return {x, y}
end


--------------------
-- main
--------------------

-- each corner/point is a table:
 	-- figure out the 3 points/corners of the initial triangle
--print("corners:", table.concat( top, ", ") .. table.concat( left, ", ") .. table.concat( right, ", "))
-- plot the triangle corners/points in red: 

-- your code for the chaos game goes here:

local nTurns = 512		-- the number of times to iterate. start small and at the end run for at least 30000 turns
local nPolyPoints = 3

points = createInitialCorners(nPolyPoints)
-- your 'for' loop for nTurns goes here:

function clearAllPoints()
	for k, v in pairs(allPoints) do
	  display.remove(v)
	end
end

function runSimulation(nTurns)
	clearAllPoints()
	last_coords = createRandomPoint({sideLen * 0.5, sideLen * 0.5}, points, nPolyPoints)
	-- plotPoint({sideLen * 0.5, sideLen * 0.45}, {0, 0, 1}, 2)
	for i=1,nTurns do
		last_coords = createRandomPoint(last_coords, points, nPolyPoints)
		plotPoint(last_coords, {0, 0, 1}, 1)
		-- print(last_coords[1], last_coords[2])
	end
	-- plotPoint(top, {0, 1, 0}, 3)
	-- plotPoint(left, {1, 0, 0}, 3)
	-- plotPoint(right, {1, 0, 0}, 3)
end

runSimulation(nTurns)

local function nTurnsStepperPress( event )
 
    if ( "increment" == event.phase ) then
        nTurns = nTurns * 2
        runSimulation(nTurns)
    elseif ( "decrement" == event.phase ) then
        nTurns = nTurns / 2
        runSimulation(nTurns)
    end
    nTurnsCounter.text = nTurns
end

local function polyPointStepperPress( event )
 
    if ( "increment" == event.phase ) then
    	nPolyPoints = nPolyPoints + 1
    	points = createInitialCorners(nPolyPoints)
    	frac[1] = frac[1] + 1
    	frac[2] = frac[2] + 1
        runSimulation(nTurns)
    elseif ( "decrement" == event.phase ) then
    	nPolyPoints = nPolyPoints - 1
    	points = createInitialCorners(nPolyPoints)
    	frac[1] = frac[1] - 1
    	frac[2] = frac[2] - 1
        runSimulation(nTurns)
    end
    polyPointCounter.text = nPolyPoints
end

local function onReset()
	runSimulation(nTurns)
end
         
-- Create the widget
local nTurnsStepper = widget.newStepper(
    {
        x = dW/2 + 75,
        y = dH*0.18,
        minimumValue = -9,
        maximumValue = 6,
        onPress = nTurnsStepperPress
    }
)

local polyPointStepper = widget.newStepper(
    {
        x = dW/2 - 75,
        y = dH*0.18,
        minimumValue = 0,
        maximumValue = 21,
        onPress = polyPointStepperPress
    }
)

local reRunSim = widget.newButton(
    {
        x = dW/2,
        y = dH*0.94,
        label="Re Run",
        onPress = onReset,
        labelColor = { default={ 1, 1, 0 }, over={ 0, 1, 0, 1 } }
    }
)

nTurnsCounter = display.newText("512", dW/2+75, dH*0.1, "Arial", 30)
nTurnsText = display.newText("N Points", dW/2+75, dH*0.05, "Arial", 16)

polyPointCounter = display.newText("3", dW/2-75, dH*0.1, "Arial", 30)
polyPointText = display.newText("Corners", dW/2-75, dH*0.05, "Arial", 16)

local function onOrientationChange( event )
    local currentOrientation = event.type
    print( "Current orientation: " .. currentOrientation )
    if currentOrientation == "portrait" or currentOrientation == "portraitUpsideDown" then
    	nTurnsStepper.x = dW/2 + 75
    	nTurnsStepper.y = dH*0.18
    	polyPointStepper.x = dW/2 - 75
    	polyPointStepper.y = dH*0.18
    	nTurnsCounter.x = dW/2 + 75
    	nTurnsCounter.y = dH*0.1
		polyPointCounter.x = dW/2 - 75
		polyPointCounter.y = dH*0.1
		nTurnsText.x = dW/2 + 75
		nTurnsText.y = dH*0.05
		polyPointText.x = dW/2 - 75
		polyPointText.y = dH*0.05
		hit = 0.85
		leftVal = 0.5
    	points = createInitialCorners(nPolyPoints)
    	frac[1] = frac[1] + 1
    	frac[2] = frac[2] + 1
        runSimulation(nTurns)
    else
    	nTurnsStepper.x = dW*1.2
    	nTurnsStepper.y = dH*0.2
    	polyPointStepper.x = dW*1.2
    	nTurnsCounter.x = dW*1.2
		polyPointCounter.x = dW*1.2
		nTurnsText.x = dW*1.2
		polyPointText.x = dW*1.2
		hit = 0.5
		leftVal = 0.5
    	points = createInitialCorners(nPolyPoints)
    	frac[1] = frac[1] + 1
    	frac[2] = frac[2] + 1
        runSimulation(nTurns)
    end
end
  
Runtime:addEventListener( "orientation", onOrientationChange )


