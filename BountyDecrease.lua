local propBountyDecreaseButton = script:GetCustomProperty("BountyDecreaseButton"):WaitForObject()

function OnButtonClicked(button)
    Events.Broadcast("BountyDecrease", 0)
end

propBountyDecreaseButton.clickedEvent:Connect(OnButtonClicked)

