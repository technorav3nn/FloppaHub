-- // Destroy excess GUIS
--for _, v in pairs(game:GetService("CoreGui"):GetChildren()) do
--    if v:FindFirstChild("MainFrameHolder") then
--        v:Destroy()
--    end
--end

-- // Flag System
local flags = {
    robbableColor = Color3.fromRGB(21, 255, 0),
    dumpsterColor = Color3.fromRGB(255, 0, 234),
    presentColor = Color3.fromRGB(255, 0, 0)
}
function flags:SetFlag(name, value)
    flags[name] = value
end

-- // ESP Library and UI
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local Library = loadstring(game:HttpGet("https://pastebin.com/raw/PTrFUueU"))()

-- // UI Theme
Library.theme.accentcolor = Color3.new(0.011764, 0.521568, 1)
Library.theme.background = "rbxassetid://2151741365"
Library.theme.tilesize = 0.77
Library.theme.accentcolor2 = Color3.new(0.011764, 0.521568, 1)
Library.theme.backgroundcolor = Color3.fromRGB(20, 20, 20)

-- // Bypass Anti Cheat
pcall(
    function()
        game:GetService("Players").LocalPlayer.Backpack.Local.Dead:Destroy()
    end
)

--#region Functions
local function removeDuplicates(arr)
    local newArray = {}
    local checkerTbl = {}
    for _, element in ipairs(arr) do
        if not checkerTbl[element] then
            checkerTbl[element] = true
            table.insert(newArray, element)
        end
    end
    return newArray
end

local function getAllBuyables()
    local items = {}
    local itemNames = {}

    for _, v in ipairs(game.Workspace:GetChildren()) do
        if string.find(v.Name, " | ") or string.find(v.Name, "| ") then
            table.insert(items, v)
            table.insert(itemNames, v.Name)
        end
    end
    return items, itemNames
end

local function getAllAmmoBuyables()
    local buyables, buyableNames = getAllBuyables()

    local ammoBuyables = {}
    local ammoBuyableNames = {}

    for _, buyable in ipairs(buyables) do
        if string.find(buyable.Name, "Ammo") then
            table.insert(ammoBuyables, buyable)
            table.insert(ammoBuyableNames, buyable.Name)
        end
    end
    return ammoBuyables, ammoBuyableNames
end

--#endregion

-- // Item Variables
local items, itemNames = getAllBuyables()
local ammoItems, ammoItemNames = getAllAmmoBuyables()

-- // Sorting the items
itemNames = removeDuplicates(itemNames)
ammoItemNames = removeDuplicates(ammoItemNames)

table.sort(itemNames)
table.sort(ammoItemNames)

-- // ESP Listeners
if game:GetService("Workspace"):FindFirstChild("Presents") then
    ESP:AddObjectListener(
        game:GetService("Workspace").Presents,
        {
            ColorDynamic = function()
                return flags.presentColor
            end,
            Validator = function(obj)
                return obj:FindFirstChild("ClickPresent") and (obj.Name == "Present" or obj.Name == "BluePresent")
            end,
            PrimaryPart = function(obj)
                return obj
            end,
            CustomName = "Present Spawn",
            IsEnabled = "Presents"
        }
    )
end

ESP:AddObjectListener(
    game:GetService("Workspace"),
    {
        ColorDynamic = function()
            return flags.dumpsterColor
        end,
        Validator = function(obj)
            return obj:FindFirstChild("Closed")
        end,
        PrimaryPart = function(obj)
            return obj:FindFirstChild("Union")
        end,
        IsEnabled = "Dumpsters"
    }
)

ESP:AddObjectListener(
    game:GetService("Workspace"),
    {
        ColorDynamic = function()
            return flags.robbableColor
        end,
        Validator = function(obj)
            return obj.Name == "ATM" or obj.Name == "Cash Register"
        end,
        PrimaryPart = function(obj)
            return obj.HumanoidRootPart
        end,
        IsEnabled = "Robbables",
        CustomName = function(obj)
            return string.format("Robbable %s", obj.Name)
        end
    }
)

-- // Initialize ESP
ESP.Players = false
ESP.Robbables = false
ESP.Dumpsters = false
ESP.Presents = false

ESP:Toggle(true)

-- // UI Components
local Window = Library:CreateWindow("Floppa Hub", Vector2.new(492, 598), Enum.KeyCode.RightShift)
do
    local playerTab = Window:CreateTab("Player")
    do
        local playerCombatSec = playerTab:CreateSector("Combat", "left")
        do
            playerCombatSec:AddToggle(
                "Auto Stomp",
                false,
                function(bool)
                    task.spawn(
                        function()
                            while Library.flags.autoStomp and task.wait() do
                                game:GetService("ReplicatedStorage").Events.GunEvent:FireServer("EPress")
                            end
                        end
                    )
                end
            )
        end
        local playerMovementSec = playerTab:CreateSector("Movement", "left")
        do
            playerMovementSec:AddSlider(
                "WalkSpeed",
                16,
                16,
                400,
                1,
                function(value)
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
                end,
                "playerWalkspeed"
            )
            playerMovementSec:AddSlider(
                "JumpPower",
                50,
                50,
                200,
                1,
                function(value)
                    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
                end,
                "playerJumpPower"
            )
        end
    end
    local farmingTab = Window:CreateTab("Farming")
    do
        local moneyFarmingSec = farmingTab:CreateSector("Money Farming", "left")
        do
            moneyFarmingSec:AddToggle(
                "Auto Collect Trash Job",
                false,
                function()
                    local startEndJob = game:GetService("Workspace")["Start/ End Job"].Head.ClickDetector

                    task.spawn(
                        function()
                            while Library.flags.autoCollectTrash do
                                if not Library.flags.autoCollectTrash then
                                    break
                                end
                                fireclickdetector(startEndJob, math.huge)
                                for _, v in ipairs(game.Workspace:GetChildren()) do
                                    if not Library.flags.autoCollectTrash then
                                        break
                                    end
                                    if v.Name == "MoneyTrash" then
                                        fireclickdetector(v:FindFirstChildOfClass("ClickDetector", true), math.huge)
                                    end
                                end
                                fireclickdetector(startEndJob, math.huge)
                                task.wait(5)
                            end
                        end
                    )
                end,
                "autoCollectTrash"
            )
            moneyFarmingSec:AddToggle(
                "Money Collect Aura",
                false,
                function()
                    task.spawn(
                        function()
                            while Library.flags.moneyCollectAura do
                                for _, v in ipairs(game.Workspace:GetChildren()) do
                                    if
                                        v.Name == "Cash" and
                                            (v.Part.Position -
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <=
                                                tonumber(
                                                    v.Part:FindFirstChildOfClass("ClickDetector").MaxActivationDistance
                                                )
                                     then
                                        fireclickdetector(v.Part:FindFirstChildOfClass("ClickDetector"), math.huge)
                                    elseif
                                        v.Name == "ATM" and
                                            (v.Main.Position -
                                                game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <=
                                                tonumber(
                                                    v.Main.Two:FindFirstChildOfClass("ClickDetector").MaxActivationDistance
                                                )
                                     then
                                        fireclickdetector(v.Main.One.ClickDetector, math.huge)
                                        fireclickdetector(v.Main.Two.ClickDetector, math.huge)
                                    end
                                end
                                task.wait(1)
                            end
                        end
                    )
                end,
                "moneyCollectAura"
            )
        end
    end
    local buyingTab = Window:CreateTab("Buying")
    do
        local buyingItemsSec = buyingTab:CreateSector("Buying Items", "left")
        do
            buyingItemsSec:AddDropdown(
                "Choose Item & Buy",
                itemNames,
                "Cola | 20$",
                false,
                function(value)
                    local item = game.Workspace:FindFirstChild(value)
                    if value then
                        fireclickdetector(item.Head:FindFirstChildWhichIsA("ClickDetector", math.huge))
                    end
                end,
                "buyItem"
            )
        end

        local buyingAmmoSec = buyingTab:CreateSector("Buying Ammo", "Right")
        do
            buyingAmmoSec:AddDropdown(
                "Choose Ammo & Buy",
                ammoItemNames,
                "[30] Uzi Ammo | $30",
                false,
                function(value)
                    local item = game.Workspace:FindFirstChild(value)
                    if value then
                        fireclickdetector(item.Head:FindFirstChildWhichIsA("ClickDetector", math.huge))
                    end
                end,
                "buyAmmo"
            )
        end
    end
    local visualsTab = Window:CreateTab("Visuals")
    do
        local espSec = visualsTab:CreateSector("ESP", "left")
        do
            espSec:AddToggle(
                "Player ESP",
                false,
                function(bool)
                    ESP.Players = bool
                end
            ):AddColorpicker(
                ESP.Color,
                function(color)
                    ESP.Color = color
                end
            )
            if game:GetService("Workspace"):FindFirstChild("Presents") then
                espSec:AddToggle(
                    "Present ESP",
                    false,
                    function(bool)
                        ESP.Presents = bool
                    end
                ):AddColorpicker(
                    flags.presentColor,
                    function(color)
                        flags.presentColor = color
                    end
                )
            end
            espSec:AddToggle(
                "Robabble ESP",
                false,
                function(bool)
                    ESP.Robbables = bool
                end
            ):AddColorpicker(
                flags.robbableColor,
                function(color)
                    flags.robbableColor = color
                end
            )
            espSec:AddToggle(
                "Dumpster ESP",
                false,
                function(bool)
                    ESP.Dumpsters = bool
                end
            ):AddColorpicker(
                flags.dumpsterColor,
                function(color)
                    flags.dumpsterColor = color
                end
            )
            espSec:AddSeperator("ESP Options")
            espSec:AddToggle(
                "Tracers",
                false,
                function(bool)
                    ESP.Tracers = bool
                end
            )
            espSec:AddToggle(
                "Boxes",
                true,
                function(bool)
                    ESP.Boxes = bool
                end
            )
            espSec:AddToggle(
                "Names",
                true,
                function(bool)
                    ESP.Names = bool
                end
            )
        end
    end
end

-- // Remove gradient
if game:GetService("CoreGui")["Floppa Hub"].main.top:FindFirstChild("UIGradient") then
    game:GetService("CoreGui")["Floppa Hub"].main.top.UIGradient:Destroy()
end
game:GetService("CoreGui")["Floppa Hub"].main.top.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
