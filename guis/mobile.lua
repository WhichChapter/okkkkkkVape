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

-- ======= GitHub loader system =======
local function wipeFolder(path)
	if not isfolder(path) then return end
	for _, file in listfiles(path) do
		if file:find('loader') then continue end
		if isfile(file) and select(1, readfile(file):find('--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.')) == 1 then
			delfile(file)
		end
	end
end

local function downloadFile(path, func)
	if not isfile(path) then
		local suc, res = pcall(function()
			return game:HttpGet(
				'https://raw.githubusercontent.com/WhichChapter/okkkkkkVape/'..
				readfile('newvape/profiles/commit.txt')..'/'..
				select(1, path:gsub('newvape/', '')),
				true
			)
		end)
		if not suc or res == '404: Not Found' then
			error(res)
		end
		if path:find('.lua') then
			res = '--This watermark is used to delete the file if its cached, remove it to make the file persist after vape updates.\n'..res
		end
		writefile(path, res)
	end
	return (func or readfile)(path)
end

--// Check latest commit
if not shared.VapeDeveloper then
	local _, subbed = pcall(function()
		return game:HttpGet('https://github.com/WhichChapter/okkkkkkVape')
	end)
	local commit = subbed:find('currentOid')
	commit = commit and subbed:sub(commit + 13, commit + 52) or nil
	commit = commit and #commit == 40 and commit or 'main'
	if commit == 'main' or (isfile('newvape/profiles/commit.txt') and readfile('newvape/profiles/commit.txt') or '') ~= commit then
		wipeFolder('newvape')
		wipeFolder('newvape/games')
		wipeFolder('newvape/guis')
		wipeFolder('newvape/libraries')
	end
	writefile('newvape/profiles/commit.txt', commit)
end

--// Ensure universal.lua is downloaded
downloadFile('newvape/Modules/universal.lua')

--// Load universal.lua from file (no require)
local Universal = loadstring(readfile('newvape/Modules/universal.lua'))()

-- ======= MAIN GUI ELEMENTS =======
-- Floating Open Button
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

-- Main Window
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 340, 0, 260)
main.Position = UDim2.new(0.5, -170, 0.5, -130)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Visible = false
main.Active = true
main.Draggable = true
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0,12)

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 40)
title.Text = "Mobile Wurst GUI"
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1
title.Parent = main

-- Close button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 40, 0, 40)
close.Position = UDim2.new(1, -40, 0, 0)
close.Text = "✕"
close.TextSize = 20
close.BackgroundTransparency = 1
close.TextColor3 = Color3.new(1,1,1)
close.Parent = main

-- Tab Holder
local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, -20, 0, 40)
tabHolder.Position = UDim2.new(0, 10, 0, 45)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = main
local tabLayout = Instance.new("UIListLayout", tabHolder)
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 8)

-- Notification function
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
	task.delay(2, function() n:Destroy() end)
end

-- MainAPI system
local MainAPI = {
	Categories = {},
	Modules = {},
	Keybind = Enum.KeyCode.RightShift,
	Rainbow = false,
	RainbowSpeed = 1
}

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

	MainAPI.Categories[name] = { Page = page, Button = btn }
end

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

	MainAPI.Modules[name] = {Toggle = function() btn:Activate() end}
end

--// OPEN / CLOSE
openButton.MouseButton1Click:Connect(function()
	main.Visible = true
	openButton.Visible = false
end)
close.MouseButton1Click:Connect(function()
	main.Visible = false
	openButton.Visible = true
end)
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == MainAPI.Keybind then
		main.Visible = not main.Visible
		openButton.Visible = not main.Visible
	end
end)

--// CREATE CATEGORIES
MainAPI:CreateCategory("Combat")
MainAPI:CreateCategory("Render")
MainAPI:CreateCategory("Utility")
MainAPI.Categories.Combat.Button:Activate()

--// ADD MODULES
MainAPI:CreateModule("Combat", "KillAura", function(v)
	print("KillAura:", v)
end)

--// ADD ESP BUTTON
MainAPI:CreateModule("Render", "ESP", function(v)
	Universal:Toggle("ESP")
	print("ESP Enabled:", Universal:IsEnabled("ESP"))
end)

MainAPI:CreateModule("Render", "Rainbow UI", function(v)
	MainAPI.Rainbow = v
end)

MainAPI:CreateModule("Utility", "Example Hack", function(v)
	print("Utility enabled:", v)
end)
