button = script.parent

function OnClick(button)
    Events.BroadcastToServer("Ship Select 2", 1)
end

button.clickedEvent:Connect(OnClick)