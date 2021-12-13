
local enemy = script:GetCustomProperty("Enemy"):WaitForObject()

local xVelocity = 0
local rotationVelocity = .75
xVelocity = math.random(50,200)


function Tick()
	originalPos = enemy:GetWorldPosition()
	newPos = originalPos
	
	newPos.x = originalPos.x - xVelocity
	
	
	enemy:SetPosition(newPos)
	
	originalRot = enemy:GetWorldRotation()
	newRot = originalRot
	
	newRot.y = originalRot.y - rotationVelocity
	newRot.x = originalRot.x - (rotationVelocity / 2)
	enemy:SetRotation(newRot)
	

end