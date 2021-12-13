button = script.parent

local turretLevel = ""

function OnClick(button)
    Events.Broadcast("AutoTurret Upgrade", 1)
end

button.clickedEvent:Connect(OnClick)