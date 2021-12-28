-- // Destroy excess GUIS
for _, v in ipairs(game.CoreGui:GetChildren()) do
    if v.Name == "ScreenGui" then
        v:Destroy()
    end
end

-- // UI Library and ESP
local Library =
    loadstring(game:HttpGet("https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua", true))()
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

-- // Services
local runService = game:GetService("RunService")
local players = game:GetService("Players")

-- // Variables
local localPlayer = players.LocalPlayer
local playerChar = localPlayer.Character or localPlayer.Character:Wait()

local flags = Library.flags

local tools = {}
local toolKeys = {}

--#region Game Funcs
local function getAllBuyables()
    local ret = {}
    local buttonsPath = game:GetService("Workspace").Buttons
    for _, button in ipairs(buttonsPath:GetChildren()) do
        if button:FindFirstChild("Button") then
            table.insert(ret, button)
        end
    end
    return ret
end

-- // Buyables Variable
local buyables = getAllBuyables()

for _, buyable in ipairs(buyables) do
    tools[buyable.ToolName.Value] = buyable
    table.insert(toolKeys, buyable.ToolName.Value)
end

local function firePrompt(prompt)
    prompt.RequiresLineOfSight = false

    prompt:InputHoldBegin()
    task.wait(prompt.HoldDuration)
    prompt:InputHoldEnd()

    prompt.RequiresLineOfSight = true
end

local function getAllRobbables()
    local robbables = game:GetService("Workspace").Robbable
    local ret = {}
    for _, v in ipairs(robbables:GetChildren()) do
        if v:FindFirstChild("Door") and v.Door.Attachment.ProximityPrompt.Enabled then
            table.insert(ret, v)
        end
    end
    return ret
end

local function collectNearCash()
    for _, v in ipairs(game.Workspace:GetChildren()) do
        if v.Name == "DroppedCash" and v:FindFirstChild("ProximityPrompt") and v.ProximityPrompt.Enabled then
            v.ProximityPrompt.RequiresLineOfSight = false
            fireproximityprompt(v.ProximityPrompt)
            task.wait(0.1)
        end
    end
end

local function tpPlayer(cf)
    localPlayer.Character.HumanoidRootPart.CFrame = cf
end

local function getAllLoot()
    local lootSpawners = game:GetService("Workspace").LootSpawns
    for _, loot in ipairs(lootSpawners:GetChildren()) do
        if loot.Part.Attachment.ProximityPrompt.Enabled then
            local prompt = loot.Part.Attachment.ProximityPrompt
            prompt.RequiresLineOfSight = false
            tpPlayer(loot.Part.CFrame)
            task.wait(0.4)
            fireproximityprompt(prompt, math.huge)
        end
    end
end
--#endregion

-- // RunService Variables
local heartBeat = runService.Heartbeat

-- // UI
local playerWindow = Library:CreateWindow("Player")
do
    local autoBuysFolder = playerWindow:AddFolder("Buys")
    do
        autoBuysFolder:AddList({text = "Choose Item", values = toolKeys, flag = "chosenItem"})
        autoBuysFolder:AddButton(
            {
                text = "Buy Chosen",
                callback = function()
                    local chosen = Library.flags.chosenItem
                    if chosen then
                        local tool = tools[chosen]
                        --- @type ProximityPrompt
                        local prompt = tool.Button.ProximityPrompt
                        local oldCframe = localPlayer.Character.HumanoidRootPart.CFrame
                        prompt.RequiresLineOfSight = false
                        tpPlayer(prompt.Parent.CFrame + Vector3.new(0, -1, 0))
                        localPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                        task.wait(0.5)
                        prompt:InputHoldBegin()
                        task.wait()
                        prompt:InputHoldEnd()
                        task.wait()
                        tpPlayer(oldCframe)
                        prompt.RequiresLineOfSight = true
                    end
                end
            }
        )
        autoBuysFolder:AddDivider()
        autoBuysFolder:AddList(
            {
                text = "Gun to buy ammo for",
                flag = "autoBuyAmmoGun",
                values = {"Spaz", "Glock", "AR", "Sawed", "Uzi", "Flare"}
            }
        )
        autoBuysFolder:AddButton(
            {
                text = "Buy ammo",
                callback = function()
                    local oldCf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(53.302879333496, -36.932140350342, -160.31660461426)
                    task.wait(0.2)
                    game:GetService("ReplicatedStorage").Events.GunEvent:FireServer("BuyAmmo", flags.autoBuyAmmoGun)
                    task.wait(0.2)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf
                end
            }
        )
    end
    local craftingFolder = playerWindow:AddFolder("Crafting")
    do
        craftingFolder:AddList(
            {text = "Gun to craft", flag = "chosenCraft", values = {"Spaz", "Glock", "AR", "Sawed", "Uzi", "Flare"}}
        )
        craftingFolder:AddButton(
            {
                text = "Craft Gun",
                callback = function()
                    local oldCf = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame =
                        CFrame.new(186.46301269531, 7.7288360595703, -113.45082092285)
                    task.wait(0.2)
                    game:GetService("ReplicatedStorage").Events.CraftEvent:FireServer(flags.chosenCraft .. "Frame")
                    task.wait(0.3)
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = oldCf
                end
            }
        )
    end
end
local farmingWindow = Library:CreateWindow("Farming")
do
    local moneyFolder = farmingWindow:AddFolder("Money Farming")
    do
        moneyFolder:AddToggle(
            {
                text = "Auto Money Bench",
                flag = "autoMoneyBench",
                callback = function()
                    if Library.flags.autoMoneyBench then
                        --- @type ProximityPrompt
                        local prompt = game:GetService("Workspace").MoneyBench.MainPart.Attachment.ProximityPrompt
                        tpPlayer(prompt.Parent.Parent.CFrame)
                        task.wait(0.2)
                        task.spawn(
                            function()
                                while Library.flags.autoMoneyBench and task.wait() do
                                    if not Library.flags.autoMoneyBench then
                                        break
                                    end
                                    prompt:InputHoldBegin()
                                    task.wait(prompt.HoldDuration + 0.5)
                                    prompt:InputHoldEnd()
                                    print("prompt ended")
                                    prompt.MaxActivationDistance = 100
                                    task.wait(0.5)
                                end
                            end
                        )
                    end
                end
            }
        )
        moneyFolder:AddToggle(
            {
                text = "Auto Rob",
                flag = "autoRob",
                callback = function()
                    if flags.autoRob then
                        repeat
                            if not flags.autoRob then
                                break
                            end
                            local robbables = getAllRobbables()

                            for _, v in ipairs(robbables) do
                                print("ROBBABLE " .. v.Name)
                                tpPlayer(v.Door.CFrame)
                                task.wait(0.2)
                                firePrompt(v.Door.Attachment.ProximityPrompt)
                                task.wait(0.3)
                                collectNearCash()
                                task.wait()
                                if not flags.autoRob then
                                    break
                                end
                            end
                            task.wait(3)
                        until not flags.autoRob
                    end
                end
            }
        )
        moneyFolder:AddToggle(
            {
                text = "Auto Collect Loot",
                flag = "autoLoot",
                callback = function()
                    task.spawn(
                        function()
                            while flags.autoLoot and task.wait() do
                                getAllLoot()
                            end
                        end
                    )
                end
            }
        )
    end
end

ESP.Players = false
ESP.Loot = false
ESP.Robbables = false

ESP:Toggle(true)

local visualsWindow = Library:CreateWindow("Visuals")
do
    local visualsFolder = visualsWindow:AddFolder("Visuals")
    do
        visualsFolder:AddToggle(
            {
                text = "Player ESP",
                callback = function(bool)
                    ESP.Players = bool
                end
            }
        )
        visualsFolder:AddDivider()
        visualsFolder:AddToggle(
            {
                text = "Tracers",
                callback = function(bool)
                    ESP.Tracers = bool
                end
            }
        )
        visualsFolder:AddToggle(
            {
                text = "Names",
                state = true,
                callback = function(bool)
                    ESP.Names = bool
                end
            }
        )
        visualsFolder:AddToggle(
            {
                text = "Boxes",
                state = true,
                callback = function(bool)
                    ESP.Boxes = bool
                end
            }
        )
    end
end

heartBeat:Connect(
    function()
        if flags.autoRob then
        end
    end
)

Library:Init()
task.spawn(
    function()
        while task.wait(1) do
            pcall(
                function()
                    game:GetService("Players").LocalPlayer.Backpack.Local.Dead:Destroy()
                end
            )
        end
    end
)
local vu = game:GetService("VirtualUser")
localPlayer.Idled:Connect(
    function()
        vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end
)
