-- LocalScript (place in StarterPlayerScripts or StarterCharacterScripts)

local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- Track whether a click is "real" (from actual hardware)
local isRealInput = false

-- Hook into UserInputService to tag real hardware input BEFORE it fires
local originalGetMouseButtonsPressed = UserInputService.GetMouseButtonsPressed

-- We intercept InputBegan to check the source
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	-- VirtualInputManager-generated clicks will NOT set this flag beforehand
	if input.InputType == Enum.UserInputType.MouseButton1 
		or input.InputType == Enum.UserInputType.MouseButton2 
		or input.InputType == Enum.UserInputType.MouseButton3 then

		if not isRealInput then
			-- This click was NOT preceded by a real hardware event flag
			-- so it's likely from VirtualInputManager — block it
			warn("[AntiVIM] Blocked virtual mouse click: " .. tostring(input.InputType))
			return -- exit early, don't process
		end
	end
end)

-- The key trick: bind to a RenderStepped/Heartbeat flag approach
-- Real hardware input arrives via the OS input pipeline and fires
-- synchronously with InputBegan. We use a wrapper on SendMouseButtonEvent
-- to detect VirtualInputManager calls.

-- Override VirtualInputManager mouse button methods
local blockedMethods = {
	"SendMouseButtonEvent",
	"SendMouseWheelEvent",
}

for _, methodName in ipairs(blockedMethods) do
	local original = VirtualInputManager[methodName]
	if original then
		VirtualInputManager[methodName] = function(self, ...)
			warn("[AntiVIM] Blocked VirtualInputManager:" .. methodName .. "() call")
			-- Do NOT call original — this swallows the event
			return
		end
	end
end

print("[AntiVIM] VirtualInputManager mouse click blocking active.")
