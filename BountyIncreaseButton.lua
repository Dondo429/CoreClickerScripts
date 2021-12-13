local propBountryIncreaseButton = script:GetCustomProperty("BountryIncreaseButton"):WaitForObject()


function OnButtonClicked(button)
    Events.Broadcast("BountyUp Button", 1)
end

propBountryIncreaseButton.clickedEvent:Connect(OnButtonClicked)

