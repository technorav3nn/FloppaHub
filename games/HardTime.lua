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

-- // Player Variables
local localPlayer = game.Players.LocalPlayer

-- // Bypass Anti Cheat
pcall(
    function()
        game:GetService("Players").LocalPlayer.Backpack.Local.Dead:Destroy()
    end
)

--#region Functions
local function getAllRobberyStatuses()
    local robberies = {}
    for _, v in ipairs(game.Workspace:GetChildren()) do
        if v.Name == "Start Robbery" then
            local robberyName = v.Head:FindFirstChildOfClass("Script").Name

            local isRobberyOpen = v.BillboardGui.Text.Text == "Start Robbery"
            local isRobberyClosed = v.BillboardGui.Text.Text:find("Cool")
            local isRobberyInProgress = v.BillboardGui.Text.Text:find("Progress")

            local status = ""

            if isRobberyInProgress then
                status = "Robbery In Progress"
            elseif isRobberyClosed then
                status = "Closed"
            elseif isRobberyOpen then
                status = "Open"
            else
                status = "Unknown"
            end

            robberies[robberyName] = status
        end
    end
    return robberies
end

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

local function sellAllItems()
    fireclickdetector(game:GetService("Workspace")["Sell Items"].Head.ClickDetector)
    task.wait(1.2)
    local pawnShopButtons = game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("PawnGUI")
    if pawnShopButtons then
        for _, v in ipairs(game:GetService("Players").LocalPlayer.PlayerGui.PawnGUI.Frame.Frame:GetChildren()) do
            if v:IsA("TextButton") then
                print("hello")
                mousemoveabs(v.Confirm.AbsolutePosition.X + 40, v.Confirm.AbsolutePosition.Y + 50)
                task.wait(0.2)
                mousemoverel(0, 3)
                task.wait(0.1)
                mouse1click()
                task.wait(0.1)
            end
        end

        local closeButton = game:GetService("Players").LocalPlayer.PlayerGui.PawnGUI.Frame.TextButton
        mousemoveabs(closeButton.AbsolutePosition.X + 40, closeButton.AbsolutePosition.Y + 50)
        mousemoverel(0, 3)
        mouse1click()
        task.wait()
        mousemoveabs(500, 500)
    end
end

local function collectNearbyCash()
    for _, v in ipairs(game.Workspace:GetChildren()) do
        if
            v.Name == "Cash" and
                (v.Part.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <=
                    tonumber(v.Part:FindFirstChildOfClass("ClickDetector").MaxActivationDistance)
         then
            fireclickdetector(v.Part:FindFirstChildOfClass("ClickDetector"), math.huge)
        elseif
            v.Name == "ATM" and
                (v.Main.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude <=
                    tonumber(v.Main.Two:FindFirstChildOfClass("ClickDetector").MaxActivationDistance)
         then
            fireclickdetector(v.Main.One.ClickDetector, math.huge)
            fireclickdetector(v.Main.Two.ClickDetector, math.huge)
        end
    end
end

local function getAllCash()
    local ret = {}
    for _, v in ipairs(game.Workspace:GetChildren()) do
        if v.Name == "Cash" and not v.PickedUp.Value then
            table.insert(ret, v)
        end
    end
    return ret
end

local function getMyCar()
    local car = game.Workspace:FindFirstChild(string.format("%ssCar", localPlayer.Name))
    if car then
        return car
    end
end

local function tpPlayer(cf, exitCar)
    local car = getMyCar()
    if not car then
        return
    end
    car:SetPrimaryPartCFrame(cf + Vector3.new(0, 3, 0))
    if exitCar then
        localPlayer.Character.Humanoid.Jump = true
    end
end

local function openAllPresents()
    for _, v in ipairs(game.Workspace.Presents:GetChildren()) do
        if not Library.flags.autoPresent then
            break
        end
        if v.Name == "Present" and v.Transparency ~= 1 then
            if Library.flags.sellAllItemsWhenFarm then
                sellAllItems()
            end
            tpPlayer(v.CFrame + Vector3.new(0, 2, 0), false)
            task.wait(0.4)
            getMyCar().PrimaryPart.Anchored = true
            fireclickdetector(v.ClickDetector, math.huge)
            task.wait(0.6)
            getMyCar().PrimaryPart.Anchored = false
        end
    end
end

local function startCashFarm()
    for _, v in ipairs(getAllCash()) do
        if not Library.flags.autoCollectDroppedCash then
            break
        end
        tpPlayer(v.Part.CFrame + Vector3.new(0, 2, 0), false)
        task.wait(0.2)
        fireclickdetector(v.Part.Click, math.huge)
        task.wait(0.2)
    end
end

local function startAtmFarm()
    for _, v in ipairs(workspace:GetChildren()) do
        if not Library.flags.autoATM then
            break
        end
        if v.Name == "ATM" and v.BillboardGui.Enabled then
            pcall(
                function()
                    tpPlayer(v.ClickPart.CFrame + Vector3.new(0, 2, 0), false)
                    task.wait(0.3)
                    fireclickdetector(v.ClickPart.ClickDetector, math.huge)
                    task.wait(1.2)
                    collectNearbyCash()
                    task.wait(0.3)
                end
            )
        end
    end
end

local function startDumpsterFarm()
    for _, v in ipairs(workspace:GetChildren()) do
        if not Library.flags.autoDumpsters then
            break
        end
        if v.Name == "SearchableDumpster" and v.Closed.Value then
            pcall(
                function()
                    tpPlayer(v.Union.CFrame + Vector3.new(0, 2, 0), false)
                    task.wait(0.3)
                    fireclickdetector(v.ClickPart.Click, math.huge)
                    if Library.flags.sellAllItemsWhenFarm then
                        sellAllItems()
                    end
                    task.wait(2.1)
                end
            )
        end
    end
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
        local jobFarmingSec = farmingTab:CreateSector("Job Farming", "left")
        do
            jobFarmingSec:AddToggle(
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
        end
        local collectableFarmingSec = farmingTab:CreateSector("Collectable Farming", "left")
        do
            collectableFarmingSec:AddToggle(
                "Present Farm (Car)",
                false,
                function()
                    if not getMyCar() then
                        return
                    end
                    task.spawn(
                        function()
                            while Library.flags.autoPresent do
                                openAllPresents()
                                task.wait(2)
                            end
                        end
                    )
                end,
                "autoPresent"
            )
            collectableFarmingSec:AddToggle(
                "Dumpster Farm (Car)",
                false,
                function()
                    if not getMyCar() then
                        return
                    end
                    task.spawn(
                        function()
                            while Library.flags.autoDumpsters do
                                startDumpsterFarm()
                                task.wait(2)
                            end
                        end
                    )
                end,
                "autoDumpsters"
            )
        end
        local cashFarmingSec = farmingTab:CreateSector("Cash Farming", "left")
        do
            cashFarmingSec:AddToggle(
                "ATM Farm (Car)",
                false,
                function()
                    if not getMyCar() then
                        return
                    end
                    task.spawn(
                        function()
                            while Library.flags.autoATM do
                                startAtmFarm()
                                task.wait(2)
                            end
                        end
                    )
                end,
                "autoATM"
            )
            cashFarmingSec:AddToggle(
                "Dropped Cash Farm (Car)",
                false,
                function()
                    if not getMyCar() then
                        return
                    end
                    task.spawn(
                        function()
                            while Library.flags.autoCollectDroppedCash do
                                startCashFarm()
                                task.wait(2)
                            end
                        end
                    )
                end,
                "autoCollectDroppedCash"
            )
        end
        local miscSec = farmingTab:CreateSector("Misc", "left")
        do
            miscSec:AddToggle(
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
            miscSec:AddToggle(
                "Sell All Items When Farm",
                false,
                function()
                end,
                "sellAllItemsWhenFarm"
            )
            miscSec:AddButton(
                "Sell All Items",
                function()
                    sellAllItems()
                end
            )
        end
        local robberyStatusSec = farmingTab:CreateSector("Robbery Statuses", "right")
        do
            local labels = {}
            for k, v in pairs(getAllRobberyStatuses()) do
                labels[k] = robberyStatusSec:AddLabel(string.format("%s: %s", k, v))
            end
            task.spawn(
                function()
                    while task.wait(3) do
                        for k, v in pairs(getAllRobberyStatuses()) do
                            labels[k]:Set((string.format("%s: %s", k, v)))
                        end
                    end
                end
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
