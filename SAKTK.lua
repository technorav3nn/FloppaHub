-- thx wally

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local runService = game:GetService("RunService")
local players = game:GetService("Players")
local player = players.LocalPlayer

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
            end
            return oldNameCall(Self, ...)
        end
    )
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

local gunList = {}
local gunValues = {}

local function populateGunList()
    for _, v in pairs(game.Workspace.AREA51:GetDescendants()) do
        if string.find(v.Name, "PUT THE WEAPON IN") then
            gunList[v.Parent.Parent.Name] = {
                func = function()
                    local oldGunPos = v.CFrame
                    v.CanCollide = false
                    v.CFrame = playerChar.HumanoidRootPart.CFrame
                    wait(0.1)
                    v.CFrame = oldGunPos
                    v.CanCollide = true
                end,
                name = v.Parent.Parent.Name
            }
            gunValues[#gunValues + 1] = v.Parent.Parent.Name
        end
    end
end

disableAntiCheatTactics()
removeDuplicateGuis()
populateGunList()

local library = safeLoadstring("UI", "https://raw.githubusercontent.com/wally-rblx/uwuware-ui/main/main.lua")()
local ESP = safeLoadstring("ESP Lib", "https://kiriot22.com/releases/ESP.lua")()
local Weapon = require(game.ReplicatedStorage.Weapon)
local fire = Weapon.fire
local aux = loadstring(game:HttpGetAsync("https://raw.githubusercontent.com/Upbolt/Hydroxide/revision/ohaux.lua"))()

ESP:AddObjectListener(
    game.Workspace.Killers,
    {
        Color = Color3.new(1, 1, 0),
        Type = "Model",
        PrimaryPart = function(obj)
            local hrp = obj.Torso
            return hrp
        end,
        CustomName = function(obj)
            return obj.Name
        end,
        IsEnabled = "Killers"
    }
)
local window = library:CreateWindow("Floppa Hub - SAKTK")

local playerFolder = window:AddFolder("Player")
do
    playerFolder:AddSlider(
        {
            text = "Walkspeed",
            min = 16,
            max = 200,
            default = 16,
            callback = function(value)
                getgenv().WalkSpeedValue = value
                player.Character.Humanoid:GetPropertyChangedSignal "WalkSpeed":Connect(
                    function()
                        player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
                    end
                )
                player.Character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue
            end
        }
    )
    playerFolder:AddSlider(
        {
            text = "Jump Power",
            min = 50,
            max = 200,
            default = 50,
            callback = function(value)
                player.Character.Humanoid.JumpPower = value
            end
        }
    )
    playerFolder:AddDivider()
    playerFolder:AddToggle(
        {
            text = "No Fog",
            callback = function(bool)
                if bool then
                    game:GetService "Lighting".FogEnd = 10000000000
                else
                    game:GetService "Lighting".FogEnd = 400
                end
            end
        }
    )
    playerFolder:AddToggle(
        {
            text = "Portable Pack-A-Punch",
            callback = function(bool)
                if bool then
                    game.Players.LocalPlayer.PlayerGui.PAP.Frame.Visible = true
                else
                    game.Players.LocalPlayer.PlayerGui.PAP.Frame.Visible = false
                end
            end
        }
    )
    playerFolder:AddButton(
        {
            text = "Anti Tails Blind",
            callback = function()
                game:GetService("StarterGui").TailsPopup:Destroy()
            end
        }
    )

    playerFolder:AddButton(
        {
            text = "No Slenderman Jumpscare",
            callback = function()
                game:GetService("Workspace").Killers.Slenderman["Damage and Behaviour"].Slender:Destroy()
            end
        }
    )
end

local combatFolder = window:AddFolder("Combat")
do
    combatFolder:AddToggle(
        {
            text = "Player ESP",
            callback = function(bool)
                ESP:Toggle(bool)
                ESP.Players = bool
            end
        }
    )
    combatFolder:AddToggle(
        {
            text = "Killer ESP",
            callback = function(bool)
                ESP:Toggle(bool)
                ESP.Players = false
                ESP.Killers = bool
            end
        }
    )
    combatFolder:AddDivider()
    combatFolder:AddLabel({text = "Gun mods"})
    combatFolder:AddDivider()

    combatFolder:AddToggle(
        {
            text = "Shotgun Bullets",
            callback = function(bool)
                for i, v in pairs(getgc()) do
                    if type(v) == "function" then
                        local b = debug.getupvalues(v)
                        for i2, v2 in pairs(b) do
                            if type(v2) == "table" and rawget(v2, "bullet_count") then
                                if bool then
                                    v2.bullet_count = 1
                                else
                                    v2.bullet_count = 15
                                end
                            end
                        end
                    end
                end
            end
        }
    )
    combatFolder:AddToggle(
        {
            text = "Full auto",
            callback = function(bool)
                for i, v in pairs(getgc()) do
                    if type(v) == "function" then
                        local b = debug.getupvalues(v)
                        for i2, v2 in pairs(b) do
                            if type(v2) == "table" and rawget(v2, "ammo") then
                                v2.is_auto = bool
                            end
                        end
                    end
                end
            end
        }
    )
    combatFolder:AddToggle(
        {
            text = "Infinite Ammo",
            callback = function(bool)
                for i, v in pairs(getgc()) do
                    if type(v) == "function" then
                        local b = debug.getupvalues(v)
                        for i2, v2 in pairs(b) do
                            if type(v2) == "table" and rawget(v2, "ammo") then
                                if bool then
                                    v2.ammo = math.huge
                                    v2.max_ammo = math.huge
                                    v2.stored_ammo = math.huge
                                else
                                    v2.ammo = 15
                                    v2.max_ammo = math.huge
                                    v2.stored_ammo = 100
                                end
                            end
                        end
                    end
                end
            end
        }
    )
    combatFolder:AddToggle(
        {
            text = "PAP'd Gun",
            callback = function(bool)
                for i, v in pairs(getgc()) do
                    if type(v) == "function" then
                        local b = debug.getupvalues(v)
                        for i2, v2 in pairs(b) do
                            if type(v2) == "table" and rawget(v2, "ammo") then
                                v2.is_pap = bool
                            end
                        end
                    end
                end
            end
        }
    )
    combatFolder:AddToggle(
        {
            text = "Insta Firerate",
            callback = function(bool)
                for i, v in pairs(getgc()) do
                    if type(v) == "function" then
                        local b = debug.getupvalues(v)
                        for i2, v2 in pairs(b) do
                            if type(v2) == "table" and rawget(v2, "ammo") then
                                v2.shoot_wait = bool and -math.huge or 0.04
                            end
                        end
                    end
                end
            end
        }
    )
end
local giversFolder = window:AddFolder("Givers")
do
    giversFolder:AddList(
        {
            values = gunValues,
            text = "Get gun",
            callback = function(value)
                gunList[value].func()
            end
        }
    )
end
local trollingFolder = window:AddFolder("Trolling")
do
end

local teleportsFolder = window:AddFolder("Teleports")
do
end

library:Init()

runService.Heartbeat:Connect(
    function()
    end
)
