--boss head's movement

local enemy = script:GetCustomProperty("Enemy"):WaitForObject()
local enemyStartPos = enemy:GetWorldPosition()

local zVelocity = 20
local yVelocity = 20

--units are positive and negative
--take dimension and div by 2
local zBounds = 1500
local yBounds = 2500

--[[
local zCoord = enemyStartPos.z + zBounds
local yCoord = enemyStartPos.y + yBounds
]]

--positive boolean not position
local posZ = true
local posY = true

--it says xBool but lmfao its zBool I'm tired and lazy
function moveZ(XBool)
	local originalPosition = enemy:GetWorldPosition()
	local newPosition = originalPosition
	if (XBool == true) then
		newPosition.z = newPosition.z + zVelocity
	else 
		newPosition.z = newPosition.z - zVelocity
	end
	enemy:SetPosition(newPosition)

end
function moveY(XBool)
	local originalPosition = enemy:GetWorldPosition()
	local newPosition = originalPosition
	if (XBool) then
		newPosition.y = newPosition.y + yVelocity
	else 
		newPosition.y = newPosition.y - yVelocity
	end
	enemy:SetPosition(newPosition)

end




function Tick()
	local enemyPos = enemy:GetWorldPosition()
	--check if it is within bounding box
	local enemyYPos = enemyPos.y
	local enemyZPos = enemyPos.z
	if (posZ == true) then
	
		--print("zTrue")
		if (enemyZPos >= (enemyStartPos.z + zBounds)) then
			--print("switch to zFalse")
			posZ = false
		
		end
		
	else	
		if(enemyZPos <= (enemyStartPos.z - zBounds)) then
			posZ = true
		end
	end
	
	if (posY == true) then
		if (enemyYPos >= (enemyStartPos.y + yBounds)) then
			posY = false
		
		end
		
	else	
		if(enemyYPos <= (enemyStartPos.y	- yBounds)) then
			posY = true
		end
	end

	moveZ(posZ)
	moveY(posY)


end