button = script.parent

function OnClick(button)
    Events.BroadcastToServer("Ship Select 3", 1)
end

button.clickedEvent:Connect(OnClick)