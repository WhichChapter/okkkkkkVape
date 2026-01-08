--// Mobile-Friendly GUI Base (Wurst-style)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "MobileGui"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- Floating Open Button
local openButton = Instance.new("TextButton")
openButton.Size = UDim2.new(0, 45, 0, 45)
openButton.Position = UDim2.new(0, 15, 0.5, -22)
openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
openButton.Text = "≡"
openButton.TextSize = 28
openButton.TextColor3 = Color3.new(1,1,1)
openButton.AutoButtonColor = true
openButton.Parent = gui

-- Round corners
local openCorner = Instance.new("UICorner", openButton)
openCorner.CornerRadius = UDim.new(1, 0)

openButton.Active = true
openButton.Draggable = true

-- Main Frame
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 320, 0, 220)
main.Position = UDim2.new(0.5, -160, 0.5, -110)
main.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
main.Visible = false
main.Active = true
main.Draggable = true
main.Parent = gui

local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 10)

-- Title Bar
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 35)
title.BackgroundTransparency = 1
title.Text = "Mobile GUI"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)
title.Parent = main

-- Close Button
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 35, 0, 35)
close.Position = UDim2.new(1, -40, 0, 0)
close.Text = "✕"
close.TextSize = 20
close.BackgroundTransparency = 1
close.TextColor3 = Color3.new(1,1,1)
close.Parent = main

-- Example Button
local exampleBtn = Instance.new("TextButton")
exampleBtn.Size = UDim2.new(0, 260, 0, 40)
exampleBtn.Position = UDim2.new(0.5, -130, 0, 70)
exampleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
exampleBtn.Text = "Example Button"
exampleBtn.TextColor3 = Color3.new(1,1,1)
exampleBtn.TextSize = 18
exampleBtn.Parent = main

local btnCorner = Instance.new("UICorner", exampleBtn)
btnCorner.CornerRadius = UDim.new(0, 8)

-- Button logic
exampleBtn.MouseButton1Click:Connect(function()
	print("Button clicked!")
end)

-- Open / Close Logic
openButton.MouseButton1Click:Connect(function()
	main.Visible = true
	openButton.Visible = false
end)

close.MouseButton1Click:Connect(function()
	main.Visible = false
	openButton.Visible = true
end)
