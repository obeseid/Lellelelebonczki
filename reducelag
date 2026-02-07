-- ddddddddddddddddddddd
-- Run this via executor or place in StarterPlayerScripts

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local terrain = Workspace.Terrain
local renderingEnabled = true

-- Configuration
local CONFIG = {
	UpdateInterval = 1,
	RenderDistance = 10,
	UseExecutorFunctions = true,
	AutoDisableRendering = true, -- Set to false if you want rendering ON at start
}

-- Check if executor functions are available
local hasExecutor = (setfpscap or set_fps_cap) and true or false

-- ============================================
-- TERRAIN OPTIMIZATION FUNCTIONS
-- ============================================

local function optimizeTerrainSettings()
	if terrain:FindFirstChild("Decoration") then
		terrain.Decoration = false
	end
	
	terrain.WaterWaveSize = 0.05
	terrain.WaterWaveSpeed = 10
	terrain.WaterReflectance = 0
	terrain.WaterTransparency = 0.8
	terrain.WaterColor = Color3.new(0.1, 0.1, 0.1)
end

local function reduceGraphicsQuality()
	Lighting.GlobalShadows = false
	Lighting.Brightness = 1
	Lighting.OutdoorAmbient = Color3.new(0.5, 0.5, 0.5)
	Lighting.Technology = Enum.Technology.Compatibility
	
	for _, effect in pairs(Lighting:GetChildren()) do
		if effect:IsA("BloomEffect") or effect:IsA("BlurEffect") or 
		   effect:IsA("ColorCorrectionEffect") or effect:IsA("DepthOfFieldEffect") or 
		   effect:IsA("SunRaysEffect") then
			effect.Enabled = false
		elseif effect:IsA("Atmosphere") then
			effect:Destroy()
		end
	end
	
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end

local function executorOptimizations()
	if not CONFIG.UseExecutorFunctions or not hasExecutor then return end
	
	pcall(function()
		if setfpscap then
			setfpscap(30)
		elseif set_fps_cap then
			set_fps_cap(30)
		end
	end)
	
	pcall(function()
		if sethiddenproperty then
			sethiddenproperty(terrain, "TerrainSize", Vector3.new(128, 128, 128))
		end
	end)
end

local function cleanupWorkspace()
	for _, obj in pairs(Workspace:GetDescendants()) do
		if obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or 
		   obj:IsA("ParticleEmitter") or obj:IsA("Trail") then
			pcall(function()
				obj.Enabled = false
				obj:Destroy()
			end)
		end
		
		if (obj:IsA("MeshPart") or obj:IsA("UnionOperation")) and player.Character then
			local isInModel = false
			local parent = obj.Parent
			while parent and parent ~= Workspace do
				if parent:IsA("Model") then
					isInModel = true
					break
				end
				parent = parent.Parent
			end
			
			if not isInModel then
				local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
				if rootPart and (obj.Position - rootPart.Position).Magnitude > CONFIG.RenderDistance then
					pcall(function()
						obj.Parent = nil
					end)
				end
			end
		end
	end
end

local function optimizeCameraSettings()
	player.CameraMaxZoomDistance = CONFIG.RenderDistance
	player.CameraMinZoomDistance = 0.5
	camera.FieldOfView = 70
	
	pcall(function()
		if sethiddenproperty then
			sethiddenproperty(camera, "FieldOfViewMode", Enum.FieldOfViewMode.Diagonal)
		end
	end)
end

local cleanupCounter = 0
local function aggressiveCleanup()
	cleanupCounter = cleanupCounter + 1
	
	if cleanupCounter >= 120 then
		collectgarbage()
		collectgarbage()
		cleanupCounter = 0
		
		pcall(function()
			for _, sound in pairs(Workspace:GetDescendants()) do
				if sound:IsA("Sound") and not sound.IsPlaying then
					sound:Stop()
					sound.TimePosition = 0
				end
			end
		end)
	end
end

-- ============================================
-- RENDERING TOGGLE FUNCTIONS
-- ============================================

local function toggleRendering()
	renderingEnabled = not renderingEnabled
	
	pcall(function()
		RunService:Set3dRenderingEnabled(renderingEnabled)
	end)
	
	return renderingEnabled
end

local function updateButton(button, indicator, enabled)
	if enabled then
		button.Text = "🎥 Rendering: ON"
		button.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		button.BorderColor3 = Color3.fromRGB(0, 255, 0)
		indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	else
		button.Text = "🎥 Rendering: OFF"
		button.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
		button.BorderColor3 = Color3.fromRGB(255, 0, 0)
		indicator.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
	end
end

local function createGUI()
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "PerformanceOptimizer"
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	pcall(function()
		screenGui.Parent = game:GetService("CoreGui")
	end)
	
	if not screenGui.Parent then
		screenGui.Parent = player:WaitForChild("PlayerGui")
	end
	
	-- Rendering toggle button
	local renderButton = Instance.new("TextButton")
	renderButton.Name = "RenderToggleButton"
	renderButton.Size = UDim2.new(0, 180, 0, 50)
	renderButton.Position = UDim2.new(1, -190, 0, 10)
	renderButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	renderButton.BorderSizePixel = 2
	renderButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
	renderButton.Font = Enum.Font.GothamBold
	renderButton.TextSize = 16
	renderButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	renderButton.Text = "🎥 Rendering: ON"
	renderButton.AutoButtonColor = false
	renderButton.Parent = screenGui
	
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = renderButton
	
	local shadow = Instance.new("Frame")
	shadow.Size = UDim2.new(1, 4, 1, 4)
	shadow.Position = UDim2.new(0, -2, 0, 2)
	shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.7
	shadow.ZIndex = renderButton.ZIndex - 1
	shadow.BorderSizePixel = 0
	shadow.Parent = renderButton
	
	local shadowCorner = Instance.new("UICorner")
	shadowCorner.CornerRadius = UDim.new(0, 8)
	shadowCorner.Parent = shadow
	
	local indicator = Instance.new("Frame")
	indicator.Size = UDim2.new(0, 10, 0, 10)
	indicator.Position = UDim2.new(0, 10, 0.5, -5)
	indicator.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
	indicator.BorderSizePixel = 0
	indicator.Parent = renderButton
	
	local indicatorCorner = Instance.new("UICorner")
	indicatorCorner.CornerRadius = UDim.new(1, 0)
	indicatorCorner.Parent = indicator
	
	-- Stats display
	local statsFrame = Instance.new("Frame")
	statsFrame.Size = UDim2.new(0, 180, 0, 70)
	statsFrame.Position = UDim2.new(1, -190, 0, 70)
	statsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	statsFrame.BackgroundTransparency = 0.5
	statsFrame.BorderSizePixel = 0
	statsFrame.Parent = screenGui
	
	local statsCorner = Instance.new("UICorner")
	statsCorner.CornerRadius = UDim.new(0, 8)
	statsCorner.Parent = statsFrame
	
	local statsLabel = Instance.new("TextLabel")
	statsLabel.Size = UDim2.new(1, -10, 1, -10)
	statsLabel.Position = UDim2.new(0, 5, 0, 5)
	statsLabel.BackgroundTransparency = 1
	statsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	statsLabel.TextSize = 13
	statsLabel.Font = Enum.Font.Code
	statsLabel.TextXAlignment = Enum.TextXAlignment.Left
	statsLabel.TextYAlignment = Enum.TextYAlignment.Top
	statsLabel.Parent = statsFrame
	
	return screenGui, renderButton, indicator, statsLabel
end

-- ============================================
-- INITIALIZE EVERYTHING
-- ============================================

print("Initializing Ultimate Performance Optimizer...")

-- Apply terrain optimizations
optimizeTerrainSettings()
reduceGraphicsQuality()
executorOptimizations()
optimizeCameraSettings()

-- Create GUI
local screenGui, renderButton, indicator, statsLabel = createGUI()

-- Button hover effect
renderButton.MouseEnter:Connect(function()
	renderButton.BackgroundTransparency = 0.2
end)

renderButton.MouseLeave:Connect(function()
	renderButton.BackgroundTransparency = 0
end)

-- Button click event
renderButton.MouseButton1Click:Connect(function()
	local enabled = toggleRendering()
	updateButton(renderButton, indicator, enabled)
	
	local sound = Instance.new("Sound")
	sound.SoundId = "rbxasset://sounds/button.wav"
	sound.Volume = 0.5
	sound.Parent = screenGui
	sound:Play()
	game:GetService("Debris"):AddItem(sound, 1)
	
	local originalSize = renderButton.Size
	renderButton.Size = UDim2.new(0, 175, 0, 48)
	wait(0.1)
	renderButton.Size = originalSize
end)

-- Stats update loop
RunService.RenderStepped:Connect(function()
	local memoryMB = math.floor(gcinfo() / 1024)
	local cpuStatus = renderingEnabled and "Normal" or "Ultra Low"
	
	statsLabel.Text = string.format(
		"Memory: %d MB\nCPU Mode: %s\nRender Dist: %d",
		memoryMB,
		cpuStatus,
		CONFIG.RenderDistance
	)
end)

-- Main optimization loop
local lastUpdateTime = 0
RunService.Heartbeat:Connect(function()
	local now = tick()
	
	aggressiveCleanup()
	
	if now - lastUpdateTime >= CONFIG.UpdateInterval then
		lastUpdateTime = now
		optimizeCameraSettings()
		cleanupWorkspace()
	end
end)

-- Auto-disable rendering if configured
if CONFIG.AutoDisableRendering then
	wait(0.5)
	renderingEnabled = toggleRendering()
	updateButton(renderButton, indicator, renderingEnabled)
	print("Rendering automatically disabled for maximum performance!")
end

print("✅ Ultimate Performance Optimizer loaded!")
print("📊 Features active:")
print("  - Terrain optimization (128 stud render distance)")
print("  - Graphics quality reduced to minimum")
print("  - Aggressive memory cleanup")
print("  - Particle effects removed")
if hasExecutor then
	print("  - Executor optimizations (FPS capped at 30)")
end
if CONFIG.AutoDisableRendering then
	print("  - 3D Rendering DISABLED (click button to enable)")
end
print("💡 Current memory usage:", math.floor(gcinfo() / 1024), "MB")
