local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Network = require(game:GetService("ReplicatedStorage").References.Utilities.Shared.Network)

local function onNewItemDetected(itemID)
	print("New item detected, firing QuickSellItem for: " .. tostring(itemID))
	Network.FireServer(Network, "QuickSellItem", itemID)
end

local function monitorBackpack()
	local contentList = playerGui:WaitForChild("Menus")
		:WaitForChild("Backpack")
		:WaitForChild("Main")
		:WaitForChild("Inventory")
		:WaitForChild("Content")
		:WaitForChild("List")

	for _, categoryContainer in ipairs(contentList:GetChildren()) do
		local list = categoryContainer:FindFirstChild("List")
		if list then
			local hasTextButton = false
			for _, child in ipairs(list:GetChildren()) do
				if child:IsA("TextButton") then
					hasTextButton = true
					break
				end
			end

			if hasTextButton then
				print("Found valid list in: " .. categoryContainer.Name)
				list.ChildAdded:Connect(function(child)
					if child:IsA("TextButton") then
						onNewItemDetected(child.Name)
					end
				end)
			end
		end
	end
end

monitorBackpack()

print("hhh")
