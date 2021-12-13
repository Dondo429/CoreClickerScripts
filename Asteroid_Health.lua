--This script is the health for the enemy lol

--enemy
local enemy = script:GetCustomProperty("Parent"):WaitForObject()
local explosion = script:GetCustomProperty("Explosion")
local hp = enemy:GetCustomProperty("StartingHP")
local eventName = enemy.name
local GameMan = World.FindObjectByName("GameMan")
local BountyLevel = GameMan:GetCustomProperty("BountyLevel")
local CURRENCYMOD = 1.05
local DAMAGEMOD = 1.5
local HPMOD = 1.1
----change MUID for explosion on exp
local exp = tostring(explosion)
-----DESTROY ASTEROID AFTER A CERTAIN AMOUNT OF TIME












function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

subtractTime = time()
pretime = 0.0

--returns current time
function counter(decimalPlaces)
	--set subtractTime = time() at start of script
	local currentTime = time() - subtractTime
	currentTime = round(currentTime, decimalPlaces)

	return currentTime
end



----------------------------------------------
--Catch Up Functions to adjust for BountyLevels > 1

function catchUp(variable, modifier)
	--use this to catch up to bounty level modifier amount
	local x = BountyLevel - 1
	while(x > 0) do
		variable = variable * modifier
		x = x - 1
	end
	return variable
end



function catchUpOnCash()
	cash = enemy:GetCustomProperty("StartingCash")
	cash = catchUp(cash, CURRENCYMOD)
	return cash
end

function catchUpOnDamage()
	local damage = enemy:GetCustomProperty("DamageAmount")
	damage = catchUp(damage, DAMAGEMOD)
	return damage

end
function catchUpOnHp()
	local startHP = hp
	startHP = catchUp(startHP, HPMOD)
--	print(tostring(startHP).." "..enemy.name)
	return startHP
end

----------------------------------------------------

--base values-----------------------------------
local enemyCash = catchUpOnCash()
local cannonDamage = catchUpOnDamage() 
enemy:SetCustomProperty("HP", catchUpOnHp())

----------------------------------------------




------------------------------------------------------------------------------------------------
--[[
		CHANGE THESE FUNCTIONS FOR EACH ENEMY
		]]--

------------------------------------------
--Currency--

function IncreaseCash()
	if(Object.IsValid(enemy)) then
		enemyCash = enemyCash * CURRENCYMOD
		script:SetCustomProperty("EnemyCash", enemyCash)
		UI.PrintToScreen("Scout Cash Value: "..enemyCash)
	end
end

--function to calculate real cash value
function calculateCash()
	-- 
end





---------------------
--Damage--
function damageEnemy(damage)
	if(Object.IsValid(enemy)) then
		currentHP = enemy:GetCustomProperty('HP')
		affectedHP = currentHP - damage
		enemy:SetCustomProperty('HP', affectedHP)
		return affectedHP
	end
end

Events.Connect("Flak Cannon", function(dam)
	if(Object.IsValid(enemy)) then
		damageEnemy(dam)
		print("FC | DMG Applied: "..tostring(dam))
	end
end)

local seismicChargeDamageEvent
seismicChargeDamageEvent = Events.Connect("Seismic Charge", function(dam)
	if(Object.IsValid(enemy)) then
        damageEnemy(dam)
        print("SC | DMG Applied: "..tostring(dam))
    end
end)


function increaseDamage()
	cannonDamage = cannonDamage * DAMAGEMOD

end

local damageEvent
damageEvent = Events.Connect(eventName.."damage",  function(d)
		damageEnemy(cannonDamage)
end)

local destroyExistingEvent
destroyExistingEvent = Events.Connect("DestroyExisting", function(d)
	destroyAsteroid()
end)


function destroyEnemy()
	--Broadcast enemy gameObj to GameMan
	local GameCurrency = GameMan:GetCustomProperty("Currency")
	GameMan:SetCustomProperty("Currency", GameCurrency + enemyCash)
	Events.Broadcast("Destroy Enemy", enemy)
	--Broadcast how much cash is sent to CurrencyManager
	Events.Broadcast("Remove Enemy", enemy)
	enemyPos = enemy:GetPosition()
	World.SpawnAsset(exp, {position = enemyPos})	
	enemy:Destroy()
end

function destroyAsteroid()
	--Broadcast enemy gameObj to GameMan
	print("Destroyed Asteroid lol")
	Events.Broadcast("Destroy Enemy", enemy)
	--Broadcast how much cash is sent to CurrencyManager
	Events.Broadcast("Remove Enemy", enemy)
	
	enemy:Destroy()
end

------------------------------------------------







--------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------
---THIS RUNS EVERY BOUNTY UPDATE BROADCASTED FROM GameMan


local BountyUpdate

BountyUpdate = Events.Connect("Bounty Level Change", function(d)
	BountyLevel = BountyLevel + 1
	IncreaseCash()
	
	if BountyUpdate.isConnected then
		BountyUpdate:Disconnect()
		BountyUpdate = nil
	end
	
end)

function Tick()
	--damageEnemy(1)
	local hp = enemy:GetCustomProperty("HP")
	if(hp <= 0)then
		destroyEnemy()
	end
	
	if counter(0) >= 9.0 then

		destroyAsteroid()
	end
end	