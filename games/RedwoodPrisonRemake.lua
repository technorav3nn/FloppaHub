-- // Fixing protect_gui and removing old GUIS
setreadonly(syn, false)
syn.protect_gui = function(gui)
    gui.Parent = game.CoreGui
end
setreadonly(syn, true)

for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

-- // Dependencies
local Library =
    loadstring(
    game:HttpGet(
        "https://gist.githubusercontent.com/technorav3nn/034cb2d38524ce2c3da8cda7a936b1ee/raw/b80dfd387ac352a8d68b5db41a3252e977d52fb5/linoria-lib-fix"
    )
)()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // Services
local runService = game:GetService("RunService")
local marketPlaceService = game:GetService("MarketplaceService")

local players = game:GetService("Players")

-- // RunService Variables
local renderStepped = runService.RenderStepped
local heartBeat = runService.Heartbeat
local stepped = runService.Stepped

-- // Player Variables
local localPlayer = players.LocalPlayer

-- // UI Library Variables
local flags = getgenv().Toggles
local options = getgenv().Options

-- // Other Table Variables
local funcs = {}
local connections = {}

local oldStates = {}
local gunList = {
    "L86A2",
    "M16",
    "M98B",
    "UMP-45",
    "M60",
    "M1014",
    "AK47",
    "Hammer",
    "Fake ID Card",
    "SPAS-12",
    "S&W 638",
    "ACR",
    "Revolver",
    "M14",
    "Makarov",
    "AK47-U",
    "Parachute"
}
table.sort(gunList)

-- // Other Variables
local clientEnv = getsenv(game.Players.LocalPlayer.PlayerGui.autoExec.client)

-- // Watermark and Notification
Library:SetWatermark("Floppa Hub")
Library:Notify("Loading UI...")

-- // ESP Functions
-- /// Not done

-- // Initialize ESP
ESP.Players = false

ESP:Toggle(true)

-- // Functions
local notify = clientEnv.smallNotice

local function populateOldStates()
    local module = require(game:GetService("ReplicatedStorage").ItemStats)
    for key, itemStats in pairs(module) do
        oldStates[key] = itemStats
    end
end

local function updateGcValues()
    for i, v in pairs(getgc(true)) do
        if type(v) == "function" then
            local b = debug.getupvalues(v)
            for i2, v2 in pairs(b) do
                if type(v2) == "table" and rawget(v2, "maxAmmo") then
                    local oldGunState = oldStates[v2.name]
                    if flags.infAmmo then
                        v2.curAmmo = math.huge
                        v2.maxAmmo = math.huge
                    else
                        v2.maxAmmo = oldGunState.maxAmmo
                        v2.curAmmo = 50
                    end
                    if flags.fastFireRate then
                        v2.coolDown = 0.000000000000001
                        print(v2.fireType)
                    else
                        v2.coolDown = oldGunState.coolDown
                    end

                    v2.fireType = flags.fireMode

                    if flags.noReloadTime then
                    else
                    end
                end
            end
        end
    end
end

local function getGamePasses(state)
    local gamepasses = {
        "hasSwat",
        "hasSpecOps",
        "hasMerc",
        "hasPilot",
        "hasAtv"
    }

    for _, v in pairs(gamepasses) do
        workspace.resources.RemoteFunction:InvokeServer("setDataValue", v, state)
    end
end

local function getGiver(name)
    for _, v in pairs(workspace:GetChildren()) do
        if v.Name == name and v:FindFirstChild("gunGiver") then
            return v
        end
    end
end

local function getGun(gunName)
    getGamePasses(true)

    local oldCf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    local giver = getGiver(gunName)

    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = giver.CFrame
    task.wait(0.2)
    workspace.resources.RemoteFunction:InvokeServer("giveItemFromGunGiver", getGiver(gunName))
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf

    getGamePasses(false)
end

--#region
local function updateTheme()
    Library.BackgroundColor = options.BackgroundColor.Value
    Library.MainColor = options.MainColor.Value
    Library.AccentColor = options.AccentColor.Value
    Library.AccentColorDark = Library:GetDarkerColor(Library.AccentColor)
    Library.OutlineColor = options.OutlineColor.Value
    Library.FontColor = options.FontColor.Value

    Library:UpdateColorsUsingRegistry()
end

local function setDefault()
    options.FontColor:SetValueRGB(Color3.fromRGB(255, 255, 255))
    options.MainColor:SetValueRGB(Color3.fromRGB(28, 28, 28))
    options.BackgroundColor:SetValueRGB(Color3.fromRGB(20, 20, 20))
    options.AccentColor:SetValueRGB(Color3.fromRGB(0, 85, 255))
    options.OutlineColor:SetValueRGB(Color3.fromRGB(50, 50, 50))
    flags.Rainbow:SetValue(false)

    updateTheme()
end
--#endregion

-- // Populate old gun states
populateOldStates()

local Window = Library:CreateWindow("Floppa Hub")
do
    local playerTab = Window:AddTab("Player")
    do
        local characterSec = playerTab:AddLeftTabbox():AddTab("Character")
        do
            characterSec:AddSlider(
                "plrWalkspeed",
                {Text = "Walkspeed", Default = 16, Min = 16, Max = 500, Rounding = 1}
            ):OnChanged(
                function()
                    if localPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
                        localPlayer.Character.Humanoid.WalkSpeed = options.plrWalkspeed.Value
                    end
                end
            )
        end

        local teamTabBox = playerTab:AddRightTabbox()
        do
            local teamChangerSec = teamTabBox:AddTab("Team Changer")
            do
                teamChangerSec:AddDropdown(
                    "selectedTeam",
                    {Text = "Select Team", Values = {"Criminal", "Neutral", "Guard", "Inmate"}}
                )
                teamChangerSec:AddButton(
                    "Change Team",
                    function()
                        local selectedTeam = options.selectedTeam.Value
                        if selectedTeam == "Criminal" then
                            firetouchinterest(
                                localPlayer.Character.HumanoidRootPart,
                                game:GetService("Workspace")["Criminals Spawn"].SpawnLocation,
                                0
                            )
                            firetouchinterest(
                                localPlayer.Character.HumanoidRootPart,
                                game:GetService("Workspace")["Criminals Spawn"].SpawnLocation,
                                1
                            )
                        elseif selectedTeam == "Inmate" then
                            game.Workspace.Remote.TeamEvent:FireServer("Bright orange")
                        elseif selectedTeam == "Guard" then
                            game.Workspace.Remote.TeamEvent:FireServer("Bright blue")
                        elseif selectedTeam == "Neutral" then
                            game.Workspace.Remote.TeamEvent:FireServer("Medium stone grey")
                        end
                    end
                )
            end
        end
        local utilSec = playerTab:AddLeftTabbox():AddTab("Utility")
        do
            utilSec:AddToggle("antiShield", {Text = "Anti Shields", Default = false}):OnChanged(
                function()
                    task.spawn(
                        function()
                            while flags.antiShield.Value do
                                for _, player in ipairs(game.Players:GetPlayers()) do
                                    pcall(
                                        function()
                                            if game.Workspace[player.Name].Torso:FindFirstChild("ShieldFolder") then
                                                game.Workspace[player.Name].Torso.ShieldFolder:Destroy()
                                            end
                                        end
                                    )
                                end
                                task.wait(1)
                            end
                        end
                    )
                end
            )
            --[[
            local oldTazeFunc
            utilSec:AddToggle("antiTaze", {Text = "Anti Taze", Default = false}):OnChanged(
                function()
                    local state = flags.antiTaze.Value
                    if state then
                        oldTazeFunc = funcs.taze
                        hookfunction(
                            funcs.taze,
                            function()
                            end
                        )
                    else
                        if oldTazeFunc ~= nil then
                            funcs.taze = oldTazeFunc
                        end
                    end
                end
            )
            
            utilSec:AddToggle("loopDoors", {Text = "Loop Open Doors (Guard)", Default = false}):OnChanged(
                function()
                    task.spawn(
                        function()
                            while flags.loopDoors.Value do
                                for _, v in ipairs(game:GetService("Workspace").Doors:GetDescendants()) do
                                    if v:IsA("TouchTransmitter") or v.Name == "TouchInterest" then
                                        firetouchinterest(game.Players.LocalPlayer.Character["Left Leg"], v.Parent, 0)
                                        firetouchinterest(game.Players.LocalPlayer.Character["Left Leg"], v.Parent, 1)
                                        firetouchinterest(game.Players.LocalPlayer.Character.Torso, v.Parent, 0)
                                        firetouchinterest(game.Players.LocalPlayer.Character.Torso, v.Parent, 1)
                                    end
                                end
                                task.wait(2)
                            end
                        end
                    )
                end
            )
            ]]
        end
    end

    local combatTab = Window:AddTab("Combat")
    do
        local itemsTabBox = combatTab:AddLeftTabbox()
        do
            local gunsSec = itemsTabBox:AddTab("Guns")
            do
                gunsSec:AddDropdown(
                    "gunToGet",
                    {
                        Text = "Grab Item",
                        Default = gunList[1],
                        Values = gunList
                    }
                )
                gunsSec:AddButton(
                    "Grab Selected Item",
                    function()
                        getGun(options.gunToGet.Value)
                    end
                )
                gunsSec:AddButton(
                    "Grab All Items",
                    function()
                        for _, gun in ipairs(gunList) do
                            getGun(gun)
                        end
                    end
                )
                gunsSec:AddToggle("autoGiveAllGuns", {Text = "Auto Give All Guns", Default = false}):OnChanged(
                    function()
                        task.spawn(
                            function()
                                while flags.autoGiveAllGuns.Value do
                                end
                            end
                        )
                    end
                )
            end
            local gunModsSec = itemsTabBox:AddTab("Gun Mods")
            do
            end
        end
    end

    local rageTab = Window:AddTab("Rage")
    do
        local rageTabBox = rageTab:AddLeftTabbox()
        do
            local mainSec = rageTabBox:AddTab("Server")
            do
            end
            local selfSec = rageTabBox:AddTab("Self")
            do
                selfSec:AddToggle("killAura", {Text = "Kill Aura", Default = false}):OnChanged(
                    function()
                        task.spawn(
                            function()
                                while flags.killAura.Value do
                                end
                            end
                        )
                    end
                )
            end
        end
    end

    local visualsTab = Window:AddTab("Visuals")
    do
        local espBoxTab = visualsTab:AddLeftTabbox()
        do
            local espSec = espBoxTab:AddTab("ESP")
            do
                espSec:AddToggle("playerESP", {Text = "Player ESP", Default = false}):OnChanged(
                    function()
                        ESP.Players = flags.playerESP.Value
                    end
                )
                flags.playerESP:AddColorPicker("playerESPColor", {Default = ESP.Color})
                options.playerESPColor:OnChanged(
                    function()
                        ESP.Color = options.playerESPColor.Value
                    end
                )
            end
            local espOptionsSec = espBoxTab:AddTab("ESP Options")
            do
                espOptionsSec:AddToggle("boxESP", {Text = "Boxes", Default = true}):OnChanged(
                    function()
                        ESP.Boxes = flags.boxESP.Value
                    end
                )
                espOptionsSec:AddToggle("nameESP", {Text = "Names", Default = true}):OnChanged(
                    function()
                        ESP.Names = flags.nameESP.Value
                    end
                )
                espOptionsSec:AddToggle("tracersESP", {Text = "Tracers", Default = false}):OnChanged(
                    function()
                        ESP.Tracers = flags.tracersESP.Value
                    end
                )
                espOptionsSec:AddToggle("teamMates", {Text = "Show Teammates", Default = true}):OnChanged(
                    function()
                        ESP.TeamMates = flags.teamMates.Value
                    end
                )
                espOptionsSec:AddToggle("teamColor", {Text = "Team Colors", Default = true}):OnChanged(
                    function()
                        ESP.TeamColor = flags.teamColor.Value
                    end
                )
            end
        end
    end
end

local SettingsTab = Window:AddTab("Settings")
do
    local themeSec = SettingsTab:AddLeftGroupbox("Theme")
    do
        themeSec:AddLabel("Background Color"):AddColorPicker("BackgroundColor", {Default = Library.BackgroundColor})
        themeSec:AddLabel("Main Color"):AddColorPicker("MainColor", {Default = Library.MainColor})
        themeSec:AddLabel("Accent Color"):AddColorPicker("AccentColor", {Default = Library.AccentColor})
        themeSec:AddLabel("Outline Color"):AddColorPicker("OutlineColor", {Default = Library.OutlineColor})
        themeSec:AddLabel("Font Color"):AddColorPicker("FontColor", {Default = Library.FontColor})
        themeSec:AddButton("Default Theme", setDefault)
        themeSec:AddToggle("Keybinds", {Text = "Show Keybinds Menu", Default = true}):OnChanged(
            function()
                Library.KeybindFrame.Visible = flags.Keybinds.Value
            end
        )
        themeSec:AddToggle("Watermark", {Text = "Show Watermark", Default = true}):OnChanged(
            function()
                Library:SetWatermarkVisibility(flags.Watermark.Value)
            end
        )
        themeSec:AddToggle("Rainbow", {Text = "Rainbow Accent Color", Default = true})
    end
end

task.spawn(
    function()
        while game:GetService("RunService").RenderStepped:Wait() do
            if flags.Rainbow.Value then
                local registry = Window.Holder.Visible and Library.Registry or Library.HudRegistry

                for _, object in pairs(registry) do
                    for Property, colorIdx in next, object.Properties do
                        if colorIdx == "AccentColor" or colorIdx == "AccentColorDark" then
                            local objInstance = object.Instance
                            local yPos = objInstance.AbsolutePosition.Y

                            local mapped = Library:MapValue(yPos, 0, 1080, 0, 0.5) * 1.5
                            local color = Color3.fromHSV((Library.CurrentRainbowHue - mapped) % 1, 0.8, 1)

                            if colorIdx == "AccentColorDark" then
                                color = Library:GetDarkerColor(color)
                            end

                            objInstance[Property] = color
                        end
                    end
                end
            end
        end
    end
)

flags.Rainbow:OnChanged(
    function()
        if not flags.Rainbow.Value then
            updateTheme()
        end
    end
)

options.BackgroundColor:OnChanged(updateTheme)
options.MainColor:OnChanged(updateTheme)
options.AccentColor:OnChanged(updateTheme)
options.OutlineColor:OnChanged(updateTheme)
options.FontColor:OnChanged(updateTheme)

-- // Loops
task.spawn(
    function()
        while true do
            pcall(
                function()
                    clientEnv = getsenv(game.Players.LocalPlayer.PlayerGui.autoExec.client)
                end
            )
            task.wait(1)
        end
    end
)

-- // Finished
Library:Notify("Loaded UI!")
