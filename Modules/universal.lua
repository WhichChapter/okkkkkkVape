-- universal.lua
-- Main feature module for your mobile GUI script

local Universal = {}

-- =========================
-- Settings / Toggles
-- =========================
Universal.Settings = {
    ESP = false,         -- Player/NPC ESP
    ShowDistance = true, -- Optional: show distance in ESP
    Aimbot = false,      -- placeholder for future aimbot
    WallHack = false,    -- placeholder for wallhack
}

-- =========================
-- Utility Functions
-- =========================
function Universal:ToggleFeature(featureName)
    if self.Settings[featureName] ~= nil then
        self.Settings[featureName] = not self.Settings[featureName]
    end
end

function Universal:IsEnabled(featureName)
    return self.Settings[featureName] == true
end

-- =========================
-- Mobile ESP Module
-- =========================
Universal.ESPModule = {}
Universal.ESPModule.UpdateRate = 0.15

local function createESP(target)
    if not target or not target:FindFirstChild("HumanoidRootPart") then return end
    if target:FindFirstChild("ESP") then return end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESP"
    billboard.Adornee = target.HumanoidRootPart
    billboard.Size = UDim2.new(0, 100, 0, 50)
    billboard.AlwaysOnTop = true
    billboard.Parent = target.HumanoidRootPart

    local text = Instance.new("TextLabel")
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 0, 0)
    text.TextStrokeTransparency = 0.5
    text.TextScaled = true
    text.Font = Enum.Font.SourceSansBold
    text.Text = target.Name

    -- show distance if enabled
    if Universal.Settings.ShowDistance then
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
            text.Text = target.Name .. " | " .. math.floor(dist) .. "m"
        end
    end

    text.Parent = billboard
end

local function removeESP(target)
    local hrp = target:FindFirstChild("HumanoidRootPart")
    if hrp then
        local esp = hrp:FindFirstChild("ESP")
        if esp then esp:Destroy() end
    end
end

-- ESP loop
spawn(function()
    while true do
        if Universal:IsEnabled("ESP") then
            -- Players
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then
                    createESP(player.Character)
                end
            end
            -- NPCs
            if workspace:FindFirstChild("NPCs") then
                for _, npc in pairs(workspace.NPCs:GetChildren()) do
                    createESP(npc)
                end
            end
        else
            -- Remove ESP if disabled
            for _, player in pairs(game.Players:GetPlayers()) do
                if player.Character then removeESP(player.Character) end
            end
            if workspace:FindFirstChild("NPCs") then
                for _, npc in pairs(workspace.NPCs:GetChildren()) do
                    removeESP(npc)
                end
            end
        end
        wait(Universal.ESPModule.UpdateRate)
    end
end)

-- =========================
-- Placeholder for other modules
-- =========================
-- You can add Aimbot, WallHack, Player Info, etc. here later

return Universal
