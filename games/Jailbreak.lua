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
local Keys, Network =
    loadstring(
    game:HttpGet(
        "https://gist.githubusercontent.com/technorav3nn/53b385abeea871dce26b413b6eba63c5/raw/0ea5372431094186339f07dbbab4edb746d381c5/jb_key_dumper_(THANKS%2520Introvert1337).lua"
    )
)()

-- // Services
local runService = game:GetService("RunService")
local replicatedStorage = game:GetService("ReplicatedStorage")
local players = game:GetService("Players")

-- /// Game Services
local notifService = require(game:GetService("ReplicatedStorage").Game.Notification)

-- // Variables
local localPlayer = players.LocalPlayer

-- // Tables
local connections = {}
local functions = {}
local hashes = {
    grabItem = "b34pkmn5",
    dropCash = "ex9xtqda",
    launchNuke = "gqkf0iai"
}

for hashName, hash in pairs(hashes) do
    Keys[hashName] = hash
end

-- // RunService Variables
local renderStepped = runService.RenderStepped

-- // UI Library Variables
local flags = getgenv().Toggles
local options = getgenv().Options

-- // Modules
local gunShopData = require(game:GetService("ReplicatedStorage").Game.GunShop.Data.Held)

-- // Disable ESP and other stuff on load
ESP.Players = false

ESP.Tracers = false
ESP.Boxes = true
ESP.Names = true

ESP:Toggle(true)

-- // Watermark and Notification
Library:SetWatermark("Floppa Hub")
Library:Notify("Loading UI...")

-- // ESP Listeners
-- /// ESP:AddObjectListener()

-- // Initialize ESP
ESP.Players = false

ESP:Toggle(true)

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
local function sendNotification(message, duration)
    notifService.new(
        {
            Text = message or "Hello, world!",
            Duration = duration or 4
        }
    )
end

-- // Grab Gun From GunShop
local guns = {}
for _, allGuns in pairs(gunShopData) do
    for _, gun in pairs(allGuns) do
        table.insert(guns, gun)
    end
end

local function grabGun(name)
    for _, allGuns in pairs(gunShopData) do
        for _, gun in pairs(allGuns) do
            if gun == name then
                Network:FireServer(hashes.grabItem, name)
                break
            end
        end
    end
end

-- // UI
sendNotification("Floppa Hub Loaded!\n(Press LeftShift to show UI)", 4)

local Window = Library:CreateWindow("Floppa Hub")
do
    local playerTab = Window:AddTab("Player")
    do
    end

    local combatTab = Window:AddTab("Combat")
    do
        local weaponsTabBox = combatTab:AddRightTabbox()
        do
            local gunsTabBox = weaponsTabBox:AddTab("Guns")
            do
                gunsTabBox:AddDropdown("gunChosen", {Text = "Grab Gun", Default = guns[1], Values = guns})
                gunsTabBox:AddButton(
                    "Grab Chosen",
                    function()
                        local chosenGun = options.gunChosen.Value
                        grabGun(chosenGun)
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

    local trollingTab = Window:AddTab("Trolling")
    do
    end

    local miscTab = Window:AddTab("Miscellaneous")
    do
    end

    local settingsTab = Window:AddTab("Settings")
    do
        local themeSec = settingsTab:AddLeftGroupbox("Theme")
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
