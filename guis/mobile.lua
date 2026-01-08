--// SERVICES
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--// SCREEN GUI
local gui = Instance.new("ScreenGui")
gui.Name = "MobileWurstGUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

--// FLOATING OPEN BUTTON
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 48, 0, 48)
openButton.Position = UDim2.new(0, 15, 0.5, -24)
openButton.Text = "≡"
openButton.TextSize = 26
openButton.TextColor3 = Color3.new(1,1,1)
openButton.BackgroundColor3 = Color3.fromRGB(30,30,30)
openButton.Parent = gui
openButton.Active = true
openButton.Draggable = true
Instance.new("UICorner", openButton).CornerRadius = UDim.new(1,0)

--// MAIN WINDOW
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 260)
main.Position = UDim2.new(0.5, -170, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Visible = false
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

--// TITLE
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Text = "Mobile Wurst GUI"
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = main

--// CLOSE
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -40, 0, 0)
close.Text = "✕"
close.TextSize = 20
close.BackgroundTransparency = 1
close.TextColor3 = Color3.new(1,1,1)
close.Parent = main

--// TAB HOLDER
local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, -20, 0, 40)
tabHolder.Position = UDim2.new(0, 10, 0, 45)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = main

local tabLayout = Instance.new("UIListLayout", tabHolder)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 8)

--// API
local MainAPI = {
	Categories = {},
	Modules = {},
	Keybind = Enum.KeyCode.RightShift,
	Rainbow = false,
	RainbowSpeed = 1
}

--// NOTIFICATION
local function Notify(text)
	local n = Instance.new("TextLabel")
	n.Size = UDim2.new(0, 240, 0, 40)
	n.Position = UDim2.new(1, -260, 1, -60)
	n.Text = text
	n.TextSize = 16
	n.TextColor3 = Color3.new(1,1,1)
	n.BackgroundColor3 = Color3.fromRGB(30,30,30)
	n.Parent = gui
	Instance.new("UICorner", n)

	TweenService:Create(n, TweenInfo.new(0.3),
		{Position = UDim2.new(1, -260, 1, -110)}
	):Play()

	task.delay(2, function()
		n:Destroy()
	end)
end

--// CATEGORY
function MainAPI:CreateCategory(name)
	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(0, 95, 1, 0)
	btn.Text = name
	btn.TextSize = 16
	btn.BackgroundColor3 = Color3.fromRGB(45,45,45)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = tabHolder
	Instance.new("UICorner", btn)

	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, -20, 1, -95)
	page.Position = UDim2.new(0, 10, 0, 95)
	page.Visible = false
	page.BackgroundTransparency = 1
	page.Parent = main

	local layout = Instance.new("UIListLayout", page)
	layout.Padding = UDim.new(0, 8)

	btn.MouseButton1Click:Connect(function()
		for _, c in pairs(MainAPI.Categories) do
			c.Page.Visible = false
		end
		page.Visible = true
	end)

	MainAPI.Categories[name] = {
		Page = page,
		Button = btn
	}
end

--// MODULE
function MainAPI:CreateModule(category, name, callback)
	local cat = MainAPI.Categories[category]
	if not cat then return end

	local btn = Instance.new("TextButton")
	btn.Size = UDim2.new(1, 0, 0, 40)
	btn.Text = name
	btn.TextSize = 18
	btn.BackgroundColor3 = Color3.fromRGB(40,40,40)
	btn.TextColor3 = Color3.new(1,1,1)
	btn.Parent = cat.Page
	Instance.new("UICorner", btn)

	local enabled = false

	btn.MouseButton1Click:Connect(function()
		enabled = not enabled
		btn.BackgroundColor3 = enabled and Color3.fromRGB(0,170,0) or Color3.fromRGB(40,40,40)
		callback(enabled)
		Notify(name.." "..(enabled and "Enabled" or "Disabled"))
	end)

	MainAPI.Modules[name] = {Toggle = function()
		btn:Activate()
	end}
end

--// RAINBOW UI
RunService.RenderStepped:Connect(function()
	if MainAPI.Rainbow then
		local h = tick() * MainAPI.RainbowSpeed % 1
		main.BackgroundColor3 = Color3.fromHSV(h, 0.5, 0.2)
	end
end)

--// OPEN / CLOSE
openButton.MouseButton1Click:Connect(function()
	main.Visible = true
	openButton.Visible = false
end)

close.MouseButton1Click:Connect(function()
	main.Visible = false
	openButton.Visible = true
end)

--// KEYBIND
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == MainAPI.Keybind then
		main.Visible = not main.Visible
		openButton.Visible = not main.Visible
	end
end)

--// DEMO CONTENT
MainAPI:CreateCategory("Combat")
MainAPI:CreateCategory("Render")
MainAPI:CreateCategory("Utility")

MainAPI.Categories.Combat.Button:Activate()

MainAPI:CreateModule("Combat", "KillAura", function(v)
	print("KillAura:", v)
end)

MainAPI:CreateModule("Render", "Rainbow UI", function(v)
	MainAPI.Rainbow = v
end)

MainAPI:CreateModule("Utility", "Example Hack", function(v)
	print("Utility enabled:", v)
end)
