local propBountyIncreaseButton = script:GetCustomProperty("BountyIncreaseButton"):WaitForObject()

function OnButtonClicked(button)
    Events.Broadcast("BountyIncrease", 0)
end

propBountyIncreaseButton.clickedEvent:Connect(OnButtonClicked)

