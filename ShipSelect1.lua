button = script.parent

function OnClick(button)
    Events.BroadcastToServer("Ship Select 1", 1)
end

button.clickedEvent:Connect(OnClick)