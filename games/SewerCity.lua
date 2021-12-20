if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Globals
local userInputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")
local players = game:GetService("Players")

local player = players.LocalPlayer
local playerChar = player.Character or player.Character:Wait()

local function disableAntiCheatTactics()
    local gameMt = getrawmetatable(game)
    setreadonly(gameMt, false)
    local oldNameCall = gameMt.__namecall

    gameMt.__namecall =
        newcclosure(
        function(Self, ...)
            local method = getnamecallmethod()

            if not checkcaller() and method == "Kick" then
                print("Got the kick lol")
                wait(9e9)
            elseif method == "FireServer" and tostring(self) == "fireme" then
                print("stopped the anti delete lol")
                return
            end
            return oldNameCall(Self, ...)
        end
    )
end
local function deleteAntiCheatScripts()
    local characters = game.Workspace.Characters
    if characters then
        local localChar = characters[players.LocalPlayer.Name]
        if localChar then
            for _, v in ipairs(localChar:GetChildren()) do
                if string.find(v.Name, "end") then
                    v:Destroy()
                    print("Destroyed a shitty script LOL!")
                end
            end
        end
    end
end

-- Utility function (thanks wally) for loading code from URLS
local function safeLoadstring(name, url)
    local success, content = pcall(game.HttpGet, game, url)
    if (not success) then
        client:Kick(string.format("Failed to load library (%s). HttpError: %s", name, content))
        return function()
            wait(9e9)
        end
    end

    local func, err = loadstring(content)
    if (not func) then
        client:Kick(string.format("Failed to load library (%s). SyntaxError: %s", name, err))
        return function()
            wait(9e9)
        end
    end

    return func
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

-- Auto farming functions

-- Gets a "collectable" (something that can be picked up / clicked)
local validCollectables = {"Money", "ATM", "Lockpick", "Shotgun", "Glock", "Knife", "Bat", "CashRegister"}
local gettingItems = {ATM = true, Money = true, Register = true}

local function getCollectables(name)
    if table.find(validCollectables, name) ~= nil then
        local oldPos = playerChar.HumanoidRootPart.CFrame

        while wait() do
            -- If it is Money, then traverse the "Cash" folder instead.
            print("Found in table")

            if name == "Money" then
                for _, cash in pairs(game.Workspace.Cash:GetChildren()) do
                    repeat
                        if cash.Transparency == 1 then
                            gettingItems.Money = false
                            break
                        end
                        playerChar.HumanoidRootPart.CFrame = cash.CFrame
                        wait(0.3)
                        fireclickdetector(cash.ClickDetector)
                        if not gettingItems.Money then
                            playerChar.HumanoidRootPart.CFrame = oldPos
                            break
                        end
                    until true
                end
                playerChar.HumanoidRootPart.CFrame = oldPos
                return
            end

            local amount = 0
            local firstTime = true

            for _, v in pairs(game.Workspace:GetChildren()) do
                if (not gettingItems.ATM and name == "ATM") or (not gettingItems.Register and name == "CashRegister") then
                    playerChar.HumanoidRootPart.CFrame = oldPos
                    break
                end

                if name == v.Name then
                    print("Got it")
                    playerChar.HumanoidRootPart.CFrame =
                        CFrame.new(v.CFrame.x, v.CFrame.y + 5, v.Name == "ATM" and v.CFrame.z + 4 or v.CFrame.z)
                    wait(0.3)
                    fireclickdetector(v.ClickDetector)
                    amount = amount + 1
                end
            end

            if amount == 0 and not firstTime then
                sendNotification(
                    {
                        title = "Floppa Hub",
                        text = "Didn't find any items named " ..
                            name .. ". Try waiting as " .. name .. " will probably respawn."
                    }
                )
                break
            else
                firstTime = false
                break
            end

            playerChar.HumanoidRootPart.CFrame = oldPos
        end
    else
        warn("Invalid collectable at getCollectables call")
        return nil
    end
end

-- Remove duplicate GUIS
local function removeDuplicateGuis()
    for _, v in ipairs(game.CoreGui:GetChildren()) do
        if v.Name == "ScreenGui" then
            v:Destroy()
        end
    end
end

local allItems = {}
local allItemsKeys = {}

local function populateItems()
    for _, v in pairs(game.Workspace:GetChildren()) do
        if string.find(v.Name, " | ") then
            allItems[v.Name] = {
                CFrame = v.Head.CFrame,
                ClickDetector = v.Head.ClickDetector
            }
            table.insert(allItemsKeys, v.Name)
        end
    end
end

populateItems()
removeDuplicateGuis()
deleteAntiCheatScripts()
disableAntiCheatTactics()

table.sort(allItemsKeys)

local library = safeLoadstring("UI", "https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua")()

local window = library:CreateWindow("Floppa Hub - SC")
do
    local mainFolder = window:AddFolder("Main")
    do
        mainFolder:AddToggle({text = "Infinite Stamina", flag = "infStamina"})
        mainFolder:AddToggle(
            {
                text = "Fast Stamina Regen",
                flag = "fastStaminaRegen",
                callback = function(bool)
                    if bool then
                        game:GetService("Players").yt4r5.Backpack.StaminaRegenVal.Value = 5
                    else
                        game:GetService("Players").yt4r5.Backpack.StaminaRegenVal.Value = 1.25
                    end
                end
            }
        )
        local runToggle =
            mainFolder:AddToggle(
            {
                text = "Auto run",
                flag = "autoRun",
                callback = function(bool)
                    game.Players.LocalPlayer.Backpack.Running.Value = bool
                end
            }
        )
        mainFolder:AddBind(
            {
                text = "Autorun Toggle",
                flag = "autoRunToggle",
                key = Enum.KeyCode.T,
                callback = function()
                    runToggle:SetState(not runToggle.state)
                end
            }
        )
        mainFolder:AddToggle(
            {
                text = "Auto Dumbell",
                flag = "",
                callback = function(bool)
                    _G.toggled = bool
                    local dumbellPath = game:GetService("Workspace")["Dumbell | $350"]
                    local playerChar = player.Character

                    local hrp = playerChar.HumanoidRootPart

                    hrp.CFrame = dumbellPath.Head.CFrame

                    for i = 0, 999999999999999 do
                        if not _G.toggled then
                            break
                        end
                        fireclickdetector(dumbellPath.Head.ClickDetector)
                        task.wait(3)
                        local dumbellTool = player.Backpack:FindFirstChild("Dumbell")
                        dumbellTool.Parent = playerChar
                        dumbellTool:Activate()
                        task.wait(9)
                    end
                end
            }
        )
    end

    local autoFarmFolder = window:AddFolder("Autofarm")
    do
        autoFarmFolder:AddToggle(
            {
                text = "Get Cash",
                flag = "loopGetMoney"
            }
        )
        autoFarmFolder:AddToggle(
            {
                text = "Get ATMs",
                flag = "loopGetATM"
            }
        )
        autoFarmFolder:AddToggle(
            {
                text = "Get Registers",
                flag = "loopGetRegister"
            }
        )
        autoFarmFolder:AddDivider()
        autoFarmFolder:AddButton(
            {
                text = "Get Lockpicks",
                callback = function()
                    getCollectables("Lockpick")
                end
            }
        )
        autoFarmFolder:AddButton(
            {
                text = "Get Shotguns",
                callback = function()
                    getCollectables("Shotgun")
                end
            }
        )
        autoFarmFolder:AddButton(
            {
                text = "Get Glocks",
                callback = function()
                    getCollectables("Glock")
                end
            }
        )
        autoFarmFolder:AddButton(
            {
                text = "Get Bats",
                callback = function()
                    getCollectables("Bat")
                end
            }
        )
        autoFarmFolder:AddButton(
            {
                text = "Get Knives",
                callback = function()
                    getCollectables("Knife")
                end
            }
        )
    end
    local autoBuyFolder = window:AddFolder("Auto buys")
    do
        local buyList =
            autoBuyFolder:AddList(
            {
                text = "Auto Buy Item",
                values = allItemsKeys,
                callback = function(value)
                    local foundItem = allItems[value]
                    if foundItem ~= nil then
                        local oldCFrame = playerChar.HumanoidRootPart.CFrame
                        playerChar.HumanoidRootPart.CFrame = foundItem.CFrame
                        runService.Heartbeat:Wait()
                        fireclickdetector(foundItem.ClickDetector, 0)
                        runService.Heartbeat:Wait()
                        playerChar.HumanoidRootPart.CFrame = oldCFrame
                    end
                end
            }
        )
    end
end

library:Init()

runService.Heartbeat:Connect(
    function()
        if library.flags.infStamina then
            game.Players.LocalPlayer.Backpack.Stamina.Value = 100
        end
        if library.flags.loopGetMoney then
            gettingItems.Money = true
            getCollectables("Money")
        else
            gettingItems.Money = false
        end
        if library.flags.loopGetATM then
            gettingItems.ATM = true
            getCollectables("ATM")
        else
            gettingItems.ATM = false
        end
        if library.flags.loopGetRegister then
            gettingItems.Register = true
            getCollectables("CashRegister")
        else
            gettingItems.Register = false
        end
        if library.flags.autoDumbell then
        end
    end
)
