--------------------------------------
--THIS SCRIPT RUNS AUTO FIRE

currentTarget = nil
currentTargets = {}
--boolean determining wether the autoturret will work or not
--Set this to false in editor to stop autoturret
local hitIndicator = script:GetCustomProperty("ImpactTemplate")
local SC_isActive = script:GetCustomProperty("isActive")
local SC_FR = script:GetCustomProperty("fireRate")
local SC_DMG = script:GetCustomProperty("damage")
SC_prevFireRateTime = 0.0

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
--broadcasts to GameMan and stores enemiesTable into currentTargets
function retrieveEnemiesTable()
    Events.Broadcast("Retrieve Enemies Table", 1)
end

Events.Connect("Enemies Table Update", function(eTable)
    currentTargets = eTable
end)

--when currentTarget dies it will be set to nill and pickNewTarget() is called in Tick()
Events.Connect("Destroy Enemy", function(enemyObj)
    --Ensure curentTargets has this enemy removed
    currentTargets[enemyObj.name] = nil
end)
-------------------------------------


--wait two seconds and pick an enemy so GameMan.enemyTable isn't empty
--get rid of this when upgrades are possible
--possibly use an event from Upgrade Manager and set FC_isActive to true.
Task.Wait(2)

function applyDamageAll()
    if currentTime - SC_prevFireRateTime >= SC_FR then
        Events.Broadcast("Seismic Charge", SC_DMG)
        SC_prevFireRateTime = currentTime 
    end
end

function Tick()
	currentTime = counter(2)

    if SC_isActive then
        applyDamageAll()
    end
end