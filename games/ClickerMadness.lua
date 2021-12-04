if not game:IsLoaded() then
    game.Loaded:Wait()
end

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local player = players.LocalPlayer

-- // Modules
local clickingModule = require(players.LocalPlayer.PlayerScripts.Aero.Controllers.UI.Click)
local normalUpgradesMod = require(game:GetService("ReplicatedStorage").Aero.Shared.List.Upgrades)
local superUpgradesMod = require(game:GetService("ReplicatedStorage").Aero.Shared.List.SuperUpgrades)

local playerChar = player.Character or player.Character:Wait()

local function safeLoadstring(name, url)
    local success, content = pcall(game.HttpGet, game, url)
    if (not success) then
        player:Kick(string.format("Failed to load library (%s). HttpError: %s", name, content))
        return function()
            wait(9e9)
        end
    end

    local func, err = loadstring(content)
    if (not func) then
        player:Kick(string.format("Failed to load library (%s). SyntaxError: %s", name, err))
        return function()
            wait(9e9)
        end
    end

    return func
end

local function removeDuplicateGuis()
    for _, v in ipairs(game.CoreGui:GetChildren()) do
        if v.Name == "ScreenGui" then
            v:Destroy()
        end
    end
end

local function sendNotification(opts)
    local CoreGui = game:GetService("StarterGui")

    CoreGui:SetCore(
        "SendNotification",
        {
            Title = opts.title and opts.title or "No title",
            Text = opts.text and opts.text or "No Text",
            Duration = opts.duration and opts.duration or opts.duration
        }
    )
end

local function getAllEggNames()
    local eggCapsuleFolder = game:GetService("Workspace").EggCapsules
    local eggs = {}

    for _, egg in pairs(eggCapsuleFolder:GetChildren()) do
        if egg:IsA("Model") and egg.Name == "Capsule" then
            if egg.EggID then
                table.insert(eggs, egg.EggID.Value)
            end
        end
    end

    return eggs
end

local function getAllWorldTeleports()
    local worldsFolder = game:GetService("Workspace").Worlds
    local allWorlds = {}
    for _, world in pairs(worldsFolder:GetChildren()) do
        local worldTpPart = world.Teleport
        allWorlds[world.Name] = worldTpPart.CFrame
    end
    return allWorlds
end

removeDuplicateGuis()

local library = safeLoadstring("UI", "https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua")()

local eggList = getAllEggNames()
local worldList = getAllWorldTeleports()

local worldListKeys = {}
for k, _ in pairs(worldList) do
    worldListKeys[k] = k
end

local mainWindow = library:CreateWindow("Floppa Hub - CM")
do
    local autoFarmFolder = mainWindow:AddFolder("Farming")
    do
        autoFarmFolder:AddToggle(
            {
                text = "Auto Click",
                flag = "autoClick"
            }
        )

        autoFarmFolder:AddToggle(
            {
                text = "Auto Boss",
                flag = "autoBoss"
            }
        )
        autoFarmFolder:AddToggle(
            {
                text = "Auto Hill",
                flag = "autoHill"
            }
        )
        autoFarmFolder:AddToggle(
            {
                text = "Auto Attack Players",
                flag = "autoAttack"
            }
        )
        autoFarmFolder:AddToggle(
            {
                text = "Auto Collect Pickups",
                flag = "autoPickup"
            }
        )
    end
    local rebirthFolder = mainWindow:AddFolder("Rebirths")
    do
        rebirthFolder:AddList(
            {
                value = "Choose",
                values = {1, 10, 100, 1000, 10000, 100000, 1000000000, 10000000000},
                text = "Rebirth Amount",
                flag = "rebirthAmount"
            }
        )
        rebirthFolder:AddToggle(
            {
                text = "Start Rebirthing",
                flag = "startRebirth"
            }
        )
    end
    local eggFolder = mainWindow:AddFolder("Pets")
    do
        eggFolder:AddList(
            {
                values = eggList,
                text = "Choose Egg",
                flag = "eggChosen"
            }
        )
        eggFolder:AddToggle(
            {
                text = "Start Opening",
                flag = "startEgg"
            }
        )
        eggFolder:AddDivider()
        eggFolder:AddToggle(
            {
                text = "Auto Combine Pets",
                flag = "autoCombine"
            }
        )
    end
    local upgradesFolder = mainWindow:AddFolder("Upgrades")
    do
        upgradesFolder:AddLabel({text = "Normal Upgrades"})
        upgradesFolder:AddDivider()

        for upgradeName, upgrade in pairs(normalUpgradesMod) do
            upgradesFolder:AddToggle(
                {
                    text = upgrade.Name,
                    callback = function(bool)
                        task.spawn(
                            function()
                                _G["normUp" .. upgradeName] = bool
                                while _G["normUp" .. upgradeName] do
                                    task.wait()
                                    print("Upgrade enabled")
                                    local ohString1 = upgradeName
                                    game:GetService("ReplicatedStorage").Aero.AeroRemoteServices.UpgradeService.BuyUpgrade:FireServer(
                                        ohString1
                                    )
                                end
                            end
                        )
                    end
                }
            )
        end
        upgradesFolder:AddDivider()
        upgradesFolder:AddLabel({text = "Super Upgrades"})
        upgradesFolder:AddDivider()
        for upgradeName, upgrade in pairs(superUpgradesMod) do
            upgradesFolder:AddToggle(
                {
                    text = upgrade.Name,
                    callback = function(bool)
                        task.spawn(
                            function()
                                _G["superUp" .. upgradeName] = bool
                                while _G["superUp" .. upgradeName] do
                                    task.wait()
                                    local ohString1 = upgradeName

                                    game:GetService("ReplicatedStorage").Aero.AeroRemoteServices.SuperUpgradeService.BuyUpgrade:FireServer(
                                        ohString1
                                    )
                                end
                            end
                        )
                    end
                }
            )
        end
    end
    local playerFolder = mainWindow:AddFolder("Player")
    do
        playerFolder:AddSlider(
            {
                text = "Walkspeed",
                min = 16,
                max = 500,
                default = 16,
                callback = function(value)
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
                end
            }
        )
        playerFolder:AddSlider(
            {
                text = "JumpPower",
                min = 50,
                max = 500,
                default = 50,
                callback = function(value)
                    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
                end
            }
        )
        playerFolder:AddSlider(
            {
                text = "HipHeight",
                min = 0,
                max = 500,
                default = 0,
                callback = function(value)
                    game.Players.LocalPlayer.Character.Humanoid.HipHeight = value
                end
            }
        )
    end
    local teleportsFolder = mainWindow:AddFolder("Teleports")
    do
        local teleportsList
        teleportsList =
            teleportsFolder:AddList(
            {
                text = "World Teleports",
                values = worldListKeys,
                callback = function(value)
                    teleportsList.open = false
                    local worldPartCFrame = worldList[value]
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = worldPartCFrame
                end
            }
        )
    end
end

runService.Heartbeat:Connect(
    function()
        if library.flags.autoClick then
            clickingModule:Click()
        end
        if library.flags.autoBoss then
            local ohString1 = "Karen Keyboard"
            game:GetService("ReplicatedStorage").Aero.AeroRemoteServices.CursorCannonService.FireBoss:FireServer(
                ohString1
            )
        end
        if library.flags.startRebirth then
            local chosen
            if library.flags.rebirthAmount == "Choose" then
                chosen = 1
            else
                chosen = library.flags.rebirthAmount
            end
            local ohNumber1 = tonumber(chosen)

            game:GetService("ReplicatedStorage").Aero.AeroRemoteServices.RebirthService.BuyRebirths:FireServer(
                ohNumber1
            )
        end
        if library.flags.startEgg then
            local chosenEgg = library.flags.eggChosen

            local ohString1 = chosenEgg
            game:GetService("ReplicatedStorage").Aero.AeroRemoteServices.EggService.Purchase:FireServer(ohString1)
        end
        if library.flags.autoHill then
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(547, 33, -172)
        end
        if library.flags.autoAttack then
            for _, plr in pairs(game:GetService("Players"):GetChildren()) do
                if plr.Name ~= player.Name then
                    local ohInstance1 = game:GetService("Players")[plr.Name]

                    game:GetService("ReplicatedStorage").Aero.AeroRemoteServices.CursorCannonService.FireCursor:FireServer(
                        ohInstance1
                    )
                    runService.Heartbeat:Wait()
                end
            end
        end
        if library.flags.autoPickup then
            local pickupFolderPath = game:GetService("Workspace").ScriptObjects
            for _, v in pairs(pickupFolderPath:GetChildren()) do
                if v.Name == "BasePickup" and v:IsA("Model") then
                    local touchInterestParent = v.HumanoidRootPart
                    firetouchinterest(playerChar.HumanoidRootPart, touchInterestParent, 0)
                    runService.Heartbeat:Wait()
                end
            end
        end
        if library.flags.autoCombine then
            runService.Heartbeat:Wait()
            local mainPetWindow = game:GetService("Players").LocalPlayer.PlayerGui.Pets.Main.Content.Main
            for _, petGui in pairs(mainPetWindow:GetDescendants()) do
                if petGui:IsA("ImageButton") and petGui.Name == "Craft" and petGui.Visible then
                    for _, conn in pairs(getconnections(petGui.MouseButton1Down)) do
                        conn:Fire()
                    end
                end
            end
        end
    end
)

library:Init()
