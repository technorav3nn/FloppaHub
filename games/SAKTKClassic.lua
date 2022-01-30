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
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/LinoriaLib/main/Library.lua"))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // Services
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- // Variables
local localPlayer = players.LocalPlayer

local connections = {}

-- /// RunService Variables
local renderStepped = runService.RenderStepped

-- /// UI Library Variables
local flags = getgenv().Toggles
local options = getgenv().Options

-- // Modules
local weaponMod = require(game.ReplicatedStorage.Weapon)

-- // Disable ESP and other stuff on load
ESP.Players = false

ESP.Tracers = false
ESP.Boxes = true
ESP.Names = true

ESP:Toggle(true)

-- // UI

-- // Watermark and Notification
Library:SetWatermark("Floppa Hub")
Library:Notify("Loading UI...")

-- // ESP Listeners
ESP:AddObjectListener(
    game.Workspace.Killers,
    {
        ColorDynamic = function()
            return options.killerESPColor.Value
        end,
        Type = "Model",
        PrimaryPart = function(obj)
            local hrp = obj.PrimaryPart
            return hrp
        end,
        CustomName = function(obj)
            return obj.Name
        end,
        IsEnabled = "Killers"
    }
)

-- // Initialize ESP
ESP.Players = false

ESP:Toggle(true)

-- // AC Bypasses
local function disableWalkSpeedAc(char)
    local humanoid = char:WaitForChild("Humanoid", 3)
    local walkSpeedConnections = getconnections(humanoid:GetPropertyChangedSignal("WalkSpeed"))

    for _, conn in pairs(walkSpeedConnections) do
        print("disabled")
        conn:Disable()
    end
end

local function setAllDoorsToState(state)
    for _, v in ipairs(game:GetService("Workspace").Doors:GetDescendants()) do
        if v.Name == state then
            fireclickdetector(v.ClickDetector, math.huge)
        end
    end
end

disableWalkSpeedAc(localPlayer.Character)
localPlayer.CharacterAdded:Connect(
    function(char)
        char:WaitForChild("Humanoid", 3).Died:Connect(
            function()
                task.wait(players.RespawnTime + 1)
                disableWalkSpeedAc(localPlayer.Character)
                print("hello")
            end
        )
    end
)

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

-- // Functions
local guns = {}
local gunKeys = {}

for _, v in ipairs(game.Workspace:GetDescendants()) do
    if string.find(v.Name, "Giver") and v:FindFirstChild("PUT THE WEAPON IN THIS BRICK") and v.Parent then
        guns[v.Parent.Name] = v["PUT THE WEAPON IN THIS BRICK"]
        table.insert(gunKeys, v.Parent.Name)
    end
end

table.sort(gunKeys)

local function getGun(gunName)
    local touchPart = guns[gunName]
    if touchPart then
        firetouchinterest(touchPart, localPlayer.Character.HumanoidRootPart, 0)
    end
end

local function modGun(props)
    for _, v in pairs(getgc()) do
        if type(v) == "function" then
            local upvalues = debug.getupvalues(v)
            for _, v2 in pairs(upvalues) do
                if type(v2) == "table" and rawget(v2, "ammo") then
                    for key, value in pairs(props) do
                        v2[key] = value
                    end
                end
            end
        end
    end
end

local Window = Library:CreateWindow("Floppa Hub")
do
    local playerTab = Window:AddTab("Player")
    do
        local characterSec = playerTab:AddLeftTabbox():AddTab("Character")
        do
            characterSec:AddSlider(
                "plrWalkspeed",
                {Text = "WalkSpeed", Default = 16, Min = 16, Max = 500, Rounding = 1}
            ):OnChanged(
                function()
                    if localPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
                        localPlayer.Character.Humanoid.WalkSpeed = options.plrWalkspeed.Value
                    end
                end
            )
            characterSec:AddSlider(
                "plrJumpPower",
                {Text = "JumpPower", Default = 50, Min = 50, Max = 500, Rounding = 1}
            ):OnChanged(
                function()
                    if localPlayer.Character:FindFirstChildWhichIsA("Humanoid") then
                        localPlayer.Character.Humanoid.JumpPower = options.plrJumpPower.Value
                    end
                end
            )

            characterSec:AddToggle("infJump", {Text = "Infinite Jump", Default = false}):OnChanged(
                function()
                    local state = flags.infJump.Value

                    if state then
                        connections.infJump =
                            game:GetService("UserInputService").JumpRequest:Connect(
                            function()
                                game.Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):ChangeState(
                                    "Jumping"
                                )
                            end
                        )
                    else
                        if connections.infJump ~= nil then
                            connections.infJump:Disconnect()
                        end
                    end
                end
            )
        end
        local secretsSec = playerTab:AddRightTabbox():AddTab("Secrets")
        do
            secretsSec:AddButton(
                "Get All Papers",
                function()
                    pcall(
                        function()
                            for _, v in ipairs(game.Workspace:GetDescendants()) do
                                if v.Name == "Paper" and v:FindFirstChild("PUT THIS IN THE WEAPON") then
                                    firetouchinterest(v, localPlayer.Character.HumanoidRootPart, 0)
                                end
                            end
                        end
                    )
                end
            )
            secretsSec:AddButton(
                "Get All Badges",
                function()
                    pcall(
                        function()
                            for _, v in ipairs(game:GetService("Workspace").AREA51.Badges:GetDescendants()) do
                                if v.Name == "Badge Giver" then
                                    firetouchinterest(v.Parent, localPlayer.Character.HumanoidRootPart, 0)
                                end
                            end
                        end
                    )
                end
            )
            secretsSec:AddButton(
                "Find All Paths",
                function()
                    for _, v in ipairs(game:GetService("Workspace").AREA51.Badges:GetDescendants()) do
                        if string.find(v.Name, "SecretPath") and v:FindFirstChild("Reward") then
                            firetouchinterest(v.Reward, localPlayer.Character.HumanoidRootPart, 0)
                        end
                    end
                end
            )
            secretsSec:AddButton(
                "Complete Checklist",
                function()
                    pcall(
                        function()
                            for _, v in ipairs(game:GetService("Workspace").AREA51.Badges:GetDescendants()) do
                                if v.Name == "Badge Giver" then
                                    firetouchinterest(v.Parent, localPlayer.Character.Torso, 0)
                                end
                            end
                            for _, v in ipairs(game:GetService("Workspace").AREA51:GetDescendants()) do
                                if v:FindFirstChild("Reward") then
                                    firetouchinterest(v.Reward, game.Players.LocalPlayer.Character.Torso, 0)
                                end
                            end
                            for _, v in ipairs(game.Workspace:GetDescendants()) do
                                if v.Name == "Paper" and v:FindFirstChild("PUT THIS IN THE WEAPON") then
                                    firetouchinterest(v, localPlayer.Character.Torso, 0)
                                end
                            end
                            for _, gun in ipairs(gunKeys) do
                                getGun(gun)
                            end
                            task.wait(0.6)
                            game.ReplicatedStorage["Remote Functions"]["PAP Weapon"]:InvokeServer("MP5k")
                            game:GetService("ReplicatedStorage")["Remote Events"].PAPFinished:FireServer()
                            task.wait(0.2)
                            firetouchinterest(
                                game:GetService("Workspace").AREA51.RadioactiveArea.GiantZombieRoom.GiantZombieEngine.Close.Door2,
                                game.Players.LocalPlayer.Character.Torso,
                                0
                            )
                            firetouchinterest(
                                game:GetService("Workspace").AREA51.Outside.Hangar.Right["Zombie Morph"].TheButton,
                                game.Players.LocalPlayer.Character.Torso,
                                0
                            )
                            firetouchinterest(
                                game:GetService("Workspace").AREA51.PlantRoom["Box of Shells"].Box,
                                game.Players.LocalPlayer.Character.Torso,
                                0
                            )
                        end
                    )
                end
            )
        end
    end

    local combatTab = Window:AddTab("Combat")
    do
        local gunsTabBox = combatTab:AddLeftTabbox()
        do
            local getGunsSection = gunsTabBox:AddTab("Guns")
            do
                getGunsSection:AddDropdown(
                    "selectedGun",
                    {Text = "Select Gun To Grab", Default = gunKeys[1].Name, Values = gunKeys}
                )
                getGunsSection:AddButton(
                    "Get Selected Gun",
                    function()
                        local selectedGun = options.selectedGun.Value
                        if selectedGun then
                            getGun(selectedGun)
                        end
                    end
                )
                getGunsSection:AddButton(
                    "Get All Guns",
                    function()
                        for _, gun in ipairs(gunKeys) do
                            getGun(gun)
                        end
                    end
                )
            end

            local gunModsSection = gunsTabBox:AddTab("Gun Mods")
            do
                local firstTime = true

                pcall(
                    function()
                        gunModsSection:AddToggle("automatic", {Text = "Automatic", Default = false}):OnChanged(
                            function()
                                local state = flags.automatic.Value
                                if state then
                                    modGun({is_auto = true})
                                else
                                    if firstTime then
                                        firstTime = false
                                        return
                                    end
                                    modGun({is_auto = false})
                                end
                            end
                        )
                        gunModsSection:AddToggle("infAmmo", {Text = "Infinite Ammo", Default = false}):OnChanged(
                            function()
                                local state = flags.infAmmo.Value
                                if state then
                                    modGun({ammo = math.huge, max_ammo = math.huge, stored_ammo = math.huge})
                                else
                                    if firstTime then
                                        firstTime = false
                                        return
                                    end
                                    modGun({ammo = 100, max_ammo = 100, stored_ammo = 100})
                                end
                            end
                        )
                        gunModsSection:AddToggle("noEquipTime", {Text = "Instant Equip", Default = false}):OnChanged(
                            function()
                                local state = flags.noEquipTime.Value
                                if state then
                                    modGun({equip_time = 0})
                                else
                                    if firstTime then
                                        firstTime = false
                                        return
                                    end
                                    modGun({equip_time = 0.1})
                                end
                            end
                        )
                        gunModsSection:AddToggle("fireRate", {Text = "Fast Fire Rate", Default = false}):OnChanged(
                            function()
                                local state = flags.fireRate.Value
                                if state then
                                    modGun({shoot_wait = 0.000000000000000000000000000000000000000000001})
                                else
                                    if firstTime then
                                        firstTime = false
                                        return
                                    end
                                    modGun({shoot_wait = 0.1})
                                end
                            end
                        )
                    end
                )
            end
        end
        local trollingSec = combatTab:AddRightTabbox():AddTab("Trolling")
        do
            trollingSec:AddButton(
                "Open All Doors",
                function()
                    setAllDoorsToState("Open")
                end
            )
            trollingSec:AddButton(
                "Close All Doors",
                function()
                    setAllDoorsToState("Close")
                end
            )
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
                espSec:AddToggle("killerESP", {Text = "Killer ESP", Default = false}):OnChanged(
                    function()
                        ESP.Killers = flags.killerESP.Value
                    end
                )
                flags.killerESP:AddColorPicker("killerESPColor", {Default = Color3.new(0.019607, 0.639215, 1)})
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
end

Library:Notify("Loaded UI!")

-- // Event Listeners

-- /// UI Listeners
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

-- /// Game Listeners
game:GetService("CoreGui").ChildRemoved:Connect(
    function(child)
        if child.Name == "ScreenGui" then
            ESP:Toggle(false)
        end
    end
)
