--------------------------------------
--THIS SCRIPT RUNS AUTO FIRE

currentTarget = nil
--boolean determining wether the autoturret will work or not
--Set this to false in editor to stop autoturret
local hitIndicator = script:GetCustomProperty("ImpactTemplate")

--AT: AutoTurret - Single Target
local AT_isActive = script:GetCustomProperty("AutoTurret_isActive")
local AT_FR = script:GetCustomProperty("AutoTurret_FR")
local AT_DMG = script:GetCustomProperty("AutoTurret_DMG")
--FC: Flak Cannon  - All Target
local FC_isActive = script:GetCustomProperty("FlakCannon_isActive")
local FC_FR = script:GetCustomProperty("FlakCannon_FR")
local FC_DMG = script:GetCustomProperty("FlakCannon_DMG")
--HM: Homing Missile - Single Target
local HM_isActive = script:GetCustomProperty("HomingMissile_isActive")
local HM_FR = script:GetCustomProperty("HomingMissile_FR")
local HM_DMG = script:GetCustomProperty("HomingMissile_DMG")
--SC: Seismic Charge - All Targer
local SC_isActive = script:GetCustomProperty("SeismicCharge_isActive")
local SC_FR = script:GetCustomProperty("SeismicCharge_FR")
local SC_DMG = script:GetCustomProperty("SeismicCharge_DMG")


AT_prevFireRateTime = 0.0

------------------------------------------------------------
--TIME FUNCTIONS
---------------------

--this function rounds to a given number of decimal places
--using because time() is accurate to like 10 decimals
function round(num, numDecimalPlaces)
	local mult = 10^(numDecimalPlaces or 0)
	return math.floor(num * mult + 0.5) / mult
  end
  
--time specific varaibles for Tick()
subtractTime = time()
prevTime = 0.0

--returns current time
function counter(decimalPlaces)
	--set subtractTime = time() at start of script
	local currentTime = time() - subtractTime
	currentTime = round(currentTime, decimalPlaces)

	return currentTime
end

-------------------------------------------------


-----------------------------------
--AI TARGETING
-------------------------------------

--To GameMan: Asks for new target
function pickNewTarget()
	print("Picking New Target")
	Events.Broadcast("Call New Target AT", 1)
end

--From GameMan: nil or enemy gameObject
Events.Connect("New Target AT",function(enemy)
	--If enemy is NOT nil, then set currentTarget to enemy
	if Object.IsValid(enemy) then
		currentTarget = enemy
	else --else Broadcast Call New Target again
		Events.Broadcast("Call New Target", 1)
	end
end)

--when currentTarget dies it will be set to nill and pickNewTarget() is called in Tick()
Events.Connect("Destroy Enemy", function(enemyObj)
	if enemyObj == currentTarget then
		currentTarget = nil
	end
end)
-------------------------------------



--wait two seconds and pick an enemy so GameMan.enemyTable isn't empty
--get rid of this when upgrades are possible
--possibly use an event from Upgrade Manager and set AT_isActive to true.
Task.Wait(2)
pickNewTarget()

function applyDamage(target)
    if currentTime - AT_prevFireRateTime >= AT_FR then
        enemyHP = target:GetCustomProperty("HP")
        finalHP = enemyHP - AT_DMG
        enemyHP = target:SetCustomProperty("HP", finalHP)
        --print("AT Target: "..target.name.." | DMG Applied: "..tostring(AT_DMG).." | HP: "..tostring(target:GetCustomProperty("HP")))
        
        --Hit Indicator Spawner
        tempPos = target:GetPosition()
        enemyPos = Vector3.New(tempPos.x - 200, tempPos.y, tempPos.z)
        World.SpawnAsset(hitIndicator, {position = enemyPos, scale = .25})
        
        AT_prevFireRateTime = currentTime
    end
end

function Tick()
	currentTime = counter(2)
	AT_isActive = script:GetCustomProperty("AutoTurret_isActive")
	if AT_isActive then
		if not (Object.IsValid(currentTarget)) then
			pickNewTarget()	
		else
			applyDamage(currentTarget)
		end
	end
end